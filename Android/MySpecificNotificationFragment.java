package com.opendoormediadesign.houseandhome757;

import android.database.Cursor;
import android.os.Bundle;
import android.support.v4.view.GestureDetectorCompat;
import android.view.GestureDetector;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.TextView;

public class MySpecificNotificationFragment extends android.support.v4.app.Fragment {
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
            rootView = inflater.inflate(R.layout.my_specific_notification_fragment, container, false);
            SWIPE_THRESHOLD_VELOCITY = (int)(1000 * getResources().getDisplayMetrics().density);
            NotificationsDatabase database = NotificationsDatabase.getDatabase(getActivity());
            Cursor cursor = database.loadNotifications(notificationNumber);
            cursor.moveToFirst();
            if (cursor.getCount()>0) {
                finishOpeningSpecificNotification(cursor.getString(cursor.getColumnIndex("type")), cursor.getString(cursor.getColumnIndex("first")), cursor.getString(cursor.getColumnIndex("third")));
            }
            cursor.close();
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
    class MyGestureListener  extends GestureDetector.SimpleOnGestureListener {

        @Override
        public boolean onDown(MotionEvent event) {
            return true;
        }

        @Override
        public boolean onFling(MotionEvent event1, MotionEvent event2,
                               float velocityX, float velocityY) {
            if (velocityX<-SWIPE_THRESHOLD_VELOCITY){
                NotificationsDatabase database = NotificationsDatabase.getDatabase(getActivity());
                Cursor cursor = database.loadNotificationsFling("left", notificationNumber);
                cursor.moveToFirst();
                if (cursor.getCount()>0 && !cursor.getString(cursor.getColumnIndex("_id")).equals(notificationNumber)){
                    notificationNumber = cursor.getString(cursor.getColumnIndex("_id"));
                    finishOpeningSpecificNotification(cursor.getString(cursor.getColumnIndex("type")), cursor.getString(cursor.getColumnIndex("first")), cursor.getString(cursor.getColumnIndex("third")));
                }
                cursor.close();
            }
            else if (velocityX>SWIPE_THRESHOLD_VELOCITY){
                NotificationsDatabase database = NotificationsDatabase.getDatabase(getActivity());
                Cursor cursor = database.loadNotificationsFling("right", notificationNumber);
                cursor.moveToFirst();
                if (cursor.getCount()>0 && !cursor.getString(cursor.getColumnIndex("_id")).equals(notificationNumber)){
                    notificationNumber = cursor.getString(cursor.getColumnIndex("_id"));
                    finishOpeningSpecificNotification(cursor.getString(cursor.getColumnIndex("type")), cursor.getString(cursor.getColumnIndex("first")), cursor.getString(cursor.getColumnIndex("third")));
                }
                cursor.close();
            }
            return true;
        }
    }
    public void finishOpeningSpecificNotification(String type, String url, String message){
        if (type.equals("pictext")) {
            imageView = (ImageView) rootView.findViewById(R.id.specific_notification_image);
            new DownloadImageTask(imageView).execute(url);
            textView = (TextView) rootView.findViewById(R.id.specific_notification_message);
            if (textView != null) {
                textView.setText(message);
            }
        }
    }
}
