package com.game.entity.wall 
{
	import com.game.assets.TileTexture;
	import com.game.entity.BaseEntity;
	import com.geom.Matrix3D;
	import com.geom.Point2D;
	import com.geom.Point3D;
	import com.info.components.location.WallInfo;
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Wall extends BaseEntity
	{
		static private var _helperM:Matrix3D = new Matrix3D();
		
		
		public var info:WallInfo;
		public var width:Number;
		public var height:Number;
		
		private var _worldSpacePoints:Vector.<Point3D>;
		private var _originPoint:Point3D
		
		private var _cameraSpacePoints:Vector.<Point3D>;
		private var _screenPoints:Vector.<Point2D>
		private var _wallTiles:Vector.<WallTile>;
		
		
		
		public function Wall() 
		{
			
		}
		public function init(walInfo:WallInfo):void
		{
			info = walInfo;
			
			width = walInfo.columns * walInfo.tileSize;
			height = walInfo.rows * walInfo.tileSize;
			
			_worldSpacePoints = new Vector.<Point3D>();
			_cameraSpacePoints = new Vector.<Point3D>();
			_screenPoints = new Vector.<Point2D>;
			
			var currentPoint:Point3D;
			var currentCameraPoint:Point3D
			var currentScreenPoint:Point2D
			
			for (var i:uint = 0; i <= walInfo.rows; i++ ) {
				for (var j:uint = 0; j <= walInfo.columns; j++ ) {
					currentPoint = new Point3D();
					currentPoint.x = walInfo.originX + walInfo.tileSize * j;
					currentPoint.y = walInfo.originY + walInfo.tileSize * i;
					currentPoint.z = walInfo.originZ;
					
					_worldSpacePoints.push(currentPoint);
					
					currentCameraPoint = new Point3D();
					_cameraSpacePoints.push(currentCameraPoint);
					
					currentScreenPoint = new Point2D();
					_screenPoints.push(currentScreenPoint);
				}
			}
			_originPoint = _worldSpacePoints[0];
			
			_wallTiles = new Vector.<WallTile>();
			var currentTile:WallTile;
			var currentColumn:int;
			var currentRow:int;
			var pointIndex1:int
			var pointIndex2:int
			var pointIndex3:int
			var pointIndex4:int
			
			var tilePixelsName:String
			var tileTexture:TileTexture
			
			for (i = 0; i < walInfo.columns * walInfo.rows; i++ ) {
				currentColumn = (i % walInfo.columns);
				currentRow = (i/walInfo.columns);
				tilePixelsName = walInfo.getTilePixelsNameAt(currentColumn, currentRow);
				tileTexture = game.assetManager.getTileTexture(tilePixelsName);
				
				currentTile = new WallTile();
				currentTile.column = currentColumn;
				currentTile.row = currentRow;
				currentTile.color = ((currentColumn + currentRow) % 2)?0x00ff00:0x0000ff;
				currentTile.setTexture(tileTexture);
				
				pointIndex1 = currentRow * (walInfo.columns + 1) + currentColumn;
				pointIndex2 = pointIndex1 + 1;
				pointIndex3 = pointIndex1 + walInfo.columns + 1;
				pointIndex4 = pointIndex3 + 1;
				
				currentTile.leftTopScreenPoint = _screenPoints[pointIndex1];
				currentTile.rightTopScreenPoint = _screenPoints[pointIndex2];
				currentTile.leftBottomScreenPoint = _screenPoints[pointIndex3];
				currentTile.rightBottomScreenPoint = _screenPoints[pointIndex4];
				
				currentTile.leftTopCameraPoint = _cameraSpacePoints[pointIndex1];
				currentTile.rightTopCameraPoint = _cameraSpacePoints[pointIndex2];
				currentTile.leftBottomCameraPoint = _cameraSpacePoints[pointIndex3];
				currentTile.rightBottomCameraPoint = _cameraSpacePoints[pointIndex4];
				
				_wallTiles.push(currentTile);
			}
			
			
			
			_helperM.identity();
			_helperM.rotateY(walInfo.angleY);
			_helperM.rotateX(walInfo.angleX);
			
			_helperM.tranformGroup(_worldSpacePoints, _originPoint);
			
			
			
		}
		public function onScreenPointsUpdate(screenWidth:Number,screenHeight:Number):void
		{
			for each(var wallTile:WallTile in _wallTiles) {
				wallTile.recalculateScreenRelatedParams(screenWidth,screenHeight);
				
			}
		}
		
		
		public function get worldSpacePoints():Vector.<Point3D>{return _worldSpacePoints;}
		public function get cameraSpacePoints():Vector.<Point3D> {return _cameraSpacePoints;}
		
		public function get screenPoints():Vector.<Point2D> {return _screenPoints;}
		public function get wallTiles():Vector.<WallTile> {	return _wallTiles;}
		
	}

}