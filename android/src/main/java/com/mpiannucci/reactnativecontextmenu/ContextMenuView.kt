package com.mpiannucci.reactnativecontextmenu

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap
import com.facebook.react.touch.OnInterceptTouchEventListener
import com.facebook.react.uimanager.events.RCTEventEmitter
import com.facebook.react.views.view.ReactViewGroup

import android.content.Context;
import android.view.Menu;
import android.view.SubMenu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.GestureDetector
import android.gesture.Gesture
import android.content.res.ColorStateList
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.RippleDrawable
import android.graphics.drawable.Drawable
import android.content.res.Resources

import me.saket.cascade.CascadePopupMenu
import me.saket.cascade.add
import me.saket.cascade.addSubMenu
import me.saket.cascade.allChildren

import kotlin.collections.List
import javax.annotation.Nullable;
import java.security.AccessController.getContext

import androidx.appcompat.widget.PopupMenu
import androidx.core.view.MenuCompat
import android.R


class ContextMenuView(context: Context) : ReactViewGroup(context), PopupMenu.OnMenuItemClickListener {
    var contextMenu: CascadePopupMenu
    var gestureDetector: GestureDetector? = null

    private var dropdownMenuMode = false
    private var backgroundColor = "#FFFFFF"
    private var textColor = "#000000"

    override fun addView(child: View, index: Int) {
        super.addView(child, index);
        child.setClickable(false);
    }

    fun setActions(@Nullable actions: ReadableArray) {
        for (i in 0 until actions.size()) {
            val action: ReadableMap = actions.getMap(i)
            val icnName = action.getString("systemIcon")
            val title = action.getString("title")

            if (icnName != null) {
                val id: Int = Resources.getSystem().getIdentifier(icnName, "drawable", "android")
                contextMenu.menu.add(title).setIcon(id)
            } else {
                contextMenu.menu.add(title)
            }

        }
    }

    override fun onInterceptTouchEvent(ev: MotionEvent?): Boolean {
        return true
    }

    override fun onTouchEvent(ev: MotionEvent?): Boolean {
        gestureDetector?.onTouchEvent(ev)
        return true
    }

    fun setDropdownMenuMode(@Nullable enabled: Boolean) {
        dropdownMenuMode = enabled
    }

    fun setBackgroundColor(color: String) {
        backgroundColor = color
    }

    fun setTextColor(color: String) {
        textColor = color
    }

    private fun cascadeMenuStyler(): CascadePopupMenu.Styler {
        return CascadePopupMenu.Styler(
                background = {
                    RoundedRectDrawable(Color.parseColor(backgroundColor), radius = 30f)
                },
                menuItem = {
                    it.titleView.setTextColor(Color.parseColor(textColor))
                }
        )
    }

    override fun onMenuItemClick(menuItem: MenuItem): Boolean {
        val reactContext: ReactContext = getContext() as ReactContext
        val event: WritableMap = Arguments.createMap()
        event.putInt("index", menuItem.getOrder())
        event.putString("name", menuItem.getTitle().toString())
        reactContext.getJSModule(RCTEventEmitter::class.java).receiveEvent(getId(), "onPress", event)
        return false
    }

    init {
        contextMenu = CascadePopupMenu(getContext(), this, styler = cascadeMenuStyler())
        contextMenu.menu.apply {
            MenuCompat.setGroupDividerEnabled(this, true)
        }
        contextMenu.setOnMenuItemClickListener(this as PopupMenu.OnMenuItemClickListener);
        gestureDetector = GestureDetector(context, object : GestureDetector.SimpleOnGestureListener() {

            override fun onSingleTapConfirmed(e: MotionEvent): Boolean {
                if (dropdownMenuMode) {
                    contextMenu.show()
                }
                return super.onSingleTapConfirmed(e)
            }

            override fun onLongPress(e: MotionEvent) {
                if (!dropdownMenuMode) {
                    contextMenu.show()
                }
            }
        })
    }
}
