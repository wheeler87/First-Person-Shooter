package com.game.entity.components.ai 
{
	import com.game.entity.components.ai.memory.Memory;
	import com.game.entity.components.ai.states.AttackPLayerState;
	import com.game.entity.components.ai.states.BaseAiState;
	import com.game.entity.components.ai.states.FindPlayerState;
	import com.game.entity.components.ai.states.WaitState;
	import com.game.entity.components.BaseComponent;
	import com.game.entity.components.influence.InfluenceName;
	import com.game.plugins.navigation.NavigationPlugin;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class AI extends BaseComponent 
	{
		static public const NAME:String = "AI";
		
		public var memory:Memory
		
		public var findPlayerState:FindPlayerState;
		public var waitState:WaitState;
		public var attackPlayerState:AttackPLayerState;
		
		public var navigation:NavigationPlugin
		
		
		
		private var _currentState:BaseAiState
		
		public function AI() 
		{
			super(NAME);
			
			memory = new Memory();
			
			findPlayerState = new FindPlayerState()
			findPlayerState.owner = this;
			
			waitState = new WaitState();
			waitState.owner = this;
			
			attackPlayerState = new AttackPLayerState();
			attackPlayerState.owner = this;
			
			
			
			registerInfluenceHandler(InfluenceName.KILLED, onKilled);
			registerInfluenceHandler(InfluenceName.GROWN, onGrown);
		}
		public function setState(value:BaseAiState):void
		{
			if (_currentState) {
				_currentState.onExit();
			}
			_currentState = value;
			if (_currentState) {
				_currentState.onEnter();
			}
		}
		public function init(cogitationTime:int,rememberTime:int):void
		{
			memory.init(cogitationTime,rememberTime);
		}
		
		public function update(dt:int):void
		{
			if (currentState) {
				currentState.update(dt);
			}
		}
		
		
		private function onGrown():void
		{
			memory.active = true;
			memory.invalidateState();
			setState(findPlayerState);
		}
		
		private function onKilled():void
		{
			setState(null);
			memory.active = false;
		}
		
		
		public function get currentState():BaseAiState {return _currentState;}
	}

}