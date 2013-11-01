package com.game.entity.components.ai.states 
{
	import com.game.entity.components.ai.memory.Note;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class WaitState extends BaseAiState 
	{
		private var _playerNote:Note;
		
		public function WaitState() 
		{
			super();
			
		}
		override public function onEnter():void 
		{
			super.onEnter();
			_playerNote= owner.memory.getNoteByTargetID(entity.game.player.id);
		}
		override public function onExit():void 
		{
			super.onExit();
			_playerNote = null;
		}
		override public function update(dt:int):void 
		{
			
			if (_playerNote.forgoten) {
				owner.setState(owner.findPlayerState);
				return;
			}
			if (_playerNote.visibleTarget) {
				owner.setState(owner.attackPlayerState);
				return;
			}
		}
		
		
		
	}

}