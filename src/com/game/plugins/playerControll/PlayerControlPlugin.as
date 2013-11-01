package com.game.plugins.playerControll 
{
	import com.game.entity.components.amunition.Amunition;
	import com.game.entity.components.animation.Weapon;
	import com.game.entity.components.indicator.Indicator;
	import com.game.entity.components.indicator.Sight;
	import com.game.entity.components.influence.Influence;
	import com.game.entity.components.influence.InfluenceName;
	import com.game.entity.components.life.Life;
	import com.game.entity.components.movement.Movement;
	import com.game.entity.components.position.Position;
	import com.game.Game;
	import com.game.plugins.BasePlugin;
	import com.game.plugins.synchronizer.PriorityInitialization;
	import com.game.plugins.synchronizer.PriorityUpdate;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class PlayerControlPlugin extends BasePlugin 
	{
		
		private var _keyTurnLeft:int
		private var _keyTurnRight:int
		private var _keyMoveForward:int;
		private var _keyMoveBackward:int;
		private var _keyFire:int
		private var _keySlot1:int;
		private var _keySlot2:int;
		
		private var _turnLeftActive:Boolean;
		private var _turnRightActive:Boolean;
		private var _moveForwardActive:Boolean;
		private var _moveBackwardActive:Boolean;
		private var _fireActive:Boolean;
		
		private var _turnSpeed:Number
		
		public function PlayerControlPlugin(owner:Game) 
		{
			super(owner);
			
		}
		override public function onEnter():void 
		{
			super.onEnter();
			owner.synchronizer.addInitializationTask(initialize, PriorityInitialization.PLAYER_CONTROL_INITIALIZATION);
			owner.synchronizer.addUpdateTask(advancePlayerControll, PriorityUpdate.ADVANCE_PLAYER_CONTROLL);
			owner.synchronizer.addUpdateTask(updateIndicatorStatus, PriorityUpdate.UPDATE_INIDATOR_STATUS);
		}
		override public function onExit():void 
		{
			super.onExit();
			owner.synchronizer.removeInitializationTask(initialize);
			owner.synchronizer.removeUpdateTask(advancePlayerControll);
		}
		
		private function initialize():void
		{
			owner.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			owner.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			owner.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			initializeKeys();
			initHelpers();
		}
		
		
		private function initializeKeys():void
		{
			_keyTurnLeft = owner.settings.turnLeft;
			_keyTurnRight = owner.settings.turnRight;
			_keyMoveForward = owner.settings.moveForward;
			_keyMoveBackward = owner.settings.moveBackward;
			_keyFire = owner.settings.fire;
			_keySlot1 = owner.settings.slot1;
			_keySlot2 = owner.settings.slot2;
			
		}
		private function initHelpers():void
		{
			_turnSpeed = owner.player.playerInfo.turnSpeedRadians;
		}
		
		
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			switch (e.keyCode) 
			{
				case _keyTurnLeft:
					_turnLeftActive = true;
				break;
				case _keyTurnRight:
					_turnRightActive = true;
				break;
				case _keyMoveForward:
					_moveForwardActive = true;
				break;
				case _keyMoveBackward:
					_moveBackwardActive = true;
				break;
				case _keyFire:
					_fireActive = true;
					var weapon:Weapon = owner.player.amunition.selectedWeapon;
					if ((weapon) && (weapon.isReadyToFire())) {
						weapon.fire();
					}
					
				break;
				case _keySlot1:
					handleWeaponSelection(0)
				break
				case _keySlot2:
					handleWeaponSelection(1);
				break
				
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			switch (e.keyCode) 
			{
				case _keyTurnLeft:
					_turnLeftActive = false;
				break;
				case _keyTurnRight:
					_turnRightActive = false;
				break;
				case _keyMoveForward:
					_moveForwardActive = false;
				break;
				case _keyMoveBackward:
					_moveBackwardActive = false;
				break;
				case _keyFire:
					_fireActive = false;
				break;
				
			}
		}
		
		private function advancePlayerControll():void
		{
			var dt:Number = owner.settings.updateStepDuration * 0.001;
			var movement:Movement=owner.player.movement;
			var position:Position=owner.player.position
			if ((_turnLeftActive)||(_turnRightActive)) {
				//movement.stopMove();
				var ort:int = (_turnLeftActive)? -1:1;
				var turnAmount:Number = _turnSpeed * dt * ort;
				owner.player.position.worldAngleY += turnAmount;
				
				
			}//else 
			if (_moveForwardActive) {
				movement.moveInDirection(position.worldAngleY);
				movement.rawHeading = false;
			}else if(_moveBackwardActive) {
				movement.moveInDirection(position.worldAngleY - Math.PI, Math.PI);
				movement.rawHeading = false;
			}else {
				movement.stopMove();
				movement.rawHeading = false;
			}
			
		}
		private function updateIndicatorStatus():void
		{
			var dt:int = owner.settings.updateStepDuration;
			
			var indicator:Indicator = owner.player.indicator;
			var weapon:Weapon = owner.player.amunition.selectedWeapon;
			var life:Life = owner.player.life;
			var influence:Influence = owner.player.influence;
			
			if (weapon) {
				indicator.displaySighn = true;
				if (weapon.reloadTimeRemain > 0) {
					indicator.sight.color = Sight.COLOR_RED;
					indicator.bulletsInCageRenderer.text = "Reloading...";
				}else if(weapon.fireTimeRemain>0)  {
					indicator.sight.color = Sight.COLOR_RED;
					indicator.bulletsInCageRenderer.text = "Bullets: " + weapon.bulletsInCage + "/" + weapon.weaponInfo.cageCapacity;
				}else{
					indicator.sight.color = Sight.COLOR_GREEN;
					indicator.bulletsInCageRenderer.text = "Bullets: " + weapon.bulletsInCage + "/" + weapon.weaponInfo.cageCapacity;
				}
				
			}else {
				indicator.displaySighn = false;
				indicator.bulletsInCageRenderer.text = "";
			}
			if (indicator.displayBloodRequest) {
				indicator.displayBloodRequest = false;
				indicator.displayBlood = true;
				indicator.timeToDisplayBlood = Indicator.DISPLAY_BLOOD_DURATION;
			}
			if (indicator.displayBlood) {
				indicator.timeToDisplayBlood -= dt;
				if (indicator.timeToDisplayBlood <= 0) {
					indicator.displayBlood = false;
				}
			}
			
			indicator.healthRenderer.text = "Health: " + life.hitpoints + "/" + life.hitpointsPool;
		}
		
		private function handleWeaponSelection(index:int):void
		{
			var amunition:Amunition = owner.player.amunition;
			if (amunition.isWeaponAtPosition(index)) {
				amunition.selectWeaponAt(index);
			}
		}
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			var delta:int = (e.delta > 0)?1: -1;
			var appropriateIndex:int = owner.player.amunition.getSelectedWeaponIndex() + delta;
			handleWeaponSelection(appropriateIndex);
		}
	}

}