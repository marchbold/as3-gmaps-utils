/******************************************************************************
       __       __               __ 
  ____/ /_ ____/ /______ _ ___  / /_
 / __  / / ___/ __/ ___/ / __ `/ __/
/ /_/ / (__  ) / / /  / / /_/ / / 
\__,_/_/____/_/ /_/  /_/\__, /_/ 
                          / / 
                          \/ 
http://distriqt.com

@file   	KmlLinearRing.as
@brief  
@author 	Michael Archbold (ma@distriqt.com)
@created	15 May 2010
@updated	$Date:$
@copyright	http://distriqt.com/copyright/license.txt
******************************************************************************/

package com.distriqt.gmaps.kml
{
	public class KmlLinearRing extends KmlGeometry
	{
		public function KmlLinearRing( _obj:Object = null )
		{
			super( <LinearRing></LinearRing> );
			tessellate = 1;
		}
		
		public function get tessellate():Number { return Number(x.tessellate.text()); }
		public function set tessellate( _value:Number ):void { x.tessellate = String(_value); } 
	}
}