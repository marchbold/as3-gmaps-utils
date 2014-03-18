/******************************************************************************
       __       __               __ 
  ____/ /_ ____/ /______ _ ___  / /_
 / __  / / ___/ __/ ___/ / __ `/ __/
/ /_/ / (__  ) / / /  / / /_/ / / 
\__,_/_/____/_/ /_/  /_/\__, /_/ 
                          / / 
                          \/ 
http://distriqt.com

@file   	KmlGroundOverlayObject.as
@brief  	
@author 	Michael Archbold (ma@distriqt.com)
@created	Nov 18, 2010
@updated	$Date:$
@copyright	http://distriqt.com/copyright/license.txt
******************************************************************************/

package com.distriqt.gmaps.kml.utils.objects
{
	import com.distriqt.gmaps.kml.utils.KmlDisplayObject;
	import com.distriqt.gmaps.kml.utils.assets.KmlLoaderAssets;
	import flash.display.Bitmap;

	import com.google.maps.extras.xmlparsers.kml.Document;
	import com.google.maps.extras.xmlparsers.kml.Feature;
	import com.google.maps.extras.xmlparsers.kml.KmlGroundOverlay;
	
	import com.google.maps.LatLngBounds;
	import com.google.maps.LatLng;
	import com.google.maps.overlays.GroundOverlay;
	import com.google.maps.overlays.GroundOverlayOptions;
	import com.google.maps.styles.StrokeStyle;
	import com.distriqt.util.ColourUtil;
	import flash.utils.Endian;
	

	/**
	 *	Implements the display object for a ground overlay
	 *  
	 */
	public class KmlGroundOverlayObject extends KmlDisplayObject
	{
		//
		//	Constants
		
		//
		//	Variables
		
		
		public function KmlGroundOverlayObject( feature:Feature, assets:KmlLoaderAssets=null, interactive:Boolean=false )
		{
			super(feature, assets, interactive);
		}
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		
		////////////////////////////////////////////////////////
		//	INTERNAL FUNCTIONALITY
		//
		
		override protected function processObject(feature:*):void
		{
			if (!(feature is KmlGroundOverlay))
			{
				throw new Error( "KmlGroundOverlayObject::Not a ground overlay object" );
			}

			addGroundOverlay( feature );
			
			super.processObject( feature );
		}

		
		private function addGroundOverlay( groundOverlay:KmlGroundOverlay ):void
		{
			try
			{
				var asset:Bitmap = _assets.getIcon( groundOverlay.icon.href );
				if (asset)
				{
					var latLngBounds:LatLngBounds = new LatLngBounds(
						new LatLng( groundOverlay.latLonBox.south, groundOverlay.latLonBox.west ), 
						new LatLng( groundOverlay.latLonBox.north, groundOverlay.latLonBox.east )
					);
					_latLng = latLngBounds.getCenter();
					
					_style = _assets.getStyle( groundOverlay );
					
					var stroke:StrokeStyle = (_style && _style.lineStyle) ? 
						new StrokeStyle( {
							color:ColourUtil.getColourFrom32Bit( _style.lineStyle.color, Endian.LITTLE_ENDIAN ), 
							alpha:ColourUtil.getAlphaFrom32Bit( _style.lineStyle.color, Endian.LITTLE_ENDIAN ), 
							thickness:_style.lineStyle.width
						})
						: null;

					var options:GroundOverlayOptions = new GroundOverlayOptions(
						{
							rotation: groundOverlay.latLonBox.rotation,
							strokeStyle:stroke
						}
					);
					var o:GroundOverlay = new GroundOverlay( asset, latLngBounds, options );
					addOverlay( o );
				}
			}
			catch (e:Error)
			{
				throw new Error( "KmlGroundOverlay::Error creating ground overlay object:"+e.message );
			}
		}
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		
	}
}