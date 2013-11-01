package com.components 
{
	import com.constants.AssetNamesConst;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class LoaderIcon extends Sprite 
	{
		private var _width:Number=200;
		private var _height:Number=20;
		private var _skewAngle:Number = 20;
		
		private var _bricksLeft:int = 3;
		private var _bricksRight:int = 3;
		private var _bricksOffsetX:int = 2;
		private var _bricksOffsetY:int = 2;
		
		
		
		private var _backgroundColor:uint = AssetNamesConst.COLOR_WHITE;
		private var _brickColor:uint = AssetNamesConst.COLOR_RED;
		
		private var _bricksContainer:Sprite
		private var _bricksBackground:Shape;
		private var _bricksList:Vector.<Shape>
		
		private var _bricksAmount:int = 5;
		
		private var _animationDuration:int = 700;
		private var _delayDuration:int = 100;
		private var _animationTimeRemain:int;
		private var _delayTimeRemain:int;
		
		
		private var _lastFrameTime:int;
		
		public function LoaderIcon() 
		{
			super();
			createComponents();
			align();
		}
		
		private function createComponents():void
		{
			_bricksContainer = new Sprite();
			_bricksList = new Vector.<Shape>();
			
			_bricksBackground = cretaeBrick(_width, _height, _skewAngle, _backgroundColor);
			
			addChild(_bricksContainer);
			_bricksContainer.addChild(_bricksBackground)
			
			
			
			var brickHeight:Number = (_height - _bricksOffsetY * 2);
			var skewAmount:Number = brickHeight * Math.tan(_skewAngle*Math.PI/180.0);
			var brickWidth:Number = ((_width -_bricksLeft-_bricksRight) +(skewAmount- _bricksOffsetX) * (_bricksAmount-1)) / (Number(_bricksAmount));
			
			
			var currentBrick:Shape;
			for (var i:uint = 0; i < _bricksAmount; i++ ) {
				currentBrick = cretaeBrick(brickWidth, brickHeight, _skewAngle, _brickColor);
				currentBrick.x = _bricksLeft+i*(brickWidth+_bricksOffsetX-skewAmount);
				currentBrick.y = _bricksOffsetY;
				
				_bricksContainer.addChild(currentBrick);
				_bricksList.push(currentBrick);
			}
			
			
		}
		private function align():void
		{
			_bricksContainer.x = -_bricksContainer.width * 0.5;
			_bricksContainer.y = -_bricksContainer.height * 0.5;
		}
		
		private function cretaeBrick(width:Number, height:Number, skewAngle:Number,color:uint):Shape
		{
			var result:Shape = new Shape();
			
			var offSetX:Number = Math.tan(skewAngle / 180.0 * Math.PI) * height;
			
			var g:Graphics = result.graphics;
			g.clear();
			g.beginFill(color);
			g.moveTo(offSetX, 0);
			g.lineTo(width, 0);
			g.lineTo(width - offSetX, height);
			g.lineTo(0, height);
			
			
			//g.clear();
			//g.beginFill(color);
			//g.lineStyle(1);
			//g.drawRect(0,0,width,height)
			
			
			
			return result;
		}
		
		
		public function activate():void
		{
			addEventListener(Event.ENTER_FRAME, enteFrameHadler)
			_animationTimeRemain = _animationDuration;
			_lastFrameTime = getTimer();
		}
		
		public function deactivate():void
		{
			removeEventListener(Event.ENTER_FRAME,enteFrameHadler)
		}
		
		
		private function enteFrameHadler(e:Event):void 
		{
			var dt:int = getTimer() - _lastFrameTime;
			_lastFrameTime += dt;
			if (_delayTimeRemain > 0) {
				_delayTimeRemain -= dt;
				if (_delayTimeRemain <= 0) {
					_animationTimeRemain = _animationDuration;
				}
				return;
			}
			
			_animationTimeRemain -= dt;
			if (_animationTimeRemain <= 0) {
				_animationTimeRemain = 0;
				_delayTimeRemain = _delayDuration;
			}
			var animationProgress:Number = (_animationDuration - _animationTimeRemain) / Number(_animationDuration);
			var progresPerItem:Number = 1.0 / _bricksAmount;
			var currentItem:int = Math.min(_bricksList.length-1,animationProgress * _bricksAmount);
			var curretItemProgress:Number = (animationProgress % progresPerItem)/progresPerItem;
			for (var i:uint = 0; i < currentItem; i++ ) {
				_bricksList[i].alpha = 1;
			}
			for (i = currentItem + 1; i < _bricksList.length; i++ ) {
				_bricksList[i].alpha = 0;
			}
			_bricksList[currentItem].alpha = curretItemProgress;
			
		}
		
	}

}