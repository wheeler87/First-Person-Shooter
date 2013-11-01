package com.info.components.location 
{
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class WallInfo 
	{
		public var originX:Number;
		public var originY:Number;
		public var originZ:Number;
		
		public var angleY:Number;
		public var angleX:Number;
		
		
		public var columns:int;
		public var rows:int;
		
		public var tileSize:Number;
		public var tilesMap:Array;
		
		public function WallInfo() 
		{
			
		}
		public function getTilePixelsNameAt(column:uint, row:uint):String
		{
			var resul:String = tilesMap[row * columns + column];
			return resul;
		}
		
	}

}