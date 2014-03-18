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
	import com.google.maps.LatLng;
	
	public class KmlPolygon extends KmlGeometry
	{
		private var m_outerBoundary	: KmlLinearRing;
		
		public function KmlPolygon( _obj:Object = null )
		{
			super( <Polygon></Polygon> );
			m_outerBoundary = new KmlLinearRing();
		}
		
		override public function addPoint(_point:LatLng, _alt:Number=0):void
		{
			m_outerBoundary.addPoint(_point, _alt);
		}
		
		override public function get xml():XML
		{
			var _x:XML = x.copy();
			_x.appendChild( <outerBoundaryIs>{m_outerBoundary.xml}</outerBoundaryIs> );
			return _x;
		}
		
		
	}
}