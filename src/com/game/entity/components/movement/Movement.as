package com.game.entity.components.movement 
{
	import com.game.entity.components.BaseComponent;
	import com.game.entity.components.influence.InfluenceName;
	import com.geom.Matrix3D;
	import com.geom.Point3D;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Movement  extends BaseComponent
	{
		static public const NAME:String = "Movement";
		
		public var velocity:Vector3D = new Vector3D();
		public var angularVelocity:Number;
		
		public var rawVelocity:Boolean;
		
		public var rawHeading:Boolean;
		public var headingCaptured:Boolean;
		public var headingAngle:Number;
		public var headingOffset:Number = 0;
		
		
		private var _velocityPool:Number;
		private var _angularVelocityPool:Number;
		
		private var _locked:Boolean;
		
		
		
		
		private var _followTargetMode:Boolean;
		private var _target:Point3D = new Point3D()
		public var angleYToTarget:Number;
		public var targetCaptured:Boolean;
		
		private var _followDirectionMode:Boolean;
		private var _directionAngleY:Number;
		
		private var _turnToDirectionMode:Boolean;
		public var turnDestiationAngle:Number
		
		public function Movement() 
		{
			super(NAME);
			registerInfluenceHandler(InfluenceName.GROWN,onGrown)
			registerInfluenceHandler(InfluenceName.KILLED, onKilled);
		}
		private function onGrown():void
		{
			_locked = false;
		}
		private function onKilled():void
		{
			_locked = true;
		}
		
		public function init(velocityPool:int, angularVelocityPool:Number ):void
		{
			_velocityPool = velocityPool;
			_angularVelocityPool = angularVelocityPool;
			rawVelocity = true;
			rawHeading = true;
			
		}
		public function moveInDirection(angleY:Number,headingOffset:Number=0):void
		{
			_followDirectionMode = true;
			_directionAngleY = angleY;
			rawVelocity = true;
			rawHeading = true;
			headingCaptured = false;
			this.headingOffset = headingOffset;
			
		}
		public function moveAtPosition(x:Number,y:Number,z:Number,headingOffset:Number=0):void
		{
			_followTargetMode = true;
			targetCaptured = false;
			_target.x = x;
			_target.y = y;
			_target.z = z;
			this.headingOffset = headingOffset;
			rawHeading = true;
			headingCaptured = false;
			
			
			rawVelocity=true
		}
		public function turnInDirection(angle:Number,headingOffset:Number=0):void
		{
			_turnToDirectionMode = true;
			turnDestiationAngle = angle;
			this.headingOffset = headingOffset;
			
			rawVelocity = true;
			rawHeading = true;
			headingCaptured = true;
		}
		
		
		public function stopMove(directionType:Boolean=true,positionType:Boolean=true,turnToDirectionMode:Boolean=true):void
		{
			if (directionType) {
				_followDirectionMode = false;
				_directionAngleY = 0;
			}
			if (positionType) {
				_followTargetMode = false;
			}
			if (turnToDirectionMode) {
				_turnToDirectionMode = false;
			}
			
			headingOffset = 0;
			angularVelocity = 0;
			rawVelocity = true;
			
		}
		
		
		
		
		public function get locked():Boolean {return _locked;}
		public function set locked(value:Boolean):void 
		{
			_locked = value;
		}
		
		public function get followTargetMode():Boolean 
		{
			return _followTargetMode;
		}
		
		public function get followDirectionMode():Boolean 
		{
			return _followDirectionMode;
		}
		
		public function get directionAngleY():Number 
		{
			return _directionAngleY;
		}
		
		public function get velocityPool():Number 
		{
			return _velocityPool;
		}
		
		public function get target():Point3D 
		{
			return _target;
		}
		
		public function get angularVelocityPool():Number 
		{
			return _angularVelocityPool;
		}
		
		
		
		public function get turnToDirectionMode():Boolean 
		{
			return _turnToDirectionMode;
		}
		public function isMoving():Boolean
		{
			var result:Boolean = (!locked) && (headingCaptured) && ((velocity.x) || (velocity.y))
			return result;
		}
		public function isTurning():Boolean
		{
			var result:Boolean = ((!locked) && (!headingCaptured));
			return result;
		}
		
	}

}