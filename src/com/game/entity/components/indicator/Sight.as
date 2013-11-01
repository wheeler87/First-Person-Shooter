package com.game.entity.components.indicator 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Sight extends Sprite 
	{
		static public const COLOR_RED:uint = 0xff0000;
		static public const COLOR_GREEN:uint = 0x00ff00;
		
		private var _traceWidth:int = 10;
		private var _traceHeight:int = 2;
		
		private var _iternalGap:int = 5;
		private var _color:uint = COLOR_GREEN;
		
		public var raw:Boolean;
		
		public function Sight() 
		{
			super();
			raw = true
			rebuild();
			
		}
		public function rebuild():void
		{
			if (!raw) return;
			raw = false;
			
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(color,0.8);
			var left:int = -traceWidth - 0.5 * iternalGap;
			var right:int = traceWidth + 0.5 * iternalGap;
			var top:int = -traceWidth - 0.5 * iternalGap;
			var bottom:int = traceWidth + 0.5 * iternalGap;
			
			g.drawRect(left, -0.5 * traceHeight, traceWidth, traceHeight);
			g.drawRect(right - traceWidth, -traceHeight * 0.5, traceWidth, traceHeight);
			g.drawRect( -0.5 * traceHeight, top, traceHeight, traceWidth);
			g.drawRect( -0.5 * traceHeight, bottom-traceWidth, traceHeight, traceWidth);
			
		}
		
		
		
		public function set traceWidth(value:int):void 
		{
			if (_traceWidth == value) return;
			_traceWidth = value;
			raw = true;
			
		}
		
		public function set traceHeight(value:int):void 
		{
			if (_traceHeight == value) return;
			_traceHeight = value;
			raw = true;
		}
		public function set iternalGap(value:int):void 
		{
			if (_iternalGap == value) return;
			_iternalGap = value;
			raw = true;
		}
		
		public function set color(value:uint):void 
		{
			if (_color == value) return;
			_color = value;
			raw = true;
		}
		
		public function get traceWidth():int{	return _traceWidth;}
		public function get traceHeight():int {	return _traceHeight;}
		public function get iternalGap():int {return _iternalGap;}
		public function get color():uint {return _color;}
		
		
	}

}