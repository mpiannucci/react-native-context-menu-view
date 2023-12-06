package com.mpiannucci.reactnativecontextmenu;

import android.content.Context;
import android.content.res.ColorStateList;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.style.ForegroundColorSpan;
import android.view.GestureDetector;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ContextMenu;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.facebook.react.views.view.ReactViewGroup;

import javax.annotation.Nullable;

public class ContextMenuView extends ReactViewGroup implements View.OnCreateContextMenuListener {
    @Nullable ReadableArray actions;

    boolean cancelled = true;

    protected boolean dropdownMenuMode = false;

    protected boolean disabled = false;

    private GestureDetector gestureDetector;

    public ContextMenuView(final Context context) {
        super(context);

        this.setOnCreateContextMenuListener(this);

        gestureDetector = new GestureDetector(context, new GestureDetector.SimpleOnGestureListener() {
            @Override
            public boolean onSingleTapConfirmed(MotionEvent e) {
                if (dropdownMenuMode && !disabled) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                        showContextMenu(e.getX(), e.getY());
                    }
                }
                return super.onSingleTapConfirmed(e);
            }

            @Override
            public void onLongPress(MotionEvent e) {
                if (!dropdownMenuMode && !disabled) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                        showContextMenu(e.getX(), e.getY());
                    }
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

    @Override
    public void onCreateContextMenu(ContextMenu contextMenu, View view, ContextMenu.ContextMenuInfo contextMenuInfo) {
        contextMenu.clear();

        for (int i = 0; i < actions.size(); i++) {
            ReadableMap action = actions.getMap(i);
            ReadableArray childActions = action.getArray("actions");

            // If there are child actions, this action is a submenu
            if (childActions != null) {
                createContextMenuSubMenu(contextMenu, action, childActions, i);
            } else {
                // Otherwise its a normal menu item
                createContextMenuAction(contextMenu, action, i, -1);
            }
        }
    }

    public void setActions(@Nullable ReadableArray actions) {
        this.actions = actions;
    }

    public void setDropdownMenuMode(@Nullable boolean enabled) {
        this.dropdownMenuMode = enabled;
    }

    public void setDisabled(@Nullable boolean disabled) {
        this.disabled = disabled;
    }

    private void createContextMenuSubMenu(Menu menu, ReadableMap action, ReadableArray childActions, int i) {
        String title = action.getString("title");
        Menu parentMenu = menu.addSubMenu(title);

        for (int j = 0; j < childActions.size(); j++) {
            createContextMenuAction(parentMenu, childActions.getMap(j), j, i);
        }
    }

    private void createContextMenuAction(Menu menu, ReadableMap action, int i, int parentIndex) {
        String title = action.getString("title");
        @Nullable Drawable systemIcon = getResourceWithName(getContext(), action.getString("systemIcon"));

        MenuItem item = menu.add(Menu.NONE, Menu.NONE, i, title);
        item.setEnabled(!action.hasKey("disabled") || !action.getBoolean("disabled"));

        if (action.hasKey("systemIconColor") && systemIcon != null) {
            int color = Color.parseColor(action.getString("systemIconColor"));
            systemIcon.setTint(color);
        }
        item.setIcon(systemIcon);
        if (action.hasKey("destructive") && action.getBoolean("destructive")) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                item.setIconTintList(ColorStateList.valueOf(Color.RED));
            }
            SpannableString redTitle = new SpannableString(title);
            redTitle.setSpan(new ForegroundColorSpan(Color.RED), 0, title.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
            item.setTitle(redTitle);
        }

        // We need a different listener for nested menus and parent menus
        item.setOnMenuItemClickListener(new MenuItem.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(@NonNull MenuItem menuItem) {
                cancelled = false;
                ReactContext reactContext = (ReactContext) getContext();
                WritableMap event = Arguments.createMap();
                event.putInt("index", i);
                event.putString("name", title);
                if (parentIndex >= 0) {
                    WritableArray indexPath = Arguments.createArray();
                    indexPath.pushInt(parentIndex);
                    indexPath.pushInt(i);
                    event.putArray("indexPath", indexPath);
                }
                reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(getId(), "onPress", event);
                return false;
            }
        });
    }

    private Drawable getResourceWithName(Context context, @Nullable String systemIcon) {
        if (systemIcon == null)
            return null;

        Resources resources = context.getResources();
        int resourceId = resources.getIdentifier(systemIcon, "drawable", context.getPackageName());
        try {
            return resourceId != 0 ? ResourcesCompat.getDrawable(resources, resourceId, context.getTheme()) : null;
        } catch (Exception e) {
            return null;
        }
    }
}
