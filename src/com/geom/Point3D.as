package com.geom 
{
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Point3D
	{
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		
		public function Point3D(x:Number = 0, y:Number = 0, z:Number = 0):void
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		public function toString():String
		{
			var result:String = "[Point3D]{" + x + ", " + y + ", " + z + "}";
			return result;
		}
		
		static public function distanceSq(a:*, b:*):Number
		{
			var result:Number = (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y) + (a.z - b.z) * (a.z - b.z);
			return result;
		}
	}

}