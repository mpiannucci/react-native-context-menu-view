package com.mpiannucci.rncontextmenu;

import android.view.ViewGroup;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.views.view.ReactViewGroup;

import java.util.ArrayList;

import javax.annotation.Nullable;

public class RnContextMenuManager extends ViewGroupManager<RnContextMenuView> {

    public static final String REACT_CLASS = "ContextMenu";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public RnContextMenuView createViewInstance(ThemedReactContext context) {
        RnContextMenuView reactViewGroup = new RnContextMenuView(context);
        return reactViewGroup;
    }

    @ReactProp(name = "title")
    public void setTitle(RnContextMenuView view, @Nullable String title) {
        // TODO: Maybe support this? IDK if its necessary though
    }

    @ReactProp(name = "actions")
    public void setActions(RnContextMenuView view, @Nullable ReadableArray actions) {
        ArrayList<String> newActions = new ArrayList();

        for (int i = 0; i < actions.size(); i++) {
            ReadableMap action = actions.getMap(i);
            newActions.add(action.getString("title"));
        }

        view.setActions(newActions);
    }


}
