package com.game.plugins.animation 
{
	import com.game.entity.characer.Enemy;
	import com.game.entity.characer.Player;
	import com.game.entity.components.amunition.Amunition;
	import com.game.entity.components.amunition.AnimationState;
	import com.game.entity.components.animation.Animation;
	import com.game.entity.components.movement.Movement;
	import com.game.entity.components.position.Position;
	import com.game.Game;
	import com.game.plugins.BasePlugin;
	import com.game.plugins.synchronizer.PriorityInitialization;
	import com.game.plugins.synchronizer.PriorityUpdate;
	import com.info.components.animation.AnimationInfo;
	import com.info.components.animation.AnimationTriggerInfo;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class AnimationPlugin extends BasePlugin 
	{
		private var _helperV1:Vector3D = new Vector3D();
		private var _directionsList:Vector.<String>;
		private var _radiansPerDirection:Number
		
		
		public function AnimationPlugin(owner:Game) 
		{
			super(owner);
			
			
			
		}
		override public function onEnter():void 
		{
			super.onEnter();
			owner.synchronizer.addInitializationTask(initialize, PriorityInitialization.ANIMATION_INITIALIZATION);
			owner.synchronizer.addUpdateTask(update, PriorityUpdate.ANIMATION_UPDATE);
		}
		override public function onExit():void 
		{
			super.onExit();
			owner.synchronizer.removeInitializationTask(initialize);
			owner.synchronizer.removeUpdateTask(update);
		}
		
		public function initialize():void
		{
			configurateDirectionParams();
			owner.player.animation.reactOnWeaponSelection = true;
		}
		
		private function configurateDirectionParams():void
		{
			_directionsList = new Vector.<String>(8, true);
			_directionsList[0] = AnimationInfo.DIRECTION_E;
			_directionsList[1] = AnimationInfo.DIRECTION_SE;
			_directionsList[2] = AnimationInfo.DIRECTION_S;
			_directionsList[3] = AnimationInfo.DIRECTION_SW;
			_directionsList[4] = AnimationInfo.DIRECTION_W;
			_directionsList[5] = AnimationInfo.DIRECTION_NW;
			_directionsList[6] = AnimationInfo.DIRECTION_N;
			_directionsList[7] = AnimationInfo.DIRECTION_NE;
			
			_radiansPerDirection = Math.PI * 2.0 / _directionsList.length;
		}
		
		public function update():void
		{
			var dt:int = owner.settings.updateStepDuration;
			updatePlayerAnimationState(owner.player, dt);
			for each(var enemy:Enemy in owner.enemies) {
				updateEnemyAnimationState(enemy,dt);
			}
		}
		
		private function updatePlayerAnimationState(value:Player, dt:int):void
		{
			var animation:Animation = value.animation;
			var amunition:Amunition = value.amunition;
			var movement:Movement = value.movement;
			
			reInitFromAmunition(animation, amunition);
			if (animation.inited) {
				procesAnimationStateLifeCycle(movement, animation);
				updateAnimationState(animation, dt);
			}
			
			
		}
		
		
		
		private function updateEnemyAnimationState(value:Enemy,dt:int):void
		{
			var animation:Animation = value.animation;
			var position:Position = value.position;
			var movement:Movement = value.movement;
			
			recalculateDirection(position, animation);
			procesAnimationStateLifeCycle(movement, animation);
			updateAnimationState(animation, dt);
			
			
		}
		private function reInitFromAmunition(animation:Animation, amunition:Amunition):void
		{
			if (!animation.reInitRequires) return;
			if (!amunition.selectedWeapon) return;
			animation.reInitRequires = false;
			var animationGroupID:int = amunition.selectedWeapon.weaponInfo.animationGroupID;
			animation.init(animationGroupID);
			
			
		}
		
		
		
		private function recalculateDirection(position:Position, animation:Animation):void
		{
			var cameraAngleY:Number = position.cameraAngleY;
			cameraAngleY = (cameraAngleY) % (Math.PI * 2);
			if (cameraAngleY < 0) {
				cameraAngleY += Math.PI * 2;
			}
			var directionIndex:int = Math.round(cameraAngleY / _radiansPerDirection);
			directionIndex = (directionIndex % _directionsList.length);
			var selectedDirection:String = _directionsList[directionIndex];
			
			
			animation.direction = selectedDirection;
			
			
			
		}
		private function procesAnimationStateLifeCycle(movement:Movement,animation:Animation):void
		{
			var stack:Vector.<AnimationTriggerInfo> = animation.executedTriggersStack;
			var currentTrigger:AnimationTriggerInfo;
			if (movement.isMoving()) {
				currentTrigger = animation.animationGroupInfo.getTriggerByName(AnimationTriggerInfo.NAME_WALKING);
				if (currentTrigger) {
					stack.push(currentTrigger);
				}
			}
			stack.sort(AnimationTriggerInfo.sorter);
			currentTrigger = (stack.length)?stack[0]:null;
			stack.length = 0;
			
			var triggerSwitchRequires:Boolean = (((animation.currentTrigger) && (currentTrigger) && (currentTrigger.priority < animation.currentTrigger.priority)) ||
												 ((!animation.currentTrigger) && (currentTrigger)) ||
												 ((!currentTrigger)&&(!animation.currentTrigger)&&(!animation.isDefaultAnimationPlays())))
			var directionSwitchRequires:Boolean = (animation.direction != animation.currentDirection);
			if ((!triggerSwitchRequires) && (!directionSwitchRequires)) {
				return;
			}
			currentTrigger = (triggerSwitchRequires)?currentTrigger:animation.currentTrigger;
			var animationID:int = (currentTrigger)?animation.getAppropriateAnimationID(currentTrigger.name, animation.direction):animation.getDefaultAnimationID(animation.direction);
			
			var animationPercent:Number = (directionSwitchRequires)?animation.currentAnimationState.getAnimationPercent():0;
			
			animation.currentDirection = animation.direction;
			animation.currentTrigger = currentTrigger;
			animation.setState(animationID);
			animation.currentAnimationState.setAnimationPercent(animationPercent);
			
		}
		private function updateAnimationState(animation:Animation, dt:int):void
		{
			animation.currentAnimationState.update(dt);
		}
		
	}

}