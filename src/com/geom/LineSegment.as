package com.geom 
{
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class LineSegment 
	{
		private var _startX:Number;
		private var _startY:Number;
		
		private var _endX:Number;
		private var _endY:Number;
		
		private var _length:Number;
		private var _angle:Number;
		
		public function LineSegment() 
		{
			
		}
		public function init(startX:Number, startY:Number, endX:Number, endY:Number):void
		{
			_startX = startX;
			_startY = startY;
			_endX = endX;
			_endY = endY;
			
			var dx:Number = _endX - _startX;
			var dy:Number = _endY - _startY;
			
			_length = Math.sqrt(dx * dx + dy * dy);
			_angle = Math.atan2(dy, dx);
		}
		
		public function get startX():Number {return _startX;}
		public function get startY():Number {return _startY;}
		
		public function get endX():Number {	return _endX;}
		public function get endY():Number {	return _endY;}
		
		public function get length():Number	{return _length;}
		public function get angle():Number {return _angle;}
		
	}

}