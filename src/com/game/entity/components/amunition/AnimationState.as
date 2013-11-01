package com.game.entity.components.amunition 
{
	import com.game.assets.TileSheet;
	import com.game.entity.components.animation.Animation;
	import com.info.components.animation.AnimationInfo;
	import com.info.components.tilesheet.TileSheetInfo;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class AnimationState 
	{
		public var pixels:BitmapData
		public var animationInfo:AnimationInfo;
		public var tileSheet:TileSheet
		
		private var _owner:Animation
		
		private var _timePerFrame:int;
		private var _totalFrames:int;
		
		
		
		private var _comulatedTime:int
		private var _currentSequenceIndex:int;
		private var _currentTileIdex:int
		
		
		
		public function AnimationState() 
		{
			
		}
		
		
		public function init(animationID:int,owner:Animation):void
		{
			_owner = owner;
			
			animationInfo = Facade.instance.info.getInfoComponentByID(animationID) as AnimationInfo;
			tileSheet = _owner.owner.game.assetManager.getTileSheet(animationInfo.tilesheetID);
			
			
			_timePerFrame = 1000 / animationInfo.frameRate;
			_totalFrames = animationInfo.sequence.length;
			
			
		}
		public function onEnter():void
		{
			_comulatedTime = 0;
			_currentSequenceIndex = 0;
			onSequenceIndexChange();
		}
		
		
		public function update(dt:int):void
		{
			//if (_totalFrames <= 1) return;
			_comulatedTime += dt;
			var framesAdvanced:int = int(_comulatedTime / _timePerFrame);
			if (!framesAdvanced) return;
			var endLoop:Boolean;
			_comulatedTime-= framesAdvanced * _timePerFrame;
			_currentSequenceIndex += framesAdvanced;
			
			if (_currentSequenceIndex >= _totalFrames) {
				_currentSequenceIndex = _currentSequenceIndex % _totalFrames;
				endLoop = true;
			}
			onSequenceIndexChange();
			if (endLoop) {
				_owner.onAnimationCycleEnd();
			}
			
		}
		private function onSequenceIndexChange():void
		{
			_currentTileIdex = animationInfo.sequence[_currentSequenceIndex];
			pixels = tileSheet.getTilePixelsByIndex(_currentTileIdex);
			_owner.rawPixels = true;
		}
		public function getAnimationPercent():Number
		{
			var result:Number = (_currentSequenceIndex) / (Number(animationInfo.sequence.length - 1));
			return result;
		}
		public function setAnimationPercent(value:Number):void
		{
			_currentSequenceIndex = int((animationInfo.sequence.length - 1) * value);
			onSequenceIndexChange();
		}
		
	}

}