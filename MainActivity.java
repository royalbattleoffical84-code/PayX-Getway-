package com.payx.io;
import android.app.Activity; import android.os.Bundle; import android.webkit.WebView; import android.webkit.WebViewClient; import android.webkit.WebSettings; import android.widget.Toast;
public class MainActivity extends Activity {
 private static final String ADMIN_URL="https://payxoffical.infinityfreeapp.com/admin.html"; // Replace with HTTPS URL after deployment.
 private WebView web;
 @Override public void onCreate(Bundle b){super.onCreate(b);web=new WebView(this);setContentView(web);WebSettings s=web.getSettings();s.setJavaScriptEnabled(true);s.setDomStorageEnabled(true);s.setAllowFileAccess(false);s.setAllowContentAccess(false);web.setWebViewClient(new WebViewClient(){@Override public boolean shouldOverrideUrlLoading(WebView v,String url){return !url.startsWith("https://payxoffical.infinityfreeapp.com/");}});web.loadUrl(ADMIN_URL);}
 @Override public void onBackPressed(){if(web!=null&&web.canGoBack())web.goBack();else super.onBackPressed();}
}