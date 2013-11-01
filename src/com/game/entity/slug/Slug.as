package com.game.entity.slug 
{
	import com.game.entity.BaseEntity;
	import com.game.entity.components.bounds.Bounds;
	import com.game.entity.components.damage.Damage;
	import com.game.entity.components.movement.Movement;
	import com.game.entity.components.position.Position;
	import com.info.components.slug.SlugInfo;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Slug extends BaseEntity 
	{
		public var position:Position;
		public var movement:Movement;
		public var bounds:Bounds;
		public var damage:Damage;
		
		private var _info:SlugInfo
		
		public function Slug() 
		{
			super();
			
			position = new Position();
			movement = new Movement();
			bounds = new Bounds();
			damage = new Damage();
			
			addComponent(position);
			addComponent(movement);
			addComponent(bounds);
			addComponent(damage);
		}
		
		public function init(info:SlugInfo):void
		{
			_info = info;
			movement.init(info.velocity, Math.PI);
			bounds.init(info.boundRadius, 20);
			damage.init(info.damage);
		}
		
		public function get info():SlugInfo 
		{
			return _info;
		}
		
	}

}