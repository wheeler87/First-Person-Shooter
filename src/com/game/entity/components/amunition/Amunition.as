package com.game.entity.components.amunition 
{
	import com.components.ApplicationSprite;
	import com.game.entity.components.animation.Weapon;
	import com.game.entity.components.BaseComponent;
	import com.game.entity.components.influence.Influence;
	import com.game.entity.components.influence.InfluenceName;
	import com.info.components.slug.SlugInfo;
	import com.info.components.weapon.WeaponInfo;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Amunition extends BaseComponent 
	{
		static public const NAME:String = "Amunition";
		public var weaponsList:Vector.<Weapon>
		
		public var selectedWeapon:Weapon
		
		
		public var defaultWeaponID:int
		
		
		
		public function Amunition() 
		{
			super(NAME);
			weaponsList = new Vector.<Weapon>();
			
		}
		
		public function init(defaultWeaponID:int):void
		{
			this.defaultWeaponID = defaultWeaponID;
		}
		
		
		public function addWeapon(weaponId:int):void
		{
			var weapon:Weapon = new Weapon();
			weapon.init(weaponId,this);
			
			weaponsList.push(weapon);
		}
		public function removeAllWeapon():void
		{
			weaponsList.length = 0;
			selectedWeapon = null;
		}
		
		public function selectWeaponAt(index:int):void
		{
			selectedWeapon = weaponsList[index];
			var influence:Influence = owner.getCompoentByName(Influence.NAME) as Influence;
			influence.addInfluence(InfluenceName.WEAPON_SELECTED);
		}
		public function isWeaponAtPosition(index:int):Boolean
		{
			var result:Boolean = (index >= 0) && (index < weaponsList.length);
			return result;
		}
		public function getSelectedWeaponIndex():int
		{
			var result:int = (selectedWeapon)?weaponsList.indexOf(selectedWeapon): -1;
			return result;
		}
	}

}