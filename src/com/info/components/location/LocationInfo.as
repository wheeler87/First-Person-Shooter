package com.info.components.location 
{
	import com.components.ApplicationSprite;
	import com.geom.Point3D;
	import com.info.components.IInfoComponent;
	import com.info.components.location.navigation.NavigationInfo;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class LocationInfo implements IInfoComponent 
	{
		private var _id:int;
		public var source:String;
		
		public var locationWidth:int;
		public var locationHeight:int;
		public var locationDepth:uint;
		
		public var tileSize:uint;
		public var tilesSource:String;
		
		
		private var _wallInfoList:Vector.<WallInfo>
		private var _spanersInfoList:Vector.<Point3D>
		private var _navigationInfo:NavigationInfo
		
		public function LocationInfo() 
		{
			
		}
		public function init(value:XML):void
		{
			_id = parseInt(value["@id"]);
			source = value["@source"];
			
			
		}
		public function parseDescription(value:XML):void
		{
			locationWidth = parseInt(value["@locationWidth"]);
			locationHeight = parseInt(value["@locationHeight"]);
			locationDepth = parseInt(value["@locationDepth"]);
			
			tileSize = parseInt(value["@tileSize"]);
			tilesSource = (value["@tilesSource"]);
			
			_wallInfoList = new Vector.<WallInfo>();
			_spanersInfoList = new Vector.<Point3D>();
			
			var currentWallInfo:WallInfo;
			var tileMapSource:String;
			
			var currentSpawnerInfo:Point3D
			
			for each(var childNode:XML in value.*) {
				
				if (childNode.name() == "wall") {
					currentWallInfo = new WallInfo();
					currentWallInfo.originX = parseFloat(childNode["@originX"]);
					currentWallInfo.originY = parseFloat(childNode["@originY"]);
					currentWallInfo.originZ = parseFloat(childNode["@originZ"]);
					currentWallInfo.angleX = parseFloat(childNode["@angleX"]);
					currentWallInfo.angleY = parseFloat(childNode["@angleY"]);
					
					
					currentWallInfo.tileSize = tileSize;
					tileMapSource = childNode["@tiles"];
					currentWallInfo.tilesMap = tileMapSource.split(",");
					currentWallInfo.columns = parseInt(childNode["@columns"]);
					currentWallInfo.rows = parseInt(childNode["@rows"]);
					
					_wallInfoList.push(currentWallInfo);
				}else if (childNode.name() == "spawner") {
					currentSpawnerInfo = new Point3D();
					currentSpawnerInfo.x = parseFloat(childNode["@x"]);
					currentSpawnerInfo.y = parseFloat(childNode["@y"]);
					currentSpawnerInfo.z = parseFloat(childNode["@z"]);
					_spanersInfoList.push(currentSpawnerInfo);
				}
				
			}
			_navigationInfo = new NavigationInfo();
			_navigationInfo.init(value["navigation"][0]);
			
		}
		
		
		public function get id():int {return _id;}
		
		public function get wallInfoList():Vector.<WallInfo> 
		{
			return _wallInfoList;
		}
		
		public function get spanersInfoList():Vector.<Point3D> 
		{
			return _spanersInfoList;
		}
		
		public function get navigationInfo():NavigationInfo 
		{
			return _navigationInfo;
		}
		
		
	}

}