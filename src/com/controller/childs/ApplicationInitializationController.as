package com.controller.childs 
{
	import com.game.entity.components.bounds.Bounds;
	import com.info.components.location.LocationInfo;
	import com.model.ApplicationState;
	import com.screens.initialization.InitialiaztionScreen;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class ApplicationInitializationController extends BaseChildController 
	{
		static private var _instance:ApplicationInitializationController = new ApplicationInitializationController();
		
		private var _modelInitializationRequires:Boolean
		private var _assetsLoadingRequires:Boolean;
		private var _infoLoadingRequires:Boolean;
		
		private var _assetsQueue:Vector.<String>
		private var _infoUrl:String
		private var _infoSource:XML
		
		private var _locationQueue:Vector.<LocationInfo>
		
		private var _stateScreen:InitialiaztionScreen
		
		public function ApplicationInitializationController() 
		{
			super();
			if (instance) {
				throw new Error("asas");
			}
			
		}
		
		override public function onEnter():void 
		{
			super.onEnter();
			if (!_stateScreen) {
				var screenWidth:Number = view.stage.stageWidth;
				var screenHeight:Number = view.stage.stageHeight;
				
				_stateScreen = new InitialiaztionScreen(screenWidth, screenHeight);
			}
			view.addChild(_stateScreen);
			_stateScreen.activate();
			
			
			configurateInitializationFlow();
			advanceInitialization();
		}
		override public function onExit():void 
		{
			super.onExit();
			_stateScreen.deactivate();
			view.removeChild(_stateScreen);
			
		}
		private function configurateInitializationFlow():void
		{
			_modelInitializationRequires = true;
			_assetsLoadingRequires = true;
			_infoLoadingRequires = true;
			
			_assetsQueue = new Vector.<String>();
			_assetsQueue.push("assets/assets.swf");
			
			_infoUrl = "assets/info.xml?="+new Date().time;
		}
		
		private function advanceInitialization():void
		{
			if (_assetsLoadingRequires) {
				_assetsLoadingRequires = false
				advanceAssetsLoading();
			}else if (_infoLoadingRequires) {
				_infoLoadingRequires = false;
				loadInfo();
			}else if (_modelInitializationRequires) {
				_modelInitializationRequires = false;
				initModel();
				advanceInitialization();
			}else {
				model.applicationState = ApplicationState.MAIN_MENU;
				//model.applicationState = ApplicationState.GAME_PREPARATION;
				//model.applicationState = ApplicationState.GAME;
			}
		}
		private function initModel():void
		{
			model.screenWidth = view.stage.stageWidth;
			model.screenHeight = view.stage.stageHeight;
			var homePageUrl:String = _infoSource["homepage"]["@url"];
			var controllText:String = _infoSource["instructions"][0]["controllText"][0][0];
			var aboutGameText:String = _infoSource["instructions"][0]["aboutGameText"][0][0];
			
			model.homePage = homePageUrl;
			model.controllText = controllText;
			model.aboutGameText = aboutGameText;
			
		}
		
		private function advanceAssetsLoading():void
		{
			if ((!_assetsQueue) || (!_assetsQueue.length)) {
				advanceInitialization();
				return;
			}
			var assetPath:String = _assetsQueue.shift();
			var request:URLRequest = new URLRequest(assetPath);
			
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			var loaderInfo:LoaderInfo = new Loader().contentLoaderInfo;
			loaderInfo.addEventListener(Event.COMPLETE, onAsetFileLoaded);
			
			loaderInfo.loader.load(request, context);
		}
		
		private function onAsetFileLoaded(e:Event):void 
		{
			advanceAssetsLoading();
		}
		private function loadInfo():void
		{
			var request:URLRequest = new URLRequest(_infoUrl);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onInfoLoaded)
			loader.load(request);
		}
		
		private function onInfoLoaded(e:Event):void 
		{
			_infoSource = new XML((e.currentTarget as URLLoader).data)
			info.init(_infoSource);
			
			generateLocationSourcesQueue();
			advanceLocationSourcesLoading();
		}
		
		private function generateLocationSourcesQueue():void
		{
			_locationQueue=new Vector.<LocationInfo>
			for each(var locationInfo:LocationInfo in info.locationsInfoList) {
				_locationQueue.push(locationInfo);
			}
		}
		private function advanceLocationSourcesLoading():void
		{
			if ((!_locationQueue) || (!_locationQueue.length)) {
				advanceInitialization();
				return;
			}
			var url:String = _locationQueue[0].source
			var request:URLRequest = new URLRequest(url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLocationSurceLoadComplete);
			loader.load(request);
		}
		
		private function onLocationSurceLoadComplete(e:Event):void 
		{
			var locationInfo:LocationInfo = _locationQueue.shift();
			var data:XML = new XML((e.currentTarget as URLLoader).data);
			locationInfo.parseDescription(data);
			advanceAssetsLoading();
		}
		
		static public function get instance():ApplicationInitializationController 
		{
			return _instance;
		}
		
	}

}