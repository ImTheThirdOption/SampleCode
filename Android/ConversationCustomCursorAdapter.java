package com.opendoormediadesign.houseandhome757;


import android.content.Context;
import android.database.Cursor;
import android.support.v4.widget.CursorAdapter;
import android.text.util.Linkify;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

public class ConversationCustomCursorAdapter extends CursorAdapter {
    private Cursor cursor;
    private LayoutInflater layoutInflater;
    public ConversationCustomCursorAdapter(Context context, Cursor cursor, int flags)
    {
        super(context, cursor, flags);
        this.cursor = cursor;
        layoutInflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }
    @Override
    public int getViewTypeCount() {
        return 2;
    }
    @Override
    public int getItemViewType(int position) {
        if (cursor!=null) {
            cursor.moveToPosition(position);
            return cursor.getInt(cursor.getColumnIndex("send_or_receive"));
        }
        return -1;
    }

    @Override
    public View newView(Context context, Cursor cursor, ViewGroup parent)
    {
        ConversationCustomCursorAdapter.CachedView cachedView = new ConversationCustomCursorAdapter.CachedView();
        View convertView = null;
        int type = cursor.getInt(cursor.getColumnIndex("send_or_receive"));
        if (0==type){
            convertView = layoutInflater.inflate(R.layout.conversation_listview_outgoing_entry, null);
        }
        else if (1==type){
            convertView = layoutInflater.inflate(R.layout.conversation_listview_incoming_entry, null);
        }
        cachedView.textViewMessage = (TextView)convertView.findViewById(R.id.conversation_listview_message);
        convertView.setTag(cachedView);

        return convertView;
    }

    @Override
    public void bindView(View view, Context context, Cursor cursor) {
        ConversationCustomCursorAdapter.CachedView cachedView = (ConversationCustomCursorAdapter.CachedView) view.getTag();
        cachedView.textViewMessage.setText(cursor.getString(cursor.getColumnIndex("message")));
        Linkify.addLinks(cachedView.textViewMessage, Linkify.ALL);
    }
    public static class CachedView {
        public TextView textViewMessage;
    }
}