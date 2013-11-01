package com.game.plugins.influence 
{
	import com.game.entity.characer.Character;
	import com.game.entity.components.BaseComponent;
	import com.game.entity.characer.Enemy;
	import com.game.Game;
	import com.game.plugins.BasePlugin;
	import com.game.plugins.synchronizer.PriorityInitialization;
	import com.game.plugins.synchronizer.PriorityUpdate;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class InfluencePlugin extends BasePlugin 
	{
		
		public function InfluencePlugin(owner:Game) 
		{
			super(owner);
			
		}
		override public function onEnter():void 
		{
			super.onEnter();
			owner.synchronizer.addInitializationTask(initialize, PriorityInitialization.INFLUENCE_INITIALIZATION);
			owner.synchronizer.addUpdateTask(handleEntytiesInfluences, PriorityUpdate.HANDLE_INFLUENCES);
		}
		override public function onExit():void 
		{
			super.onExit();
		}
		
		private function initialize():void
		{
			
		}
		private function handleEntytiesInfluences():void
		{
			handleEntityInfluences(owner.player);
			for each(var enemy:Enemy in owner.enemies) {
				handleEntityInfluences(enemy);
			}
		}
		private function handleEntityInfluences(value:Character):void
		{
			var length:int = value.influence.influenceList.length;
			var influenceName:String
			var currentComponent:BaseComponent;
			
			for (var i:uint = 0; i < length; i++ ) {
				influenceName = value.influence.shiftInfluence();
				for (var j:uint = 0; j < value.components.length; j++ ) {
					currentComponent = value.components[j];
					currentComponent.hadleInfluence(influenceName);
				}
			}
			
		}
	}

}