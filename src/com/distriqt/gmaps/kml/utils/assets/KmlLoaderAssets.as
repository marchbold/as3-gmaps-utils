/******************************************************************************
       __       __               __ 
  ____/ /_ ____/ /______ _ ___  / /_
 / __  / / ___/ __/ ___/ / __ `/ __/
/ /_/ / (__  ) / / /  / / /_/ / / 
\__,_/_/____/_/ /_/  /_/\__, /_/ 
                          / / 
                          \/ 
http://distriqt.com

@file   	KmlLoaderAssets.as
@brief  	
@author 	Michael Archbold (ma@distriqt.com)
@created	Nov 18, 2010
@updated	$Date:$
@copyright	http://distriqt.com/copyright/license.txt
******************************************************************************/

package com.distriqt.gmaps.kml.utils.assets
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.Event;

	import com.google.maps.extras.xmlparsers.kml.Kml22;
	import com.google.maps.extras.xmlparsers.kml.Style;
	import com.google.maps.extras.xmlparsers.kml.Feature;
	import com.google.maps.extras.xmlparsers.kml.Document;
	import br.com.stimuli.loading.BulkLoader;
	import com.google.maps.extras.xmlparsers.kml.Container;
	import flash.utils.getQualifiedClassName;
	import com.google.maps.extras.xmlparsers.kml.Placemark;
	import com.google.maps.extras.xmlparsers.kml.KmlGroundOverlay;
	import flash.display.Bitmap;
	
	public class KmlLoaderAssets extends EventDispatcher
	{
		//
		//	Constants
		
		
		//
		//	Variables
		private var _loader			: BulkLoader;
		
		
		
		private var _kml			: Kml22;
		/**
		 * The parsed kml handler associated with the loaded KML file (null until successful load) 
		 * 	(see reference in google maps utility library)
		 * @return
		 */
		public function get kml():Kml22			{ return _kml; }
		
		
		private var _kmlDocument	: Document;
		/**
		 * The root Document of the kml file
		 * @return 
		 */
		public function get document():Document { return _kmlDocument; }

		
		
		public function KmlLoaderAssets(target:IEventDispatcher=null)
		{
			super(target);
			_loader = BulkLoader.createUniqueNamedLoader();
		}	
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function process( kml:Kml22 ):void
		{
			try
			{
				_kml = kml;
				_kmlDocument = _kml.feature as Document;
				
				//
				//	Queue any linked files and assets
				identifyObjectAssets( _kmlDocument );
				identifyStyleAssets( _kmlDocument.styles );
				
				//
				//	Load the files...
				if (_loader.itemsTotal > 0)
				{
					_loader.addEventListener( Event.COMPLETE, loader_completeHandler, false, 0, true );
					_loader.start();
				}
				else
				{
					//
					//	No Items to load so just complete
					completeLoad();
				}
			}
			catch (e:Error)
			{
				trace( "KmlLoaderAssets::ERROR::"+e.message );
			}
		}
		
		
		/**
		 *	Retrieves the Style object associated with the particular feature  
		 * @param feature
		 * @return A Style instance;
		 */		
		public function getStyle( feature:Feature ):Style
		{
			var _style:Style = feature.style;
			if (_style == null && _kmlDocument != null)
			{
				for each (var style:Style in _kmlDocument.styles)
				{
					if (feature.styleUrl && feature.styleUrl.substr(1) == style.id)
					{
						_style = style;
						break;
					}
				}
			}
			return _style;
		}
		
		
		public function getIcon( id:String ):Bitmap
		{
			return _loader.getBitmap( id );
		}
		
		
		public function getLinkedFile( id:String ):*
		{
			return _loader.get( id );
		}
		
		
		////////////////////////////////////////////////////////
		//	INTERNAL FUNCTIONALITY
		//
		
		/**
		 * This helper function analyses the specified feature for any linked
		 * 	assets, such as linked files, external styles through styleUri or 
		 * 	icons for ground overlays.
		 * 
		 * It adds them to the current loader instance
		 * 
		 * @param feature
		 */
		private function identifyObjectAssets( feature:Feature ):void
		{
			//
			//	Check feature for links
			if (feature.link) 
			{ 
				throw new Error( "Need to implement link loading" ); 
			}
			
			//
			//	TODO::The styleUrl could be a linked file
//			if (feature.styleUrl && )
//			{
//				trace( "FEATURESTYLE"+feature.styleUrl );
//			}
			
			//
			//	Check the feature for particular assets (overlay icons etc)
			if (feature is Placemark)
			{
			}
			else if (feature is KmlGroundOverlay)
			{
				if (KmlGroundOverlay(feature).icon)
					_loader.add( KmlGroundOverlay(feature).icon.href ); 
			}

			//
			//	Check if the feature is a container as it may contain children			
			else if (feature is Container)
			{
				for each (var child:Feature in Container(feature).features)
				{
					identifyObjectAssets( child );
				}
			}
		}	

		/**
		 * This helper function iterates over the styles in the specified array and
		 * 	adds any icons for markers to the current loader instance.
		 * 
		 */
		private function identifyStyleAssets( styles:Array ):void
		{
			for each (var style:Style in styles)
			{
				if (style.iconStyle)
				{
					_loader.add( style.iconStyle.icon.href );
				}
			}
		}
		
		private function completeLoad():void
		{
			dispatchEvent( new Event( Event.COMPLETE ));
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		private function loader_completeHandler(event:Event):void
		{
			completeLoad();
		}	
				
		
	}
}