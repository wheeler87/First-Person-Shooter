package com.game.entity.components.animation 
{
	import com.game.entity.components.amunition.Amunition;
	import com.game.entity.components.influence.Influence;
	import com.game.entity.components.influence.InfluenceName;
	import com.info.components.slug.SlugInfo;
	import com.info.components.weapon.WeaponInfo;
	import com.info.Info;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Weapon 
	{
		public var weaponInfo:WeaponInfo;
		public var slugInfo:SlugInfo;
		
		public var bulletsInCage:int;
		
		public var reloadTimeRemain:int
		public var fireTimeRemain:int;
		
		public var makeSlugRequest:Boolean
		public var generatedBulletsAmount:int
		
		
		private var _amunition:Amunition
		
		public function Weapon() 
		{
			
		}
		public function init(weaponInfoID:int,amunition:Amunition):void
		{
			_amunition = amunition;
			
			var info:Info = Facade.instance.info;
			weaponInfo = info.getInfoComponentByID(weaponInfoID) as WeaponInfo;
			slugInfo = info.getInfoComponentByID(weaponInfo.slugID) as SlugInfo;
			
			bulletsInCage = weaponInfo.cageCapacity;
			reloadTimeRemain = 0;
			fireTimeRemain = 0;
			
		}
		public function update(dt:int):void
		{
			if (fireTimeRemain > 0) {
				fireTimeRemain -= dt;
				//trace(fireTimeRemain);
				if (fireTimeRemain <= 0) {
					if (bulletsInCage <= 0) {
						reloadTimeRemain = weaponInfo.reloadingTime;
						influence.addInfluence(InfluenceName.RELOADING_START);
					}
				}
			}
			if (reloadTimeRemain > 0) {
				reloadTimeRemain -= dt;
				if (reloadTimeRemain <= 0) {
					bulletsInCage = weaponInfo.cageCapacity;
					influence.addInfluence(InfluenceName.RELOADING_END);
				}
			}
		}
		public function fire():void
		{
			if (!isReadyToFire()) {
				return;
			}
			fireTimeRemain = weaponInfo.shootTime;
			makeSlugRequest = true;
			generatedBulletsAmount = Math.min(bulletsInCage, weaponInfo.bulletsPerShot);
			bulletsInCage-= generatedBulletsAmount;
			influence.addInfluence(InfluenceName.FIRE);
			
		}
		public function isReadyToFire():Boolean
		{
			var result:Boolean = (reloadTimeRemain <= 0) && (fireTimeRemain <= 0);
			return result;
		}
		
		private function get influence():Influence
		{
			var result:Influence = _amunition.owner.getCompoentByName(Influence.NAME) as Influence;
			return result;
		}
	}

}