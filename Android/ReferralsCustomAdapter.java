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

public class ReferralsCustomAdapter extends BaseAdapter {

    private Activity activity;
    private ArrayList<String[]> arrayList;
    private LayoutInflater layoutInflater;

    public  ReferralsCustomAdapter(Activity activity,ArrayList<String[]> arrayList)
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
            convertView = layoutInflater.inflate(R.layout.referrals_listview, null);
            cachedView.imageView = (ImageView)convertView.findViewById(R.id.referrals_listview_image);
            cachedView.textViewPreviewFirst = (TextView)convertView.findViewById(R.id.referrals_listview_preview_first);
            cachedView.textViewPreviewSecond = (TextView)convertView.findViewById(R.id.referrals_listview_preview_second);
            convertView.setTag(cachedView);
        }
        else
        {
            cachedView = (CachedView) convertView.getTag();
        }
        new DownloadImageTask(cachedView.imageView).execute(arrayList.get(position)[0]);
        cachedView.textViewPreviewFirst.setText(arrayList.get(position)[1]);
        cachedView.textViewPreviewSecond.setText(arrayList.get(position)[2]);
        return convertView;
    }
    public static class CachedView {
        public ImageView imageView;
        public TextView textViewPreviewFirst;
        public TextView textViewPreviewSecond;
    }
}
