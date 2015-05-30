//
// $Id: ImmutableMap.as 111 2009-09-16 00:14:47Z ray $
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

package com.threerings.util.maps {

import flash.errors.IllegalOperationError;

import com.threerings.util.Map;

/**
 * A map that throws IllegalOperationError is thrown if any mutating methods are called.
 */
public class ImmutableMap extends ForwardingMap
{
    public function ImmutableMap (source :Map)
    {
        super(source);
    }

    /** @inheritDoc */
    override public function put (key :Object, value :Object) :*
    {
        return immutable();
    }

    /** @inheritDoc */
    override public function remove (key :Object) :*
    {
        return immutable();
    }

    /** @inheritDoc */
    override public function clear () :void
    {
        immutable();
    }

    /** @private */
    protected function immutable () :void
    {
        throw new IllegalOperationError();
    }
}
}
