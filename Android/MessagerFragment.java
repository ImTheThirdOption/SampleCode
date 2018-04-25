package com.opendoormediadesign.houseandhome757;

import android.app.Activity;
import android.content.DialogInterface;
import android.database.Cursor;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import java.util.ArrayList;

public class MessagerFragment extends android.support.v4.app.Fragment {
    public interface MessagerFragmentListener {
        void checkOnlineStatus();
        void setCurrentToName(String currentToFirstName, String currentToLastName);
        void startConversation();
    }

    MessagerFragmentListener mListener;
    View rootView;
    final ArrayList<String[]> arrayList = new ArrayList<String[]>();
    ListView listView;
    int position = 0;
    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        try {
            mListener = (MessagerFragmentListener) activity;
        } catch (ClassCastException e) {
            throw new ClassCastException(activity.toString() + " must implement MessagerFragmentListener");
        }
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        /*outState.putStringArray("adapterArrayList0", arrayList.get(0));
        outState.putStringArray("adapterArrayList1", arrayList.get(1));
        outState.putStringArray("adapterArrayList2", arrayList.get(2));*/
        if (listView!=null) {
            outState.putInt("listViewPosition", listView.getFirstVisiblePosition());
        }
    }
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                         Bundle savedInstanceState) {
        MainActivity.isMessagerOpen = true;
        if(rootView==null) {
            rootView = inflater.inflate(R.layout.messager_fragment, container, false);
            updateMessagerFragment();
        }
        setRetainInstance(true);
        if (savedInstanceState != null) {
            position = savedInstanceState.getInt("listViewPosition", 0);
        }
        return rootView;
    }
    public void updateMessagerFragment(){
        final ConversationDatabase database = ConversationDatabase.getDatabase(getActivity());
        Cursor cursor = database.loadLastMessages();
        if(cursor.getCount() > 0) {
            cursor.moveToFirst();
            arrayList.clear();
            for (int i = 0; i < cursor.getCount(); i++) {
                String[] data = new String[3];
                data[0] = cursor.getString(cursor.getColumnIndex("first_name"));
                data[1] = cursor.getString(cursor.getColumnIndex("last_name"));
                data[2] = cursor.getString(cursor.getColumnIndex("message"));
                arrayList.add(data);
                cursor.moveToNext();
            }
            cursor.close();
            if (listView == null) {
                listView = (ListView) rootView.findViewById(R.id.messager_fragment_listview);
            }
            final MessagerCustomAdapter messagerCustomAdapter = new MessagerCustomAdapter(getActivity(), arrayList);
            listView.setAdapter(messagerCustomAdapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

                @Override
                public void onItemClick(AdapterView<?> arg0, View arg1, int position, long arg3) {
                    mListener.setCurrentToName(arrayList.get(position)[0], arrayList.get(position)[1]);
                    mListener.checkOnlineStatus();
                    mListener.startConversation();
                }
            });
            listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
                @Override
                public boolean onItemLongClick(AdapterView<?> arg0, View arg1,
                                               final int pos, long id) {
                    new AlertDialog.Builder(getActivity()).setItems(new String[]{"Delete conversation"}, new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int which) {
                            switch (which) {
                                case 0:
                                    ConversationDatabase.getDatabase(getActivity()).deleteConversation(arrayList.get(pos)[0], arrayList.get(pos)[1]);
                                    arrayList.remove(pos);
                                    messagerCustomAdapter.notifyDataSetChanged();
                                    break;
                                default:
                                    break;
                            }
                        }
                    }).show();
                    return true;
                }
            });
        }
    }
}
