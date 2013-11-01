package com.info.components.player 
{
	import com.info.components.IInfoComponent;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class PlayerInfo implements IInfoComponent 
	{
		private var _id:int;
		
		public var speed:int;
		public var hitpoints:int;
		public var boundRadius:int;
		public var turSpeedDegrees:Number;
		public var turnSpeedRadians:Number;
		public var height:int
		
		public var defaultWeaponID:int
		
		public function PlayerInfo() 
		{
			
		}
		
		public function init(value:XML):void
		{
			_id = parseInt(value["@id"]);
			speed = parseInt(value["@speed"]);
			hitpoints = parseInt(value["@hitpoints"]);
			boundRadius = parseInt(value["@boundRadius"]);
			defaultWeaponID = parseInt(value["@defaultWeaponID"]);
			turSpeedDegrees = parseInt(value["@turnSpeed"]);
			height = parseInt(value["@height"]);
			turnSpeedRadians = turSpeedDegrees / 180.0 * Math.PI;
			
		}
		public function get id():int {	return _id;	}
		
	}

}