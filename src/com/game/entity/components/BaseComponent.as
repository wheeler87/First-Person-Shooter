package com.game.entity.components 
{
	import com.game.entity.BaseEntity;
	import com.game.entity.characer.Character;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class BaseComponent 
	{
		
		
		private var _name:String;
		private var _owner:BaseEntity
		private var _handlersDict:Dictionary = new Dictionary();
		
		public function BaseComponent(name:String) 
		{
			_name = name;
		}
		
		public function get owner():BaseEntity {	return _owner;}
		
		public function set owner(value:BaseEntity):void 
		{
			_owner = value;
		}
		public function hadleInfluence(value:String):void
		{
			var handler:Function = _handlersDict[value];
			if (handler != null) {
				handler();
			}
		}
		protected function registerInfluenceHandler(influenceName:String, handler:Function):void
		{
			_handlersDict[influenceName] = handler;
		}
		public function get name():String
		{
			return _name;
		}
		
	}

}