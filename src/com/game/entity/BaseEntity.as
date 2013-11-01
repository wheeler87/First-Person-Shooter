package com.game.entity 
{
	import com.game.entity.components.BaseComponent;
	import com.game.Game;
	import com.info.components.IInfoComponent;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class BaseEntity 
	{
		static private var nextValidID:int = 1;
		
		public var id:int;
		public var game:Game;
		
		public var components:Vector.<BaseComponent>;
		private var _componentsDict:Dictionary
		
		public function BaseEntity():void
		{
			
			id = nextValidID;
			nextValidID++;
			
			components = new Vector.<BaseComponent>();
			_componentsDict = new Dictionary();
		}
		public function addComponent(value:BaseComponent):void
		{
			value.owner = this;
			components.push(value);
			_componentsDict[value.name] = value;
		}
		public function getCompoentByName(componentName:String):BaseComponent
		{
			var result:BaseComponent = _componentsDict[componentName];
			return result;
		}
		
	}

}