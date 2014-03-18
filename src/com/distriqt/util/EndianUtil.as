/******************************************************************************
        __       __               __ 
   ____/ /_ ____/ /______ _ ___  / /_
  / __  / / ___/ __/ ___/ / __ `/ __/
 / /_/ / (__  ) / / /  / / /_/ / / 
 \__,_/_/____/_/ /_/  /_/\__, /_/ 
                           / / 
                           \/ 
http://distriqt.com
 
@file   	ColourUtil.as
@brief  
@author 	Michael Archbold (ma@distriqt.com)
@created	16 May 2010
@updated	$Date:$
@copyright	http://distriqt.com/copyright/license.txt
******************************************************************************/

package com.distriqt.util
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class EndianUtil
	{
		public static function litteToBigEndian( _little:int ):int
		{
			var _bA:ByteArray = new ByteArray();
			_bA.endian = Endian.LITTLE_ENDIAN;
			_bA.writeInt(_little);
			_bA.position = 0;
			_bA.endian = Endian.BIG_ENDIAN;
			var _ret:int = _bA.readInt();
			return _ret;
		}

		public static function bigToLittleEndian( _big:int ):uint 
		{
			var _bA:ByteArray = new ByteArray();
			_bA.endian = Endian.BIG_ENDIAN;
			_bA.writeInt(_big);
			_bA.position = 0;
			_bA.endian = Endian.LITTLE_ENDIAN;
			var _ret:uint = _bA.readInt();
			return _ret;
		}
	}
}