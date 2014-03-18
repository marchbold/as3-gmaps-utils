/******************************************************************************
       __       __               __ 
  ____/ /_ ____/ /______ _ ___  / /_
 / __  / / ___/ __/ ___/ / __ `/ __/
/ /_/ / (__  ) / / /  / / /_/ / / 
\__,_/_/____/_/ /_/  /_/\__, /_/ 
                          / / 
                          \/ 
http://distriqt.com

@file   	KmlPlacemark.as
@brief  
@author 	Michael Archbold (ma@distriqt.com)
@created	15 May 2010
@updated	$Date:$
@copyright	http://distriqt.com/copyright/license.txt
******************************************************************************/

package com.distriqt.gmaps.kml
{
	public class KmlPlacemark extends KmlObject
	{
		private var m_geometry:KmlGeometry;
		
		public function KmlPlacemark()
		{
			super();
			x = new XML( <Placemark></Placemark> );
		}
		
		
		override public function get xml():XML
		{
			var _ret:XML = x.copy();
			_ret.appendChild( m_geometry.xml );
			return _ret;
		}
		
		
		public function get name():String { return x.name.text(); }
		public function set name( _value:String ):void { x.name = _value; }
		
		public function get description():String { return x.description.text(); }
		public function set description( _value:String ):void 
		{
			x.description = _value;
		}
		
		public function get styleUrl():String { return x.styleUrl.text(); }
		public function set styleUrl( _value:String ):void { x.styleUrl = _value; }
		
		public function set geometry( _value:KmlGeometry ):void { m_geometry = _value; }
		
	}
}