package com.game.entity.characer 
{
	import com.game.entity.BaseEntity;
	import com.game.entity.components.amunition.Amunition;
	import com.game.entity.components.bounds.Bounds;
	import com.game.entity.components.influence.Influence;
	import com.game.entity.components.life.Life;
	import com.game.entity.components.movement.Movement;
	import com.game.entity.components.position.Position;
	import com.info.components.IInfoComponent;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Character extends BaseEntity 
	{
		
		private var _info:IInfoComponent;
		
		public var life:Life
		public var bounds:Bounds;
		public var position:Position;
		public var movement:Movement;
		public var influence:Influence;
		public var amunition:Amunition;
		
		
		
		public function Character() 
		{
			super();
			
			life = new Life();
			bounds = new Bounds();
			position = new Position();
			movement = new Movement();
			influence = new Influence();
			amunition = new Amunition();
			
			
			addComponent(life);
			addComponent(bounds);
			addComponent(position);
			addComponent(movement);
			addComponent(influence);
			addComponent(amunition)
		}
		
		public function init(info:IInfoComponent):void
		{
			_info = info;
			
			
		}
		
		
		
		
		public function get info():IInfoComponent {	return _info;}
		
		
		
	}

}