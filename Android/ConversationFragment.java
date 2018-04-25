package com.opendoormediadesign.houseandhome757;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.IBinder;
import android.support.v4.app.LoaderManager;
import android.support.v4.content.CursorLoader;
import android.support.v4.content.Loader;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

public class ConversationFragment extends android.support.v4.app.Fragment implements
        LoaderManager.LoaderCallbacks<Cursor> {
    public interface ConversationFragmentListener {
        void hideKeyboard();
    }
    ConversationFragment.ConversationFragmentListener mListener;
    private LoaderManager.LoaderCallbacks<Cursor> mCallbacks;
    private ConversationCustomCursorAdapter conversationCustomCursorAdapter;
    //public static String currentToFirstName, currentToLastName;
    private String firstName, lastName;
    private View rootView;
    ListView listView;
    EditText editText;
    private int currentPosition = -1;
    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        try {
            mListener = (ConversationFragment.ConversationFragmentListener) activity;
        } catch (ClassCastException e) {
            throw new ClassCastException(activity.toString() + " must implement ConversationFragmentListener");
        }
    }
    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        //outState.putInt("listViewPosition", listView.getFirstVisiblePosition());
    }
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        MainActivity.isMessagerOpen = false;
        MainActivity.isConversationOpen = true;
        if(rootView==null){
            rootView = inflater.inflate(R.layout.conversation_fragment, container, false);
            TextView textView = (TextView)rootView.findViewById(R.id.conversation_fragment_recipient_name);
            textView.setText(MainActivity.currentToFirstName+" "+MainActivity.currentToLastName);
            editText = (EditText)rootView.findViewById(R.id.composeMessageEditText);
            if (listView==null){
                conversationCustomCursorAdapter = new ConversationCustomCursorAdapter(getActivity(), null, 0);
                listView = (ListView)rootView.findViewById(R.id.conversation_fragment_listview);
                //listView.setTranscriptMode(AbsListView.TRANSCRIPT_MODE_NORMAL);
                listView.setAdapter(conversationCustomCursorAdapter);
                mCallbacks = this;
                LoaderManager loaderManager = getLoaderManager();
                loaderManager.initLoader(1, null, mCallbacks);
                /*new Handler().post(new Runnable() {
                    @Override
                    public void run() {
                        ConversationDatabase database = ConversationDatabase.getDatabase(getActivity());
                        final Cursor cursor = database.loadHistory(MainActivity.currentToFirstName+MainActivity.currentToLastName);
                        if(cursor.getCount() > 0){
                            listView = (ListView)rootView.findViewById(R.id.conversation_fragment_listview);
                            listView.setTranscriptMode(AbsListView.TRANSCRIPT_MODE_NORMAL);
                            ConversationCustomCursorAdapter conversationCustomCursorAdapter = new ConversationCustomCursorAdapter(getActivity(), cursor, 0);
                            listView.setAdapter(conversationCustomCursorAdapter);
                            listView.setSelection(conversationCustomCursorAdapter.getCount()-1);
                        }
                    }
                });*/
            }
        }
        setRetainInstance(true);
        if (savedInstanceState != null) {
            //position = savedInstanceState.getInt("listViewPosition", 0);
        }
        mListener.hideKeyboard();
        if (editText!=null) {
            closeKeyboard(getActivity(), editText.getWindowToken());
        }
        if (firstName==null){
            SharedPreferences settings = getActivity().getSharedPreferences("registeredname", 0);
            firstName = settings.getString("firstName", "");
            lastName = settings.getString("lastName", "");

        }
        return rootView;
    }
    @Override
    public Loader<Cursor> onCreateLoader(int id, Bundle args) {
        //return new CursorLoader(getActivity(), CONTENT_URI,PROJECTION, null, null, null);
        Uri uri = Uri.parse("content://uri_for_conversation_fragment_cursor_loader");
        return new CursorLoader(getActivity(), uri, null, null, null, null) {
            private final ForceLoadContentObserver mObserver = new ForceLoadContentObserver();

            @Override
            public Cursor loadInBackground() {
                ConversationDatabase database = ConversationDatabase.getDatabase(getActivity());
                Cursor cursor = database.loadHistory(MainActivity.currentToFirstName+MainActivity.currentToLastName);
                if (cursor != null) {
                    // Ensure the cursor window is filled
                    cursor.getCount();
                    cursor.registerContentObserver(mObserver);
                }
                cursor.setNotificationUri(getContext().getContentResolver(), getUri());
                return cursor;
            }
        };
    }

    @Override
    public void onLoadFinished(Loader<Cursor> loader, Cursor cursor) {
        // A switch-case is useful when dealing with multiple Loaders/IDs
        switch (loader.getId()) {
            case 1:
                conversationCustomCursorAdapter.swapCursor(cursor);
                if (-1==currentPosition){
                    listView.setSelection(conversationCustomCursorAdapter.getCount()-1);
                }
                else {
                    listView.setSelection(currentPosition);
                }
                break;
        }
    }

    @Override
    public void onLoaderReset(Loader<Cursor> loader) {
        conversationCustomCursorAdapter.swapCursor(null);
    }
    public void closeKeyboard(Context context, IBinder windowToken) {
        InputMethodManager inputMethodManager = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
        inputMethodManager.hideSoftInputFromWindow(windowToken, 0);
        try {
            inputMethodManager.hideSoftInputFromWindow(getActivity().getCurrentFocus().getWindowToken(), 0);
        }
        catch(Exception e) {
            e.printStackTrace();
        }
    }
    public void composeMessageEnterPressed() {
        Intent intent = new Intent(getActivity(), HttpPost.class);
        intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.http.post");
        intent.putExtra("url", getResources().getString(R.string.server_address)+"send-message.php");
        try {
            JSONObject payload = new JSONObject();
            payload.put("type", "instantMessage");
            JSONObject message = new JSONObject();
            message.put("fromFirstName", firstName);
            message.put("fromLastName", lastName);
            message.put("message", editText.getText().toString());
            payload.put("message", message);
            intent.putExtra("data", URLEncoder.encode("toFirstName", "UTF-8") + "=" + URLEncoder.encode(MainActivity.currentToFirstName, "UTF-8") + "&" + URLEncoder.encode("toLastName", "UTF-8") + "=" + URLEncoder.encode(MainActivity.currentToLastName, "UTF-8") + "&" + URLEncoder.encode("message_payload", "UTF-8") + "=" + URLEncoder.encode(payload.toString(), "UTF-8"));

            JSONObject extraData = new JSONObject();
            extraData.put("toFirstName", MainActivity.currentToFirstName);
            extraData.put("toLastName", MainActivity.currentToLastName);
            extraData.put("message", editText.getText().toString());
            intent.putExtra("extra_data", extraData.toString());
        } catch (UnsupportedEncodingException | JSONException e) {
            e.printStackTrace();
        }
        intent.putExtra("broadcast_receiver", "instantmessageresponse");
        //mListener.addNewMessage(editText.getText().toString(), MainActivity.currentToFirstName, MainActivity.currentToLastName, 0);
        //editText.setText("");
        getActivity().startService(intent);
    }
    public void clearEditText(){
        editText.setText("");
    }
    public void saveListViewPosition(){
        if (listView!=null){
            currentPosition = listView.getFirstVisiblePosition();
        }
    }
}
