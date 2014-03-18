/******************************************************************************
       __       __               __ 
  ____/ /_ ____/ /______ _ ___  / /_
 / __  / / ___/ __/ ___/ / __ `/ __/
/ /_/ / (__  ) / / /  / / /_/ / / 
\__,_/_/____/_/ /_/  /_/\__, /_/ 
                          / / 
                          \/ 
http://distriqt.com

@file   	KmlLoader.as
@brief  	A KML Loader class for simplifying loading of KML overlays
@author 	Shane Korin (sk@distriqt.com) & Michael Archbold (ma@distriqt.com)
@created	21 Sep 2009
@updated	$Date:$
@copyright	http://distriqt.com/copyright/license.txt
******************************************************************************/

package com.distriqt.gmaps.kml.utils
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import com.google.maps.extras.xmlparsers.kml.*;
	import com.distriqt.gmaps.kml.utils.assets.KmlLoaderAssets;
	import com.distriqt.gmaps.kml.utils.events.KmlLoaderEvent;
	
	/**
	 * A KML Loader class for simplifying loading of KML overlays. 
	 * 	This class uses the KML parser that is part of the google maps utility
	 * 	library and relies on the base functionality provided by that parser.
	 * 
	 * <p>Example usage:</p>
	 * 
	 * <pre>
	 * var kmlLoader:KmlLoader = new KmlLoader();
	 * kmlLoader.addEventListener( Event.COMPLETE, kmlLoader_completeHandler );
	 * kmlLoader.load(  "your-kml-file-location.kml" );
	 * 
	 * function kmlLoader_completeHandler( event:Event ):void
	 * {
	 * 		for each (var object:KmlDisplayObject in KmlLoader(event.currentTarget).objects)
	 * 			addObject( object );
	 * }
	 * 
	 * function addObject( object:KmlDisplayObject ):void
	 * {
	 * 		// It may just be a container with child elements
	 *		//    so check if there are overlays (MultiGeometry)
	 *		for each (var overlay:IOverlay in object.overlays)
	 *		{
	 *			// Here we add the kml object to the map
	 *			_map.addOverlay( overlay );
	 *		}	
	 * 		// Add the children	
	 * 		for each (var child:KmlDisplayObject in object.children)
	 * 			addObject( child );
	 * }
	 * </pre>
	 * 
	 * @see http://labs.distriqt.com/post/164
	 * 
	 */
	public class KmlLoader extends EventDispatcher
	{
		/**
		 *	The version string of the KmlLoader class library 
		 */		
		public static const VERSION	: String = "1.2";

		//
		//	Variables
		
		///	Loader used to actually load the kml file
		private var _loader		: URLLoader;
		///	Array of objects parsed and created from the kml
		private var _objects	: Array /* of KmlDisplayObject */;
		///	The asset manager - handles linked files and images
		private var _assets		: KmlLoaderAssets;
		
		
		/**
		 * The array of KmlDisplayObject's loaded from the KML file 
		 * @return 
		 */
		public function get objects():Array { return _objects; }
		
		
		/**
		 * The parsed kml handler associated with the loaded KML file (null until successful load)
		 * @return
		 */
		public function get kml():Kml22		{ return _assets.kml; }
		
		
		/**
		 * The asset manager providing access to all the associated files and images
		 * @return
		 */
		public function get assets():KmlLoaderAssets 	{ return _assets; }

		
		/**
		 *	Constructor 
		 */
		public function KmlLoader()
		{
			super();
			_objects = [];
			_loader = new URLLoader();
			_assets = new KmlLoaderAssets();
			_assets.addEventListener( Event.COMPLETE, assets_completeHandler, false, 0, true );
		}
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//

		/**
		 * Load the specified KML file URI.
		 * 
		 * Standard loader events are dispatched:
		 * 	Event.COMPLETE	:	On successful load and KML processing
		 * 	ProgressEvent.PROGRESS : On downloading progress
		 *  IOErrorEvent.IO_ERROR : On IO errors
		 * 	SecurityErrorEvent.SECURITY_ERROR : On any security errors
		 * 
		 * Additionally:
		 * 	ErrorEvent.ERROR : If the KML failed to parse or could not find any features in the kml
		 *  
		 * @param uri		The KML file URI
		 */
		public function load( uri:String ):void
		{
			listen( true );
			_loader.load( new URLRequest( uri ));
		}
		
		
		/**
		 * Stops the loader and cleans any internal listeners 
		 */		
		public function cleanup():void
		{
			listen( false );
			_loader.close();
		}

		
		////////////////////////////////////////////////////////
		//	INTERNAL FUNCTIONALITY
		//
		private function listen( enable:Boolean = true ):void
		{
			if (enable)
			{
				_loader.addEventListener( Event.COMPLETE, 						loader_completeHandler, false, 0, true );
				_loader.addEventListener( ProgressEvent.PROGRESS, 				loader_progressHandler, false, 0, true );
				_loader.addEventListener( IOErrorEvent.IO_ERROR, 				loader_errorHandler, false, 0, true );
				_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, 	loader_securityErrorHandler, false, 0, true );
			}
			else
			{
				_loader.removeEventListener( Event.COMPLETE, 						loader_completeHandler );
				_loader.removeEventListener( ProgressEvent.PROGRESS, 				loader_progressHandler );
				_loader.removeEventListener( IOErrorEvent.IO_ERROR, 				loader_errorHandler );
				_loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, 	loader_securityErrorHandler );
			}		
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		protected function loader_completeHandler( event:Event ):void
		{
			//
			//	Process the kml and check for any linked assets
			_assets.process( new Kml22(event.target.data) );
			dispatchEvent( new KmlLoaderEvent( KmlLoaderEvent.KML_FILE_LOADED ));
		}
		
		protected function loader_progressHandler( event:ProgressEvent ):void
		{
			dispatchEvent( event.clone() );
		}
		
		protected function loader_errorHandler( event:IOErrorEvent ):void
		{
			dispatchEvent( event.clone() );
			listen(false);
		}
		
		protected function loader_securityErrorHandler( event:SecurityErrorEvent ):void
		{
			dispatchEvent( event.clone() );
			listen(false);
		}

		protected function assets_completeHandler( event:Event ):void
		{
			if (_assets.kml.feature == null)
			{
				dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, "KML Parse Error: Could not find any features" ));
			}
			else
			{
				var _object:KmlDisplayObject = new KmlDisplayObject( _assets.kml.feature, _assets );
				_objects.push( _object );
				
				dispatchEvent( new Event( Event.COMPLETE ));
				dispatchEvent( new KmlLoaderEvent( KmlLoaderEvent.KML_ASSETS_COMPLETE ));
				dispatchEvent( new KmlLoaderEvent( KmlLoaderEvent.KML_COMPLETE ));
			}
			listen(false);
		}	

		////////////////////////////////////////////////////////
		//	ACCESSORS / MUTATORS	
		//
		
	}
}
