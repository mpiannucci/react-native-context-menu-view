package com.mpiannucci.reactnativecontextmenu;

import android.content.Context;
import android.content.res.Resources;
import android.gesture.Gesture;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.GestureDetector;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupMenu;

import androidx.core.content.res.ResourcesCompat;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.touch.OnInterceptTouchEventListener;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.facebook.react.views.view.ReactViewGroup;

import java.lang.reflect.Method;
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

    protected boolean dropdownMenuMode = false;

    public ContextMenuView(final Context context) {
        super(context);

        contextMenu = new PopupMenu(getContext(), this);
        contextMenu.setOnMenuItemClickListener(this);
        contextMenu.setOnDismissListener(this);

        gestureDetector = new GestureDetector(context, new GestureDetector.SimpleOnGestureListener() {
            @Override
            public boolean onSingleTapConfirmed(MotionEvent e) {
                if (dropdownMenuMode) {
                    contextMenu.show();
                }
                return super.onSingleTapConfirmed(e);
            }

            @Override
            public void onLongPress(MotionEvent e) {
                if (!dropdownMenuMode) {
                    contextMenu.show();
                }
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
        setIconEnable(menu, true);

        for (int i = 0; i < actions.size(); i++) {
            ReadableMap action = actions.getMap(i);
            @Nullable Drawable systemIcon = getResourceWithName(getContext(), action.getString("systemIcon"));
            int order = i;
            menu.add(Menu.NONE, Menu.NONE, order, action.getString("title"));
            menu.getItem(i).setEnabled(!action.hasKey("disabled") || !action.getBoolean("disabled"));
            menu.getItem(i).setIcon(systemIcon);
        }
    }

    public void setDropdownMenuMode(@Nullable boolean enabled) {
        this.dropdownMenuMode = enabled;
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

    private Drawable getResourceWithName(Context context, @Nullable String systemIcon) {
        if (systemIcon == null)
            return null;

        Resources resources = context.getResources();
        int resourceId = resources.getIdentifier(systemIcon, "drawable", context.getPackageName());
        try {
            return resourceId != 0 ? ResourcesCompat.getDrawable(resources, resourceId, null) : null;
        } catch (Exception e) {
            return null;
        }
    }

    // Reflection to set icon visible
    private void setIconEnable(Menu menu, boolean enable){
        try{
            Class<?> clazz = Class.forName("com.android.internal.view.menu.MenuBuilder");
            Method m = clazz.getDeclaredMethod("setOptionalIconsVisible", boolean.class);
            m.setAccessible(true);

            m.invoke(menu, enable);
        } catch (Exception e){
            e.printStackTrace();
        }
    }
}
