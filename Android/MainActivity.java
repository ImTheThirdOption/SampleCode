package com.opendoormediadesign.houseandhome757;

import android.app.Activity;
import android.app.Dialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.provider.ContactsContract;
import android.provider.MediaStore;
import android.support.design.widget.NavigationView;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Toast;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.firebase.messaging.FirebaseMessaging;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener, SelectRecipientDialog.DialogListener, MessagerFragment.MessagerFragmentListener, ConversationFragment.ConversationFragmentListener, ReferralsFragment.ReferralsFragmentListener, NotificationFragment.NotificationFragmentListener, MyNotificationFragment.MyNotificationFragmentListener{

    FragmentManager fragmentManager = getSupportFragmentManager();
    private static final String ACTION_NEW_INSTANT_MESSAGE_RECEIVED = "com.opendoormediadesign.houseandhome757.action.new.instant.message.received";
    private static final String ACTION_NEW_GENERAL_NOTIFICATION_RECEIVED = "com.opendoormediadesign.houseandhome757.action.new.general.notification.received";
    private static final String ACTION_NEW_TAILORED_NOTIFICATION_RECEIVED = "com.opendoormediadesign.houseandhome757.action.new.tailored.notification.received";
    String firstName, lastName;
    String token;
    protected static String currentToFirstName = "";
    protected static String currentToLastName = "";
    boolean googlePlayEnabled = false;
    protected static boolean isMessagerOpen = false;
    protected static boolean isConversationOpen = false;
    protected static boolean isWaiting = false;

    public void onRecipientChosen(String firstName, String lastName){
        currentToFirstName = firstName;
        currentToLastName = lastName;
        checkOnlineStatus();
        startConversation();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        SharedPreferences settings = getSharedPreferences("registeredname", 0);
        firstName = settings.getString("firstName", "");
        lastName = settings.getString("lastName", "");
        token = settings.getString("token", "");
        String myVersion = settings.getString("version","");
        if (!myVersion.equals(BuildConfig.VERSION_NAME)){
            if (!(token.equals("") || firstName.equals("") || lastName.equals(""))){
                String data = "";
                try {
                    data = URLEncoder.encode("first_name", "UTF-8")+ "=" + URLEncoder.encode("", "UTF-8") + "&" + URLEncoder.encode("last_name", "UTF-8") + "=" + URLEncoder.encode("", "UTF-8") + "&" + URLEncoder.encode("token", "UTF-8") + "=" + URLEncoder.encode(token, "UTF-8") + "&" + URLEncoder.encode("system", "UTF-8") + "=" + URLEncoder.encode("android", "UTF-8") + "&" + URLEncoder.encode("version", "UTF-8") + "=" + URLEncoder.encode(BuildConfig.VERSION_NAME, "UTF-8") + "&" + URLEncoder.encode("old_first_name", "UTF-8") + "=" + URLEncoder.encode("", "UTF-8") + "&" + URLEncoder.encode("old_last_name", "UTF-8") + "=" + URLEncoder.encode("", "UTF-8") + "&" + URLEncoder.encode("new_name", "UTF-8") + "=" + URLEncoder.encode("no", "UTF-8");
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                reRegister(data);
            }
            SharedPreferences.Editor editor = settings.edit();
            editor.putString("version", BuildConfig.VERSION_NAME);
            editor.apply();
        }

        //scheduleAlarm();
        if(null == savedInstanceState){
            HomeFragment fragment = new HomeFragment();
            fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).commit();
        }
        processIntent(this.getIntent());

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        /*FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });
*/
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);
        googlePlayEnabled = isGooglePlayServicesAvailable(this);
    }
    @Override
    protected void onNewIntent(Intent intent){
        super.onNewIntent(intent);
        setIntent(intent);
        processIntent(intent);
    }
    void processIntent(Intent intent){
        if (intent != null) {
            String action = intent.getStringExtra("action");
            if (ACTION_NEW_INSTANT_MESSAGE_RECEIVED.equals(action)) {
                //startMessager(null);
                currentToFirstName = intent.getStringExtra("fromFirstName");
                currentToLastName = intent.getStringExtra("fromLastName");
                checkOnlineStatus();
                startConversation();
                MyFirebaseMessagingService.numberNewMessages = 0;
            } else if (ACTION_NEW_GENERAL_NOTIFICATION_RECEIVED.equals(action)){
                MyFirebaseMessagingService.numberNewNotifications = 0;
                openSpecificNotification(intent.getStringExtra("notificationNumber"));
            } else if (ACTION_NEW_TAILORED_NOTIFICATION_RECEIVED.equals(action)){
                MyFirebaseMessagingService.numberNewNotifications = 0;
                openMySpecificNotification(intent.getStringExtra("notificationNumber"));
            }
        }
    }

    protected void onResume() {
        super.onResume();
        googlePlayEnabled = isGooglePlayServicesAvailable(this);
        Fragment f = fragmentManager.findFragmentById(R.id.fragment_holder);
        isMessagerOpen = f instanceof MessagerFragment;
        isConversationOpen = f instanceof ConversationFragment;
        LocalBroadcastManager.getInstance(this).registerReceiver(tokenReceiver, new IntentFilter("newtoken"));
        LocalBroadcastManager.getInstance(this).registerReceiver(pongReceiver, new IntentFilter("pongreceived"));
        LocalBroadcastManager.getInstance(this).registerReceiver(messageReceiver, new IntentFilter("newmessage"));
        LocalBroadcastManager.getInstance(this).registerReceiver(allContactsReceiver, new IntentFilter("allcontacts"));
        LocalBroadcastManager.getInstance(this).registerReceiver(triedToRegisterReceiver, new IntentFilter("triedtoregister"));
        LocalBroadcastManager.getInstance(this).registerReceiver(instantMessageResponseReceiver, new IntentFilter("instantmessageresponse"));
    }

    public boolean isGooglePlayServicesAvailable(Activity activity) {
        GoogleApiAvailability googleApiAvailability = GoogleApiAvailability.getInstance();
        int status = googleApiAvailability.isGooglePlayServicesAvailable(activity);
        if (status != ConnectionResult.SUCCESS) {
            if (googleApiAvailability.isUserResolvableError(status)) {
                googleApiAvailability.getErrorDialog(activity, status, 2404).show();
            }
            return false;
        }
        return true;
    }

    protected void onPause() {
        super.onPause();
        isMessagerOpen = false;
        isConversationOpen = false;
        LocalBroadcastManager.getInstance(this).unregisterReceiver(pongReceiver);
        LocalBroadcastManager.getInstance(this).unregisterReceiver(tokenReceiver);
        LocalBroadcastManager.getInstance(this).unregisterReceiver(messageReceiver);
        LocalBroadcastManager.getInstance(this).unregisterReceiver(allContactsReceiver);
        LocalBroadcastManager.getInstance(this).unregisterReceiver(triedToRegisterReceiver);
        LocalBroadcastManager.getInstance(this).unregisterReceiver(instantMessageResponseReceiver);
    }
    public void onBackPressed() {
        isMessagerOpen = false;
        isConversationOpen = false;
        hideKeyboard();
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        }
        else if(fragmentManager.findFragmentById(R.id.fragment_holder) instanceof WebviewFragment && WebviewFragment.webView.canGoBack()){
            WebviewFragment.webView.goBack();
        }
        else if (fragmentManager.getBackStackEntryCount()!=0){
            fragmentManager.popBackStack();
        }
        else {
            super.onBackPressed();
        }
    }
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    /*@Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }*/

    //@SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        isMessagerOpen = false;
        isConversationOpen = false;
        int id = item.getItemId();

        if (id == R.id.nav_home) {
            goHome(null);
        } else if (id == R.id.nav_visit_website) {
            visitWebsiteWithString(getResources().getString(R.string.realtor_website));
        } else if (id == R.id.nav_contact_us) {
            openContactMe(null);
        } else if (id == R.id.nav_share_app) {
            startSharing(null);
        } else if (id == R.id.nav_reregister) {
            tryToRegister();
        } else if (id == R.id.nav_help) {
            openHelp();
        } else if (id == R.id.nav_about) {
            openAboutThisApp(null);
        }
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (1==requestCode && RESULT_OK==resultCode) {
            Uri uri = data.getData();
            Cursor cursor = getContentResolver().query(uri, null, null, null, null);
            String id = null;
            if(cursor.moveToFirst()) {
                id = cursor.getString(cursor.getColumnIndex(ContactsContract.Contacts._ID));
            }
            cursor.close();
            if (id != null && !id.isEmpty()) {
                Cursor phoneCursor = getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
                        null, ContactsContract.CommonDataKinds.Phone.CONTACT_ID + " = ?", new String[]{id}, null);
                String[] phoneArray = new String[phoneCursor.getCount()];
                String[] phoneTextArray = new String[phoneCursor.getCount()];
                if (phoneCursor.moveToFirst()) {
                    for (int i = 0; i < phoneCursor.getCount(); i++) {
                        String phone = phoneCursor.getString(phoneCursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DATA));
                        int typeNumber = phoneCursor.getInt(phoneCursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE));
                        String type = (String) ContactsContract.CommonDataKinds.Phone.getTypeLabel(getResources(), typeNumber, "");
                        phoneArray[i] = phone;
                        phoneTextArray[i] = type+ " phone number: "+phone;
                        phoneCursor.moveToNext();
                    }
                }
                phoneCursor.close();
                Cursor emailCursor = getContentResolver().query(ContactsContract.CommonDataKinds.Email.CONTENT_URI,
                        null, ContactsContract.CommonDataKinds.Email.CONTACT_ID + " = ?", new String[]{id}, null);
                String[] emailArray = new String[emailCursor.getCount()];
                String[] emailTextArray = new String[emailCursor.getCount()];
                if (emailCursor.moveToFirst()) {
                    for (int i = 0; i < emailCursor.getCount(); i++) {
                        String email = emailCursor.getString(emailCursor.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA));
                        int typeNumber = emailCursor.getInt(emailCursor.getColumnIndex(ContactsContract.CommonDataKinds.Email.TYPE));
                        String type = (String) ContactsContract.CommonDataKinds.Email.getTypeLabel(getResources(), typeNumber, "");
                        emailArray[i] = email;
                        emailTextArray[i] = type+ " email address: "+email;
                        emailCursor.moveToNext();
                    }
                }
                emailCursor.close();
                String[] allChoices = new String[phoneArray.length+emailArray.length];
                System.arraycopy(phoneTextArray, 0, allChoices, 0, phoneArray.length);
                System.arraycopy(emailTextArray, 0, allChoices, phoneArray.length, emailArray.length);
                DialogFragment dialog = ChooseRecipientURIDialog.newInstance(allChoices, phoneArray, emailArray);
                dialog.show(fragmentManager, "choose_recipient_dialog");
            }
        }
    }
    public void scheduleAlarm() {
        /*int breakTime = 5000;
        Intent intent = new Intent(getApplicationContext(), MyAlarmReceiver.class);
        final PendingIntent pIntent = PendingIntent.getBroadcast(this, MyAlarmReceiver.REQUEST_CODE,
                intent, PendingIntent.FLAG_UPDATE_CURRENT);
        // Setup periodic alarm every 5 seconds
        long firstMillis = System.currentTimeMillis(); // alarm is set right away
        AlarmManager alarm = (AlarmManager) this.getSystemService(Context.ALARM_SERVICE);
        // First parameter is the type: ELAPSED_REALTIME, ELAPSED_REALTIME_WAKEUP, RTC_WAKEUP
        // Interval can be INTERVAL_FIFTEEN_MINUTES, INTERVAL_HALF_HOUR, INTERVAL_HOUR, INTERVAL_DAY
        alarm.setInexactRepeating(AlarmManager.RTC_WAKEUP, firstMillis,
                breakTime, pIntent);
                */
    }
    public void openHelp(){
        DialogFragment dialog = AbstractDialog.newInstance(R.layout.help_dialog);
        dialog.show(fragmentManager, "help_dialog");
    }
    public void closeHelp(View v){
        Fragment f = fragmentManager.findFragmentByTag("help_dialog");
        if (f!=null) {
            ((DialogFragment) f).dismiss();
        }
    }
    public void chooseRealtorForPhoneCall(View v) {
        DialogFragment dialog = AbstractDialog.newInstance(R.layout.choose_realtor_for_phone_call_dialog);
        dialog.show(fragmentManager, "choose_realtor_for_phone_call");
    }
    public void onFirstRealtorChosen(View v){
        closeChooseRealtorForPhoneCall(null);
        callNumberOf("tel:" + getResources().getString(R.string.firstRealtorPhoneNumber));
    }
    public void onSecondRealtorChosen(View v){
        closeChooseRealtorForPhoneCall(null);
        callNumberOf("tel:" + getResources().getString(R.string.secondRealtorPhoneNumber));
    }
    public void closeChooseRealtorForPhoneCall(View v){
        Fragment f = fragmentManager.findFragmentByTag("choose_realtor_for_phone_call");
        ((DialogFragment)f).dismiss();
    }
    public void goHome(View v){
        hideKeyboard();
        Fragment f = fragmentManager.findFragmentById(R.id.fragment_holder);
        if (!(f instanceof HomeFragment)) {
            isMessagerOpen = false;
            isConversationOpen = false;
            HomeFragment fragment = new HomeFragment();
            fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).addToBackStack(null).commit();
        }
    }
    public void goBack(View v){
        onBackPressed();
    }
    public void hideKeyboard(){
        InputMethodManager inputMethodManager = (InputMethodManager) getSystemService(Activity.INPUT_METHOD_SERVICE);
        //Find the currently focused view, so we can grab the correct window token from it.
        View view = getCurrentFocus();
        //If no view currently has focus, create a new one, just so we can grab a window token from it
        if (view == null) {
            view = new View(this);
        }
        inputMethodManager.hideSoftInputFromWindow(view.getWindowToken(), 0);
    }
    public void startSharing(View v) {
        /*Intent intent = new Intent(Intent.ACTION_PICK, ContactsContract.Contacts.CONTENT_URI);
        if (intent.resolveActivity(getPackageManager()) != null) {
            startActivityForResult(intent, 1);
        }*/
        DialogFragment dialog = AbstractDialog.newInstance(R.layout.email_or_text_dialog);
        dialog.show(fragmentManager, "choose_email_or_text");
    }
    public void onEmailOrTextChosen(int id) {
        DialogFragment dialog = SetMessageDialog.newInstance(id);
        dialog.show(fragmentManager, "set_message");
    }
    public void onEmailChosen(View v){
        closeEmailOrText(null);
        //DialogFragment dialog = SetMessageDialog.newInstance(0);
        //dialog.show(fragmentManager, "set_message");
        Intent intent = new Intent(Intent.ACTION_SENDTO);
        intent.setData(Uri.parse("mailto:")); // only email apps should handle this
        intent.putExtra(Intent.EXTRA_TEXT, "I would like to share the " + getResources().getString(R.string.app_name) + " app with you. Go to " + getResources().getString(R.string.open_door_realtor_website) + " for more information and download links.");
        if (intent.resolveActivity(getPackageManager()) != null) {
            startActivity(intent);
        }
    }
    public void onTextChosen(View v){
        closeEmailOrText(null);
        //DialogFragment dialog = SetMessageDialog.newInstance(1);
        //dialog.show(fragmentManager, "set_message");
        Intent intent = new Intent(Intent.ACTION_SENDTO);
        intent.setData(Uri.parse("smsto:"));
        intent.putExtra("sms_body", "I would like to share the " + getResources().getString(R.string.app_name) + " app with you. Go to " + getResources().getString(R.string.open_door_realtor_website) + " for more information and download links.");
        intent.putExtra(Intent.EXTRA_TEXT, "I would like to share the " + getResources().getString(R.string.app_name) + " app with you. Go to " + getResources().getString(R.string.open_door_realtor_website) + " for more information and download links.");
        if (intent.resolveActivity(getPackageManager()) != null) {
            startActivity(intent);
        }
    }
    public void closeEmailOrText(View v){
        Fragment f = fragmentManager.findFragmentByTag("choose_email_or_text");
        ((DialogFragment)f).dismiss();
    }
    public void startChat(View v) {
        Intent intent = new Intent(Intent.ACTION_SENDTO, Uri.parse("smsto:"));
        intent.setData(Uri.parse("smsto:7577855075"));

        if (intent.resolveActivity(getPackageManager()) != null) {
            startActivity(intent);
        }
    }

    public void startUpload(View v) {

    }

    static final int REQUEST_IMAGE_CAPTURE = 1;

    public void openCamera(View v) {

        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        //intent.putExtra(MediaStore.EXTRA_OUTPUT,Uri.withAppendedPath(mLocationForPhotos, targetFilename));
        if (intent.resolveActivity(getPackageManager()) != null) {
            startActivityForResult(intent, REQUEST_IMAGE_CAPTURE);
        }

    }

    static final int REQUEST_VIDEO_CAPTURE = 2;

    public void openVideo(View v) {
        Intent intent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
        if (intent.resolveActivity(getPackageManager()) != null) {
            startActivityForResult(intent, REQUEST_VIDEO_CAPTURE);
        }

    }
    public void openAboutMe(View v) {
        Fragment f = fragmentManager.findFragmentById(R.id.fragment_holder);
        if (!(f instanceof AboutMeFragment)) {
            AboutMeFragment fragment = new AboutMeFragment();
            fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).addToBackStack(null).commit();
        }
    }
    public void openContactMe(View v) {
        Fragment f = fragmentManager.findFragmentById(R.id.fragment_holder);
        if (!(f instanceof ContactMeFragment)) {
            ContactMeFragment fragment = new ContactMeFragment();
            fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).addToBackStack(null).commit();
        }
    }
    public void callAgent(View v) {callNumberOf("tel:" + getResources().getString(R.string.firstRealtorPhoneNumber));}
    public void callNumber(View view) {
        callNumberOf("tel:"+view.getTag());
    }
    public void callReferral(View v){
        if (!SpecificReferralFragment.referralPhone.equals("")) {
            callNumberOf("tel:" + SpecificReferralFragment.referralPhone);
        }
        else {
            Toast toast = Toast.makeText(MainActivity.this,"No phone number on file", Toast.LENGTH_SHORT);
            toast.setGravity(Gravity.CENTER, 0, 0);
            toast.show();
        }
    }
    public void callNumberOf(String of) {
        Intent intent = new Intent(Intent.ACTION_DIAL, Uri.parse(of));
        if (intent.resolveActivity(getPackageManager()) != null) {
            startActivity(intent);
        }
    }
    public void textNumber(View view){
        Intent intent = new Intent(Intent.ACTION_SENDTO);
        intent.setData(Uri.parse("smsto:"+view.getTag()));
        if (intent.resolveActivity(getPackageManager()) != null) {
            startActivity(intent);
        }
    }

    public void sendEmail(View view) {
        sendEmailTo((String)view.getTag());
    }
    public void sendRealtorEmail(View v) {
        sendEmailTo("deane@realestategrp.com");
    }
    public void emailReferral(View v){
        if (!SpecificReferralFragment.referralEmail.equals("")) {
            Intent intent = new Intent(Intent.ACTION_SENDTO);
            intent.setData(Uri.parse("mailto:" + SpecificReferralFragment.referralEmail + "?subject=Request%20for%20contact")); // only email apps should handle this
            intent.putExtra(Intent.EXTRA_TEXT, "Hi, my name is (Enter your name). I would like for you to contact me. Thank you\n\n\n(Message sent from " + getResources().getString(R.string.app_name) + " Mobile App)");
            if (intent.resolveActivity(getPackageManager()) != null) {
                startActivity(intent);
            }
        }
        else {
            Toast toast = Toast.makeText(MainActivity.this,"No email on file", Toast.LENGTH_SHORT);
            toast.setGravity(Gravity.CENTER, 0, 0);
            toast.show();
        }
    }
    public void sendEmailTo(String to) {
        Intent intent = new Intent(Intent.ACTION_SENDTO);
        intent.setData(Uri.parse("mailto:")); // only email apps should handle this
        intent.putExtra(Intent.EXTRA_EMAIL, new String[]{to});
        if (intent.resolveActivity(getPackageManager()) != null) {
            startActivity(intent);
        }
    }
    public void closePopupsAndVisitWebsite(View view){
        closePopups();
        visitWebsiteWithString((String)view.getTag());
    }
    public void closePopups(){
        closeHelp(null);
    }
    public void visitWebsite(View view) {
        visitWebsiteWithString((String)view.getTag());
    }

    public void visitWebsiteWithString(String url) {
        WebviewFragment.url = url;
        WebviewFragment fragment = new WebviewFragment();
        fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).addToBackStack(null).commit();
        /*Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
        if (intent.resolveActivity(getPackageManager()) != null) {
            startActivity(intent);
        }*/
    }

    public void visitReferralWebsite(View v){
        if (!SpecificReferralFragment.referralURL.equals("")) {
            try {
                Intent intent = new Intent(this, HttpPost.class);
                intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.http.post");
                intent.putExtra("url", getResources().getString(R.string.server_address)+"app-analytics.php");
                intent.putExtra("data", URLEncoder.encode("message", "UTF-8") + "=" + URLEncoder.encode("The website for "+ SpecificReferralFragment.referralName + " was viewed in the "+ getResources().getString(R.string.app_name) + " Mobile App.", "UTF-8"));
                startService(intent);
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
            WebviewFragment.url = SpecificReferralFragment.referralURL;
            WebviewFragment fragment = new WebviewFragment();
            fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).addToBackStack(null).commit();
        }
        else {
            Toast toast = Toast.makeText(MainActivity.this,"No website on file", Toast.LENGTH_SHORT);
            toast.setGravity(Gravity.CENTER, 0, 0);
            toast.show();
        }
    }

    private BroadcastReceiver pongReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (isWaiting && currentToFirstName.toLowerCase().equals(intent.getStringExtra("fromFirstName").toLowerCase()) && currentToLastName.toLowerCase().equals(intent.getStringExtra("fromLastName").toLowerCase())) {
                    isWaiting = false;
            }
            else {
                String message = intent.getStringExtra("fromFirstName") + " " + intent.getStringExtra("fromLastName") + " is now online.";
                Toast toast = Toast.makeText(MainActivity.this, message, Toast.LENGTH_LONG);
                toast.setGravity(Gravity.CENTER, 0, 0);
                toast.show();
            }
        }
    };
    private BroadcastReceiver tokenReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            FirebaseMessaging.getInstance().subscribeToTopic("alldevices");
            FirebaseMessaging.getInstance().subscribeToTopic("allandroiddevices");
            token = intent.getStringExtra("token");
            SharedPreferences settings = getSharedPreferences("registeredname", 0);
            SharedPreferences.Editor editor = settings.edit();
            editor.putString("token", token);
            editor.commit();
            if (firstName.equals("") || lastName.equals("")) {
                tryToRegister();
            } else {
                String data = "";
                try {
                    data = URLEncoder.encode("first_name", "UTF-8")+ "=" + URLEncoder.encode("", "UTF-8") + "&" + URLEncoder.encode("last_name", "UTF-8") + "=" + URLEncoder.encode("", "UTF-8") + "&" + URLEncoder.encode("token", "UTF-8") + "=" + URLEncoder.encode(token, "UTF-8") + "&" + URLEncoder.encode("system", "UTF-8") + "=" + URLEncoder.encode("android", "UTF-8") + "&" + URLEncoder.encode("version", "UTF-8") + "=" + URLEncoder.encode(BuildConfig.VERSION_NAME, "UTF-8") + "&" + URLEncoder.encode("old_first_name", "UTF-8") + "=" + URLEncoder.encode("", "UTF-8") + "&" + URLEncoder.encode("old_last_name", "UTF-8") + "=" + URLEncoder.encode("", "UTF-8") + "&" + URLEncoder.encode("new_name", "UTF-8") + "=" + URLEncoder.encode("no", "UTF-8");
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                reRegister(data);

            }
        }
    };
    private BroadcastReceiver messageReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            addNewMessage(intent.getStringExtra("message"), intent.getStringExtra("fromFirstName"), intent.getStringExtra("fromLastName"), 1);
        }
    };
    private BroadcastReceiver allContactsReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String result = intent.getStringExtra("result");
            makeNameArrays(result);
        }
    };
    private BroadcastReceiver triedToRegisterReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String result = intent.getStringExtra("result");
            if (result.equals("taken") || !result.equals("success")){
                String message = null;
                if (result.equals("taken")){
                    message = "That name is not available. Please choose another.";
                }
                else if (!result.equals("success")) {
                    message = "There was an error.";
                }
                SharedPreferences settings = getSharedPreferences("registeredname", 0);
                SharedPreferences.Editor editor = settings.edit();
                editor.putString("firstName", "");
                editor.putString("lastName", "");
                firstName = "";
                lastName = "";
                editor.commit();
                new AlertDialog.Builder(MainActivity.this).setMessage(message).setPositiveButton("Ok", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        tryToRegister();
                    }
                }).show();
            }
            else {
                Toast toast = Toast.makeText(MainActivity.this,"Registration was successful.", Toast.LENGTH_SHORT);
                toast.setGravity(Gravity.CENTER, 0, 0);
                toast.show();
            }
        }
    };
    private BroadcastReceiver instantMessageResponseReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            boolean sentProperly = false;
            try {
                JSONObject result = new JSONObject(intent.getStringExtra("result"));
                if (result.getString("success").equals("1")){
                    sentProperly = true;
                    JSONObject extraData = new JSONObject(intent.getStringExtra("extra_data"));
                    addNewMessage(extraData.getString("message"), extraData.getString("toFirstName"), extraData.getString("toLastName"), 0);
                    Fragment f = fragmentManager.findFragmentById(R.id.fragment_holder);
                    if (f instanceof ConversationFragment) {
                        ((ConversationFragment)f).clearEditText();
                    }
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
            if (!sentProperly){
                new AlertDialog.Builder(MainActivity.this).setMessage("Your message was not properly sent.").show();
            }
        }
    };
    public void tryToRegister(){
        DialogFragment dialog = new RegistrationDialog();
        dialog.show(fragmentManager, "registration_dialog_fragment");
    }
        public void onNameChosen(View v) {
        DialogFragment f = (DialogFragment)fragmentManager.findFragmentByTag("registration_dialog_fragment");
        Dialog dialog = f.getDialog();
        String firstName = ((EditText)dialog.findViewById(R.id.firstName)).getText().toString();
        String lastName = ((EditText)dialog.findViewById(R.id.lastName)).getText().toString();
        if (firstName.equals("") || lastName.equals("")) {
            f.dismiss();
            new AlertDialog.Builder(MainActivity.this).setMessage("Please choose a first and last name.").setPositiveButton("Ok", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int id) {
                    tryToRegister();
                }
            }).show();
        }
        else {
            this.firstName = firstName;
            this.lastName = lastName;
            SharedPreferences settings = getSharedPreferences("registeredname", 0);
            String oldFirstName = settings.getString("firstName", "");
            String oldLastName = settings.getString("lastName", "");
            SharedPreferences.Editor editor = settings.edit();
            editor.putString("firstName", firstName);
            editor.putString("lastName", lastName);
            editor.commit();
            String emailAddress = ((EditText)dialog.findViewById(R.id.emailAddress)).getText().toString();
            String phoneNumber = ((EditText)dialog.findViewById(R.id.phoneNumber)).getText().toString();
            String howHeard = ((EditText)dialog.findViewById(R.id.howHeard)).getText().toString();
            int mayContactId = ((RadioGroup) dialog.findViewById(R.id.may_contact)).getCheckedRadioButtonId();
            String mayContact = "";
            if (-1!=mayContactId){
                mayContact = ((RadioButton)dialog.findViewById(mayContactId)).getText().toString();
            }
            int buyingOrSellingId = ((RadioGroup) dialog.findViewById(R.id.buying_or_selling)).getCheckedRadioButtonId();
            String buyingOrSelling = "";
            if (-1!=buyingOrSellingId){
                buyingOrSelling = ((RadioButton)dialog.findViewById(buyingOrSellingId)).getText().toString();
            }
            f.dismiss();
            String data = "";
            try {
                data = URLEncoder.encode("first_name", "UTF-8") + "=" + URLEncoder.encode(firstName, "UTF-8") + "&" + URLEncoder.encode("last_name", "UTF-8") + "=" + URLEncoder.encode(lastName, "UTF-8") + "&" + URLEncoder.encode("email_address", "UTF-8") + "=" + URLEncoder.encode(emailAddress, "UTF-8") + "&" + URLEncoder.encode("phone_number", "UTF-8") + "=" + URLEncoder.encode(phoneNumber, "UTF-8") + "&" + URLEncoder.encode("how_heard", "UTF-8") + "=" + URLEncoder.encode(howHeard, "UTF-8") + "&" + URLEncoder.encode("may_contact", "UTF-8") + "=" + URLEncoder.encode(mayContact, "UTF-8") + "&" + URLEncoder.encode("buying_or_selling", "UTF-8") + "=" + URLEncoder.encode(buyingOrSelling, "UTF-8") + "&" + URLEncoder.encode("token", "UTF-8") + "=" + URLEncoder.encode(token, "UTF-8") + "&" + URLEncoder.encode("system", "UTF-8") + "=" + URLEncoder.encode("android", "UTF-8") + "&" + URLEncoder.encode("version", "UTF-8") + "=" + URLEncoder.encode(BuildConfig.VERSION_NAME, "UTF-8")+ "&" + URLEncoder.encode("old_first_name", "UTF-8") + "=" + URLEncoder.encode(oldFirstName, "UTF-8") + "&" + URLEncoder.encode("old_last_name", "UTF-8") + "=" + URLEncoder.encode(oldLastName, "UTF-8") + "&" + URLEncoder.encode("new_name", "UTF-8") + "=" + URLEncoder.encode("yes", "UTF-8");
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
            reRegister(data);
        }
    }
    void reRegister(String data) {
        Intent intent = new Intent(this, HttpPost.class);
        intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.http.post");
        intent.putExtra("url", getResources().getString(R.string.server_address)+"register-contact.php");
        intent.putExtra("data", data);
        intent.putExtra("broadcast_receiver", "triedtoregister");
        startService(intent);
    }
    public void closeRegistration(View v){
        Fragment f = fragmentManager.findFragmentByTag("registration_dialog_fragment");
        ((DialogFragment)f).dismiss();
    }
    public void openResources(View v){
        ResourcesFragment fragment = new ResourcesFragment();
        fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).addToBackStack(null).commit();
    }
    public void openReferrals(View v) {
        ReferralsFragment fragment = new ReferralsFragment();
        fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).addToBackStack(null).commit();
    }
    public void openSpecificReferral(String referralNumber){
        Fragment f = fragmentManager.findFragmentById(R.id.fragment_holder);
        if (!(f instanceof SpecificReferralFragment)) {
            SpecificReferralFragment fragment = new SpecificReferralFragment();
            SpecificReferralFragment.referralNumber = referralNumber;
            fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).addToBackStack(null).commit();
        }
        else {
            SpecificReferralFragment.referralNumber = referralNumber;
        }
    }
    public void openNotifications(View v) {
        DialogFragment dialog = AbstractDialog.newInstance(R.layout.general_or_personalized_dialog);
        dialog.show(fragmentManager, "choose_type_of_notification");
    }
    public void onGeneralNotificationChosen(View v){
        closeGeneralOrPersonalized(null);
        NotificationFragment fragment = new NotificationFragment();
        fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).addToBackStack(null).commit();
    }
    public void onPersonalizedNotificationChosen(View v){
        closeGeneralOrPersonalized(null);
        MyNotificationFragment fragment = new MyNotificationFragment();
        fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).addToBackStack(null).commit();
    }
    public void closeGeneralOrPersonalized(View v){
        Fragment f = fragmentManager.findFragmentByTag("choose_type_of_notification");
        ((DialogFragment)f).dismiss();
    }

    public void openSpecificNotification(String notificationNumber){
        Fragment f = fragmentManager.findFragmentById(R.id.fragment_holder);
        if (!(f instanceof SpecificNotificationFragment)) {
            SpecificNotificationFragment fragment = new SpecificNotificationFragment();
            SpecificNotificationFragment.notificationNumber = notificationNumber;
            fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).addToBackStack(null).commit();
        }
        else {
            SpecificNotificationFragment.notificationNumber = notificationNumber;
        }
    }
    public void openMySpecificNotification(String notificationNumber){
        Fragment f = fragmentManager.findFragmentById(R.id.fragment_holder);
        if (!(f instanceof MySpecificNotificationFragment)) {
            MySpecificNotificationFragment fragment = new MySpecificNotificationFragment();
            MySpecificNotificationFragment.notificationNumber = notificationNumber;
            fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).addToBackStack(null).commit();
        }
        else {
            MySpecificNotificationFragment.notificationNumber = notificationNumber;
        }
    }
    public void openAboutThisApp(View v){
        Fragment f = fragmentManager.findFragmentById(R.id.fragment_holder);
        if (!(f instanceof AboutThisAppFragment)){
            AboutThisAppFragment fragment = new AboutThisAppFragment();
            fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).addToBackStack(null).commit();
        }
    }
    public void showDeveloperInformation(View v){
        Toast toast = Toast.makeText(MainActivity.this,"This App was Developed By Simon P. Matthews and SIAB.", Toast.LENGTH_LONG);
        toast.setGravity(Gravity.CENTER, 0, 0);
        toast.show();
    }
    public void makeNameArrays(String result) {
        JSONArray jArray;
        try {
            jArray = new JSONArray(result);
            String[] firstNames = new String[jArray.length()];
            String[] lastNames = new String[jArray.length()];
            for (int i = 0; i < jArray.length(); i++) {
                JSONObject jObject = jArray.getJSONObject(i);
                firstNames[i] = jObject.getString("first_name");
                lastNames[i] = jObject.getString("last_name");
            }
            chooseRecipient(firstNames, lastNames);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }


    public void startMessager(View v) {
        isMessagerOpen = false;
        isConversationOpen = false;
        hideKeyboard();
        if (firstName.equals("") || lastName.equals("")) {
            tryToRegister();
        }
        MessagerFragment fragment = new MessagerFragment();
        fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).addToBackStack(null).commit();
    }
    public void setCurrentToName(String newCurrentToFirstName, String newCurrentToLastName) {
        currentToFirstName = newCurrentToFirstName;
        currentToLastName = newCurrentToLastName;
    }

    public void startNewConversation(View v){
        if (firstName.equals("") || lastName.equals("")) {
            tryToRegister();
        }
        else {
            Intent intent = new Intent(this, HttpPost.class);
            intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.http.post");
            intent.putExtra("url", getResources().getString(R.string.server_address)+"get-contacts.php");
            intent.putExtra("data", "");
            intent.putExtra("broadcast_receiver", "allcontacts");
            startService(intent);
        }
    }
    public void chooseRecipient(String[] firstNames, String[] lastNames){
        DialogFragment dialog = SelectRecipientDialog.newInstance(firstNames,lastNames);
        dialog.show(fragmentManager, "select_recipient");
    }
    public void checkOnlineStatus(){
        Intent intent = new Intent(this, HttpPost.class);
        intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.http.post");
        intent.putExtra("url", getResources().getString(R.string.server_address)+"send-message.php");
        try {
            JSONObject payload = new JSONObject();
            payload.put("type", "systemMessage");
            JSONObject message = new JSONObject();
            message.put("fromFirstName", firstName);
            message.put("fromLastName", lastName);
            message.put("type", "ping");
            payload.put("message", message);
            intent.putExtra("data", URLEncoder.encode("toFirstName", "UTF-8") + "=" + URLEncoder.encode(currentToFirstName, "UTF-8")+ "&" + URLEncoder.encode("toLastName", "UTF-8") + "=" + URLEncoder.encode(currentToLastName, "UTF-8") + "&" + URLEncoder.encode("message_payload", "UTF-8") + "=" + URLEncoder.encode(payload.toString(), "UTF-8"));
        } catch (UnsupportedEncodingException | JSONException e) {
            e.printStackTrace();
        }
        intent.putExtra("broadcast_receiver", "");
        startService(intent);

        isWaiting = true;
        Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            public void run() {
                if (isWaiting){
                    String message = currentToFirstName+" "+currentToLastName+" is not currently online";
                    Toast toast = Toast.makeText(MainActivity.this, message, Toast.LENGTH_LONG);
                    toast.setGravity(Gravity.CENTER, 0, 0);
                    toast.show();
                    isWaiting = false;
                }
            }
        }, 5000);
    }
    public void startConversation(){
        ConversationFragment fragment = new ConversationFragment();
        //ConversationFragment.currentToFirstName = currentToFirstName;
        //ConversationFragment.currentToLastName = currentToLastName;
        fragmentManager.beginTransaction().replace(R.id.fragment_holder, fragment).addToBackStack(null).commit();
    }
    public void addNewMessage(String message, String fromFirstName, String fromLastName,  int sendOrReceive) {
        ConversationDatabase database = ConversationDatabase.getDatabase(this);
        database.addMessage(fromFirstName, fromLastName, message, sendOrReceive);
        final Fragment f = fragmentManager.findFragmentById(R.id.fragment_holder);
        if (f instanceof ConversationFragment) {
            ((ConversationFragment)f).saveListViewPosition();
        }
        getContentResolver().notifyChange(Uri.parse("content://uri_for_conversation_fragment_cursor_loader"), null);
        if (f instanceof MessagerFragment) {
            ((MessagerFragment)f).updateMessagerFragment();
        }
    }

    public void composeMessageEnterPressed(View view) {
        Fragment f = fragmentManager.findFragmentById(R.id.fragment_holder);
        if (f instanceof ConversationFragment) {
            ((ConversationFragment)f).composeMessageEnterPressed();
        }
    }
}