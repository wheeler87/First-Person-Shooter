package com.game.plugins.lifeCycle 
{
	import com.game.entity.characer.Character;
	import com.game.entity.components.influence.InfluenceName;
	import com.game.entity.components.life.Life;
	import com.game.entity.characer.Enemy;
	import com.game.Game;
	import com.game.plugins.BasePlugin;
	import com.game.plugins.synchronizer.PriorityInitialization;
	import com.game.plugins.synchronizer.PriorityUpdate;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class LifeCyclePlugin extends BasePlugin 
	{
		
		public function LifeCyclePlugin(owner:Game) 
		{
			super(owner);
			
		}
		override public function onEnter():void 
		{
			super.onEnter();
			
			owner.synchronizer.addInitializationTask(initialize, PriorityInitialization.LIFE_CYCLE_INITIALIZATION);
			owner.synchronizer.addUpdateTask(advanceCharactersLifeCycle, PriorityUpdate.ADVANCE_CHARACTERS_LIFE_CYCLE);
		}
		
		private function initialize():void
		{
			initializeCharacterLifeCycle(owner.player);
			for each(var enemy:Enemy in owner.enemies)
			{
				initializeCharacterLifeCycle(enemy);
			}
		}
		
		private function advanceCharactersLifeCycle():void
		{
			var dt:int = owner.settings.updateStepDuration;
			advanceCharacterLifeCycle(owner.player, dt);
			for each(var enemy:Enemy in owner.enemies)
			{
				advanceCharacterLifeCycle(enemy, dt);
			}
		}
		private function advanceCharacterLifeCycle(target:Character,dt:int):void
		{
			target.life.advanceLifeCycle(dt);
		}
		private function initializeCharacterLifeCycle(target:Character):void
		{
			target.life.lifeState = Life.LIFE_STATE_BORN;
			
		}
	}

}