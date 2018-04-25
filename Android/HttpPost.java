package com.opendoormediadesign.houseandhome757;

import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.support.v4.content.LocalBroadcastManager;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;

public class HttpPost extends IntentService {

    private static final String ACTION_HTTP_POST = "com.opendoormediadesign.houseandhome757.action.http.post";

    public HttpPost() {
        super("HttpPost");
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        if (intent != null) {
            String action = intent.getStringExtra("action");
            if (ACTION_HTTP_POST.equals(action)) {
                String data = null;
                try {
                    data = intent.getStringExtra("data") + "&" + URLEncoder.encode("phpKey", "UTF-8") + "=" + URLEncoder.encode(getResources().getString(R.string.php_key), "UTF-8");
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                httpPost(intent.getStringExtra("url"), data, intent.getStringExtra("broadcast_receiver"), intent.getStringExtra("extra_data"));
            }
        }
    }
    protected void httpPost(String link, String data, String broadcastReceiver, String extraData){
        ConnectivityManager connMgr = (ConnectivityManager)
                getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connMgr.getActiveNetworkInfo();
        if (networkInfo != null && networkInfo.isConnected()) {
            URL url;
            URLConnection conn;
            String result;
            BufferedReader reader=null;
            try {
                url = new URL(link);
                conn = url.openConnection();
                if (data != null) {
                    conn.setDoOutput(true);
                    Writer wr = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
                    wr.write(data);
                    wr.flush();
                    wr.close();
                }
                reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder builder = new StringBuilder();
                String line;
                if ((line = reader.readLine()) != null) {
                    builder.append(line);
                }
                while ((line = reader.readLine()) != null) {
                    builder.append("\n"+line);
                }
                if (broadcastReceiver != "") {
                    result = builder.toString();
                    Intent intent = new Intent(broadcastReceiver);
                    intent.putExtra("result", result);
                    intent.putExtra("extra_data", extraData);
                    LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
                }

            } catch (IOException e) {
                e.printStackTrace();
            }
            finally { try { reader.close(); } catch(Exception ex) {} }

        }
        else {
            // display error
        }
    }
}
