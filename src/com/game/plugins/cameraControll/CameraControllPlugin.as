package com.game.plugins.cameraControll 
{
	import com.game.entity.components.position.Position;
	import com.game.Game;
	import com.game.plugins.BasePlugin;
	import com.game.plugins.synchronizer.PriorityEnterFrame;
	import com.game.plugins.synchronizer.PriorityInitialization;
	import com.geom.Matrix3D;
	import com.geom.Projection;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class CameraControllPlugin extends BasePlugin 
	{
		private var _helperM1:Matrix3D = new Matrix3D();
		private var _helperV1:Vector3D = new Vector3D();
		
		public function CameraControllPlugin(owner:Game) 
		{
			super(owner);
			
		}
		override public function onEnter():void 
		{
			super.onEnter();
			owner.synchronizer.addInitializationTask(initialize, PriorityInitialization.CAMERA_CONTROLL_INITIALIZATION);
			owner.synchronizer.addEnterFrameTask(update, PriorityEnterFrame.CAMERA_CONTROLL_UPDATE);
		}
		override public function onExit():void 
		{
			super.onExit();
		}
		
		private function initialize():void
		{
			
		}
		private function update():void
		{
			_helperM1.identity();
			_helperM1.rotateY(owner.player.position.worldAngleY);
			
			_helperV1.x = Projection.focalLength * 0.5;
			
			_helperV1.y = 0;
			_helperV1.z = 0;
			
			_helperM1.transformVector(_helperV1);
			
			var position:Position = owner.player.position;
			
			var x:Number = position.worldCoordinates.x + _helperV1.x;
			var y:Number = position.worldCoordinates.y + _helperV1.y;
			var z:Number = position.worldCoordinates.z + _helperV1.z;
			var angleY:Number = position.worldAngleY;
			
			
			
			owner.camera.setPosition(x, y, z, angleY+Math.PI*0.5);
		}
	}

}