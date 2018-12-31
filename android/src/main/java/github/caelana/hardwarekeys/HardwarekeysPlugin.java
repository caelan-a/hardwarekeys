// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package github.caelana.hardwarekeys;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;

import android.view.View;
import android.view.KeyEvent;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class HardwarekeysPlugin implements EventChannel.StreamHandler {
  /** Plugin registration. */
  private static final String CHANNEL_NAME = "github.caelana.hardwarekeys";

  public static void registerWith(Registrar registrar) {
    final EventChannel channel = new EventChannel(registrar.messenger(), CHANNEL_NAME);
    channel.setStreamHandler(new HardwarekeysPlugin(registrar.context(), registrar.view()));
  }

  /** Plugin */
  private Context context;
  private View view;
  private EventChannel.EventSink events;

  private HomeKeyListener homeKeyListener;
  private KeyListener keyListener;

  public HardwarekeysPlugin(Context context, View view) {
    this.context = context;
    this.view = view;
    homeKeyListener = new HomeKeyListener(context);
    keyListener = new KeyListener(view);
  }

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
    this.events = events;
    homeKeyListener.onListen(arguments, events);
    keyListener.onListen(arguments, events);
  }

  @Override
  public void onCancel(Object arguments) {
    homeKeyListener.onCancel(arguments);
    keyListener.onCancel(arguments);
  }

}

class KeyListener implements View.OnKeyListener {
  View view;
  EventChannel.EventSink events;

  KeyListener(View view) {
    this.view = view;
  }

  public void onListen(Object arguments, EventChannel.EventSink events) {
    view.setOnKeyListener(this);
    this.events = events;
  }

  public void onCancel(Object arguments) {
    /*  */
  }

  public boolean onKey(View v, int keyCode, KeyEvent event) {
    if (event.getAction() == KeyEvent.ACTION_DOWN) {
      switch (keyCode) {
      case KeyEvent.KEYCODE_VOLUME_DOWN:
        events.success("volume_down");
        return true;
      case KeyEvent.KEYCODE_VOLUME_UP:
        events.success("volume_up");
        return true;
      case KeyEvent.KEYCODE_VOLUME_MUTE:
        events.success("volume_mute");
        return true;
      }
    }
    return false;
  }
}

class HomeKeyListener {
  private Context context;
  private IntentFilter mFilter;
  private InnerReceiver mReceiver;

  HomeKeyListener(Context context) {
    this.context = context;
    mFilter = new IntentFilter(Intent.ACTION_CLOSE_SYSTEM_DIALOGS);
  }

  public void onListen(Object arguments, EventChannel.EventSink events) {
    mReceiver = new InnerReceiver(events);
    if (mReceiver != null) {
      context.registerReceiver(mReceiver, mFilter);
    }
  }

  public void onCancel(Object arguments) {
    if (mReceiver != null) {
      context.unregisterReceiver(mReceiver);
    }
  }

  class InnerReceiver extends BroadcastReceiver {
    final String SYSTEM_DIALOG_REASON_KEY = "reason";
    final String SYSTEM_DIALOG_REASON_HOME_KEY = "homekey";
    final String SYSTEM_DIALOG_REASON_POWER_KEY = "dream";

    final EventChannel.EventSink events;

    InnerReceiver(final EventChannel.EventSink events) {
      this.events = events;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
      String action = intent.getAction();
      // Detect home key pressed
      if (action.equals(Intent.ACTION_CLOSE_SYSTEM_DIALOGS)) {
        String reason = intent.getStringExtra(SYSTEM_DIALOG_REASON_KEY);
        if (reason != null) {
          Log.e("HomeKeyListener", "action: " + action + ", reason: " + reason);
          if (reason.equals(SYSTEM_DIALOG_REASON_HOME_KEY)) {
            events.success("home");
          } else if (reason.equals(SYSTEM_DIALOG_REASON_POWER_KEY)) {
            events.success("power");
          }
        }
      }
    }
  }
}