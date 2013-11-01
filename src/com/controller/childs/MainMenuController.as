package com.controller.childs 
{
	import com.model.ApplicationState;
	import com.screens.mainMenu.MainMenuScreen;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class MainMenuController extends BaseChildController 
	{
		static private var _instance:MainMenuController = new MainMenuController();
		
		private var _stateScreen:MainMenuScreen
		
		public function MainMenuController() 
		{
			super();
			if (instance) {
				throw new Error("as");
			}
			
		}
		override public function onEnter():void 
		{
			if (!_stateScreen) {
				var screenWidth:Number = model.screenWidth;
				var screenHeight:Number = model.screenHeight;
				_stateScreen = new MainMenuScreen(screenWidth, screenHeight);
			}
			view.addChild(_stateScreen);
			_stateScreen.activate();
			_stateScreen.addEventListener(MainMenuScreen.PLAY_SELECTED, onPlaySelected);
			_stateScreen.addEventListener(MainMenuScreen.INSTRUCTIONS_SELECTED, onInstructionsSelected);
			_stateScreen.addEventListener(MainMenuScreen.HOME_PAGE_SELECTED, onHomePageSelected);
		}
		
		
		override public function onExit():void 
		{
			_stateScreen.deactivate();
			view.removeChild(_stateScreen);
			_stateScreen.removeEventListener(MainMenuScreen.PLAY_SELECTED, onPlaySelected);
			_stateScreen.removeEventListener(MainMenuScreen.INSTRUCTIONS_SELECTED, onInstructionsSelected);
			_stateScreen.removeEventListener(MainMenuScreen.HOME_PAGE_SELECTED, onHomePageSelected);
		}
		
		private function onPlaySelected(e:Event):void 
		{
			view.stage.focus = null;
			model.applicationState = ApplicationState.GAME_PREPARATION;
		}
		
		private function onInstructionsSelected(e:Event):void 
		{
			model.applicationState = ApplicationState.INSTRUCTIONS;
		}
		
		private function onHomePageSelected(e:Event):void 
		{
			var request:URLRequest = new URLRequest(model.homePage);
			navigateToURL(request, "_blank");
		}
		
		
		static public function get instance():MainMenuController {	return _instance;}
		
	}

}