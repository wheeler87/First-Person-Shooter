package com.game.entity.wall 
{
	import com.game.assets.TileTexture;
	import com.geom.Point2D;
	import com.geom.Point3D;
	import com.geom.Projection;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class WallTile 
	{
		static private var _helperV1:Vector3D = new Vector3D();
		static private var _helperV2:Vector3D = new Vector3D();
		
		public var column:uint;
		public var row:uint;
		
		public var leftTopScreenPoint:Point2D;
		public var rightTopScreenPoint:Point2D;
		public var rightBottomScreenPoint:Point2D
		public var leftBottomScreenPoint:Point2D;
		
		public var leftTopCameraPoint:Point3D;
		public var rightTopCameraPoint:Point3D;
		public var leftBottomCameraPoint:Point3D;
		public var rightBottomCameraPoint:Point3D;
		
		
		public var color:uint;
		
		private var _width:int;
		private var _height:int
		
		private var _texture:TileTexture
		
		
		
		
		private var _topM:Matrix = new Matrix()
		private var _bottomM:Matrix = new Matrix();
		private var _helperM3:Matrix = new Matrix();
		
		public var depth:Number;
		public var visible:Boolean
		
		
		
		private var _divisions:int = 2;
		private var _vertices:Vector.<Number>;
		private var _indices:Vector.<int>;
		private var _uv:Vector.<Number>;
		
		
		
		public function WallTile() 
		{
			createDrawingRelatedContent();
			
		}
		
		public function setTexture(texture:TileTexture):void
		{
			_width = texture.width;
			_height = texture.height;
			_texture = texture;
			
		}

		
		public function render(screenPixels:BitmapData,origin:Point2D):void
		{
			if (!visible) return;
			
			_helperM3.identity();
			_helperM3.a = _topM.a;
			_helperM3.b = _topM.b;
			_helperM3.c = _topM.c;
			_helperM3.d = _topM.d;
			_helperM3.tx = leftTopScreenPoint.x+origin.x;
			_helperM3.ty= leftTopScreenPoint.y+origin.y;
			
			screenPixels.draw(_texture.topTriangleTexture, _helperM3);
			
			_helperM3.identity();
			_helperM3.a = _bottomM.a;
			_helperM3.b = _bottomM.b;
			_helperM3.c = _bottomM.c;
			_helperM3.d = _bottomM.d;
			_helperM3.tx = rightBottomScreenPoint.x+origin.x;
			_helperM3.ty= rightBottomScreenPoint.y+origin.y;
			
			
			screenPixels.draw(_texture.bottomTriangleTexture, _helperM3);
			
		}
		public function recalculateScreenRelatedParams(screenWidth:Number,screenHeight:Number):void
		{
			depth = (leftBottomCameraPoint.z + rightTopCameraPoint.z) * 0.5;
			
			visible = (depth >=( -Projection.focalLength*0.8));
			if (!visible) {
				return;
			}
			validateVisibilityByOrientation();
			if (!visible) {
				return;
			}
			validateVisibilityByScreenBounds(screenWidth, screenHeight);
			if (!visible) {
				return;
			}
			recalculateTrasformationMatrices()
			
			//recalculateTrianglesVertices(_topM,_bottomM);
		}
		private function validateVisibilityByOrientation():void
		{
			var angle:Number = Math.atan2(rightTopScreenPoint.y - leftTopScreenPoint.y, rightTopScreenPoint.x - leftTopScreenPoint.x);
			var rNormal:Vector3D = _helperV1;
			rNormal.x = Math.cos(angle + Math.PI * 0.5);
			rNormal.y = Math.sin(angle + Math.PI * 0.5);
			
			var toRightBottom:Vector3D = _helperV2;
			toRightBottom.x = rightBottomScreenPoint.x - leftTopScreenPoint.x;
			toRightBottom.y = rightBottomScreenPoint.y - leftTopScreenPoint.y;
			
			var helper:Number = rNormal.dotProduct(toRightBottom);
			visible = (helper >= 0);
		}
		private function validateVisibilityByScreenBounds(screenWidth:Number, screenHeight:Number):void
		{
			var left:Number = Math.min(leftTopScreenPoint.x, rightTopScreenPoint.x, leftBottomScreenPoint.x, rightBottomScreenPoint.x);
			var right:Number = Math.max(leftTopScreenPoint.x, rightTopScreenPoint.x, leftBottomScreenPoint.x, rightBottomScreenPoint.x);
			
			var top:Number = Math.min(leftTopScreenPoint.y, rightTopScreenPoint.y, leftBottomScreenPoint.y, rightBottomScreenPoint.y);
			var bottom:Number = Math.max(leftTopScreenPoint.y, rightTopScreenPoint.y, leftBottomScreenPoint.y, rightBottomScreenPoint.y);
			
			var hW:int = screenWidth * 0.5;
			var hH:int = screenHeight* 0.5*2;
			
			visible = !((right <= (-hW)) || (left >= (hW)) || (top > (hH)) || (bottom <= (-hH)));
			
		}
		private function recalculateTrasformationMatrices():void
		{
			_topM.a = (rightTopScreenPoint.x - leftTopScreenPoint.x)/ _width;
			_topM.d = (leftBottomScreenPoint.y - leftTopScreenPoint.y) / _height;
			
			_topM.b = (rightTopScreenPoint.y - leftTopScreenPoint.y) / _width;
			_topM.c = (leftBottomScreenPoint.x - leftTopScreenPoint.x) / _height;
			
			
			_bottomM.a = -1 * ((leftBottomScreenPoint.x - rightBottomScreenPoint.x)/ _width);
			_bottomM.d = -1*((rightTopScreenPoint.y - rightBottomScreenPoint.y) / _height);
			
			_bottomM.b = -1*((leftBottomScreenPoint.y - rightBottomScreenPoint.y) / _width);
			_bottomM.c = -1 * ((rightTopScreenPoint.x - rightBottomScreenPoint.x) / _height);
			
			
			
			
			
		}
		private function createDrawingRelatedContent():void
		{
			
			_vertices = new Vector.<Number>((_divisions+1) * (_divisions+1)*2, true);
			_indices = new Vector.<int>();
			_uv = new Vector.<Number>();
			
			var column:uint;
			var row:uint;
			
			var index1:int;
			var index2:int;
			var index3:int;
			var index4:int;
			
			var percentX:Number;
			var percentY:Number;
			
			for (var i:uint = 0; i < _divisions * _divisions; i++ ) {
				column = i % _divisions;
				row = i / _divisions;
				
				index1 = row * (_divisions + 1)+column;
				index2 = index1 + 1;
				index3 = (row + 1) * (_divisions + 1) + column;
				index4 = index3 + 1;
				
				_indices.push(index1);
				_indices.push(index2);
				_indices.push(index3);
				
				_indices.push(index2);
				_indices.push(index4);
				_indices.push(index3);
				
			}
			
			for (i = 0; i < (_divisions + 1) * (_divisions + 1); i++ ) {
				
				percentX = (i % (_divisions + 1)) / _divisions;
				percentY = (int(i / (_divisions + 1))) / _divisions;
				_uv.push(percentX);
				_uv.push(percentY);
				
			}
			
		}
		private function recalculateTrianglesVertices(topM:Matrix=null,bottomM:Matrix=null):void
		{
			var originX:Number = leftTopScreenPoint.x;
			var originY:Number = leftTopScreenPoint.y;
			
			//originX = 0;
			//originY = 0;
			
			var percentX:Number
			var percentY:Number;
			
			var localX:Number
			var localY:Number;
			
			var appropriateM:Matrix
			
			var column:uint;
			var row:uint;
			
			for (var i:uint = 0; i < _vertices.length*0.5; i++ ) {
				row = i / (_divisions + 1);
				column= i % (_divisions + 1);
				
				if ((row + column) <= (_divisions)) {
					appropriateM = topM;
					originX = leftTopScreenPoint.x;
					originY = leftTopScreenPoint.y;
					
					localX=(column/(_divisions))*_width
					localY=(row/(_divisions))*_height
					
				}else {
					appropriateM = bottomM;
					originX = rightBottomScreenPoint.x;
					originY = rightBottomScreenPoint.y;
					localX=-(1-column/(_divisions))*_width
					localY=-(1-row/(_divisions))*_height
				}
				
				appropriateM = ((row + column) <= (_divisions))?topM:bottomM;
				_vertices[i * 2] = appropriateM.a*localX+appropriateM.c*localY*1+originX;
				_vertices[i * 2+1] = appropriateM.b*localX+appropriateM.d*localY+originY;
				
			}
			
			
		}
		
		static public function sorter(a:WallTile, b:WallTile):int
		{
			if (a.depth < b.depth) return 1;
			if (a.depth > b.depth) return -1;
			return 0;
		}
	}

}