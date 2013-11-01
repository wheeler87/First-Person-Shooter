package com.info.components.tilesheet 
{
	import com.info.components.IInfoComponent;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class TileSheetInfo implements IInfoComponent 
	{
		private var _id:int;
		
		public var tileWidth:int;
		public var tileHeight:int;
		public var totalTiles:int
		
		public var source:String;
		
		public function TileSheetInfo() 
		{
			
		}
		public function init(value:XML):void
		{
			_id = parseInt(value["@id"]);
			
			tileWidth = parseInt(value["@tileWidth"]);
			tileHeight = parseInt(value["@tileHeight"]);
			totalTiles = parseInt(value["@totalTiles"]);
			
			source = value["@source"];
			
			
		}
		
		
		/* INTERFACE com.info.components.IInfoComponent */
		
		public function get id():int 
		{
			return _id;
		}
		
	}

}