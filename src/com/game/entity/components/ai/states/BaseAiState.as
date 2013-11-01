package com.game.entity.components.ai.states 
{
	import com.game.entity.characer.Character;
	import com.game.entity.components.ai.AI;
	import com.game.entity.characer.Enemy;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class BaseAiState 
	{
		private var _owner:AI
		
		
		public function BaseAiState() 
		{
			
		}
		public function onEnter():void
		{
			
		}
		public function onExit():void
		{
			
		}
		public function update(dt:int):void
		{
			
		}
		
		
		
		public function get owner():AI 
		{
			return _owner;
		}
		
		public function set owner(value:AI):void 
		{
			_owner = value;
		}
		
		public function get entity():Character {return owner.owner as Character}
		
	}

}