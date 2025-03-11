package com.mpiannucci.reactnativecontextmenu;

import android.view.ViewGroup;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.views.view.ReactViewGroup;

import java.util.ArrayList;
import java.util.Map;

import javax.annotation.Nullable;

public class ContextMenuManager extends ViewGroupManager<ContextMenuView> {

    public static final String REACT_CLASS = "ContextMenu";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public ContextMenuView createViewInstance(ThemedReactContext context) {
        ContextMenuView reactViewGroup = new ContextMenuView(context);
        return reactViewGroup;
    }

    @ReactProp(name = "title")
    public void setTitle(ContextMenuView view, @Nullable String title) {
        // TODO: Maybe support this? IDK if its necessary though
    }

    @ReactProp(name = "actions")
    public void setActions(ContextMenuView view, @Nullable ReadableArray actions) {
        view.setActions(actions);
    }

    @ReactProp(name = "dropdownMenuMode")
    public void setDropdownMenuMode(ContextMenuView view, @Nullable boolean enabled) {
        view.setDropdownMenuMode(enabled);
    }

    @ReactProp(name = "disabled")
    public void setDisabled(ContextMenuView view, @Nullable boolean disabled) {
        view.setDisabled(disabled);
    }

    @ReactProp(name = "fontName")
    public void setFontName(ContextMenuView view, @Nullable String fontName) {
        view.setFontName(fontName);
    }

    @androidx.annotation.Nullable
    @Override
    public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
        return MapBuilder.<String, Object>builder()
                .put("onPress", MapBuilder.of("registrationName", "onPress"))
                .put("onCancel", MapBuilder.of("registrationName", "onCancel"))
                .build();
    }
}
