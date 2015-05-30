//
// $Id: EventHandlerManager.as 133 2009-10-20 20:40:16Z tim $
//
// Flash Utils library - general purpose ActionScript utility code
// Copyright (C) 2007-2009 Three Rings Design, Inc., All Rights Reserved
// http://www.threerings.net/code/ooolib/
//
// This library is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published
// by the Free Software Foundation; either version 2.1 of the License, or
// (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

package com.threerings.util {

import flash.events.Event;
import flash.events.IEventDispatcher;

/**
 * A class for keeping track of event listeners and freeing them all at a given time.  This is
 * useful for keeping track of your ENTER_FRAME listeners, and releasing them all on UNLOAD to
 * make sure your game/furni/avatar fully unloads at the proper time.
 */
public class EventHandlerManager
{
    /**
     * Adds the specified listener to the specified dispatcher for the specified event.
     */
    public function registerListener (dispatcher :IEventDispatcher, event :String,
        listener :Function, useCapture :Boolean = false, priority :int = 0) :void
    {
        dispatcher.addEventListener(event, listener, useCapture, priority);
        _eventHandlers.push(new RegisteredListener(dispatcher, event, listener, useCapture));
    }

    /**
     * Removes the specified listener from the specified dispatcher for the specified event.
     */
    public function unregisterListener (dispatcher :IEventDispatcher, event :String,
        listener :Function, useCapture :Boolean = false) :void
    {
        dispatcher.removeEventListener(event, listener, useCapture);

        for (var ii :int = 0; ii < _eventHandlers.length; ii++) {
            var rl :RegisteredListener = _eventHandlers[ii];
            if (dispatcher == rl.dispatcher && event == rl.event &&  listener == rl.listener &&
                useCapture == rl.useCapture) {
                _eventHandlers.splice(ii, 1);
                break;
            }
        }
    }

    /**
     * Registers a zero-arg callback function that should be called once when the event fires.
     */
    public function registerOneShotCallback (dispatcher :IEventDispatcher, event :String,
        callback :Function, useCapture :Boolean = false, priority :int = 0) :void
    {
        var eventListener :Function = function (...ignored) :void {
            unregisterListener(dispatcher, event, eventListener, useCapture);
            callback();
        };

        registerListener(dispatcher, event, eventListener, useCapture, priority);
    }

    /**
     * Registers the freeAllHandlers() method to be called upon Event.UNLOAD on the supplied
     * event dispatcher.
     */
    public function registerUnload (dispatcher :IEventDispatcher) :void
    {
        registerListener(dispatcher, Event.UNLOAD, freeAllHandlers);
    }

    /**
     * Will either call a given function now, or defer it based on the boolean parameter.  If the
     * parameter is false, the function will be registered as a one-shot callback on the dispatcher
     */
    public function callWhenTrue (callback :Function, callNow :Boolean,
        dispatcher :IEventDispatcher, event :String, useCapture :Boolean = false,
        priority :int = 0) :void
    {
        if (callNow) {
            callback();
        } else {
            registerOneShotCallback(dispatcher, event, callback, useCapture, priority);
        }
    }

    public function freeAllOn (dispatcher :IEventDispatcher) :void
    {
        for each (var rl :RegisteredListener in _eventHandlers) {
            if (rl.dispatcher == dispatcher) {
                rl.free();
            }
        }
    }

    /**
     * Free all handlers that have been added via this registerListener() and have not been
     * freed already via unregisterListener()
     */
    public function freeAllHandlers (...ignored) :void
    {
        for each (var rl :RegisteredListener in _eventHandlers) {
            rl.free();
        }

        _eventHandlers = [];
    }

    protected var _eventHandlers :Array = [];
}

}

import flash.events.IEventDispatcher;

class RegisteredListener
{
    public var dispatcher :IEventDispatcher;
    public var event :String;
    public var listener :Function;
    public var useCapture :Boolean;

    public function RegisteredListener (dispatcher :IEventDispatcher, event :String,
        listener :Function, useCapture :Boolean)
    {
        this.dispatcher = dispatcher;
        this.event = event;
        this.listener = listener;
        this.useCapture = useCapture;
    }

    public function free () :void
    {
        dispatcher.removeEventListener(event, listener, useCapture);
    }
}
