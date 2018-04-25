package com.opendoormediadesign.houseandhome757;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class MyAlarmReceiver extends BroadcastReceiver {
    public static final int REQUEST_CODE = 12345;
    @Override
    public void onReceive(Context context, Intent intent) {
        /*Intent newIntent = new Intent(context, OldCheckForNewNotifications.class);
        newIntent.putExtra("action","com.opendoormediadesign.houseandhome757.action.check.for.new.notifications");
        context.startService(newIntent);*/
    }
}