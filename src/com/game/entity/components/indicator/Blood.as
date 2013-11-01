package com.game.entity.components.indicator 
{
	import com.geom.Matrix3D;
	import com.geom.Point2D;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Blood extends Sprite 
	{
		private var _helperM:Matrix = new Matrix();
		private var _helperM3D1:Matrix3D = new Matrix3D();
		private var _helperV1:Vector3D = new Vector3D();
		private var _helperV2:Vector3D = new Vector3D();
		
		
		private var _corner1:Vector3D = new Vector3D();
		private var _corner2:Vector3D = new Vector3D();
		private var _corner3:Vector3D = new Vector3D();
		
		private var _cv1:Vector3D = new Vector3D();
		private var _cv2:Vector3D = new Vector3D();
		private var _cv3:Vector3D = new Vector3D();
		
		
		
		
		private var _commads:Vector.<int>
		private var _vertices:Vector.<Number>;
		
		private var _offsetX:Number = -40;
		private var _offsetY:Number = -40;
		private var _width:Number = 200;
		private var _height:Number = 100;
		private var _angle:Number = Math.PI / 180.0 * 10;
		
		
		public function Blood() 
		{
			super();
			init();
			rebuild();
		}
		private function init():void
		{
			_commads = new Vector.<int>(4, true);
			_commads[0] = GraphicsPathCommand.MOVE_TO;
			_commads[1] = GraphicsPathCommand.CURVE_TO;
			_commads[2] = GraphicsPathCommand.CURVE_TO;
			_commads[3] = GraphicsPathCommand.CURVE_TO;
			
			_vertices = new Vector.<Number>(14, true);
		}
		private function recalculateVertices():void
		{
			_corner1.x = _offsetX + 0.2 * _width;
			_corner1.y = _offsetY;
			
			_corner2.x = _offsetX + _width;
			_corner2.y = _offsetY;
			
			_corner3.x = _offsetX;
			_corner3.y = _offsetY + _height;
			
			_helperM3D1.identity();
			_helperM3D1.rotateZ(_angle);
			
			_helperM3D1.transformVector(_corner1);
			_helperM3D1.transformVector(_corner2);
			_helperM3D1.transformVector(_corner3);
			
			calculateControlVertex(_corner1, _corner2, _cv1,0.5,0.5);
			calculateControlVertex(_corner3, _corner2, _cv2,0.25,0.15);
			calculateControlVertex(_corner3, _corner1, _cv3,0.1,0.5);
			
			_vertices[0] = _corner1.x;
			_vertices[1] = _corner1.y;
			
			_vertices[2] = _cv1.x;
			_vertices[3] = _cv1.y;
			_vertices[4] = _corner2.x;
			_vertices[5] = _corner2.y;
			
			_vertices[6] = _cv2.x;
			_vertices[7] = _cv2.y;
			_vertices[8] = _corner3.x;
			_vertices[9] = _corner3.y;
			
			_vertices[10] = _cv3.x;
			_vertices[11] = _cv3.y;
			_vertices[12] = _corner1.x;
			_vertices[13] = _corner1.y;
			
			
			
		}
		private function calculateControlVertex(corner1:Vector3D, corner2:Vector3D, result:Vector3D,headingRatio:Number,normalRatio:Number):void
		{
			
			var heading:Vector3D = _helperV1;
			heading.x = corner2.x - corner1.x;
			heading.y = corner2.y - corner1.y;
			heading.z = 0;
			
			var distance:Number = heading.length;
			
			heading.normalize();
			
			
			var normal:Vector3D = _helperV2;
			normal.x = heading.y;
			normal.y = -heading.x;
			
			result.x = heading.x * distance * headingRatio + normal.x * distance* normalRatio;
			result.y = heading.y * distance* headingRatio + normal.y * distance* normalRatio;
			
		}
		
		public function rebuild():void
		{
			recalculateVertices();
			
			var color:uint = 0xff0000;
			var colors:Array = [color,color,color]
			var alphas:Array = [0.1, 0.6, 0.1]
			var ratios:Array = [0, 50, 250];
			var type:String = GradientType.LINEAR;
			
			_helperM.createGradientBox(_width, _width, _angle, _offsetX, _offsetY);
			
			
			
			
			var g:Graphics = this.graphics;
			g.clear();
			g.beginGradientFill(type,colors,alphas,ratios,_helperM);
			g.drawPath(_commads, _vertices);
			
			
		}
	}

}