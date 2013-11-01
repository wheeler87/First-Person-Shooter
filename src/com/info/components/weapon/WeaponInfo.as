package com.info.components.weapon 
{
	import com.info.components.IInfoComponent;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class WeaponInfo implements IInfoComponent 
	{
		private var _id:int;
		
		public var attackDistanceMax:int;
		public var attackDistanceMin:int;
		public var slugID:int;
		public var animationGroupID:int
		
		public var cageCapacity:int
		public var shootTime:int
		public var reloadingTime:int;
		public var bulletsPerShot:int;
		
		public function WeaponInfo() 
		{
			
		}
		public function init(value:XML):void
		{
			_id = parseInt(value["@id"]);
			slugID= parseInt(value["@slugID"]);
			
			attackDistanceMax = parseInt(value["@attackDistanceMax"]);
			attackDistanceMin = parseInt(value["@attackDistanceMin"]);
			animationGroupID = parseInt(value["@animationGroupID"]);
			cageCapacity = parseInt(value["@cageCapacity"]);
			shootTime = parseInt(value["@shootTime"]);
			reloadingTime = parseInt(value["@reloadingTime"]);
			bulletsPerShot = parseInt(value["@bulletsPerShot"]);
			
		}
		
		
		/* INTERFACE com.info.components.IInfoComponent */
		
		public function get id():int 
		{
			return _id;
		}
		
	}

}