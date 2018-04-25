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
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

public class SpecificNotificationFragment extends android.support.v4.app.Fragment {
    public static String notificationNumber;
    int SWIPE_THRESHOLD_VELOCITY;
    View rootView;
    ImageView imageView;
    TextView textView;
    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
    }
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        if(rootView==null){
            rootView = inflater.inflate(R.layout.specific_notification_fragment, container, false);
            SWIPE_THRESHOLD_VELOCITY = (int)(1000 * getResources().getDisplayMetrics().density);
            Intent intent = new Intent(getActivity(), HttpPost.class);
            intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.http.post");
            intent.putExtra("url", getResources().getString(R.string.server_address)+"get-specific-notification.php");
            try {
                intent.putExtra("data",URLEncoder.encode("notificationNumber", "UTF-8") + "=" + URLEncoder.encode(notificationNumber, "UTF-8"));
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
            intent.putExtra("broadcast_receiver", "specificnotificationready");
            getActivity().startService(intent);
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
        ScrollView scrollView = (ScrollView)getActivity().findViewById(R.id.specific_notification_scrollview);
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
        LocalBroadcastManager.getInstance(getActivity()).registerReceiver(flingNotificationReceiver, new IntentFilter("flingnotificationready"));
        LocalBroadcastManager.getInstance(getActivity()).registerReceiver(specificNotificationReceiver,  new IntentFilter("specificnotificationready"));
    }
    @Override
    public void onPause() {
        super.onPause();
        LocalBroadcastManager.getInstance(getActivity()).unregisterReceiver(flingNotificationReceiver);
        LocalBroadcastManager.getInstance(getActivity()).unregisterReceiver(specificNotificationReceiver);
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
                Intent intent = new Intent(getActivity(), HttpPost.class);
                intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.http.post");
                intent.putExtra("url", getResources().getString(R.string.server_address)+"get-notification-fling.php");
                try {
                    String data = URLEncoder.encode("notificationNumber", "UTF-8")+ "=" + URLEncoder.encode(notificationNumber, "UTF-8");
                    data += "&" + URLEncoder.encode("direction", "UTF-8") + "=" + URLEncoder.encode("left", "UTF-8");
                    intent.putExtra("data", data);
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                intent.putExtra("broadcast_receiver", "flingnotificationready");
                getActivity().startService(intent);
            }
            else if (velocityX>SWIPE_THRESHOLD_VELOCITY){
                Intent intent = new Intent(getActivity(), HttpPost.class);
                intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.http.post");
                intent.putExtra("url", getResources().getString(R.string.server_address)+"get-notification-fling.php");
                try {
                    String data = URLEncoder.encode("notificationNumber", "UTF-8")+ "=" + URLEncoder.encode(notificationNumber, "UTF-8");
                    data += "&" + URLEncoder.encode("direction", "UTF-8") + "=" + URLEncoder.encode("right", "UTF-8");
                    intent.putExtra("data", data);
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                intent.putExtra("broadcast_receiver", "flingnotificationready");
                getActivity().startService(intent);
            }
            return true;
        }
    }
    public void finishOpeningSpecificNotification(String type, String first, String third){
        if (type.equals("pictext")) {
            imageView = (ImageView) getActivity().findViewById(R.id.specific_notification_image);
            new DownloadImageTask(imageView).execute(first);
            textView = (TextView) getActivity().findViewById(R.id.specific_notification_message);
            if (textView != null) {
                textView.setText(third);
            }
        }
    }
    private BroadcastReceiver flingNotificationReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String result = intent.getStringExtra("result");
            JSONArray jArray;
            try {
                jArray = new JSONArray(result);
                JSONObject jObject = jArray.getJSONObject(0);
                String newNotificationNumber = jObject.getString("notificationNumber");
                if (notificationNumber!= newNotificationNumber){
                    notificationNumber = newNotificationNumber;
                    Fragment f = getActivity().getSupportFragmentManager().findFragmentById(R.id.fragment_holder);
                    if (f instanceof SpecificNotificationFragment) {
                        ((SpecificNotificationFragment) f).finishOpeningSpecificNotification(jObject.getString("type"), jObject.getString("first"), jObject.getString("third"));
                    }
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    };
    private BroadcastReceiver specificNotificationReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String result = intent.getStringExtra("result");
            JSONArray jArray;
            try {
                jArray = new JSONArray(result);
                JSONObject jObject = jArray.getJSONObject(0);
                Fragment f = getActivity().getSupportFragmentManager().findFragmentById(R.id.fragment_holder);
                if (f instanceof SpecificNotificationFragment) {
                    ((SpecificNotificationFragment)f).finishOpeningSpecificNotification(jObject.getString("type"), jObject.getString("first"), jObject.getString("third"));
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    };
}