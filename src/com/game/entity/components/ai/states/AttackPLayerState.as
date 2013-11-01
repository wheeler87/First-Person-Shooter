package com.game.entity.components.ai.states 
{
	import com.game.entity.characer.Player;
	import com.game.entity.components.ai.memory.Note;
	import com.game.entity.components.animation.Weapon;
	import com.info.components.weapon.WeaponInfo;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class AttackPLayerState extends BaseAiState 
	{
		private var _helperV1:Vector3D = new Vector3D();
		private var _helperV2:Vector3D = new Vector3D();
		private var _helperV3:Vector3D = new Vector3D();
		
		private var _playerNode:Note
		
		
		public function AttackPLayerState() 
		{
			super();
			
		}
		override public function onEnter():void 
		{
			super.onEnter();
			
			_playerNode = owner.memory.getNoteByTargetID(entity.game.player.id);
			
		}
		override public function onExit():void 
		{
			super.onExit();
			
			_playerNode = null;
			stopLoocomotion();
		}
		
		override public function update(dt:int):void 
		{
			super.update(dt);
			if (_playerNode.forgoten) {
				owner.setState(owner.waitState);
				return;
			}
			if (!entity.amunition.selectedWeapon) {
				selectAppropriateWeapon()
				if (!entity.amunition.selectedWeapon) {
					return;
				}
			}
			if (!isInAttackDiapazon()) {
				moveInAtackDiapazon()
				return;
			}
			if (!_playerNode.visibleTarget) {
				owner.setState(owner.waitState);
				return;
			}
			
			
			if (!isAimed()) {
				stopLoocomotion();
				advanceAiming();
				return;
			}
			
			if (isWeaponReadyToAttak()) {
				attackPlayer();
			}
			
			
		}
		
		private function selectAppropriateWeapon():void
		{
			var totalWeapons:int = entity.amunition.weaponsList.length;
			if (totalWeapons < 1) return;
			entity.amunition.selectWeaponAt(0);
		}
		private function isInAttackDiapazon():Boolean
		{
			var enemyCoordinates:Vector3D = entity.position.worldCoordinates;
			var playerCoordinates:Vector3D = _playerNode.lastSeenPosition;
			
			var toEnemy:Vector3D = _helperV1;
			toEnemy.x = enemyCoordinates.x - playerCoordinates.x;
			toEnemy.y = enemyCoordinates.y - playerCoordinates.y;
			toEnemy.z = enemyCoordinates.z - enemyCoordinates.z;
			
			var distSQ:Number = toEnemy.lengthSquared;
			
			var weaponInfo:WeaponInfo = entity.amunition.selectedWeapon.weaponInfo;
			if (distSQ > (weaponInfo.attackDistanceMax * weaponInfo.attackDistanceMax)) {
				return false;
			}
			if ((distSQ) < (weaponInfo.attackDistanceMin * weaponInfo.attackDistanceMin)) {
				return false;
			}
			return true;
			
			
		}
		private function moveInAtackDiapazon():void
		{
			var enemyCoordinates:Vector3D = entity.position.worldCoordinates;
			var playerCoordinates:Vector3D = _playerNode.lastSeenPosition;
			var weaponInfo:WeaponInfo = entity.amunition.selectedWeapon.weaponInfo;
			
			
			var toEnemy:Vector3D = _helperV1;
			toEnemy.x = enemyCoordinates.x - playerCoordinates.x;
			toEnemy.y = enemyCoordinates.y - playerCoordinates.y;
			toEnemy.z = enemyCoordinates.z - enemyCoordinates.z;
			
			toEnemy.normalize();
			toEnemy.scaleBy(weaponInfo.attackDistanceMin + 0.3 * (weaponInfo.attackDistanceMax - weaponInfo.attackDistanceMin))
			
			entity.movement.moveAtPosition(playerCoordinates.x + toEnemy.x, enemyCoordinates.y, playerCoordinates.z + toEnemy.z);
			
		}
		
		
		private function isAimed():Boolean
		{
			var playerPosition:Vector3D = player.position.worldCoordinates;
			var enemyPosition:Vector3D = entity.position.worldCoordinates;
			
			var distance:Number = Vector3D.distance(playerPosition, enemyPosition);
			var radius:Number = player.bounds.radius;
			
			
			var currentAngle:Number = entity.position.worldAngleY;
			var desiredAngle:Number = -Math.atan2(playerPosition.z - enemyPosition.z, playerPosition.x - enemyPosition.x);
			
			
			var currentHeading:Vector3D = _helperV1;
			currentHeading.x = Math.cos(currentAngle);
			currentHeading.y = Math.sin(currentAngle);
			
			var desiredHeading:Vector3D = _helperV2;
			desiredHeading.x = Math.cos(desiredAngle);
			desiredHeading.y = Math.sin(desiredAngle);
			
			var deviationCurrent:Number = Math.abs(Vector3D.angleBetween(currentHeading, desiredHeading));
			var headingsDot:Number = currentHeading.dotProduct(desiredHeading);
			
			var maxDeviation:Number = Math.atan2(radius * 0.9, distance);
			
			var result:Boolean = ((maxDeviation >= deviationCurrent)&&(headingsDot>=0));
			
			return result;
		}
		
		private function advanceAiming():void
		{
			var enemyPosition:Vector3D = entity.position.worldCoordinates;
			var playerPosition:Vector3D = player.position.worldCoordinates;
			
			var wishfulHeading:Number = -Math.atan2(playerPosition.z - enemyPosition.z, playerPosition.x - enemyPosition.x);
			
			
			entity.movement.turnInDirection(wishfulHeading);
		}
		private function stopLoocomotion():void
		{
			entity.movement.stopMove();
			
		}
		
		private function isWeaponReadyToAttak():Boolean
		{
			var weapon:Weapon=entity.amunition.selectedWeapon
			var result:Boolean=weapon.isReadyToFire();
			
			return result;
		}
		private function attackPlayer():void
		{
			var weapon:Weapon = entity.amunition.selectedWeapon;
			weapon.fire();
		}
		
		
		private function get player():Player { return entity.game.player }
	}

}