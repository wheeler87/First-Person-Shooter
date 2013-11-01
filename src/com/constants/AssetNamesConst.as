package com.constants 
{
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class AssetNamesConst 
	{
		
		static public const LOCATION:String = "location";
		static public const COLOR_RED:uint = 0x61313d;
		static public const COLOR_LIGHT_BLACK:uint = 0x333333;
		static public const COLOR_WHITE:uint = 0xffffff;
		static public const COLOR_YELLOW:uint = 0xFFFF99;
		static public const COLOR_WHITE_DARK:uint = 0xdddddd;
		static public const COLOR_LIGHT_GREEN:uint = 0x003300
		static public const COLOR_BLUE:uint = 0x313d61;
		static public const COLOR_GREEN:uint = 0x31613d;
		
		public static const WHITE_LINE_THIN:GlowFilter = new GlowFilter(0xFFFFFF, 1, 2, 2, 100, BitmapFilterQuality.LOW);
		public static const WHITE_LINE_THIN_4:GlowFilter = new GlowFilter(0xFFFFFF, 1, 4, 4, 100, BitmapFilterQuality.LOW);
		
		public function AssetNamesConst() 
		{
			
		}
		
	}

}