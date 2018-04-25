package com.opendoormediadesign.houseandhome757;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.ArrayList;

public class MessagerCustomAdapter extends BaseAdapter {

    private Activity activity;
    private ArrayList<String[]> arrayList;
    private LayoutInflater layoutInflater;

    public  MessagerCustomAdapter(Activity activity,ArrayList<String[]> arrayList)
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
            convertView = layoutInflater.inflate(R.layout.messager_listview, null);
            cachedView.textViewUserName = (TextView)convertView.findViewById(R.id.messager_listview_user_name);
            cachedView.textViewLastMessage = (TextView)convertView.findViewById(R.id.messager_listview_last_message);
            convertView.setTag(cachedView);
            convertView.setId(MyUtilities.generateViewId());
        }
        else
        {
            cachedView = (CachedView) convertView.getTag();
        }
        cachedView.textViewUserName.setText(arrayList.get(position)[0]+" "+arrayList.get(position)[1]);
        cachedView.textViewLastMessage.setText(arrayList.get(position)[2]);
        return convertView;
    }
    public static class CachedView {
        public TextView textViewUserName, textViewLastMessage;
    }
}
