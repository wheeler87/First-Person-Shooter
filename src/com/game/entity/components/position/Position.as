package com.game.entity.components.position 
{
	import com.game.entity.components.BaseComponent;
	import com.geom.Point2D;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Position  extends BaseComponent
	{
		static public const NAME:String = "Position";
		public var worldCoordinates:Vector3D = new Vector3D();
		public var lastWorldCoordinates:Vector3D = new Vector3D();
		
		public var worldAngleY:Number = 0;
		
		public var cameraCoordinates:Vector3D = new Vector3D();
		public var screenCoordinates:Point2D = new Point2D();
		public var cameraAngleY:Number = 0;
		public var depth:Number
		
		
		
		public function Position() 
		{
			super(NAME);
			
		}
		public function locate(x:Number, y:Number, z:Number, angleY:Number):void
		{
			worldCoordinates.x = x;
			worldCoordinates.y = y;
			worldCoordinates.z = z;
			
			lastWorldCoordinates.x = x;
			lastWorldCoordinates.y = y;
			lastWorldCoordinates.z = z;
			
			worldAngleY = angleY;
		}
		public function move(dx:Number, dy:Number, dz:Number):void
		{
			lastWorldCoordinates.x = worldCoordinates.x;
			lastWorldCoordinates.y = worldCoordinates.y;
			lastWorldCoordinates.z = worldCoordinates.z;
			
			worldCoordinates.x += dx;
			worldCoordinates.y += dy;
			worldCoordinates.z += dz;
			
		}
		public function stepBackward():void
		{
			worldCoordinates.x = lastWorldCoordinates.x;
			worldCoordinates.y = lastWorldCoordinates.y;
			worldCoordinates.z = lastWorldCoordinates.z;
		}
		public function resetCameraCoordinates():void
		{
			cameraCoordinates.x = worldCoordinates.x;
			cameraCoordinates.y = worldCoordinates.y;
			cameraCoordinates.z = worldCoordinates.z;
		}
		
		
	}

}