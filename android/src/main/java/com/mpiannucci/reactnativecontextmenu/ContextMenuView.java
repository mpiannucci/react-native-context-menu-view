package com.mpiannucci.reactnativecontextmenu;

import android.content.Context;
import android.gesture.Gesture;
import android.util.Log;
import android.view.GestureDetector;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupMenu;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.touch.OnInterceptTouchEventListener;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.facebook.react.views.view.ReactViewGroup;

import java.util.List;

import javax.annotation.Nullable;

public class ContextMenuView extends ReactViewGroup implements PopupMenu.OnMenuItemClickListener, PopupMenu.OnDismissListener {

    public class Action {
        String title;
        boolean disabled;

        public Action(String title, boolean disabled) {
            this.title = title;
            this.disabled = disabled;
        }
    }

    PopupMenu contextMenu;

    GestureDetector gestureDetector;

    boolean cancelled = true;

    public ContextMenuView(final Context context) {
        super(context);

        contextMenu = new PopupMenu(getContext(), this);
        contextMenu.setOnMenuItemClickListener(this);
        contextMenu.setOnDismissListener(this);

        gestureDetector = new GestureDetector(context, new GestureDetector.SimpleOnGestureListener() {
            @Override
            public void onLongPress(MotionEvent e) {
                contextMenu.show();
            }
        });
    }

    @Override
    public void addView(View child, int index) {
        super.addView(child, index);

        child.setClickable(false);
    }

    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {
        return true;
    }

    @Override
    public boolean onTouchEvent(MotionEvent ev) {
        gestureDetector.onTouchEvent(ev);
        return true;
    }

    public void setActions(@Nullable ReadableArray actions) {
        Menu menu = contextMenu.getMenu();
        menu.clear();

        for (int i = 0; i < actions.size(); i++) {
            ReadableMap action = actions.getMap(i);
            int order = i;
            menu.add(Menu.NONE, Menu.NONE, order, action.getString("title"));
            menu.getItem(i).setEnabled(!action.hasKey("disabled") || !action.getBoolean("disabled"));
        }
    }

    @Override
    public boolean onMenuItemClick(MenuItem menuItem) {
        cancelled = false;
        ReactContext reactContext = (ReactContext) getContext();
        WritableMap event = Arguments.createMap();
        event.putInt("index", menuItem.getOrder());
        event.putString("name", menuItem.getTitle().toString());
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(getId(), "onPress", event);
        return false;
    }

    @Override
    public void onDismiss(PopupMenu popupMenu) {
        if (cancelled) {
            ReactContext reactContext = (ReactContext) getContext();
            reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(getId(), "onCancel", null);
        }

        cancelled = true;
    }
}
