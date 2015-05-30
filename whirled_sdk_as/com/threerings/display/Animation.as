//
// $Id: Animation.as 5 2009-07-21 21:33:52Z mdb $
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

package com.threerings.display {

public interface Animation
{
    /**
     * The primary working method for your animation. The argument indicates how
     * many milliseconds have passed since the animation was started.
     */
    function updateAnimation (elapsed :Number) :void;
}
}