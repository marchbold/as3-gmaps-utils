/******************************************************************************
       __       __               __ 
  ____/ /_ ____/ /______ _ ___  / /_
 / __  / / ___/ __/ ___/ / __ `/ __/
/ /_/ / (__  ) / / /  / / /_/ / / 
\__,_/_/____/_/ /_/  /_/\__, /_/ 
                          / / 
                          \/ 
http://distriqt.com

@file   	Kml.as
@brief  
@author 	Michael Archbold (ma@distriqt.com)
@created	15 May 2010
@updated	$Date:$
@copyright	http://distriqt.com/copyright/license.txt
******************************************************************************/

package com.distriqt.gmaps.kml
{
	import com.google.maps.extras.xmlparsers.Namespaces;

	public class Kml 
	{
		private var m_xml		: XML;
		private var m_document	: XML;
		
		public function Kml()
		{
			m_xml = new XML(<kml></kml> );
			m_xml.setNamespace( Namespaces.KML_NS );
			m_document = new XML( <Document></Document> );
		}
		
		
		public function add( _kmlObject:KmlObject ):void
		{
			m_document.appendChild( _kmlObject.xml );
		}

		
		public function toString():String
		{
			m_xml.Document = m_document;
			return m_xml.toXMLString();
		}
		

	}
}