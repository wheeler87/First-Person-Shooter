package com.game.entity.components.life 
{
	import com.game.entity.components.BaseComponent;
	import com.game.entity.components.influence.Influence;
	import com.game.entity.components.influence.InfluenceName;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Life extends BaseComponent
	{
		static public const NAME:String = "Life";
		
		static public const LIFE_STATE_BORN:int = 1;
		static public const LIFE_STATE_REGULAR:int=2
		static public const LIFE_STATE_KILLED:int = 3;
		
		private var _lifeState:int
		
		private var _hitpoints:int=0;
		private var _hitpointsPool:int = 100;
		
		private var _currentLife:int = 0;
		private var _mortal:Boolean;
		private var _stateExistTime:int;
		
		private var _birthDuration:int;
		private var _deathDuration:int;
		
		
		public function Life() 
		{
			super(NAME);
		}
		public function init(hitpointsPool:int,deathDuration:int=100,birthDuration:int=100):void
		{
			_hitpointsPool = hitpointsPool;
			_hitpoints = 0;
			
			_currentLife = 0;
			
			_birthDuration = birthDuration;
			_deathDuration = deathDuration;
			_stateExistTime = 0;
		}
		
		public function get lifeState():int 
		{
			return _lifeState;
		}
		
		public function set lifeState(value:int):void 
		{
			_lifeState = value;
			switch (_lifeState) 
			{
				case LIFE_STATE_BORN:
					_hitpoints = _hitpointsPool;
					_currentLife++;
					_mortal = false;
					_stateExistTime = _birthDuration;
					(owner.getCompoentByName(Influence.NAME) as Influence).addInfluence(InfluenceName.BORN);
				break;
				case LIFE_STATE_REGULAR:
					_mortal = true;
					
					_stateExistTime = -1;
					(owner.getCompoentByName(Influence.NAME) as Influence).addInfluence(InfluenceName.GROWN);
				break;
				case LIFE_STATE_KILLED:
					_hitpoints = 0;
					_mortal = false;
					_stateExistTime = _deathDuration;
					(owner.getCompoentByName(Influence.NAME) as Influence).addInfluence(InfluenceName.KILLED);
				break;
				
			}
		}
		
		public function get hitpoints():int 
		{
			return _hitpoints;
		}
		
		public function get hitpointsPool():int 
		{
			return _hitpointsPool;
		}
		public function advanceLifeCycle(dt:int):void
		{
			if (_stateExistTime > 0) {
				_stateExistTime-= dt;
				if (_stateExistTime <= 0) {
					if (_lifeState == LIFE_STATE_BORN) {
						lifeState = LIFE_STATE_REGULAR;
					}else if (_lifeState == LIFE_STATE_KILLED) {
						lifeState = LIFE_STATE_BORN;
					}
				}
			}
		}
		public function reciveDamage(value:int):void
		{
			if (!_mortal) {
				return;
			}
			_hitpoints -= value;
			if (_hitpoints > 0) {
				var influence:Influence = owner.getCompoentByName(Influence.NAME) as Influence;
				influence.addInfluence(InfluenceName.DAMAGED);
			}else {
				lifeState = LIFE_STATE_KILLED;
				
			}
		}
	}

}