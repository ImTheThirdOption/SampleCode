package com.opendoormediadesign.houseandhome757;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;


public class NotificationCustomAdapter extends BaseAdapter {

    private Activity activity;
    private ArrayList<String[]> arrayList;
    private LayoutInflater layoutInflater;

    public  NotificationCustomAdapter(Activity activity,ArrayList<String[]> arrayList)
    {
        this.activity = activity;
        this.arrayList = arrayList;
        layoutInflater = (LayoutInflater)activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }
    @Override
    public int getCount() {
        return arrayList.size();
    }
    @Override
    public Object getItem(int position) {
        return arrayList.get(position);
    }
    @Override
    public long getItemId(int position) {
        return 0;
    }
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        CachedView cachedView;
        if(convertView==null){
            cachedView = new CachedView();
            convertView = layoutInflater.inflate(R.layout.notification_listview, null);
            cachedView.imageView = (ImageView)convertView.findViewById(R.id.notification_listview_image);
            cachedView.textViewPreview = (TextView)convertView.findViewById(R.id.notification_listview_preview);
            convertView.setTag(cachedView);
        }
        else
        {
            cachedView = (CachedView) convertView.getTag();
        }
        new DownloadImageTask(cachedView.imageView).execute(arrayList.get(position)[0]);
        cachedView.textViewPreview.setText(arrayList.get(position)[1]);
        return convertView;
    }
    public static class CachedView {
        public ImageView imageView;
        public TextView textViewPreview;
    }
}
