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
	import flash.utils.Endian;
	
	public class ColourUtil
	{
		public static const BIG_ENDIAN		: String = "bigEndian";//Endian.BIG_ENDIAN;
		public static const LITTLE_ENDIAN	: String = "littleEndian";//Endian.LITTLE_ENDIAN;
		
		public static function getColourFrom32Bit( _32bit:int, _endian:String = BIG_ENDIAN ):int
		{
			var _colour:int = _32bit;
			if (_endian == LITTLE_ENDIAN) _colour = EndianUtil.litteToBigEndian( _32bit );
			_colour >>>= 8; // Removes the 32bit alpha channel
			return _colour;
		}
		
		public static function getAlphaFrom32Bit( _32bit:int, _endian:String = BIG_ENDIAN ):Number
		{
			var _alpha:int = _32bit;
			if (_endian == LITTLE_ENDIAN) _alpha = EndianUtil.litteToBigEndian( _32bit );
			_alpha &= 0x000000FF;
			return Number(_alpha / 0x000000FF);
		}
		
		
		public static function to32bitHexString( _colour:int, _alpha:Number, _endian:String = BIG_ENDIAN ):String
		{
			var _ret:uint = _alpha * 0x000000FF;
			_ret |= (_colour << 8);
			if (_endian == LITTLE_ENDIAN) _ret = EndianUtil.bigToLittleEndian(_ret);
			return _ret.toString(16);
		} 
		
	}
}