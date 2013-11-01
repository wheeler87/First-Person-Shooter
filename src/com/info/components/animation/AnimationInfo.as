package com.info.components.animation 
{
	import com.info.components.IInfoComponent;
	import com.info.Info;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class AnimationInfo implements IInfoComponent 
	{
		static public const DIRECTION_N:String = "n";
		static public const DIRECTION_S:String = "s";
		static public const DIRECTION_E:String = "e";
		static public const DIRECTION_W:String = "w";
		static public const DIRECTION_SW:String = "sw";
		static public const DIRECTION_SE:String = "se";
		static public const DIRECTION_NW:String = "nw";
		static public const DIRECTION_NE:String = "ne";
		
		private var _id:int;
		public var tilesheetID:int
		public var frameRate:int
		
		public var name:String
		public var sequence:Vector.<int>
		public var directions:Vector.<String>
		
		public var offsetX:int
		public var offsetY:int
		
		private var _directionsDict:Dictionary;
		
		public function AnimationInfo() 
		{
			
		}
		public function init(value:XML):void
		{
			_id = parseInt(value["@id"]);
			
			tilesheetID = parseInt(value["@tilesheetID"]);
			frameRate = parseInt(value["@frameRate"]);
			
			name = value["@name"];
			
			sequence = Info.getCSInt(value["@sequence"]);
			directions = Info.getCSString(value["@directions"]);
			_directionsDict = new Dictionary();
			var currentDirection:String
			for (var i:uint = 0; i < directions.length; i++) {
				currentDirection = directions[i];
				_directionsDict[currentDirection] = currentDirection;
			}
			
			offsetX = parseInt(value["@offsetX"]);
			offsetY = parseInt(value["@offsetY"]);
			
		}
		public function isDirectionSupported(value:String):Boolean
		{
			var result:Boolean = Boolean(_directionsDict[value]);
			return result;
		}
		
		/* INTERFACE com.info.components.IInfoComponent */
		
		public function get id():int 
		{
			return _id;
		}
		
	}

}