package com.opendoormediadesign.houseandhome757;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.content.LocalBroadcastManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class ReferralsFragment extends android.support.v4.app.Fragment {
        public interface ReferralsFragmentListener {
            void openSpecificReferral(String referralNumber);
        }

        ReferralsFragment.ReferralsFragmentListener mListener;
        View rootView;
        final ArrayList<String[]> arrayList = new ArrayList<String[]>();
        ListView listView;
        int position = 0;
        @Override
        public void onAttach(Activity activity) {
            super.onAttach(activity);
            try {
                mListener = (ReferralsFragment.ReferralsFragmentListener) activity;
            } catch (ClassCastException e) {
                throw new ClassCastException(activity.toString() + " must implement ReferralsFragmentListener");
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
            rootView = inflater.inflate(R.layout.referrals_fragment, container, false);
            Intent intent = new Intent(getActivity(), HttpPost.class);
            intent.putExtra("action", "com.opendoormediadesign.houseandhome757.action.http.post");
            intent.putExtra("url", getResources().getString(R.string.server_address)+"get-referrals-previews.php");
            intent.putExtra("broadcast_receiver", "referralspreviewsready");
            getActivity().startService(intent);
        }
        setRetainInstance(true);
        if (savedInstanceState != null) {
            position = savedInstanceState.getInt("listViewPosition", 0);
        }
        return rootView;
    }
    @Override
    public void onResume() {
        super.onResume();
        LocalBroadcastManager.getInstance(getActivity()).registerReceiver(referralsPreviewsReceiver, new IntentFilter("referralspreviewsready"));
    }
    @Override
    public void onPause() {
        super.onPause();
        LocalBroadcastManager.getInstance(getActivity()).unregisterReceiver(referralsPreviewsReceiver);
    }
    public void populateReferrals(String[] urls, String[] previewsFirst, String[] previewsSecond, String[] referralNumbers){
        if (urls!=null) {
            for (int i = 0; i < urls.length; i++) {
                String[] data = new String[4];
                data[0] = urls[i];
                data[1] = previewsFirst[i];
                data[2] = previewsSecond[i];
                data[3] = referralNumbers[i];
                arrayList.add(data);
            }
        }
        if (listView==null){
            listView = (ListView)getActivity().findViewById(R.id.referrals_fragment_listview);
        }
        ReferralsCustomAdapter referralsCustomAdapter = new ReferralsCustomAdapter(getActivity(), arrayList);
        listView.setAdapter(referralsCustomAdapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> arg0, View view, int position, long arg3) {
                mListener.openSpecificReferral(arrayList.get(position)[3]);
            }
        });
    }
    private BroadcastReceiver referralsPreviewsReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String [] urls = null, previewsFirst = null, previewsSecond = null, referralNumbers = null;
            String result = intent.getStringExtra("result");
            JSONArray jArray;
            try {
                jArray = new JSONArray(result);
                referralNumbers = new String[jArray.length()];
                urls = new String[jArray.length()];
                previewsFirst = new String[jArray.length()];
                previewsSecond = new String[jArray.length()];
                for (int i = 0; i < jArray.length(); i++) {
                    JSONObject jObject = jArray.getJSONObject(i);
                    referralNumbers[i] = jObject.getString("referralNumber");
                    urls[i] = jObject.getString("first");
                    previewsFirst[i] = jObject.getString("second");
                    previewsSecond[i] = jObject.getString("third");
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
            Fragment f = getActivity().getSupportFragmentManager().findFragmentById(R.id.fragment_holder);
            if (f instanceof ReferralsFragment) {
                ((ReferralsFragment)f).populateReferrals(urls, previewsFirst, previewsSecond, referralNumbers);
            }
        }
    };
}