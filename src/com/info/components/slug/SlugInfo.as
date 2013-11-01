package com.info.components.slug 
{
	import com.info.components.IInfoComponent;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class SlugInfo implements IInfoComponent 
	{
		private var _id:int;
		public var type:String;
		public var damage:int;
		
		public var boundRadius:int;
		public var velocity:int
		
		public function SlugInfo() 
		{
			
		}
		
		public function init(value:XML):void
		{
			_id = parseInt(value["@id"]);
			type = (value["@type"]);
			damage = parseInt(value["@damage"]);
			
			boundRadius = parseInt(value["@boundRadius"]);
			velocity = parseInt(value["@velocity"]);
			
		}
		
		/* INTERFACE com.info.components.IInfoComponent */
		
		public function get id():int 
		{
			return _id;
		}
		
	}

}