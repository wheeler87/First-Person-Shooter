package com.info.components.animation 
{
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class AnimationTriggerInfo 
	{
		static public const NAME_WALKING:String = "walking";
		static public const NAME_FIRE:String = "fire";
		static public const NAME_HIT:String = "hit";
		static public const RELOAD_START:String = "reload_start";
		static public const DEATH:String = "death";
		
		public var name:String;
		public var priority:int
		public var aimations:Vector.<int>
		
		public function AnimationTriggerInfo() 
		{
			
		}
		static public function sorter(a:AnimationTriggerInfo, b:AnimationTriggerInfo):int
		{
			if (a.priority < b.priority) return -1;
			if (a.priority > b.priority) return 1;
			return 0;
		}
		
	}

}