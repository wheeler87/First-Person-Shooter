package com.game.plugins.synchronizer 
{
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class PriorityUpdate 
	{
		static public const LAST:int = -100;
		static public const FIRST:int = 100;
		
		static public const ADVANCE_CHARACTERS_LIFE_CYCLE:int = 30;
		static public const ADVANCE_RESPAWN_POLICY:int = 29;
		static public const ADVANCE_MOVEMENT:int = 28;
		
		static public const ADVANCE_PLAYER_CONTROLL:int = 27;
		static public const AI_UPDATE:int = 26;
		static public const ANIMATION_UPDATE:int = 25;
		static public const UPDATE_AMUNITION_STATUS:int = 24;
		static public const ADVANCE_SLUGS_LIFE_CYCLE:int = 23;
		static public const UPDATE_INIDATOR_STATUS:int = 22;
		
		
		static public const RESLOVE_COLLISIONS:int=-30
		
		
		static public const HANDLE_INFLUENCES:int = LAST - 1;
		
		public function PriorityUpdate() 
		{
			
		}
		
	}

}