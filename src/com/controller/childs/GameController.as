package com.controller.childs 
{
	import com.game.Game;
	import com.game.settings.GameSettings;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class GameController extends BaseChildController 
	{
		static private var _instance:GameController = new GameController();
		
		private var _game:Game
		
		public function GameController() 
		{
			super();
			
			if (instance) {
				throw new Error("asas");
			}
			
		}
		
		static public function get instance():GameController 
		{
			return _instance;
		}
		override public function onEnter():void 
		{
			super.onEnter();
			
			var settings:GameSettings = new GameSettings();
			settings.screenWidth = model.screenWidth;
			settings.screenHeight = model.screenHeight;
			settings.locationInfo = model.currentLocationInfo;
			settings.tilesRepository = model.currentLocationTilesRepository;
			settings.playerTemplate = info.playerInfoList[0];
			settings.addEnemy(info.enemyInfoList[0]);
			settings.addEnemy(info.enemyInfoList[0]);
			settings.addEnemy(info.enemyInfoList[0]);
			
			settings.configurate();
			
			_game = new Game();
			view.addChild(_game);
			_game.init(settings);
			_game.start();
			
		}
		override public function onExit():void 
		{
			super.onExit();
			
			_game.stop();
			_game.destroy();
			view.removeChild(_game);
			_game = null;
			
		}
		
		
	}

}