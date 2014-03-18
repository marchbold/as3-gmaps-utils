/******************************************************************************
       __       __               __ 
  ____/ /_ ____/ /______ _ ___  / /_
 / __  / / ___/ __/ ___/ / __ `/ __/
/ /_/ / (__  ) / / /  / / /_/ / / 
\__,_/_/____/_/ /_/  /_/\__, /_/ 
                          / / 
                          \/ 
http://distriqt.com

@file   	OverlayGroup.as
@brief  	
@author 	"Michael Archbold (ma@distriqt.com)"
@created	Jun 22, 2011
@updated	$Date:$
@copyright	http://distriqt.com/copyright/license.txt
******************************************************************************/

package com.distriqt.gmaps.overlays
{
	import com.google.maps.overlays.OverlayBase;
	import com.google.maps.interfaces.IPane;
	import com.google.maps.interfaces.IMap;
	import com.google.maps.interfaces.IOverlay;
	import com.google.maps.PaneId;
	import com.google.maps.MapEvent;
	import flash.display.DisplayObject;
	
	public class OverlayGroup extends OverlayBase
	{
		//
		//	Constants
		
		//
		//	Variables

		public function get numOverlays():int { return _overlays.length; }
		
		private var _overlays	: Array /* of IOverlay */;
		
		public function OverlayGroup()
		{
			super();
			_overlays = [];
			addEventListener( MapEvent.OVERLAY_ADDED, overlayAddedHandler, false, 0, true);
			addEventListener( MapEvent.OVERLAY_REMOVED, overlayRemovedHandler, false, 0, true);
		}
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//

		public function clear():void
		{
			for each (var overlay:IOverlay in _overlays)
			{
				this.pane.removeOverlay( overlay );
			}
			_overlays = [];
		}
		
		public function addOverlay( overlay:IOverlay ):void
		{
			_overlays.push( overlay );
		}
		
		
		
		override public function getDefaultPane(map:IMap):IPane
		{
			return map.getPaneManager().getPaneById(PaneId.PANE_OVERLAYS);
		}
		
		override public function positionOverlay(zoom:Boolean):void
		{
			for each (var overlay:IOverlay in _overlays)
			{
				overlay.positionOverlay(zoom);
			}
		}
		
		
		public function setAlpha( value:Number ):void
		{
			
		}
		
		
		override public function get foreground():DisplayObject
		{
			var o:DisplayObjectDelegator = new DisplayObjectDelegator();
			o.addEventListener( "propertyChange", foreground_propertyChangeHandler, false, 0, true );
			return o as DisplayObject;
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		private function overlayAddedHandler( event:MapEvent ):void
		{
			for each (var overlay:IOverlay in _overlays)
			{
				this.pane.addOverlay( overlay );
			}
		}
		
		private function overlayRemovedHandler( event:MapEvent ):void
		{
			for each (var overlay:IOverlay in _overlays)
			{
				this.pane.removeOverlay( overlay );
			}
		}
		
		private function foreground_propertyChangeHandler( event:PropertyChangeEvent ):void
		{
			for each (var overlay:IOverlay in _overlays)
			{
				overlay.foreground[event.property] = event.value;
			}
		}
		
	}
}

import flash.display.Sprite;
class DisplayObjectDelegator extends Sprite
{
	public function DisplayObjectDelegator()
	{
	}
	
	override public function set alpha(value:Number):void
	{
		dispatchEvent( new PropertyChangeEvent( "propertyChange", "alpha", value ));
	}
	
	override public function set filters(value:Array):void
	{
		dispatchEvent( new PropertyChangeEvent( "propertyChange", "filters", value ));
	}
	
	override public function set x(value:Number):void
	{
		dispatchEvent( new PropertyChangeEvent( "propertyChange", "x", value ));
	}
	override public function set y(value:Number):void
	{
		dispatchEvent( new PropertyChangeEvent( "propertyChange", "x", value ));
	}
	override public function set z(value:Number):void
	{
		dispatchEvent( new PropertyChangeEvent( "propertyChange", "x", value ));
	}
	
}
import flash.events.Event;
class PropertyChangeEvent extends Event
{
	public var property:String;
	public var value:*;
	public function PropertyChangeEvent( type:String, property:String, value:* )
	{
		super( type );
		this.property = property;
		this.value = value;
	}
	override public function clone():Event
	{
		return new PropertyChangeEvent( type, property, value );
	}
}

