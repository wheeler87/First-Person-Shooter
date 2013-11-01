package com.game.assets 
{
	import com.info.components.tilesheet.TileSheetInfo;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class TileSheet 
	{
		static private const _helperP:Point = new Point();
		static private const _helperR:Rectangle = new Rectangle();
		
		public var info:TileSheetInfo
		
		private var _tiles:Vector.<BitmapData>
		
		public function TileSheet() 
		{
			
		}
		
		public function init(info:TileSheetInfo,pixels:BitmapData):void
		{
			this.info = info;
			
			_tiles = new Vector.<BitmapData>();
			
			_helperP.x = 0;
			_helperP.y = 0;
			
			_helperR.width = info.tileWidth;
			_helperR.height=info.tileHeight
			
			var currentTilePixels:BitmapData
			
			
			for (var i:uint = 0; i < info.totalTiles; i++ ) {
				
				_helperR.x = int((i * info.tileWidth) % pixels.width);
				_helperR.y = int((i * info.tileWidth) / pixels.width) * info.tileHeight;
				
				
				currentTilePixels = new BitmapData(info.tileWidth, info.tileHeight, true, 0);
				currentTilePixels.copyPixels(pixels, _helperR, _helperP);
				
				_tiles.push(currentTilePixels);
				
			}
			
			
			
		}
		
		public function getTilePixelsByIndex(index:int):BitmapData
		{
			return _tiles[index];
		}
		
		
		public function get tiles():Vector.<BitmapData> 
		{
			return _tiles;
		}
		
	}

}