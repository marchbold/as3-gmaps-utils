/******************************************************************************
       __       __               __ 
  ____/ /_ ____/ /______ _ ___  / /_
 / __  / / ___/ __/ ___/ / __ `/ __/
/ /_/ / (__  ) / / /  / / /_/ / / 
\__,_/_/____/_/ /_/  /_/\__, /_/ 
                          / / 
                          \/ 
http://distriqt.com

@file   	KmlGeometry.as
@brief  
@author 	Michael Archbold (ma@distriqt.com)
@created	15 May 2010
@updated	$Date:$
@copyright	http://distriqt.com/copyright/license.txt
******************************************************************************/

package com.distriqt.gmaps.kml
{
	import com.google.maps.LatLng;
	
	public class KmlGeometry extends KmlObject
	{
		
		public function KmlGeometry( _obj:Object = null )
		{
			super(_obj);
		}
		
		public function addPoint( _point:LatLng, _alt:Number = 0 ):void
		{
			var _coords:String = x.coordinates.text();
			_coords += "\t\t"+_point.lng()+","+_point.lat()+","+_alt+"\n";
			x.coordinates = _coords;
		}
		
	}
}