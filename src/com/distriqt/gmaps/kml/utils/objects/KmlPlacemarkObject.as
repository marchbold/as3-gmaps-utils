/******************************************************************************
       __       __               __ 
  ____/ /_ ____/ /______ _ ___  / /_
 / __  / / ___/ __/ ___/ / __ `/ __/
/ /_/ / (__  ) / / /  / / /_/ / / 
\__,_/_/____/_/ /_/  /_/\__, /_/ 
                          / / 
                          \/ 
http://distriqt.com

@file   	KmlPlacemarkObject.as
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
	import com.distriqt.util.ColourUtil;
	import flash.utils.Endian;

	import com.google.maps.extras.xmlparsers.kml.*;

	import com.google.maps.interfaces.IOverlay;
	import com.google.maps.extras.xmlparsers.kml.Style;
	import com.google.maps.styles.StrokeStyle;
	import com.google.maps.styles.FillStyle;
	import com.google.maps.extras.xmlparsers.kml.MultiGeometry;
	import com.google.maps.extras.xmlparsers.kml.KmlPoint;
	import com.google.maps.extras.xmlparsers.kml.LineString;
	import com.google.maps.extras.xmlparsers.kml.LinearRing;
	import com.google.maps.LatLng;
	import com.google.maps.extras.xmlparsers.kml.KmlPolygon;
	
	import com.google.maps.overlays.*;
	import flash.display.Bitmap;
	
	/**
	 *	Implements the display object for a placemark object
	 *  
	 */
	public class KmlPlacemarkObject extends KmlDisplayObject
	{
		//
		//	Constants
		
		//
		//	Variables
		
		
		public function KmlPlacemarkObject(feature:Feature, assets:KmlLoaderAssets=null, interactive:Boolean=false)
		{
			trace( "KmlPlacemarkObject");
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
			if (!(feature is Placemark))
			{
				throw new Error( "KmlPlacemarkObject::Not a placemark object" );
			}

			addPlacemark( feature );
		
			super.processObject( feature );
		}
		
		
		private function addPlacemark( placemark:Placemark ):void
		{
			if (placemark == null) return;
			if (placemark.geometry == null) return;
			
			_style = _assets.getStyle( placemark );
			
			if (placemark.geometry is MultiGeometry) 
			{
				var multiGeometry:MultiGeometry = MultiGeometry(placemark.geometry);
				_style = _assets.getStyle(placemark);
				for (var i:uint = 0; i < multiGeometry.geometries.length; i++) 
				{
					if (multiGeometry.geometries[i] is Placemark)
						addPlacemark( Placemark(multiGeometry.geometries[i]) );
					else
						addOverlay( createGeometryWithStyle( multiGeometry.geometries[i], _style ));
				}
			}
			else
			{
				addOverlay( createGeometryWithStyle( placemark.geometry, _style ));
			}
		}
		
		
		private function createGeometryWithStyle( geometry:*, style:Style = null ):IOverlay
		{
			var o:IOverlay = null;
			var stroke:StrokeStyle;
			var fill:FillStyle;
			var iconStyle:IconStyle;
			
			if (style != null)	_style = style;
			
			if (geometry is KmlPoint) 
			{
				var point:KmlPoint = KmlPoint(geometry);
				_latLng = new LatLng(point.coordinates.coordsList[0].lat, point.coordinates.coordsList[0].lon);
				var marker:Marker = new Marker(_latLng);
				if (_style)
				{
					var icon:Bitmap = (_style.iconStyle) ? _assets.getIcon( _style.iconStyle.icon.href ) : null;
					stroke = (_style.lineStyle == null) ? null :  
						new StrokeStyle( {
							color:ColourUtil.getColourFrom32Bit( _style.lineStyle.color, Endian.LITTLE_ENDIAN ), 
							alpha:ColourUtil.getAlphaFrom32Bit( _style.lineStyle.color, Endian.LITTLE_ENDIAN ), 
							thickness:_style.lineStyle.width
						});
					fill = (_style.polyStyle == null) ? null : 
						new FillStyle( {
							color:ColourUtil.getColourFrom32Bit( _style.polyStyle.color, Endian.LITTLE_ENDIAN ), 
							alpha:ColourUtil.getAlphaFrom32Bit( _style.polyStyle.color, Endian.LITTLE_ENDIAN ) 
						});
					var markerOptions:MarkerOptions = new MarkerOptions( {strokeStyle:stroke, fillStyle:fill, icon:icon, iconAlignment: MarkerOptions.ALIGN_BOTTOM + MarkerOptions.ALIGN_HORIZONTAL_CENTER} );
					marker.setOptions( markerOptions );
				}
				o = marker;
			} 
			else if (geometry is LineString) 
			{
				var lineString:LineString = LineString(geometry);
				var line:Polyline = new Polyline(getCoordinatesLatLngs(lineString.coordinates));
				_latLng = line.getVertex(0);
				if (_style)
				{
					stroke = (_style.lineStyle == null) ? null :  
						new StrokeStyle( {
							color:ColourUtil.getColourFrom32Bit( _style.lineStyle.color, Endian.LITTLE_ENDIAN ), 
							alpha:ColourUtil.getAlphaFrom32Bit( _style.lineStyle.color, Endian.LITTLE_ENDIAN ), 
							thickness:_style.lineStyle.width
						});
					var lineoptions:PolylineOptions = new PolylineOptions( {strokeStyle:stroke} );
					_options = lineoptions;
					line.setOptions( lineoptions );
				}
				o = line;
			} 
			else if (geometry is LinearRing) 
			{
				var linearRing:LinearRing = LinearRing(geometry);
				var polyline:Polyline = new Polyline(getCoordinatesLatLngs(linearRing.coordinates));
				_latLng = polyline.getLatLngBounds().getCenter();
				if (_style)
				{
					stroke = (_style.lineStyle == null) ? null :  
						new StrokeStyle( {
							color:ColourUtil.getColourFrom32Bit( _style.lineStyle.color, Endian.LITTLE_ENDIAN ), 
							alpha:ColourUtil.getAlphaFrom32Bit( _style.lineStyle.color, Endian.LITTLE_ENDIAN ), 
							thickness:_style.lineStyle.width
						});
					var polylineoptions:PolylineOptions = new PolylineOptions( {strokeStyle:stroke} );
					_options = polylineoptions;
					polyline.setOptions( polylineoptions );
				}
				o = polyline;
			} 
			else if (geometry is KmlPolygon) 
			{
				var kmlPolygon:KmlPolygon = KmlPolygon(geometry);
				var polygon:Polygon = new Polygon( getCoordinatesLatLngs(kmlPolygon.outerBoundaryIs.linearRing.coordinates) );
				_latLng = polygon.getLatLngBounds().getCenter();
				if (_style)
				{
					stroke = (_style.lineStyle == null) ? null :  
						new StrokeStyle( {
							color:ColourUtil.getColourFrom32Bit( _style.lineStyle.color, Endian.LITTLE_ENDIAN ), 
							alpha:ColourUtil.getAlphaFrom32Bit( _style.lineStyle.color, Endian.LITTLE_ENDIAN ), 
							thickness:_style.lineStyle.width
						});
					fill = (_style.polyStyle == null) ? null : 
						new FillStyle( {
							color:ColourUtil.getColourFrom32Bit( _style.polyStyle.color, Endian.LITTLE_ENDIAN ), 
							alpha:ColourUtil.getAlphaFrom32Bit( _style.polyStyle.color, Endian.LITTLE_ENDIAN ) 
						});
					var options:PolygonOptions = new PolygonOptions({ strokeStyle:stroke, fillStyle:fill} );
					_options = options;
					polygon.setOptions( options );
				}
				o = polygon;
			}
			else if (geometry is MultiGeometry) 
			{
				var _multiGeometry:MultiGeometry = MultiGeometry(geometry);
				for (var i:uint = 0; i < _multiGeometry.geometries.length; i++) 
				{
					if (_multiGeometry.geometries[i] is Placemark)
						addPlacemark( Placemark(_multiGeometry.geometries[i]) );
					else
						createGeometryWithStyle( _multiGeometry.geometries[i], _style );
				}
			}
			return o;
		}
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		
		////////////////////////////////////////////////////////
		//	ACCESSORS / MUTATORS
		//
	}
}