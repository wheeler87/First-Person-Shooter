package com.game.entity.components.damage 
{
	import com.game.entity.components.BaseComponent;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Damage extends BaseComponent 
	{
		static public const NAME:String = "Damage";
		
		public var damage:int
		public var ownerID:int
		
		public function Damage() 
		{
			super(NAME);
			
		}
		public function init(damage:int):void
		{
			
			this.damage = damage;
		}
		
		
	}

}