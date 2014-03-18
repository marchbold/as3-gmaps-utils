/******************************************************************************
       __       __               __ 
  ____/ /_ ____/ /______ _ ___  / /_
 / __  / / ___/ __/ ___/ / __ `/ __/
/ /_/ / (__  ) / / /  / / /_/ / / 
\__,_/_/____/_/ /_/  /_/\__, /_/ 
                          / / 
                          \/ 
http://distriqt.com

@file   	KmlDisplayObject.as
@brief  	A KML Display Object for loading KML objects
@author 	Shane Korin (sk@distriqt.com) & Michael Archbold (ma@distriqt.com)
@created	21 Sep 2009
@updated	$Date:$
@copyright	http://distriqt.com/copyright/license.txt
******************************************************************************/

package com.distriqt.gmaps.kml.utils
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	
	import com.google.maps.Map;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.styles.FillStyle;
	import com.google.maps.styles.StrokeStyle;
	import com.google.maps.interfaces.IOverlay;

	import com.google.maps.extras.xmlparsers.kml.*;

	import com.distriqt.gmaps.kml.utils.objects.*;
	import com.distriqt.gmaps.kml.utils.assets.KmlLoaderAssets;
	import com.distriqt.gmaps.overlays.OverlayGroup;
	
	/**
	 * Class represents a display object created from a KML file. 
	 *  It contains references to the original feature information 
	 * 	and creates an overlay for use with a google map representing
	 * 	this feature. 
	 * 
	 */
	public class KmlDisplayObject extends EventDispatcher
	{
		
		//
		//	Variables
		protected var _assets		: KmlLoaderAssets;
		protected var _options		: *;
		protected var _fill			: Sprite;
		
		
		public function get kml():Document				{ return _assets.document; }

		protected var _feature		: Feature;
		/**
		 * The Feature object instance associated with this display object. 
		 * 	The Feature is the abstract element (super class) of the 
		 * 	Container/Overlay/Placemark objects. 
		 * 
		 * @return 
		 */
		public function get feature():Feature			{ return _feature; }

		
		protected var _style		: Style;
		/**
		 * 
		 * @return 
		 */
		public function get style():Style				{ return _style; }
		
		
		protected var _interactive	: Boolean = false;
		/**
		 * 
		 * @return 
		 */
		public function get interactive():Boolean				{ return _interactive; }
		public function set interactive( _value:Boolean ):void 	{ setInteractive( _value ); }
		
		protected var _latLng		: LatLng;
		/**
		 * 
		 * @return 
		 */
		public function get latLng():LatLng				{ return _latLng; }
		
		protected var _overlays		: Array /* of IOverlay */;
		/**
		 * Access to the Google Map IOverlay objects as part of this display object
		 * @return
		 */
		public function get overlays():Array { return _overlays; }
		
		private var _overlay		: OverlayGroup;
		/**
		 * Access to the first IOverlay (generally the only one) in this display object
		 * @return 
		 */
		public function get overlay():IOverlay			{ return _overlay; }
		
		protected var _points		: Array /* of LatLng */;
		/**
		 * 
		 * @return 
		 */
		public function get points():Array				{ return _points; }
		
		protected var _children		: Array /* of KmlDisplayObject */;
		/**
		 * 
		 * @return 
		 */
		public function get children():Array  			{ return _children; }
		
		protected var _name			: String;
		/**
		 * The name of this display object
		 * @return 
		 */
		public function get name():String				{ return _name; }
		public function set name( value:String ):void 	{ _name = value; }
		
		
		/**
		 * Creates a KML display object from the specified parameters
		 * 
		 * @param feature		The KML feature to use as the base for this display object 
		 * @param assets		The KML Loader Assets manager for the base loader
		 * @param interactive	If true the object will listen to map mouse events on the 
		 * 							overlay and dispatch them to any listeners
		 */
		public function KmlDisplayObject( feature:Feature, assets:KmlLoaderAssets = null, interactive:Boolean = false )
		{
			super();
			_latLng = new LatLng(0,0);
			_name = feature.name;
			_children = [];
			_points = [];
			_overlays = [];
			_assets = assets;
			_feature = feature;
			_overlay = new OverlayGroup();
			
			processObject( feature );

			setInteractive( interactive );
		}

		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		/**
		 *	Adds a bitmap fill on the overlay
		 *  
		 * @param _map
		 * @param _bitmap
		 * @param _smoothing
		 * @param _styleid
		 */
		public function setBitmapFill( _map:Map, _bitmap:Bitmap, _smoothing:Boolean = false, _styleid:String = "" ):void
		{
			if (!_map.parent) throw new Error( "Needs to be on stage before bitmap fill" );
			if (overlay && overlay.foreground)
			{
				if (_styleid == "" || _feature.styleUrl.substr(1) == _styleid) 
				{
					_fill = new Sprite();
					_fill.graphics.beginBitmapFill( _bitmap.bitmapData, null, true, _smoothing );
					// Check width/height here, might be a problem?
					_fill.graphics.drawRect( 0, 0, _map.parent.width, _map.parent.height ); 
					_fill.graphics.endFill();
					_fill.mouseEnabled = false;
					_fill.mask = overlay.foreground;
					_map.parent.addChild( _fill );
				}
			}
			for (var i:int = _children.length-1; i >= 0; --i)
			{
				KmlDisplayObject(_children[i]).setBitmapFill(_map,_bitmap,_smoothing,_styleid);
			}
		}
		
		
		/**
		 *	Cleans the object of any content created from using bitmap fills etc
		 */
		public function cleanup():void
		{
			if (_fill && _fill.parent) _fill.parent.removeChild( _fill );
		}


		////////////////////////////////////////////////////////
		//	INTERNAL FUNCTIONALITY
		//
		
		protected function processObject( feature:* ):void
		{
			if (feature is Container)
			{
				processChildren( feature );
				if (_children.length > 0)
					_latLng = _children[0].latLng;
			}
		}
		
		protected function processChildren( container:Container ):void
		{
			for each (var feature:Feature in container.features) 
			{
				var childObj:KmlDisplayObject;

				//
				//	Add in additional objects here as required
				if (feature is Placemark)
					childObj = new KmlPlacemarkObject( feature, _assets, _interactive );
				else if (feature is KmlGroundOverlay)
					childObj = new KmlGroundOverlayObject( feature, _assets, _interactive );
				else
					childObj = new KmlDisplayObject( feature, _assets,  _interactive );
				
				_children.push( childObj );
			}
		}

		protected function setInteractive( interactive:Boolean ):void
		{
			for each (var overlay:IOverlay in overlays)
			{
				if (interactive && !_interactive)
				{
					overlay.addEventListener( MapMouseEvent.ROLL_OVER,		overlay_eventDispatch, false, 0, true );
					overlay.addEventListener( MapMouseEvent.ROLL_OUT,		overlay_eventDispatch, false, 0, true );
					overlay.addEventListener( MapMouseEvent.CLICK, 			overlay_eventDispatch, false, 0, true );
					overlay.addEventListener( MapMouseEvent.DOUBLE_CLICK, 	overlay_eventDispatch, false, 0, true );
				}
				else if (!interactive) 
				{
					overlay.removeEventListener( MapMouseEvent.ROLL_OVER,		overlay_eventDispatch );
					overlay.removeEventListener( MapMouseEvent.ROLL_OUT,		overlay_eventDispatch );
					overlay.removeEventListener( MapMouseEvent.CLICK, 			overlay_eventDispatch );
					overlay.removeEventListener( MapMouseEvent.DOUBLE_CLICK, 	overlay_eventDispatch );
				}
			}
			_interactive = interactive;
		}
		
		protected function addOverlay( overlay:IOverlay ):void
		{
			_overlays.push( overlay );
			_overlay.addOverlay( overlay );
		}
		
		
		////////////////////////////////////////////////////////
		//	HELPERS
		//		

		public function getStyle( feature:Feature ):Style 
		{
			return _assets.getStyle( feature );
		}
		
		public function getOptions():*
		{
			return _options;
		}
		
		public function getCoordinatesLatLngs( coordinates:Coordinates ):Array 
		{
			_points = [];
			for (var i:Number = 0; i < coordinates.coordsList.length; i++) 
			{
				var coordinate:Object = coordinates.coordsList[i];
				_points[i] = new LatLng(Number(coordinate.lat), Number(coordinate.lon));
			}
			return _points;
		}

		public function getBounds():void
		{
			//TODO::	
			throw new Error( "Unimplemented" ); 
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT LISTENERS
		//
		
		private function overlay_eventDispatch( event:MapMouseEvent ):void
		{
			dispatchEvent( event.clone() );
		}


		
	}
}