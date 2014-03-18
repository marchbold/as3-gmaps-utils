/******************************************************************************
        __       __               __ 
   ____/ /_ ____/ /______ _ ___  / /_
  / __  / / ___/ __/ ___/ / __ `/ __/
 / /_/ / (__  ) / / /  / / /_/ / / 
 \__,_/_/____/_/ /_/  /_/\__, /_/ 
                           / / 
                           \/ 
http://distriqt.com
 
@file   	KmlLineStyle.as
@brief  
@author 	Michael Archbold (ma@distriqt.com)
@created	15 May 2010
@updated	$Date:$
@copyright	http://distriqt.com/copyright/license.txt
******************************************************************************/

package com.distriqt.gmaps.kml
{
	public class KmlLineStyle extends KmlObject
	{
		public function KmlLineStyle(_obj:Object=null)
		{
			super(_obj ? _obj : <LineStyle><color>FF000000</color><width>1</width></LineStyle>);			
		}
		
	}
}