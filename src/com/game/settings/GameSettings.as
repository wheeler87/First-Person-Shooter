package com.game.settings 
{
	import com.info.components.enemy.EnemyInfo;
	import com.info.components.location.LocationInfo;
	import com.info.components.player.PlayerInfo;
	import flash.display.Loader;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class GameSettings 
	{
		public var screenWidth:Number;
		public var screenHeight:Number;
		
		public var updateRate:int = 50;
		public var updateStepDuration:int;
		
		public var locationInfo:LocationInfo;
		public var tilesRepository:Loader
		
		public var turnLeft:int = Keyboard.LEFT;
		public var turnRight:int = Keyboard.RIGHT;
		public var moveForward:int = Keyboard.UP;
		public var moveBackward:int = Keyboard.DOWN;
		public var fire:int = Keyboard.SPACE;
		public var slot1:int = 49;
		public var slot2:int = 50;
		
		public var playerTemplate:PlayerInfo;
		private var _enemiesTemplatesList:Vector.<EnemyInfo> = new Vector.<EnemyInfo>();
		
		public var debug:Boolean = false;
		
		public function GameSettings() 
		{
			
		}
		
		public function addEnemy(value:EnemyInfo):void
		{
			_enemiesTemplatesList.push(value);
		}
		
		public function configurate():void
		{
			updateStepDuration = 1000.0 / updateRate;
		}
		
		public function get enemiesTemplatesList():Vector.<EnemyInfo> {	return _enemiesTemplatesList;}
	}

}