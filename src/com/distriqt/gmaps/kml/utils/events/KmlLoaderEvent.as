/******************************************************************************
       __       __               __ 
  ____/ /_ ____/ /______ _ ___  / /_
 / __  / / ___/ __/ ___/ / __ `/ __/
/ /_/ / (__  ) / / /  / / /_/ / / 
\__,_/_/____/_/ /_/  /_/\__, /_/ 
                          / / 
                          \/ 
http://distriqt.com

@file   	KmlLoaderEvent.as
@brief  	
@author 	"Michael Archbold (ma@distriqt.com)"
@created	Jun 18, 2011
@updated	$Date:$
@copyright	http://distriqt.com/copyright/license.txt
******************************************************************************/

package com.distriqt.gmaps.kml.utils.events
{
	import flash.events.Event;
	
	public class KmlLoaderEvent extends Event
	{
		//
		//	Constants
		public static const KML_FILE_LOADED			: String = "kml:file:loaded";
		public static const KML_ASSETS_PROGRESS		: String = "kml:assets:progress";
		public static const KML_ASSETS_COMPLETE		: String = "kml:assets:complete";
		
		public static const KML_COMPLETE			: String = "kml:complete";
		
		
		//
		//	Variables
		
		
		public function KmlLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		
		////////////////////////////////////////////////////////
		//	ACCESSORS / MUTATORS
		//
	}
}