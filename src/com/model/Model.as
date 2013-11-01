package com.model 
{
	import com.info.components.location.LocationInfo;
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	[Event(name="application_state_enter", type="com.model.ModelEvent")]
	[Event(name="application_state_exit", type="com.model.ModelEvent")]
	public class Model extends EventDispatcher 
	{
		public var screenWidth:Number = 0;
		public var screenHeight:Number = 0;
		
		public var homePage:String;
		public var controllText:String;
		public var aboutGameText:String;
		
		
		private var _currentLocationID:int = 1;
		private var _currentLocationInfo:LocationInfo;
		private var _currentLocationTilesRepository:Loader;
		
		private var _applicationState:int
		
		public function Model() 
		{
			super(null);
			
		}
		
		public function get applicationState():int {return _applicationState;}
		
		public function set applicationState(value:int):void 
		{
			dispatchEvent(new ModelEvent(ModelEvent.APPLICATION_STATE_EXIT));
			_applicationState = value;
			dispatchEvent(new ModelEvent(ModelEvent.APPLICATION_STATE_ENTER));
		}
		
		public function get currentLocationID():int 
		{
			return _currentLocationID;
		}
		
		public function set currentLocationID(value:int):void 
		{
			_currentLocationID = value;
		}
		
		public function get currentLocationInfo():LocationInfo 
		{
			return _currentLocationInfo;
		}
		
		public function set currentLocationInfo(value:LocationInfo):void 
		{
			_currentLocationInfo = value;
		}
		
		public function get currentLocationTilesRepository():Loader 
		{
			return _currentLocationTilesRepository;
		}
		
		public function set currentLocationTilesRepository(value:Loader):void 
		{
			_currentLocationTilesRepository = value;
		}
		
		
		
	}

}