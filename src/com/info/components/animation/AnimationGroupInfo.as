package com.info.components.animation 
{
	import com.info.components.IInfoComponent;
	import com.info.Info;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class AnimationGroupInfo implements IInfoComponent 
	{
		public var scale:Number;
		
		private var _id:int;
		
		private var _aniations:Vector.<int>;
		private var _defaultAnimations:Vector.<int>
		
		
		private var _triggers:Vector.<AnimationTriggerInfo>
		private var _triggersDict:Dictionary
		
		public function AnimationGroupInfo() 
		{
			
		}
		public function init(value:XML):void
		{
			_id = parseInt(value["@id"]);
			_defaultAnimations = Info.getCSInt(value["@defaultAnimations"]);
			
			saveAnimations(value["@animations"]);
			saveTriggers(value["trigger"])
			scale = parseFloat(value["@scale"]);
			
		}
		
		private function saveAnimations(source:String):void
		{
			var animationsSource:Array = source.split(",");
			
			_aniations = new Vector.<int>();
			var animationIDSource:String;
			var animationId:int
			for (var i:uint = 0; i < animationsSource.length; i++ ) {
				animationIDSource = animationsSource[i];
				if ((!animationIDSource) || (!animationIDSource.length)) continue;
				animationId = parseInt(animationIDSource);
				_aniations.push(animationId);
			}
		}
		private function saveTriggers(source:XMLList):void
		{
			_triggers = new Vector.<AnimationTriggerInfo>();
			_triggersDict = new Dictionary();
			
			var length:int = source.length();
			var currentTrigger:AnimationTriggerInfo;
			var triggerSource:XML
			for (var i:uint = 0; i < length; i++ ) {
				triggerSource = source[i];
				
				currentTrigger = new AnimationTriggerInfo();
				currentTrigger.name = triggerSource["@name"];
				currentTrigger.priority = parseInt(triggerSource["@priority"]);
				currentTrigger.aimations = Info.getCSInt(triggerSource["@animations"])
				
				_triggers.push(currentTrigger);
				_triggersDict[currentTrigger.name] = currentTrigger;
			}
			
			
		}
		
		public function getTriggerByName(triggerName:String):AnimationTriggerInfo
		{
			var result:AnimationTriggerInfo = _triggersDict[triggerName] as AnimationTriggerInfo;
			return result;
		}
		
		/* INTERFACE com.info.components.IInfoComponent */
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get aniations():Vector.<int> 
		{
			return _aniations;
		}
		
		
		
		public function get triggers():Vector.<AnimationTriggerInfo> 
		{
			return _triggers;
		}
		
		public function get defaultAnimations():Vector.<int> 
		{
			return _defaultAnimations;
		}
		
	}

}