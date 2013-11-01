package com.game.plugins.amunition 
{
	
	import com.game.entity.characer.Character;
	import com.game.entity.characer.Enemy;
	import com.game.entity.components.amunition.Amunition;
	import com.game.entity.components.animation.Weapon;
	import com.game.entity.components.bounds.Bounds;
	import com.game.entity.components.influence.Influence;
	import com.game.entity.components.influence.InfluenceName;
	import com.game.entity.components.position.Position;
	import com.game.entity.slug.Slug;
	import com.game.Game;
	import com.game.plugins.BasePlugin;
	import com.game.plugins.synchronizer.PriorityInitialization;
	import com.game.plugins.synchronizer.PriorityUpdate;
	import com.geom.Matrix3D;
	import com.info.components.slug.SlugInfo;
	import com.info.components.weapon.WeaponInfo;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class AmunitionPlugin extends BasePlugin 
	{
		private var _helperM1:Matrix3D = new Matrix3D();
		private var _helperV1:Vector3D = new Vector3D();
		
		
		public function AmunitionPlugin(owner:Game) 
		{
			super(owner);
			
		}
		override public function onEnter():void 
		{
			super.onEnter();
			owner.synchronizer.addInitializationTask(initialize, PriorityInitialization.AMUNITION_INITIALIZATION);
			owner.synchronizer.addUpdateTask(updateAmunitionsStatus, PriorityUpdate.UPDATE_AMUNITION_STATUS);
			owner.synchronizer.addUpdateTask(advanceSlugsLifeCycle, PriorityUpdate.ADVANCE_SLUGS_LIFE_CYCLE);
			
		}
		override public function onExit():void 
		{
			super.onExit();
			owner.synchronizer.removeInitializationTask(initialize);
			
		}
		
		private function initialize():void
		{
			
		}
		
		private function updateAmunitionsStatus():void
		{
			var dt:int = owner.settings.updateStepDuration;
			
			updateAmunitionStatus(owner.player, dt);
			for each(var enemy:Enemy in owner.enemies) {
				updateAmunitionStatus(enemy, dt);
			}
		}
		
		private function updateAmunitionStatus(character:Character,dt:int):void
		{
			var amunition:Amunition = character.amunition;
			var influence:Influence = character.influence;
			
			if (influence.wasInfluenced(InfluenceName.KILLED)) {
				amunition.removeAllWeapon();
			}else if (influence.wasInfluenced(InfluenceName.GROWN)) {
				var weaponsList:Vector.<WeaponInfo> = Facade.instance.info.weaponInfoList;
				for (var i:int = 0; i < weaponsList.length; i++ ) {
					amunition.addWeapon(weaponsList[i].id);
				}
				
				
				amunition.selectWeaponAt(0);
			}
			
			var selectedWeapon:Weapon = amunition.selectedWeapon;
			if (selectedWeapon) {
				selectedWeapon.update(dt);
				if (selectedWeapon.makeSlugRequest) {
					createSlugForCharacter(character,selectedWeapon.generatedBulletsAmount);
					selectedWeapon.makeSlugRequest = false;
					selectedWeapon.generatedBulletsAmount = 0;
				}
			}
		}
		private function createSlugForCharacter(value:Character,bulletsAmount:int):void
		{
			var amunition:Amunition = value.amunition;
			var weapon:Weapon = amunition.selectedWeapon;
			var position:Position = value.position;
			
			
			
			var slugPosition:Vector3D = _helperV1;
			slugPosition.x = value.bounds.radius * 1.1;
			slugPosition.y = 0;
			slugPosition.z = 0;
			
			_helperM1.identity();
			_helperM1.rotateY(position.worldAngleY);
			_helperM1.translate(position.worldCoordinates.x, position.worldCoordinates.y - value.bounds.height * 0.5, position.worldCoordinates.z);
			
			_helperM1.transformVector(slugPosition);
			
			for (var i:uint = 0; i < bulletsAmount; i++ ) {
				var slug:Slug = new Slug();
				slug.damage.ownerID = value.id;
				owner.addSlug(slug);
				slug.init(weapon.slugInfo);
				slug.position.locate(slugPosition.x, slugPosition.y, slugPosition.z, position.worldAngleY);
				slug.movement.moveInDirection(slug.position.worldAngleY);
			}
			
			
			
		}
		
		private function advanceSlugsLifeCycle():void
		{
			var slug:Slug;
			var bounds:Bounds;
			var hittedCharacter:Character;
			
			for (var i:int = owner.slugs.length - 1; i >= 0; i-- ) {
				slug = owner.slugs[i];
				bounds = slug.bounds;
				if (bounds.collidedWithWall) {
					owner.removeSlug(slug);
					continue;
				}
				if (bounds.collidedWithEntity) {
					if (bounds.collidedEntityID != slug.damage.ownerID) {
						hittedCharacter = owner.getEntityByID(bounds.collidedEntityID) as Character;
						hittedCharacter.life.reciveDamage(slug.damage.damage);
						
						owner.removeSlug(slug);
					}
				}
				
			}
		}
		
	}

}