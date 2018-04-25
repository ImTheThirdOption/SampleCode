package com.opendoormediadesign.houseandhome757;

import android.app.Activity;
import android.content.DialogInterface;
import android.database.Cursor;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import java.util.ArrayList;

public class MyNotificationFragment extends android.support.v4.app.Fragment {
    public interface MyNotificationFragmentListener {
        void openMySpecificNotification(String notificationNumber);
    }

    MyNotificationFragment.MyNotificationFragmentListener mListener;
    View rootView;
    final ArrayList<String[]> arrayList = new ArrayList<String[]>();
    ListView listView;
    int position = 0;
    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        try {
            mListener = (MyNotificationFragment.MyNotificationFragmentListener) activity;
        } catch (ClassCastException e) {
            throw new ClassCastException(activity.toString() + " must implement MyNotificationFragmentListener");
        }
    }
    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        if (listView!=null) {
            outState.putInt("listViewPosition", listView.getFirstVisiblePosition());
        }
    }
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        if(rootView==null) {
            rootView = inflater.inflate(R.layout.my_notification_fragment, container, false);
            NotificationsDatabase database = NotificationsDatabase.getDatabase(getActivity());
            Cursor cursor = database.loadNotifications();
            if(cursor.getCount() > 0){
                cursor.moveToFirst();
                for (int i = 0; i < cursor.getCount(); i++) {
                    if (cursor.getString(cursor.getColumnIndex("type")).equals("pictext")) {
                        String[] data = new String[3];
                        data[0] = cursor.getString(cursor.getColumnIndex("first"));
                        data[1] = cursor.getString(cursor.getColumnIndex("second"));
                        data[2] = cursor.getString(cursor.getColumnIndex("_id"));
                        arrayList.add(data);
                    }
                    cursor.moveToNext();
                }
                cursor.close();
                if (listView==null){
                    listView = (ListView)rootView.findViewById(R.id.notification_fragment_listview);
                }
                final NotificationCustomAdapter notificationCustomAdapter = new NotificationCustomAdapter(getActivity(), arrayList);
                listView.setAdapter(notificationCustomAdapter);
                listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

                    @Override
                    public void onItemClick(AdapterView<?> arg0, View view, int position, long arg3) {
                        mListener.openMySpecificNotification(arrayList.get(position)[2]);
                    }
                });
                listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
                    @Override
                    public boolean onItemLongClick(AdapterView<?> arg0, View arg1,
                                                   final int pos, long id) {
                        new AlertDialog.Builder(getActivity()).setItems(new String[] {"Delete notification", "Delete all notifications"}, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                if (0==which) {
                                    NotificationsDatabase.getDatabase(getActivity()).deleteNotification(arrayList.get(pos)[2]);
                                    arrayList.remove(pos);
                                    notificationCustomAdapter.notifyDataSetChanged();
                                }
                                else if (1==which){
                                    NotificationsDatabase.getDatabase(getActivity()).deleteAllNotifications();
                                    arrayList.clear();
                                    notificationCustomAdapter.notifyDataSetChanged();
                                }
                            }
                        }).show();
                        return true;
                    }
                });
            }
            else {
                cursor.close();
            }
        }

        setRetainInstance(true);
        if (savedInstanceState != null) {
            position = savedInstanceState.getInt("listViewPosition", 0);
        }
        return rootView;
    }
 }