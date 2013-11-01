package com.game.camera 
{
	import com.components.ApplicationSprite;
	import com.game.entity.characer.Character;
	import com.game.entity.characer.Enemy;
	import com.game.entity.slug.Slug;
	import com.game.entity.wall.Wall;
	import com.game.Game;
	import com.game.plugins.synchronizer.PriorityEnterFrame;
	import com.game.plugins.synchronizer.PriorityInitialization;
	import com.geom.Matrix3D;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class DebugCamera extends ApplicationSprite 
	{
		private var _width:Number;
		private var _height:Number;
		
		private var _owner:Game
		
		private var _worldToCameraM:Matrix3D
		
		private var _helperM1:Matrix3D = new Matrix3D();
		private var _helperV1:Vector3D = new Vector3D();
		private var _helperV2:Vector3D = new Vector3D();
		private var _helperV3:Vector3D = new Vector3D();
		private var _helperV4:Vector3D = new Vector3D();
		
		private var _background:Shape
		
		private var _wallsLayer:Shape;
		private var _charactersLayer:Shape
		
		public function DebugCamera(width:Number,height:Number,owner:Game):void
		{
			super();
			_width = width;
			_height = height;
			_owner = owner;
			
			addBackground();
			addLayers();
			
			owner.synchronizer.addInitializationTask(initialize, PriorityInitialization.LAST);
			owner.synchronizer.addEnterFrameTask(render, PriorityEnterFrame.LAST);
		}
		private function addBackground():void
		{
			_background = new Shape();
			addChild(_background);
			var g:Graphics = _background.graphics;
			g.beginFill(0xccffcc);
			g.drawRect(0, 0, _width, _height);
		}
		private function addLayers():void
		{
			_wallsLayer = new Shape();
			addChild(_wallsLayer);
			
			_charactersLayer = new Shape();
			addChild(_charactersLayer);
		}
		
		
		private function initialize():void
		{
			configurateRenreringParametrs();
			renderWalls();
		}
		
		private function render():void
		{
			renderCharacters();
			renderSlugs();
		}
		private function configurateRenreringParametrs():void
		{
			var worldScaleX:Number = _width / _owner.settings.locationInfo.locationWidth;
			var worldScaleZ:Number = _height / _owner.settings.locationInfo.locationDepth;
			
			
			_worldToCameraM = new Matrix3D();
			_worldToCameraM.a11 = worldScaleX;
			_worldToCameraM.a33 = worldScaleZ;
			_worldToCameraM.a34 = -_owner.settings.locationInfo.locationDepth*worldScaleZ;
			
			_worldToCameraM.rotateX(Math.PI * 0.5);
			
		}
		
		
		private function renderWalls():void
		{
			var g:Graphics = _wallsLayer.graphics;
			g.clear();
			g.lineStyle(2,0x9999FF);
			
			
			for each(var wall:Wall in _owner.walls) {
				if (wall.info.angleX != 0) {
					continue
				}
				_helperM1.identity();
				_helperM1.rotateY(wall.info.angleY);
				
				_helperV1.x = wall.info.originX;
				_helperV1.y = wall.info.originY;
				_helperV1.z = wall.info.originZ;
				
				_helperV2.x = wall.info.originX+wall.info.columns*wall.info.tileSize;
				_helperV2.y = wall.info.originY;
				_helperV2.z = wall.info.originZ;
				
				_helperM1.transformVector(_helperV2, _helperV1);
				
				
				_worldToCameraM.transformVector(_helperV1);
				_worldToCameraM.transformVector(_helperV2);
				
				g.moveTo(_helperV1.x, _helperV1.y);
				g.lineTo(_helperV2.x, _helperV2.y);
				
			}
			
			_helperV1.x = _owner.camera.worldPosition.x;
			_helperV1.y = _owner.camera.worldPosition.y;
			_helperV1.z = _owner.camera.worldPosition.z;
			
		}
		private function renderCharacters():void
		{
			var g:Graphics = _charactersLayer.graphics;
			g.clear();
			var playerColor:uint = 0x00FF00;
			var enemyColor:uint = 0x0000FF;
			
			drawCharacter(_owner.player, g, playerColor);
			for each(var enemy:Enemy in _owner.enemies) {
				drawCharacter(enemy, g, enemyColor);
			}
		}
		private function renderSlugs():void
		{
			var g:Graphics = _charactersLayer.graphics;
			g.beginFill(0xff0000);
			
			var screenPosition:Vector3D = _helperV1;
			for each(var slug:Slug in _owner.slugs) {
				screenPosition.x = slug.position.worldCoordinates.x;
				screenPosition.y = slug.position.worldCoordinates.y;
				screenPosition.z = slug.position.worldCoordinates.z;
				
				_worldToCameraM.transformVector(screenPosition);
				g.drawCircle(screenPosition.x, screenPosition.y, 10);
			}
		}
		
		private function drawCharacter(target:Character, destination:Graphics, color:uint):void
		{
			var oPos:Vector3D = _helperV1;
			
			var triangleWidth:Number = 20;
			var triangleHeight:Number = 10;
			
			oPos.x = target.position.worldCoordinates.x;
			oPos.y = target.position.worldCoordinates.y;
			oPos.z = target.position.worldCoordinates.z;
			
			_worldToCameraM.transformVector(oPos);
			
			
			var fPos:Vector3D = _helperV2;
			var rPos:Vector3D = _helperV3;
			var lPos:Vector3D = _helperV4;
			
			fPos.x = oPos.x + 0.7 * triangleWidth;
			fPos.y = oPos.y ;
			
			
			rPos.x = oPos.x - 0.3 * triangleWidth;
			rPos.y = oPos.y + 0.5 * triangleHeight;
			
			lPos.x = oPos.x - 0.3 * triangleWidth;
			lPos.y = oPos.y - 0.5 * triangleHeight;
			
			
			
			_helperM1.identity()
			_helperM1.rotateZ(target.position.worldAngleY);
			
			
			_helperM1.transformVector(fPos, oPos);
			_helperM1.transformVector(rPos, oPos);
			_helperM1.transformVector(lPos, oPos);
			
			
			destination.beginFill(color);
			destination.moveTo(fPos.x, fPos.y);
			destination.lineTo(rPos.x, rPos.y);
			destination.lineTo(lPos.x, lPos.y);
			
		}
	}

}