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
	public class KmlPolyStyle extends KmlObject
	{
		public function KmlPolyStyle(_obj:Object=null)
		{
			super(_obj ? _obj :  <PolyStyle><color>FF000000</color><fill>1</fill><outline>1</outline></PolyStyle> );
		}
		
	}
}