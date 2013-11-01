package com.game.entity.components.bounds 
{
	import com.game.entity.components.BaseComponent;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Bounds  extends BaseComponent
	{
		static public const NAME:String = "Bounds";
		public var radius:Number = 10;
		public var height:int;
		
		public var collidedWithWall:Boolean;
		public var collidedWallID:int;
		
		public var collidedWithEntity:Boolean;
		public var collidedEntityID:int;
		
		public function Bounds() 
		{
			super(NAME)
		}
		public function init(boundRadius:int,height:int):void
		{
			radius = boundRadius;
			this.height = height;
		}
		public function resetCollisionInfo():void
		{
			collidedWithWall = false;
			collidedWallID = -1;
			collidedWithEntity = false;
			collidedEntityID = -1;
		}
	}

}