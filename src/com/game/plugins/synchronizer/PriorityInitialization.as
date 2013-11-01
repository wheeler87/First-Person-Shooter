package com.game.plugins.synchronizer 
{
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class PriorityInitialization 
	{
		static public const LAST:int = -100;
		static public const FIRST:int = 100;
		
		static public const GAME_CAMERA_INITIALIZATION:int = 10;
		static public const PLAYER_CONTROL_INITIALIZATION:int = 9;
		static public const LIFE_CYCLE_INITIALIZATION:int = 8;
		
		static public const INFLUENCE_INITIALIZATION:int = 7;
		static public const NAVIGATION_INITIALIZATION:int = 6;
		static public const PHYSICS_INITIALIZATION:int = 5;
		
		static public const CAMERA_CONTROLL_INITIALIZATION:int = 4;
		static public const AMUNITION_INITIALIZATION:int = 3;
		static public const ANIMATION_INITIALIZATION:int = 2;
		static public const AI_INITIALIZATION:int = 1;
		
		public function PriorityInitialization() 
		{
			
		}
		
	}

}