package com.controller.childs 
{
	import com.model.ApplicationState;
	import com.screens.istructions.InstructionsScreen;
	import flash.events.Event;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class InstructionsController extends BaseChildController 
	{
		static private var _instance:InstructionsController = new InstructionsController();
		
		private var _stateScreen:InstructionsScreen
		
		public function InstructionsController() 
		{
			super();
			if (instance) {
				throw new Error("aasa");
			}
			
		}
		
		override public function onEnter():void 
		{
			if (!_stateScreen) {
				var screenWidth:Number = model.screenWidth;
				var screenHeight:Number = model.screenHeight;
				
				_stateScreen = new InstructionsScreen(screenWidth, screenHeight);
			}
			view.addChild(_stateScreen);
			_stateScreen.activate();
			_stateScreen.addEventListener(InstructionsScreen.BACK_REQUEST, onBackRequest);
			_stateScreen.addEventListener(InstructionsScreen.PLAY_REQUEST, onPlayRequest);
		}
		
		override public function onExit():void 
		{
			_stateScreen.deactivate();
			view.removeChild(_stateScreen);
			_stateScreen.removeEventListener(InstructionsScreen.BACK_REQUEST, onBackRequest);
			_stateScreen.removeEventListener(InstructionsScreen.PLAY_REQUEST, onPlayRequest);
			
		}
		
		private function onPlayRequest(e:Event):void 
		{
			model.applicationState = ApplicationState.GAME_PREPARATION;
		}
		
		private function onBackRequest(e:Event):void 
		{
			model.applicationState = ApplicationState.MAIN_MENU;
		}
		
		
		
		static public function get instance():InstructionsController 
		{
			return _instance;
		}
		
	}

}