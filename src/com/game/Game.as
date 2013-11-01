package com.game 
{
	import com.components.ApplicationSprite;
	import com.game.assets.GameAssetManager;
	import com.game.camera.DebugCamera;
	import com.game.camera.GameCamera;
	import com.game.entity.BaseEntity;
	import com.game.entity.characer.Enemy;
	import com.game.entity.characer.Player
	import com.game.entity.slug.Slug;
	import com.game.entity.wall.Wall;
	import com.game.plugins.ai.AiPlugin;
	import com.game.plugins.amunition.AmunitionPlugin;
	import com.game.plugins.animation.AnimationPlugin;
	import com.game.plugins.BasePlugin;
	import com.game.plugins.cameraControll.CameraControllPlugin;
	import com.game.plugins.influence.InfluencePlugin;
	import com.game.plugins.lifeCycle.LifeCyclePlugin;
	import com.game.plugins.navigation.NavigationPlugin;
	import com.game.plugins.physics.PhysicsPlugin;
	import com.game.plugins.playerControll.PlayerControlPlugin;
	import com.game.plugins.synchronizer.Synchronizer;
	import com.game.progress.GameProgress;
	import com.game.settings.GameSettings;
	import com.info.components.enemy.EnemyInfo;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Game extends ApplicationSprite 
	{
		private var _settings:GameSettings
		private var _progress:GameProgress;
		
		private  var _assetManager:GameAssetManager;
		
		private var _camera:GameCamera
		
		private var _synchronizer:Synchronizer
		private var _playerControl:PlayerControlPlugin
		private var _cameraControll:CameraControllPlugin
		private var _navigation:NavigationPlugin
		private var _lifeCycle:LifeCyclePlugin
		private var _physics:PhysicsPlugin
		private var _ai:AiPlugin
		private var _aimation:AnimationPlugin
		private var _amunition:AmunitionPlugin
		
		private var _influencePlugin:InfluencePlugin
		
		private var _plugins:Vector.<BasePlugin>
		
		private var _walls:Vector.<Wall>;
		private var _player:Player;
		private var _enemies:Vector.<Enemy>;
		private var _slugs:Vector.<Slug>
		
		private var _entitiesDict:Dictionary
		
		public function Game() 
		{
			super();
			
		}
		public function destroy():void
		{
			_assetManager.destroy();
			System.gc();
		}
		public function init(settings:GameSettings):void
		{
			
			
			
			_plugins = new Vector.<BasePlugin>;
			
			_settings = settings;
			_progress = new GameProgress();
			
			_assetManager = new GameAssetManager();
			_assetManager.setTileDefinitionsRepository(_settings.tilesRepository.contentLoaderInfo.applicationDomain);
			
			
			
			_synchronizer = new Synchronizer(this);
			addPlugin(_synchronizer);
			
			_camera = new GameCamera(settings.screenWidth, settings.screenHeight,this);
			addChild(_camera);
			
			_slugs = new Vector.<Slug>();
			
			_walls = new Vector.<Wall>();
			
			_entitiesDict = new Dictionary();
			var currentWall:Wall;
			for (var i:uint = 0; i < settings.locationInfo.wallInfoList.length; i++ ) {
				currentWall = new Wall();
				currentWall.game = this;
				currentWall.init(settings.locationInfo.wallInfoList[i]);
				_walls.push(currentWall);
				_entitiesDict[currentWall.id] = currentWall;
			}
			_player = new Player();
			_player.game = this;
			_player.init(settings.playerTemplate);
			
			_entitiesDict[_player.id] = _player;
			
			
			var currentEnemy:Enemy;
			var enemyInfo:EnemyInfo;
			_enemies = new Vector.<Enemy>();
			for (i = 0; i < settings.enemiesTemplatesList.length; i++ ) {
				enemyInfo = settings.enemiesTemplatesList[i];
				
				currentEnemy = new Enemy();
				currentEnemy.game = this;
				currentEnemy.init(enemyInfo);
				
				_enemies.push(currentEnemy);
				_entitiesDict[currentEnemy.id] = currentEnemy;
			}
			
			if (settings.debug) {
				var cameraW:Number = settings.screenWidth * 0.25;
				var cameraH:Number = settings.screenHeight * 0.25;
				
				var debugCamera:DebugCamera = new DebugCamera(cameraW, cameraH,this);
				addChild(debugCamera);
				debugCamera.x = (settings.screenWidth - cameraW);
				debugCamera.y = 0;
				//debugCamera.x = 100;
				//debugCamera.y = 100;
				
			}
			
			
			_playerControl = new PlayerControlPlugin(this);
			addPlugin(_playerControl);
			
			_cameraControll=new CameraControllPlugin(this)
			addPlugin(_cameraControll);
			
			_navigation = new NavigationPlugin(this);
			addPlugin(_navigation);
			
			_lifeCycle = new LifeCyclePlugin(this);
			addPlugin(_lifeCycle);
			
			_physics = new PhysicsPlugin(this);
			addPlugin(_physics);
			
			_ai = new AiPlugin(this);
			addPlugin(_ai);
			_aimation = new AnimationPlugin(this);
			addPlugin(_aimation);
			
			_amunition = new AmunitionPlugin(this);
			addPlugin(_amunition);
			
			_influencePlugin = new InfluencePlugin(this);
			addPlugin(_influencePlugin);
			
			_synchronizer.runInitializationTasks();
			
		}
		public function start():void
		{
			if (progress.running) return;
			progress.running = true;
			progress.lastFrameTime = getTimer();
			progress.currentUpdateStep = -1;
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		public function stop():void
		{
			if (!progress.running) return;
			progress.running = false;
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		public function addPlugin(value:BasePlugin):void
		{
			var index:int = (value)?_plugins.indexOf(value):0;
			if (index >= 0) return;
			_plugins.push(value);
			value.onEnter();
		}
		public function removePlugin(value:BasePlugin):void
		{
			var index:int = _plugins.indexOf(value);
			if (index < 0) return;
			_plugins.splice(index, 1);
			value.onExit();
		}
		public function getEntityByID(id:int):BaseEntity
		{
			var result:BaseEntity = _entitiesDict[id];
			return result;
		}
		
		private function enterFrameHandler(e:Event):void
		{
			var stepsAmount:int = int((getTimer() - progress.lastFrameTime) / settings.updateStepDuration);
			for (var i:uint = 0; i < stepsAmount; i++ ) {
				progress.currentUpdateStep++;
				progress.lastFrameTime += settings.updateStepDuration;
				_synchronizer.runUpdateTasks();
			}
			_synchronizer.runEnterFrameTasks();
		}
		public function addSlug(value:Slug):void
		{
			_slugs.push(value);
			value.game = this;
			_entitiesDict[value.id] = value;
		}
		public function removeSlug(value:Slug):void
		{
			var index:int = _slugs.indexOf(value);
			if (index >= 0) {
				_slugs.splice(index, 1);
			}
			_entitiesDict[value.id] = null;
			delete _entitiesDict[value.id];
		}
		
		
		public function get settings():GameSettings {return _settings;}
		public function get progress():GameProgress {return _progress;}
		public function get camera():GameCamera{	return _camera;	}
		public function get synchronizer():Synchronizer{return _synchronizer;}
		
		public function get navigation():NavigationPlugin {return _navigation;}
		
		public function get walls():Vector.<Wall> {	return _walls;}
		public function get player():Player {return _player;}
		public function get enemies():Vector.<Enemy> {return _enemies;}
		
		public function get assetManager():GameAssetManager	{return _assetManager;}
		
		public function get slugs():Vector.<Slug> {return _slugs;}
		
		
		
		
		
	}

}