/******************************************************************************
       __       __               __ 
  ____/ /_ ____/ /______ _ ___  / /_
 / __  / / ___/ __/ ___/ / __ `/ __/
/ /_/ / (__  ) / / /  / / /_/ / / 
\__,_/_/____/_/ /_/  /_/\__, /_/ 
                          / / 
                          \/ 
http://distriqt.com

@file   	LatLngUtils.as
@brief  
@author 	Michael Archbold (ma@distriqt.com)
@created	16 May 2010
@updated	$Date:$
@copyright	http://distriqt.com/copyright/license.txt
******************************************************************************/

package com.distriqt.gmaps.utils
{
	import com.google.maps.LatLng;
	
	public class LatLngUtils
	{
		
		/**
		 *	Subtracts the two coordinates (_a - _b) 
		 * @param _a
		 * @param _b
		 * @return 
		 */
		public static function Sub( _a:LatLng, _b:LatLng ):LatLng
		{
			return new LatLng( _a.lat() - _b.lat(), _a.lng() - _b.lng() );
		}
		
		/**
		 *	Adds the two lat / long coordinates together 
		 * @param _a
		 * @param _b
		 * @return 
		 */
		public static function Add( _a:LatLng, _b:LatLng ):LatLng
		{
			return new LatLng( _a.lat() + _b.lat(), _a.lng() + _b.lng() );
		}
		
		/**
		 *	Finds the closest point in the array of points to the specified 
		 * 		point (_a) 
		 * @param _a		The specified point
		 * @param _points	The array of points to check against
		 * @return 			The index of the point that is the closest, or -1
		 */
		public static function Closest( _a:LatLng, _points:Array /* of LatLng */ ):int
		{
			var _index:int = -1;
			var _dist:Number = -1;
			var _min:Number = -1;
			for (var i:int = _points.length-1; i >= 0; --i)
			{
				_dist = _a.distanceFrom( LatLng(_points[i]) );	
				if (_min == -1 || _dist < _min)
				{
					_index = i;
					_min = _dist;
				}	
			}
			return _index;
		}
		
	}
}