package com.game.entity.components.ai.memory 
{
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Note 
	{
		static public const TYPE_PLAYER:int = 1;
		static public const TYPE_ENEMY:int = 2;
		
		public var type:int
		public var targetID:int
		
		public var forgoten:Boolean = false;
		public var visibleTarget:Boolean;
		public var lastSeenPosition:Vector3D = new Vector3D();
		public var lastSeenTime:int = 0;
		
		
		public var rememberTime:int;
		
		
		
		public function Note() 
		{
			
		}
		
	}

}