package com.opendoormediadesign.houseandhome757;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Vibrator;
import android.support.v4.app.NotificationCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Map;

import static com.opendoormediadesign.houseandhome757.MainActivity.currentToFirstName;
import static com.opendoormediadesign.houseandhome757.MainActivity.currentToLastName;

public class MyFirebaseMessagingService extends FirebaseMessagingService {

    private static final String TAG = "MyFirebaseMsgService";
    public static int numberNewMessages = 0, numberNewNotifications = 0;
    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        Map<String,String> data = remoteMessage.getData();
        if (data.size() > 0) {
            if (data.get("type").equals("instantMessage")) {
                JSONObject jObject;
                try {
                    jObject = new JSONObject(data.get("message"));
                    String fromFirstName = jObject.getString("fromFirstName");
                    String fromLastName = jObject.getString("fromLastName");
                    String message = jObject.getString("message");
                    if (null == fromFirstName) {
                        fromFirstName = " ";
                    }
                    if (null == fromLastName) {
                        fromLastName = " ";
                    }
                    if (MainActivity.isMessagerOpen || (MainActivity.isConversationOpen && currentToFirstName.toLowerCase().equals(fromFirstName.toLowerCase()) && currentToLastName.toLowerCase().equals(fromLastName.toLowerCase()))) {
                        Intent intent = new Intent("newmessage");
                        intent.putExtra("message", jObject.getString("message"));
                        intent.putExtra("fromFirstName", fromFirstName);
                        intent.putExtra("fromLastName", fromLastName);
                        Uri notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
                        Ringtone r = RingtoneManager.getRingtone(getApplicationContext(), notification);
                        r.play();
                        Vibrator v = (Vibrator) this.getSystemService(Context.VIBRATOR_SERVICE);
                        v.vibrate(500);
                        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
                    } else {
                        ConversationDatabase database = ConversationDatabase.getDatabase(this);
                        database.addMessage(fromFirstName, fromLastName, message, 1);
                        sendNotification(message, fromFirstName, fromLastName);
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            else if (data.get("type").equals("systemMessage")) {
                JSONObject jObject;
                try {
                    jObject = new JSONObject(data.get("message"));
                    String type = jObject.getString("type");
                    if (type.equals("ping")) {
                        String fromFirstName = jObject.getString("fromFirstName");
                        String fromLastName = jObject.getString("fromLastName");
                        Intent intent = new Intent(this, HttpPost.class);
                        intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.http.post");
                        intent.putExtra("url", getResources().getString(R.string.server_address)+"send-message.php");
                        SharedPreferences settings = getSharedPreferences("registeredname", 0);

                        try {
                            JSONObject payload = new JSONObject();
                            payload.put("type", "systemMessage");
                            JSONObject message = new JSONObject();
                            message.put("fromFirstName", settings.getString("firstName", ""));
                            message.put("fromLastName", settings.getString("lastName", ""));
                            message.put("type", "pong");
                            payload.put("message", message);
                            intent.putExtra("data", URLEncoder.encode("toFirstName", "UTF-8") + "=" + URLEncoder.encode(fromFirstName, "UTF-8") + "&" + URLEncoder.encode("toLastName", "UTF-8") + "=" + URLEncoder.encode(fromLastName, "UTF-8") + "&" + URLEncoder.encode("message_payload", "UTF-8") + "=" + URLEncoder.encode(payload.toString(), "UTF-8"));
                        } catch (UnsupportedEncodingException | JSONException e) {
                            e.printStackTrace();
                        }
                        intent.putExtra("broadcast_receiver", "");
                        startService(intent);


                        /*intent = new Intent(this, ConversationHistory.class);
                        intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.save.conversation");
                        intent.putExtra("firstName", fromFirstName);
                        intent.putExtra("lastName", fromLastName);
                        intent.putExtra("message", data.get("message"));
                        intent.putExtra("sendOrReceive", 1);
                        startService(intent);*/
                        /*ConversationDatabase database = ConversationDatabase.getDatabase(this);
                        database.addMessage(fromFirstName, fromLastName, "*ping*", 1);
                        sendNotification(data.get("message"), fromFirstName, fromLastName);*/


                    } else if (type.equals("pong")) {
                        String fromFirstName = jObject.getString("fromFirstName");
                        String fromLastName = jObject.getString("fromLastName");
                        Intent intent = new Intent("pongreceived");
                        intent.putExtra("fromFirstName", fromFirstName);
                        intent.putExtra("fromLastName", fromLastName);
                        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            else if (data.get("type").equals("generalNotification")){
                JSONArray jArray;
                try {
                    jArray = new JSONArray(data.get("message"));
                    JSONObject jObject = jArray.getJSONObject(0);
                    String newNotificationNumber = jObject.getString("notificationNumber");
                    String type = jObject.getString("type");
                    String first = jObject.getString("first");
                    String second = jObject.getString("second");
                    sendNotificationOfNewNotification(newNotificationNumber, type, first, second);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            else if (data.get("type").equals("tailoredNotification")){
                JSONArray jArray;
                try {
                    jArray = new JSONArray(data.get("message"));
                    JSONObject jObject = jArray.getJSONObject(0);
                    String type = jObject.getString("type");
                    String first = jObject.getString("first");
                    String second = jObject.getString("second");
                    String third = jObject.getString("third");
                    sendNotificationOfNewTailoredNotification(type, first, second, third);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }
        if (remoteMessage.getNotification() != null) {
            Log.e(TAG, "Message Notification Body: " + remoteMessage.getNotification().getBody());
        }
    }
    private void sendNotification(String messageBody, String firstName, String lastName) {
        numberNewMessages = numberNewMessages+1;
        Intent intent = new Intent(this, MainActivity.class);
        intent.putExtra("action","com.opendoormediadesign.houseandhome757.action.new.instant.message.received");
        intent.putExtra("fromFirstName", firstName);
        intent.putExtra("fromLastName", lastName);
        intent.putExtra("message", messageBody);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, intent,
                PendingIntent.FLAG_ONE_SHOT);

        Uri defaultSoundUri= RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this)
                .setSmallIcon(R.drawable.realtor)
                .setContentTitle("Message from " +firstName+" "+lastName)
                .setContentText(messageBody)
                .setAutoCancel(true)
                .setSound(defaultSoundUri)
                .setLights(0xff0000ff, 500, 1500)
                .setVibrate(new long[] {0, 200, 200, 400, 400, 1000})
                .setNumber(numberNewMessages)
                .setContentIntent(pendingIntent);

        NotificationManager notificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        notificationManager.notify(0 /* ID of notification */, notificationBuilder.build());
    }
    private void sendNotificationOfNewNotification(String notificationNumber, String type, String first, String second) {
        numberNewNotifications = numberNewNotifications+1;
        Intent intent = new Intent(this, MainActivity.class);
        if (type.equals("pictext")) {
            intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.new.general.notification.received");
            intent.putExtra("notificationNumber", notificationNumber);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            PendingIntent pendingIntent = PendingIntent.getActivity(this, 1 /* Request code */, intent,
                    PendingIntent.FLAG_ONE_SHOT);

            Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
            NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this)
                    .setSmallIcon(R.drawable.realtor)
                    .setContentTitle("New general notification")
                    .setContentText(second)
                    .setAutoCancel(true)
                    .setSound(defaultSoundUri)
                    .setLights(0xff0000ff, 500, 1500)
                    .setVibrate(new long[]{0, 200, 200, 400, 400, 1000})
                    .setNumber(numberNewNotifications)
                    .setContentIntent(pendingIntent);
            NotificationManager notificationManager =
                    (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

            notificationManager.notify(1 /* ID of notification */, notificationBuilder.build());
        }
    }
    private void sendNotificationOfNewTailoredNotification(String type, String first, String second, String third) {
        numberNewNotifications = numberNewNotifications+1;
        Intent intent = new Intent(this, MainActivity.class);
        if (type.equals("pictext")) {
            NotificationsDatabase database = NotificationsDatabase.getDatabase(this);
            int notificationNumber = database.addNotification(type, first, second, third);

            intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.new.tailored.notification.received");
            intent.putExtra("notificationNumber", String.valueOf(notificationNumber));
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            PendingIntent pendingIntent = PendingIntent.getActivity(this, 1 /* Request code */, intent,
                    PendingIntent.FLAG_ONE_SHOT);

            Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
            NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this)
                    .setSmallIcon(R.drawable.realtor)
                    .setContentTitle("New personalized notification")
                    .setContentText(second)
                    .setAutoCancel(true)
                    .setSound(defaultSoundUri)
                    .setLights(0xff0000ff, 500, 1500)
                    .setVibrate(new long[]{0, 200, 200, 400, 400, 1000})
                    .setNumber(numberNewNotifications)
                    .setContentIntent(pendingIntent);
            NotificationManager notificationManager =
                    (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

            notificationManager.notify(1 /* ID of notification */, notificationBuilder.build());
        }
    }
}