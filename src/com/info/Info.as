package com.info 
{
	import com.info.components.animation.AnimationGroupInfo;
	import com.info.components.animation.AnimationInfo;
	import com.info.components.enemy.EnemyInfo;
	import com.info.components.IInfoComponent;
	import com.info.components.location.LocationInfo;
	import com.info.components.player.PlayerInfo;
	import com.info.components.slug.SlugInfo;
	import com.info.components.tilesheet.TileSheetInfo;
	import com.info.components.weapon.WeaponInfo;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Info 
	{
		private var _locationsInfoList:Vector.<LocationInfo>;
		private var _playerInfoList:Vector.<PlayerInfo>;
		private var _enemyInfoList:Vector.<EnemyInfo>;
		
		private var _weaponInfoList:Vector.<WeaponInfo>;
		private var _slugInfoList:Vector.<SlugInfo>;
		
		private var _tileSheetInfoList:Vector.<TileSheetInfo>;
		private var _animationInfoList:Vector.<AnimationInfo>;
		private var _animationGroupInfoList:Vector.<AnimationGroupInfo>;
		
		private var _componentsDict:Dictionary = new Dictionary();
		
		public function Info() 
		{
			
		}
		public function init(data:XML):void
		{
			saveLocations(data["location"])
			savePlayerInfo(data["player"]);
			saveEnemyInfo(data["enemy"])
			saveWeaponInfo(data["weapon"]);
			saveSlugInfo(data["slug"]);
			saveTileSheetInfo(data["tilesheet"])
			saveAnimationInfo(data["animation"])
			saveAnimationGroupInfo(data["animationGroup"])
			
			registerComponents(_locationsInfoList);
			registerComponents(_playerInfoList);
			registerComponents(_enemyInfoList);
			registerComponents(_weaponInfoList);
			registerComponents(_slugInfoList);
			registerComponents(_tileSheetInfoList);
			registerComponents(_animationInfoList);
			registerComponents(_animationGroupInfoList);
			
		}
		public function getInfoComponentByID(id:int):IInfoComponent
		{
			var result:IInfoComponent = _componentsDict[id];
			return result;
		}
		
		private function saveLocations(value:XMLList):void
		{
			_locationsInfoList = new Vector.<LocationInfo>();
			var currentInfo:LocationInfo
			var length:int = value.length();
			for (var i:uint = 0; i < length; i++ ) {
				currentInfo = new LocationInfo();
				currentInfo.init(value[i]);
				_locationsInfoList.push(currentInfo);
			}
		}
		private function savePlayerInfo(value:XMLList):void
		{
			_playerInfoList = new Vector.<PlayerInfo>();
			var length:int = value.length();
			
			var currentInfo:PlayerInfo
			for (var i:uint = 0; i < length; i++ ) {
				currentInfo = new PlayerInfo();
				currentInfo.init(value[i]);
				_playerInfoList.push(currentInfo);
			}
		}
		private function saveEnemyInfo(value:XMLList):void
		{
			_enemyInfoList = new Vector.<EnemyInfo>();
			var length:int = value.length();
			
			var currentInfo:EnemyInfo
			for (var i:uint = 0; i < length; i++ ) {
				currentInfo = new EnemyInfo();
				currentInfo.init(value[i]);
				_enemyInfoList.push(currentInfo);
			}
		}
		private function saveWeaponInfo(value:XMLList):void
		{
			_weaponInfoList = new Vector.<WeaponInfo>();
			var length:int = value.length();
			
			var currentInfo:WeaponInfo
			for (var i:uint = 0; i < length; i++ ) {
				currentInfo = new WeaponInfo();
				currentInfo.init(value[i]);
				_weaponInfoList.push(currentInfo);
			}
			
		}
		private function saveSlugInfo(value:XMLList):void
		{
			_slugInfoList = new Vector.<SlugInfo>();
			var length:int = value.length();
			
			var currentInfo:SlugInfo
			for (var i:uint = 0; i < length; i++ ) {
				currentInfo = new SlugInfo();
				currentInfo.init(value[i]);
				_slugInfoList.push(currentInfo);
			}
			
		}
		private function saveTileSheetInfo(value:XMLList):void
		{
			_tileSheetInfoList=new Vector.<TileSheetInfo>()
			var length:int = value.length();
			
			var currentInfo:TileSheetInfo
			for (var i:uint = 0; i < length; i++ ) {
				currentInfo = new TileSheetInfo();
				currentInfo.init(value[i]);
				_tileSheetInfoList.push(currentInfo);
			}
		}
		private function saveAnimationInfo(value:XMLList):void
		{
			_animationInfoList = new Vector.<AnimationInfo>();
			var length:int = value.length();
			
			var currentInfo:AnimationInfo
			for (var i:uint = 0; i < length; i++ ) {
				currentInfo = new AnimationInfo();
				currentInfo.init(value[i]);
				_animationInfoList.push(currentInfo);
			}
		}
		private function saveAnimationGroupInfo(value:XMLList):void
		{
			_animationGroupInfoList = new Vector.<AnimationGroupInfo>();
			var length:int = value.length();
			
			var currentInfo:AnimationGroupInfo
			for (var i:uint = 0; i < length; i++ ) {
				currentInfo = new AnimationGroupInfo();
				currentInfo.init(value[i]);
				_animationGroupInfoList.push(currentInfo);
			}
		}
		
		
		private function registerComponents(group:Object):void
		{
			for each(var component:IInfoComponent in group) {
				_componentsDict[component.id]=component
			}
		}
		
		public function get locationsInfoList():Vector.<LocationInfo> {	return _locationsInfoList;	}
		
		public function get playerInfoList():Vector.<PlayerInfo> 
		{
			return _playerInfoList;
		}
		
		public function get enemyInfoList():Vector.<EnemyInfo> 
		{
			return _enemyInfoList;
		}
		
		public function get weaponInfoList():Vector.<WeaponInfo> 
		{
			return _weaponInfoList;
		}
		
		static public function getCSString(source:String):Vector.<String>
		{
			var result:Vector.<String> = new Vector.<String>();
			var sourceCollection:Array = source.split(",");
			var currentValue:String
			for (var i:uint = 0; i < sourceCollection.length; i++ ) {
				currentValue = sourceCollection[i];
				if (!currentValue) continue;
				if (!currentValue.length) continue;
				result.push(currentValue);
			}
			return result;
		}
		static public function getCSInt(sourse:String):Vector.<int>
		{
			var result:Vector.<int> = new Vector.<int>();
			var sourceCollection:Array = sourse.split(",");
			var currentValueSource:String
			var currentValue:int;
			for (var i:uint = 0; i < sourceCollection.length; i++ ) {
				currentValueSource = sourceCollection[i];
				if ((!currentValueSource) || (!currentValueSource.length)) continue;
				
				currentValue = int(currentValueSource);
				result.push(currentValue);
			}
			return result;
		}
		
	}

}