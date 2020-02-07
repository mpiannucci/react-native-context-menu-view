package com.mpiannucci.rncontextmenu;

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

import com.facebook.react.touch.OnInterceptTouchEventListener;
import com.facebook.react.views.view.ReactViewGroup;

import java.util.List;

public class RnContextMenuView extends ReactViewGroup {

    PopupMenu contextMenu;

    GestureDetector gestureDetector;

    public RnContextMenuView(final Context context) {
        super(context);

        contextMenu = new PopupMenu(getContext(), this);

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
        return false;
    }

    void setActions(List<String> actions) {
        Menu menu = contextMenu.getMenu();
        menu.clear();

        for (String action : actions) {
            menu.add(action);
        }
    }
}
