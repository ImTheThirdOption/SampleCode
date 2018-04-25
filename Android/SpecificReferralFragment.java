package com.opendoormediadesign.houseandhome757;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v4.view.GestureDetectorCompat;
import android.view.GestureDetector;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

public class SpecificReferralFragment extends android.support.v4.app.Fragment {
    public static String referralName;
    public static String referralNumber;
    public static String referralEmail;
    public static String referralPhone;
    public static String referralURL;
    int SWIPE_THRESHOLD_VELOCITY;
    View rootView;
    ImageView imageView;
    Button titleButton;
    TextView descriptionTextView;
    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
    }
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        if(rootView==null){
            rootView = inflater.inflate(R.layout.specific_referral_fragment, container, false);
            SWIPE_THRESHOLD_VELOCITY = (int)(1000 * getResources().getDisplayMetrics().density);
            try {
                Intent intent = new Intent(getActivity(), HttpPost.class);
                intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.http.post");
                intent.putExtra("url", getResources().getString(R.string.server_address)+"get-specific-referral.php");
                intent.putExtra("data", URLEncoder.encode("referralNumber", "UTF-8") + "=" + URLEncoder.encode(referralNumber, "UTF-8"));
                intent.putExtra("broadcast_receiver", "specificreferralready");
                getActivity().startService(intent);
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }
        setRetainInstance(true);
        if (savedInstanceState != null) {
            //position = savedInstanceState.getInt("listViewPosition", 0);
        }
        return rootView;
    }
    @Override
    public void onStart() {
        super.onStart();
        ScrollView scrollView = (ScrollView)getActivity().findViewById(R.id.specific_referral_scrollview);
        scrollView.setOnTouchListener(new View.OnTouchListener() {
            GestureDetectorCompat mDetector = new GestureDetectorCompat(getActivity(), new MyGestureListener());
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                mDetector.onTouchEvent(motionEvent);
                return false;
            }
        });
    }
    @Override
    public void onResume() {
        super.onResume();
        LocalBroadcastManager.getInstance(getActivity()).registerReceiver(flingReferralReceiver, new IntentFilter("flingreferralready"));
        LocalBroadcastManager.getInstance(getActivity()).registerReceiver(specificReferralReceiver,  new IntentFilter("specificreferralready"));
    }
    @Override
    public void onPause() {
        super.onPause();
        LocalBroadcastManager.getInstance(getActivity()).unregisterReceiver(flingReferralReceiver);
        LocalBroadcastManager.getInstance(getActivity()).unregisterReceiver(specificReferralReceiver);
    }
    class MyGestureListener  extends GestureDetector.SimpleOnGestureListener {

        @Override
        public boolean onDown(MotionEvent event) {
            return true;
        }

        @Override
        public boolean onFling(MotionEvent event1, MotionEvent event2,
                               float velocityX, float velocityY) {
            if (velocityX<-SWIPE_THRESHOLD_VELOCITY){
                try {
                    Intent intent = new Intent(getActivity(), HttpPost.class);
                    intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.http.post");
                    intent.putExtra("url", getResources().getString(R.string.server_address)+"get-referral-fling.php");
                    String data = URLEncoder.encode("referralNumber", "UTF-8")+ "=" + URLEncoder.encode(referralNumber, "UTF-8");
                    data += "&" + URLEncoder.encode("direction", "UTF-8") + "=" + URLEncoder.encode("left", "UTF-8");
                    intent.putExtra("data", data);
                    intent.putExtra("broadcast_receiver", "flingreferralready");
                    getActivity().startService(intent);
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
            }
            else if (velocityX>SWIPE_THRESHOLD_VELOCITY){
                try {
                    Intent intent = new Intent(getActivity(), HttpPost.class);
                    intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.http.post");
                    intent.putExtra("url", getResources().getString(R.string.server_address)+"get-referral-fling.php");
                    String data = URLEncoder.encode("referralNumber", "UTF-8")+ "=" + URLEncoder.encode(referralNumber, "UTF-8");
                    data += "&" + URLEncoder.encode("direction", "UTF-8") + "=" + URLEncoder.encode("right", "UTF-8");
                    intent.putExtra("data", data);
                    intent.putExtra("broadcast_receiver", "flingreferralready");
                    getActivity().startService(intent);
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
            }
            return true;
        }
    }
    public void finishOpeningSpecificReferral(String type, String first, String second, String fourth, String fifth, String sixth, String seventh){
        if (type.equals("pictext")) {
            imageView = (ImageView) getActivity().findViewById(R.id.specific_referral_image);
            new DownloadImageTask(imageView).execute(first);
            descriptionTextView = (TextView) getActivity().findViewById(R.id.specific_referral_message);
            if (descriptionTextView != null) {
                descriptionTextView.setText(fourth);
            }
            titleButton = (Button) getActivity().findViewById(R.id.specific_referral_fragment_referral_name);
            if (titleButton != null){
                titleButton.setText(second);
            }
            try {
                Intent intent = new Intent(getActivity(), HttpPost.class);
                intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.http.post");
                intent.putExtra("url", getResources().getString(R.string.server_address)+"app-analytics.php");
                intent.putExtra("data", URLEncoder.encode("message", "UTF-8") + "=" + URLEncoder.encode(referralName + " was viewed in the " + getResources().getString(R.string.app_name) + " App.", "UTF-8"));
                getActivity().startService(intent);
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }
    }
    private BroadcastReceiver flingReferralReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String result = intent.getStringExtra("result");
            JSONArray jArray;
            try {
                jArray = new JSONArray(result);
                JSONObject jObject = jArray.getJSONObject(0);
                String newReferralNumber = jObject.getString("referralNumber");
                if (referralNumber!= newReferralNumber){
                    referralNumber = newReferralNumber;
                    Fragment f = getActivity().getSupportFragmentManager().findFragmentById(R.id.fragment_holder);
                    if (f instanceof SpecificReferralFragment) {
                        referralName = jObject.getString("second");
                        referralEmail = jObject.getString("fifth");
                        referralPhone = jObject.getString("sixth");
                        referralURL = jObject.getString("seventh");
                        ((SpecificReferralFragment) f).finishOpeningSpecificReferral(jObject.getString("type"), jObject.getString("first"), jObject.getString("second"), jObject.getString("fourth"), jObject.getString("fifth"), jObject.getString("sixth"), jObject.getString("seventh"));
                    }
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    };
    private BroadcastReceiver specificReferralReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String result = intent.getStringExtra("result");
            JSONArray jArray;
            try {
                jArray = new JSONArray(result);
                JSONObject jObject = jArray.getJSONObject(0);
                Fragment f = getActivity().getSupportFragmentManager().findFragmentById(R.id.fragment_holder);
                if (f instanceof SpecificReferralFragment) {
                    referralName = jObject.getString("second");
                    referralEmail = jObject.getString("fifth");
                    referralPhone = jObject.getString("sixth");
                    referralURL = jObject.getString("seventh");
                    ((SpecificReferralFragment)f).finishOpeningSpecificReferral(jObject.getString("type"), jObject.getString("first"), jObject.getString("second"), jObject.getString("fourth"), jObject.getString("fifth"), jObject.getString("sixth"), jObject.getString("seventh"));
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    };
}