/******************************************************************************
        __       __               __ 
   ____/ /_ ____/ /______ _ ___  / /_
  / __  / / ___/ __/ ___/ / __ `/ __/
 / /_/ / (__  ) / / /  / / /_/ / / 
 \__,_/_/____/_/ /_/  /_/\__, /_/ 
                           / / 
                           \/ 
http://distriqt.com
 
@file   	KmlPolygon.as
@brief  
@author 	Michael Archbold (ma@distriqt.com)
@created	15 May 2010
@updated	$Date:$
@copyright	http://distriqt.com/copyright/license.txt
******************************************************************************/

package com.distriqt.gmaps.kml
{
	public class KmlStyle extends KmlObject
	{
		
		public var lineStyle:KmlLineStyle;
		public var polyStyle:KmlPolyStyle;
		
		public function KmlStyle(_obj:Object=null)
		{
			super(<Style></Style>);
		}
		
		
		override public function get xml():XML
		{
			var _x:XML = x.copy();
			if (lineStyle) _x.appendChild( lineStyle.xml );
			if (polyStyle) _x.appendChild( polyStyle.xml );
			return _x;
		}
		
		public function get id():String { return x.@id; }
		public function set id( _value:String ):void { x.@id = _value; }
		
	}
}