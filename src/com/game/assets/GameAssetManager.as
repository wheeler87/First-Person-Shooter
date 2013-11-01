package com.game.assets 
{
	import com.info.components.tilesheet.TileSheetInfo;
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class GameAssetManager 
	{
		
		private var _tilesDefinitions:ApplicationDomain;
		
		private var _tilesPixelsDict:Dictionary
		private var _tileTexturesDict:Dictionary
		private var _tilesheetsDict:Dictionary
		
		public function GameAssetManager() 
		{
			_tilesPixelsDict = new Dictionary();
			_tileTexturesDict = new Dictionary();
			_tilesheetsDict = new Dictionary();
		}
		public function setTileDefinitionsRepository(value:ApplicationDomain):void
		{
			_tilesDefinitions = value;
		}
		public function getTileTexture(tileName:String):TileTexture
		{
			var result:TileTexture
			if (!_tileTexturesDict[tileName]) {
				var sourcePixels:BitmapData = getTilePixels(tileName);
				result = new TileTexture();
				result.init(sourcePixels);
				_tileTexturesDict[tileName] = result;
				
			}
			result = _tileTexturesDict[tileName];
			return result;
		}
		public function getTileSheet(tilesheetID:int):TileSheet
		{
			var result:TileSheet;
			if (!_tilesheetsDict[tilesheetID]) {
				var tileSheetInfo:TileSheetInfo = Facade.instance.info.getInfoComponentByID(tilesheetID) as TileSheetInfo;
				var SheetPixelsSource:Class = getDefinition(tileSheetInfo.source, ApplicationDomain.currentDomain);
				var sheetPixels:BitmapData = new SheetPixelsSource();
				
				result = new TileSheet();
				result.init(tileSheetInfo, sheetPixels);
				
				_tilesheetsDict[tilesheetID] = result;
				
			}
			result = _tilesheetsDict[tilesheetID];
			
			return result;
		}
		
		private function getTilePixels(tileName:String):BitmapData
		{
			var result:BitmapData
			if (!_tilesPixelsDict[tileName]) {
				var source:Class = getDefinition(tileName, _tilesDefinitions);
				result = (source)?new source():null;
				_tilesPixelsDict[tileName] = result;
			}
			result = _tilesPixelsDict[tileName]
			
			return result;
		}
		
		
		private function getDefinition(definitionName:String, domain:ApplicationDomain):Class
		{
			var result:Class = domain.hasDefinition(definitionName)?domain.getDefinition(definitionName) as Class:null;
			return result;
		}
		
		public function destroy():void
		{
			
		}
	}

}