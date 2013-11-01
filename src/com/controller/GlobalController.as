package com.controller 
{
	import com.controller.childs.ApplicationInitializationController;
	import com.controller.childs.BaseChildController;
	import com.controller.childs.GameController;
	import com.controller.childs.GamePreparationController;
	import com.controller.childs.InstructionsController;
	import com.controller.childs.MainMenuController;
	import com.model.ApplicationState;
	import com.model.Model;
	import com.model.ModelEvent;
	
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class GlobalController 
	{
		private var _childs:Vector.<BaseChildController>
		
		
		public function GlobalController() 
		{
			_childs = new Vector.<BaseChildController>();
		}
		public function init():void
		{
			model.addEventListener(ModelEvent.APPLICATION_STATE_ENTER, onApplicationStateEnter);
			model.addEventListener(ModelEvent.APPLICATION_STATE_EXIT, onApplicationStateExit);
			
			model.applicationState = ApplicationState.INITIALIZATION;
		}
		
		public function addChildController(value:BaseChildController):void
		{
			var index:int = (value)?_childs.indexOf(value):0;
			if (index >= 0) return;
			_childs.push(value);
			value.onEnter();
			
			
		}
		public function removeChildController(value:BaseChildController):void
		{
			var index:int = (value)?_childs.indexOf(value): -1;
			if (index < 0) return;
			_childs.splice(index, 1);
			value.onExit();
		}
		
		private function onApplicationStateEnter(e:ModelEvent):void
		{
			switch (model.applicationState) 
			{
				case ApplicationState.INITIALIZATION:
					addChildController(ApplicationInitializationController.instance);
				break;
				case ApplicationState.MAIN_MENU:
					addChildController(MainMenuController.instance);
				break;
				case ApplicationState.GAME_PREPARATION:
					addChildController(GamePreparationController.instance);
				break;
				case ApplicationState.GAME:
					addChildController(GameController.instance);
				break;
				case ApplicationState.INSTRUCTIONS:
					addChildController(InstructionsController.instance);
				break;
				
			}
		}
		private function onApplicationStateExit(e:ModelEvent):void
		{
			switch (model.applicationState) 
			{
				case ApplicationState.INITIALIZATION:
					removeChildController(ApplicationInitializationController.instance);
				break;
				case ApplicationState.MAIN_MENU:
					removeChildController(MainMenuController.instance);
				break;
				case ApplicationState.GAME_PREPARATION:
					removeChildController(GamePreparationController.instance);
				break;
				case ApplicationState.GAME:
					removeChildController(GameController.instance);
				break;
				case ApplicationState.INSTRUCTIONS:
					removeChildController(InstructionsController.instance);
				break;
				
			}
			
		}
		
		
		private function get model():Model { return Facade.instance.model }
		
	}

}