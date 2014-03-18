/******************************************************************************
       __       __               __ 
  ____/ /_ ____/ /______ _ ___  / /_
 / __  / / ___/ __/ ___/ / __ `/ __/
/ /_/ / (__  ) / / /  / / /_/ / / 
\__,_/_/____/_/ /_/  /_/\__, /_/ 
                          / / 
                          \/ 
http://distriqt.com

@file   	SimpleKmlLoader.as
@brief  
@author 	Michael Archbold (ma@distriqt.com)
@created	16 May 2010
@updated	$Date:$
@copyright	http://distriqt.com/copyright/license.txt
******************************************************************************/

package com.distriqt.gmaps.kml.utils
{
	import flash.events.Event;
	import com.google.maps.interfaces.IMap;
	import com.google.maps.interfaces.IOverlay;
	import com.distriqt.gmaps.kml.utils.events.KmlLoaderEvent;
	
	/**
	 *	SimpleKmlLoader implements a simple way to load and add a kml file 
	 * 		to a google map instance.
	 * 
	 * @author Michael Archbold (ma@distriqt.com)
	 * 
	 * @see http://labs.distriqt.com/post/251
	 */
	public class SimpleKmlLoader extends KmlLoader
	{
		private var _map			: IMap;
		/**
		 * 	The google map instance currently associated with this kml loader 
		 */
		public function get map():IMap { return _map; }
		public function set map( _value:IMap ):void { _map = _value; }		

		
		private var _visible		: Boolean;
		
		private var _addOnceLoaded	: Boolean;
		
		
		
		/**
		 *	Simple KML Loader extends the KmlLoader class for simpler operations 
		 * 
		 * 
		 * 	@param map				A google map instance
		 * 	@param addOnceLoaded	If true the kml objects will be added to 
		 * 							the map once loading is complete
		 */
		public function SimpleKmlLoader( map:IMap = null, addOnceLoaded:Boolean = false )
		{
			super();
			_map = map;
			_addOnceLoaded = addOnceLoaded;
			
			addEventListener( KmlLoaderEvent.KML_COMPLETE, kmlLoaderCompleteHandler, false, 0, true );
		}
		

		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		/**
		 *	Cleans up the kml loader so this class can be disposed of and removes
		 * 		any objects from the map
		 */
		override public function cleanup():void
		{
			super.cleanup();
			removeFromMap();
		}

		/**
		 *	Adds this overlay to the specified map. 
		 * @param _map	The map to add the kml objects to. Default: the map specified at instance creation
		 */				
		public function addToMap( map:IMap = null ):void
		{
			if (map) _map = map;
			for each (var _object:KmlDisplayObject in objects)
				addObject( _object );
		}

		/**
		 * Removes the kml file from the map
		 */
		public function removeFromMap():void
		{
			for each (var _object:KmlDisplayObject in objects)
				removeObject( _object );
		}

		
		////////////////////////////////////////////////////////
		//	INTERNAL FUNCTIONALITY
		//
		
		private function addObject( object:KmlDisplayObject ):void
		{
			// It may just be a container with child elements
			//    so check if there are overlays (MultiGeometry)
//			for each (var overlay:IOverlay in object.overlays)
//			{
//				// Here we add the kml object to the map
//				_map.addOverlay( overlay );
//			}
			
			//
			//	Check this has some overlays
			if (object.overlays.length > 0)
				//
				//	Add the overlay group
				_map.addOverlay( object.overlay );			
			
			//
			// Add the children
			for each (var child:KmlDisplayObject in object.children)
				addObject( child );
		}
		
		private function removeObject( object:KmlDisplayObject ):void
		{
			if (object.overlay != null)
			{
				_map.removeOverlay( object.overlay );
				object.cleanup();
			}
			// Add the children
			for each (var child:KmlDisplayObject in object.children)
				removeObject( child );
		}

		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
				
		private function kmlLoaderCompleteHandler(event:Event):void
		{
			if (_addOnceLoaded) addToMap();
		}
		
		
	}
}