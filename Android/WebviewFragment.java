package com.opendoormediadesign.houseandhome757;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import java.net.URI;
import java.net.URISyntaxException;

public class WebviewFragment extends android.support.v4.app.Fragment {
    public static String url;
    public static WebView webView;
    View rootView;
    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
    }
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        if(rootView==null){
            rootView = inflater.inflate(R.layout.webview_fragment, container, false);
            webView = (WebView) rootView.findViewById(R.id.webview_fragment_webview);
            WebSettings webSettings = webView.getSettings();
            webSettings.setJavaScriptEnabled(true);
            webSettings.setBuiltInZoomControls(true);
            webView.setWebViewClient(new MyWebViewClient());
            webView.loadUrl(url);
        }
        setRetainInstance(true);
        if (savedInstanceState != null) {
            //position = savedInstanceState.getInt("listViewPosition", 0);
        }
        return rootView;
    }
    @Override
    public void onStart() {
        super.onStart();

    }
    @Override
    public void onResume() {
        super.onResume();
    }
    @Override
    public void onPause() {
        super.onPause();
    }
    private class MyWebViewClient extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String clickedURL) {
            URI uri;
            try {
                uri = new URI(url);
                String hostURL = uri.getHost();
                int position = hostURL.indexOf(".");
                int secondPosition = hostURL.substring(position+1).indexOf(".");
                if (-1==secondPosition && Uri.parse(clickedURL).getHost().contains(hostURL)) {
                    return false;
                }
                if (-1!=secondPosition && Uri.parse(clickedURL).getHost().contains(hostURL.substring(position+1))) {
                    return false;
                }
            } catch (URISyntaxException e) {
                e.printStackTrace();
            }
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(clickedURL));
            if (intent.resolveActivity(getActivity().getPackageManager()) != null) {
                startActivity(intent);
            }
            return true;
        }
    }
}