package com.model 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	[Event(name="application_state_enter", type="com.model.ModelEvent")]
	[Event(name="application_state_exit", type="com.model.ModelEvent")]
	public class ModelEvent extends Event 
	{
		public static const APPLICATION_STATE_ENTER:String="application_state_enter"
		public static const APPLICATION_STATE_EXIT:String="application_state_exit"
		
		private var _data:Object
		
		public function ModelEvent(type:String,data:Object=null):void
		{
			_data = data;
			super(type, false, false);
			
		}
		
		public function get data():Object 
		{
			return _data;
		}
		override public function clone():Event 
		{
			return new ModelEvent(type,data);
		}
		
		
	}

}