package com.geom 
{
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Point2D 
	{
		public var x:Number = 0;
		public var y:Number= 0;
		
		public function Point2D(x:Number=0,y:Number=0):void
		{
			this.x = x;
			this.y = y;
		}
		public function toString():String
		{
			return "[Point2D]" + "{"+x + ", " + y+"}";
		}
	}

}