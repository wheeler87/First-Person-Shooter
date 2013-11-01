package com.geom 
{
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class IntersectionResult 
	{
		public var intersects:Boolean
		public var validIntersection:Boolean
		public var n1:Number;
		public var n2:Number;
		
		
		public function IntersectionResult() 
		{
			
		}
		public function test(aOrigin:Point2D, cOrigin:Point2D, ab:Vector3D, cd:Vector3D):void
		{
			intersects = (!(Math.abs(ab.x * cd.y) == Math.abs(ab.y * cd.x)));
			if (!intersects) {
				n1 = NaN;
				n2 = NaN;
				validIntersection = false;
				
			}else {
				n1 = (cOrigin.y * cd.x + aOrigin.x*cd.y - cOrigin.x * cd.y-aOrigin.y*cd.x) / (ab.y * cd.x - ab.x * cd.y);
				n2 = (aOrigin.y * ab.x + cOrigin.x * ab.y - aOrigin.x * ab.y - cOrigin.y * ab.x) / (ab.x * cd.y - ab.y * cd.x);
				validIntersection = (n1 >= 0) && (n1 < 1) && (n2 >= 0) && (n2 < 1)
			}
			
		}
		
		
	}

}