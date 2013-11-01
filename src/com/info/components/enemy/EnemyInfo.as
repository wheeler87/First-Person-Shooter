package com.info.components.enemy 
{
	import com.info.components.IInfoComponent;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class EnemyInfo implements IInfoComponent
	{
		private var _id:int;
		
		public var speed:Number;
		public var turSpeedDegrees:Number;
		public var turnSpeedRadians:Number;
		
		public var hitpoints:Number
		public var boundRadius:int
		public var height:int
		
		public var cogitationTime:int;
		public var rememberTime:int
		
		public var defaultWeaponID:int
		public var animationGroupID:int;
		
		public var deathDuration:int;
		
		public function EnemyInfo() 
		{
			
		}
		
		public function init(value:XML):void
		{
			_id = parseInt(value["@id"]);
			speed = parseInt(value["@speed"]);
			turSpeedDegrees = parseInt(value["@turnSpeed"]);
			turnSpeedRadians = turSpeedDegrees / 180.0 * Math.PI;
			
			hitpoints = parseInt(value["@hitpoints"]);
			boundRadius = parseInt(value["@boundRadius"]);
			defaultWeaponID = parseInt(value["@defaultWeaponID"]);
			height = parseInt(value["@height"]);
			cogitationTime = parseInt(value["@cogitationTime"]);
			rememberTime = parseInt(value["@rememberTime"]);
			
			animationGroupID = parseInt(value["@animationGroupID"]);
			deathDuration = parseInt(value["@deathDuration"]);
			
		}
		
		public function get id():int {return _id;}
		
	}

}