package com.components 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class ApplicationSprite extends Sprite 
	{
		
		public function ApplicationSprite() 
		{
			super();
			
		}
		static public function getDefinition(definitionName:String):Class
		{
			var domain:ApplicationDomain = ApplicationDomain.currentDomain;
			var result:Class = domain.hasDefinition(definitionName)?domain.getDefinition(definitionName) as Class:null;
			return result;
		}
		static public function getBitmapData(definitionName:String):BitmapData
		{
			var source:Class = getDefinition(definitionName);
			var result:BitmapData = (source)?new source():null;
			return result;
		}
		
	}

}