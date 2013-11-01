package com.game.plugins.ai 
{
	import com.game.entity.characer.Character;
	import com.game.entity.components.ai.memory.Memory;
	import com.game.entity.components.ai.memory.Note;
	import com.game.entity.characer.Enemy;
	import com.game.Game;
	import com.game.plugins.BasePlugin;
	import com.game.plugins.synchronizer.PriorityInitialization;
	import com.game.plugins.synchronizer.PriorityUpdate;
	import com.info.components.location.navigation.Node;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class AiPlugin extends BasePlugin 
	{
		
		public function AiPlugin(owner:Game) 
		{
			super(owner);
			
		}
		
		override public function onEnter():void 
		{
			super.onEnter();
			owner.synchronizer.addInitializationTask(initialize, PriorityInitialization.AI_INITIALIZATION)
			owner.synchronizer.addUpdateTask(update, PriorityUpdate.AI_UPDATE);
		}
		override public function onExit():void 
		{
			super.onExit();
			owner.synchronizer.removeInitializationTask(initialize)
			owner.synchronizer.removeUpdateTask(update);
		}
		
		private function initialize():void
		{
			for each(var enemy:Enemy in owner.enemies) {
				initializeEntity(enemy);
			}
		}
		private function update():void
		{
			advanceEntitiesBehaviour();
			advanceEntitiesMemoryState();
		}
		private function advanceEntitiesMemoryState():void
		{
			var dt:int = owner.settings.updateStepDuration;
			var lastFrameTime:int = owner.progress.lastFrameTime;
			for each(var enemy:Enemy in owner.enemies) {
				advaanceEntityMemoryState(enemy, dt,lastFrameTime);
			}
		}
		
		private function advanceEntitiesBehaviour():void
		{
			var dt:int = owner.settings.updateStepDuration;
			for each(var enemy:Enemy in owner.enemies) {
				advanceEntityAiBehaviour(enemy,dt);
			}
		}
		
		
		private function initializeEntity(value:Enemy):void
		{
			value.ai.navigation = owner.navigation;
			var memory:Memory = value.ai.memory;
			memory.addNote(Note.TYPE_PLAYER, owner.player.id);
			for each(var enemy:Enemy in owner.enemies) {
				if (enemy == value) {
					continue;
				}
				memory.addNote(Note.TYPE_ENEMY, enemy.id);
			}
		}
		
		private function advanceEntityAiBehaviour(value:Enemy,dt:int):void
		{
			value.ai.update(dt);
		}
		private function advaanceEntityMemoryState(value:Enemy,dt:int,lastFrameTime:int):void
		{
			var memory:Memory = value.ai.memory;
			memory.advanceCogitation(dt);
			if (!memory.stateUpdateRequires()) {
				
				return;
			}
			var playerNotesGroup:Vector.<Note> = memory.getNotesByType(Note.TYPE_PLAYER);
			var enemyNotesGroup:Vector.<Note> = memory.getNotesByType(Note.TYPE_ENEMY);
			updateCharacterRelatedNotes(playerNotesGroup,value,lastFrameTime);
			updateCharacterRelatedNotes(enemyNotesGroup,value,lastFrameTime);
			
			memory.markAsUpdated();
			
			
		}
		
		private function updateCharacterRelatedNotes(notesGroup:Vector.<Note>,notesOwner:Enemy,lastFrameTime:int):void
		{
			var target:Character
			for each(var note:Note in notesGroup) {
				target = owner.getEntityByID(note.targetID) as Character;
				var isInFOV:Boolean = owner.navigation.isInFieldOfView(notesOwner, target);
				if (isInFOV) {
					note.forgoten = false;
					note.visibleTarget = true;
					note.lastSeenPosition.x = target.position.worldCoordinates.x;
					note.lastSeenPosition.y = target.position.worldCoordinates.y;
					note.lastSeenPosition.z = target.position.worldCoordinates.z;
					note.lastSeenTime = lastFrameTime;
					
				}else if (!note.forgoten) {
					note.visibleTarget = false;
					if ((note.lastSeenTime+note.rememberTime) <= (lastFrameTime)) {
						note.forgoten = true;
						
					}
				}
				
				
				
			}
		}
	}

}