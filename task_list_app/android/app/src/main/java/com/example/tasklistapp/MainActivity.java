package com.example.tasklistapp;

import android.app.FragmentTransaction;
import android.content.SharedPreferences;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.preference.PreferenceFragment;
import android.support.v7.preference.PreferenceManager;

import java.util.Map;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "task_app";
  private static final String preferencesFile = "FlutterSharedPreferences";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    GeneratedPluginRegistrant.registerWith(this);

    final MainActivity act = this;

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
      new MethodChannel.MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall call, MethodChannel.Result result) {
              if (call.method.equals("showPreferences")) {
                  Intent intent = new Intent(act, PreferenceActivity.class);
                  startActivity(intent);
              }
          }
    });
  }

   @Override
   protected void onResume() {
       super.onResume();

       MethodChannel channel = new MethodChannel(getFlutterView(), CHANNEL);
       SharedPreferences prefs = getSharedPreferences(preferencesFile, MODE_PRIVATE);

       Map<String, ?> strings = prefs.getAll();
       for(Map.Entry<String, ?> entry : strings.entrySet()) {
            channel.invokeMethod(
                    "loadPreference",
                    String.format("%s:%s", entry.getKey(), entry.getValue()));
       }
    }
}

