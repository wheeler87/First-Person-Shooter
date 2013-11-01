package com.geom 
{
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Projection 
	{
		
		public static var focalLength:Number = 500;
		
		
		public function Projection() 
		{
			
		}
		static public function project(target:*, focalLength:Number, resultP:Point2D = null):Point2D
		{
			if (!resultP) {
				resultP = new Point2D();
			}
			var ratio:Number = focalLength / (focalLength + target.z);
			resultP.x = target.x * ratio;
			resultP.y = target.y * ratio;
			
			return resultP;
		}
		static public function projectGroup(targetGroup:Vector.<Point3D>, focalLength:Number, resultGroup:Vector.<Point2D>):void
		{
			var currentTargetP:Point3D;
			var currentResutP:Point2D;
			
			for (var i:uint = 0; i < targetGroup.length; i++ ) {
				currentTargetP = targetGroup[i];
				currentResutP = resultGroup[i];
				project(currentTargetP, focalLength, currentResutP);
			}
		}
	}

}