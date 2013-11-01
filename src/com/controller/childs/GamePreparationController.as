package com.controller.childs 
{
	import com.info.components.location.LocationInfo;
	import com.model.ApplicationState;
	import com.screens.preparation.PreparationScreen;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class GamePreparationController extends BaseChildController 
	{
		static private var _instance:GamePreparationController = new GamePreparationController();
		
		private var _locationInfoSpecificationRequires:Boolean;
		private var _tilesAssetsLoadingRequires:Boolean;
		
		
		private var _stateScreen:PreparationScreen
		
		public function GamePreparationController() 
		{
			super();
			if (instance) {
				throw new Error("SNGLTN");
			}
		}
		
		override public function onEnter():void 
		{
			super.onEnter();
			if (!_stateScreen) {
				var screenWidth:Number = model.screenWidth;
				var screenHeight:Number = model.screenHeight;
				_stateScreen = new PreparationScreen(screenWidth, screenHeight);
			}
			view.addChild(_stateScreen);
			_stateScreen.activate();
			
			resetStateBehaviour();
			advanceStateBehaviour();
		}
		override public function onExit():void 
		{
			super.onExit();
			_stateScreen.deactivate();
			view.removeChild(_stateScreen);
		}
		private function resetStateBehaviour():void
		{
			_locationInfoSpecificationRequires = true;
			_tilesAssetsLoadingRequires = true;
		}
		private function advanceStateBehaviour():void
		{
			if (_locationInfoSpecificationRequires) {
				_locationInfoSpecificationRequires = false;
				specifyLocationInfo();
			}else if (_tilesAssetsLoadingRequires) {
				_tilesAssetsLoadingRequires = false;
				startTilesAssetsLoading();
			}else {
				model.applicationState = ApplicationState.GAME;
			}
		}
		private function specifyLocationInfo():void
		{
			var locationId:int = model.currentLocationID;
			var locationInfo:LocationInfo = info.getInfoComponentByID(locationId) as LocationInfo;
			model.currentLocationInfo = locationInfo;
			
			advanceStateBehaviour();
		}
		private function startTilesAssetsLoading():void
		{
			var url:String = model.currentLocationInfo.tilesSource;
			var request:URLRequest = new URLRequest(url);
			var loaderInfo:LoaderInfo = new Loader().contentLoaderInfo;
			loaderInfo.addEventListener(Event.COMPLETE, onTilesAssetsLoaded);
			loaderInfo.loader.load(request);
		}
		
		private function onTilesAssetsLoaded(e:Event):void 
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onTilesAssetsLoaded);
			model.currentLocationTilesRepository = loaderInfo.loader;
			
			advanceStateBehaviour();
		}
		
		
		static public function get instance():GamePreparationController 
		{
			return _instance;
		}
		
	}

}