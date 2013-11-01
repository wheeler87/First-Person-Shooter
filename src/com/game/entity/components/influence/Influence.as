package com.game.entity.components.influence 
{
	import com.game.entity.components.BaseComponent;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Influence extends BaseComponent 
	{
		static public const NAME:String = "Influence";
		private var _influenceList:Vector.<String>
		private var _influenceDict:Dictionary;
		
		public function Influence() 
		{
			super(NAME);
			
			_influenceList = new Vector.<String>();
			_influenceDict = new Dictionary();
			
		}
		public function addInfluence(value:String):void
		{
			if (!wasInfluenced(value)) {
				_influenceList.push(value);
				_influenceDict[value] = value;
			}
			
		}
		public function wasInfluenced(influenceName:String):Boolean
		{
			var result:Boolean = _influenceDict[influenceName];
			return result;
		}
		public function getInfluenceNameAt(index:int):String
		{
			var result:String = _influenceList[index];
			return result;
		}
		public function getInfluenceDataAt(index:int):Object
		{
			var key:String = _influenceList[index];
			var result:Object = _influenceDict[key];
			
			return result;
		}
		
		public function shiftInfluence():String
		{
			var value:String = _influenceList.shift();
			_influenceDict[value] = null;
			delete _influenceList[value]
			
			return value;
		}
		
		
		public function get influenceList():Vector.<String> {return _influenceList;}
		
	}

}