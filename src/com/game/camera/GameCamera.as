package com.game.camera 
{
	import adobe.utils.CustomActions;
	import com.game.entity.components.animation.Animation;
	import com.game.entity.components.position.Position;
	import com.game.entity.characer.Enemy;
	import com.game.entity.wall.Wall;
	import com.game.entity.wall.WallTile;
	import com.game.Game;
	import com.game.plugins.synchronizer.PriorityEnterFrame;
	import com.game.plugins.synchronizer.PriorityInitialization;
	import com.game.plugins.synchronizer.PriorityUpdate;
	import com.geom.Matrix3D;
	import com.geom.Point2D;
	import com.geom.Point3D;
	import com.geom.Projection;
	import com.info.components.location.LocationInfo;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class GameCamera extends Sprite 
	{
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		private var _maxDepth:Number;
		private var _helperM:Matrix3D
		private var _helperV:Vector3D
		
		
		private var _owner:Game
		
		private var _worldPosition:Vector3D
		private var _heading:Vector3D
		private var _angleY:Number;
		//private var _angleX:Number;
		
		
		
		private var _screenCanvas:Bitmap;
		private var _screenPixels:BitmapData;
		private var _pixelsCenter:Point2D
		private var _tiles:Vector.<WallTile>;
		
		
		public function GameCamera(width:Number,height:Number,owner:Game):void
		{
			super();
			
			_screenWidth = width;
			_screenHeight = height;
			_owner = owner;
			
			_helperM = new Matrix3D();
			_helperV = new Vector3D();
			
			
			
			
			_screenPixels = new BitmapData(_screenWidth, _screenHeight, true, 0);
			_screenCanvas = new Bitmap(_screenPixels);
			//_screenCanvas.scaleX = _screenCanvas.scaleY = 0.5;
			addChild(_screenCanvas);
			
			_pixelsCenter = new Point2D();
			_pixelsCenter.x = _screenWidth * 0.5;
			_pixelsCenter.y = _screenHeight * 0.5;
			
			//_screenCanvas.alpha = 0.8;
			_worldPosition=new Vector3D();
			_heading = new Vector3D();
			_owner.synchronizer.addInitializationTask(initialize,PriorityInitialization.GAME_CAMERA_INITIALIZATION);
		}
		
		public function render():void
		{
			recalculateEnemiesCameraCoordinates();
			projectEnemiesOnScreen();
			_owner.enemies.sort(enemiesCompareFunc);
			var currentEnemyIndex:int = 0;
			var currentEnemy:Enemy = (_owner.enemies.length > currentEnemyIndex)?_owner.enemies[currentEnemyIndex]:null;
			var currentEnemyDepth:Number = currentEnemy?currentEnemy.position.depth:int.MIN_VALUE;
			
			var currentWallTile:WallTile
			var position:Position;
			var animation:Animation
			
			
			_screenPixels.lock();
			_screenPixels.fillRect(_screenPixels.rect, 0);
			
			for (var i:uint = 0; i < _tiles.length; i++ ) {
				currentWallTile = _tiles[i];
				if (currentWallTile.depth > currentEnemyDepth) {
					currentWallTile.render(_screenPixels,_pixelsCenter);
				}else {
					i--;
					
					position = currentEnemy.position;
					animation = currentEnemy.animation;
					
					var visibleEnemy:Boolean = (position.depth > ( -Projection.focalLength));
					var scale:Number = Projection.focalLength / (Projection.focalLength + position.depth);
					
					animation.recalculateTransformation(position.screenCoordinates.x, position.screenCoordinates.y-animation.skin.height*0.5*animation.zoomCurrent,scale,visibleEnemy);
					animation.render(_screenPixels);
					
					
					
					currentEnemyIndex++;
					currentEnemy = (_owner.enemies.length > currentEnemyIndex)?_owner.enemies[currentEnemyIndex]:null;
					currentEnemyDepth = (currentEnemy)?currentEnemy.position.depth:int.MIN_VALUE;
					
				}
				
			}
			animation = _owner.player.animation;
			//animation.recalculateTransformation(_pixelsCenter.x, _pixelsCenter.y*2, 0, true);
			animation.recalculateTransformation(_pixelsCenter.x, _pixelsCenter.y*2, 1, true);
			animation.render(_screenPixels);
			
			_owner.player.indicator.render(_screenPixels);
			_screenPixels.unlock();
			
		}
		private function recalculateEnemiesCameraCoordinates():void
		{
			_helperM.identity();
			_helperM.translate( -_worldPosition.x, -_worldPosition.y, - _worldPosition.z);
			_helperM.rotateY( -_angleY);
			
			var position:Position
			for each(var enemy:Enemy in _owner.enemies) {
				position = enemy.position;
				position.resetCameraCoordinates();
				position.cameraCoordinates.y=_owner.settings.locationInfo.locationHeight
				_helperM.transformVector(position.cameraCoordinates);
				position.depth = position.cameraCoordinates.z;
				position.cameraAngleY = position.worldAngleY - _angleY;
				
			}
		}
		private function projectEnemiesOnScreen():void
		{
			var position:Position
			for each (var enemy:Enemy in _owner.enemies) {
				position = enemy.position;
				Projection.project(position.cameraCoordinates, Projection.focalLength, position.screenCoordinates);
				position.screenCoordinates.x += _pixelsCenter.x;
				position.screenCoordinates.y += _pixelsCenter.y;
			}
		}
		
		public function setPosition(worldX:Number, worldY:Number, worldZ:Number, angleY:Number):void
		{
			_worldPosition.x = worldX;
			_worldPosition.y = worldY;
			_worldPosition.z = worldZ;
			
			_heading.x = 0;
			_heading.y = 1;
			_heading.z = 0;
			
			_helperM.identity();
			_helperM.rotateY(angleY);
			
			_helperM.transformVector(_heading);
			
			_angleY = angleY;
			
			recalculateCameraPointsForWalls();
			recalculateScreenPointsForWals();
		}
		private function recalculateCameraPointsForWalls():void
		{
			_helperM.identity();
			_helperM.translate( -_worldPosition.x, -_worldPosition.y, -_worldPosition.z);
			_helperM.rotateY( -_angleY);
			//_helperM.rotateX(-Math.PI * 10 / 180.0);
			
			var currentWall:Wall
			var currentWorldPoint:Point3D;
			var currentCameraPoint:Point3D;
			for each(currentWall in _owner.walls) {
				for (var i:uint = 0; i < currentWall.worldSpacePoints.length; i++ ) {
					
					currentWorldPoint = currentWall.worldSpacePoints[i];
					currentCameraPoint = currentWall.cameraSpacePoints[i];
					currentCameraPoint.x = currentWorldPoint.x;
					currentCameraPoint.y = currentWorldPoint.y;
					currentCameraPoint.z = currentWorldPoint.z;
					_helperM.transform(currentCameraPoint);
					
				}
			}
		}
		private function recalculateScreenPointsForWals():void
		{
			var currentWall:Wall;
			var currentCameraPoints:Vector.<Point3D>;
			var currentScreenPoints:Vector.<Point2D>;
			
			for each(currentWall in _owner.walls) {
				currentCameraPoints = currentWall.cameraSpacePoints;
				currentScreenPoints = currentWall.screenPoints;
				
				Projection.projectGroup(currentCameraPoints, Projection.focalLength, currentScreenPoints);
				currentWall.onScreenPointsUpdate(screenWidth,screenHeight);
			}
			_tiles.sort(WallTile.sorter);
		}
		
		
		
		private function initialize():void
		{
			
			
			_owner.synchronizer.addEnterFrameTask(render, PriorityEnterFrame.GAME_CAMERA_RENDER);
			
			var locationInfo:LocationInfo = _owner.settings.locationInfo;
			
			var initialX:int = locationInfo.locationWidth * 0.25;
			var initialY:int = locationInfo.locationHeight * 0.5;
			var initialZ:int = locationInfo.locationDepth * 0.25;
			
			
			_maxDepth = Math.max(locationInfo.locationDepth, locationInfo.locationHeight, locationInfo.locationWidth);
			
			
			
			var initialRotation:Number = 0;
			
			_tiles = new Vector.<WallTile>();
			for (var i:uint = 0; i < _owner.walls.length; i++ ) {
				_tiles = _tiles.concat(_owner.walls[i].wallTiles);
			}
			
			setPosition(initialX, initialY, initialZ, initialRotation);
			
		}
		
		
		
		public function get screenWidth():Number {return _screenWidth;}
		public function get screenHeight():Number {	return _screenHeight;}
		
		public function get worldPosition():Vector3D 
		{
			return _worldPosition;
		}
		private function enemiesCompareFunc(a:Enemy, b:Enemy):int
		{
			var aPosition:Position = a.position;
			var bPosition:Position = b.position;
			if (aPosition.depth > bPosition.depth) return -1;
			if (aPosition.depth < bPosition.depth) return 1;
			return 0;
			
		}
		
	}

}