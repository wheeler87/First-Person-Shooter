package com.game.entity.components.animation 
{
	import adobe.utils.CustomActions;
	import com.components.ApplicationSprite;
	import com.game.entity.components.amunition.AnimationState;
	import com.game.entity.components.BaseComponent;
	import com.game.entity.components.influence.InfluenceName;
	import com.info.components.animation.AnimationGroupInfo;
	import com.info.components.animation.AnimationInfo;
	import com.info.components.animation.AnimationTriggerInfo;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Animation extends BaseComponent 
	{
		static public const NAME:String = "Animation";
		
		public var reactOnWeaponSelection:Boolean
		public var reInitRequires:Boolean
		public var inited:Boolean;
		
		public var visible:Boolean;
		public var rawPixels:Boolean;
		
		public var skin:Sprite
		public var transformation:Matrix
		
		
		private var _pixelsCanvas:Bitmap
		
		
		
		public var animationGroupInfo:AnimationGroupInfo;
		private var _animatioStatesDict:Dictionary
		private var _triggerToAnimationDict:Dictionary;
		private var _animationToTriggerDict:Dictionary;
		private var _defaultAnimationDict:Dictionary;
		
		public var direction:String = AnimationInfo.DIRECTION_S;
		public var currentDirection:String
		public var currentTrigger:AnimationTriggerInfo
		public var currentAnimationState:AnimationState
		public var executedTriggersStack:Vector.<AnimationTriggerInfo>
		
		
		
		public var zoomCurrent:Number;
		
		
		
		
		public function Animation() 
		{
			super(NAME);
			
			transformation = new Matrix();
			
			
			skin = new Sprite();
			_pixelsCanvas=new Bitmap()
			
			
			skin.addChild(_pixelsCanvas);
			
			
			registerInfluenceHandler(InfluenceName.WEAPON_SELECTED, onWeaponSelected);
			
			
		}
		public function init(animationGroupID:int):void
		{
			animationGroupInfo = Facade.instance.info.getInfoComponentByID(animationGroupID) as AnimationGroupInfo;
			_pixelsCanvas.scaleX = _pixelsCanvas.scaleY = animationGroupInfo.scale;
			
			_animatioStatesDict = new Dictionary();
			
			
			var animationID:int;
			var animationState:AnimationState
			for (var i:uint = 0; i < animationGroupInfo.aniations.length; i++ ) {
				animationID = animationGroupInfo.aniations[i];
				animationState = new AnimationState();
				animationState.init(animationID, this);
				
				_animatioStatesDict[animationID] = animationState;
				
				
			}
			
			_triggerToAnimationDict = new Dictionary();
			_animationToTriggerDict = new Dictionary();
			
			var triggerDict:Dictionary
			var animationInfo:AnimationInfo
			
			for each(var triggerInfo:AnimationTriggerInfo in animationGroupInfo.triggers) {
				
				triggerDict = new Dictionary();
				_triggerToAnimationDict[triggerInfo.name] = triggerDict;
				for (i = 0; i < triggerInfo.aimations.length; i++ ) {
					animationID = triggerInfo.aimations[i];
					animationInfo = Facade.instance.info.getInfoComponentByID(animationID) as AnimationInfo;
					for each(var direction:String in animationInfo.directions) {
						triggerDict[direction] = animationID;
					}
					_animationToTriggerDict[animationID] = triggerInfo.name;
				}
				
			}
			_defaultAnimationDict = new Dictionary();
			
			for each(animationID in animationGroupInfo.defaultAnimations) {
				animationInfo = Facade.instance.info.getInfoComponentByID(animationID) as AnimationInfo;
				for each(direction in animationInfo.directions) {
					_defaultAnimationDict[direction] = animationID;
				}
			}
			
			
			executedTriggersStack = new Vector.<AnimationTriggerInfo>();
			registerInfluenceHandler(InfluenceName.FIRE, onFireInfluence);
			registerInfluenceHandler(InfluenceName.DAMAGED, onDamageInfluence);
			registerInfluenceHandler(InfluenceName.RELOADING_START, onReloadStart);
			registerInfluenceHandler(InfluenceName.KILLED, onKilled);
			
			currentDirection = AnimationInfo.DIRECTION_N;
			currentTrigger = null;
			setState(getDefaultAnimationID(currentDirection));
			
			inited = true;
			
		}
		public function setState(stateID:int):void
		{
			var desiredState:AnimationState = _animatioStatesDict[stateID] as AnimationState;
			currentAnimationState = desiredState;
 			currentAnimationState.onEnter();
			
		}
		
		public function getAppropriateAnimationID(triggerName:String, direction:String):int
		{
			var result:int = _triggerToAnimationDict[triggerName][direction];
			return result;
		}
		public function getTrigerNameOFAnimation(animationID:int):String
		{
			var result:String = _animationToTriggerDict[animationID];
			return result;
		}
		public function getDefaultAnimationID(direction:String):int
		{
			var result:int = _defaultAnimationDict[direction];
			return result;
		}
		public function isDefaultAnimationPlays():Boolean
		{
			var appropriateDefailtAnimationID:int = getDefaultAnimationID(currentDirection);
			var currentAnimationID:int = (currentAnimationState)?currentAnimationState.animationInfo.id: -1;
			var result:Boolean = (appropriateDefailtAnimationID == currentAnimationID);
			
			return result
		}
		public function render(screenPixels:BitmapData):void
		{
			if (!visible) return;
			if (rawPixels) {
				rebuildSkin()
				rawPixels = false;
			}
			screenPixels.draw(skin,transformation)
		}
		
		
		
		
		
		public function recalculateTransformation(dx:Number, dy:Number, scale:Number,visible:Boolean=true):void
		{
			this.visible = visible;
			if (!visible) return;
			
			
			zoomCurrent = scale;
			
			transformation.identity();
			transformation.scale(zoomCurrent, zoomCurrent);
			transformation.translate(dx, dy);
			
		}
		
		private function rebuildSkin():void
		{
			_pixelsCanvas.bitmapData = currentAnimationState.pixels;
			_pixelsCanvas.x = -0.5 * _pixelsCanvas.width+currentAnimationState.animationInfo.offsetX*_pixelsCanvas.scaleX;
			_pixelsCanvas.y = -0.5 * _pixelsCanvas.height+currentAnimationState.animationInfo.offsetY*_pixelsCanvas.scaleY;
		}
		
		private function onFireInfluence():void
		{
			var executedTrigger:AnimationTriggerInfo = animationGroupInfo.getTriggerByName(AnimationTriggerInfo.NAME_FIRE);
			if (!executedTrigger) return;
			executedTriggersStack.push(executedTrigger);
		}
		private function onDamageInfluence():void
		{
			var executedTrigger:AnimationTriggerInfo = animationGroupInfo.getTriggerByName(AnimationTriggerInfo.NAME_HIT);
			if (!executedTrigger) return;
			executedTriggersStack.push(executedTrigger);
		}
		private function onReloadStart():void
		{
			var executedTrigger:AnimationTriggerInfo = animationGroupInfo.getTriggerByName(AnimationTriggerInfo.RELOAD_START);
			if (!executedTrigger) return;
			executedTriggersStack.push(executedTrigger);
		}
		
		private function onWeaponSelected():void
		{
			if (!reactOnWeaponSelection) return;
			reInitRequires = true;
		}
		private function onKilled():void
		{
			var executtedTrigger:AnimationTriggerInfo = animationGroupInfo.getTriggerByName(AnimationTriggerInfo.DEATH);
			if (!executtedTrigger) return;
			executedTriggersStack.push(executtedTrigger);
		}
		
		public function onAnimationCycleEnd():void
		{
			currentTrigger = null;
		}
	}

}