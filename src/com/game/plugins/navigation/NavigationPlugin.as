package com.game.plugins.navigation 
{
	import com.game.entity.characer.Character;
	import com.game.entity.components.influence.InfluenceName;
	import com.game.entity.characer.Enemy;
	import com.game.entity.wall.Wall;
	import com.game.Game;
	import com.game.plugins.BasePlugin;
	import com.game.plugins.synchronizer.PriorityInitialization;
	import com.game.plugins.synchronizer.PriorityUpdate;
	import com.geom.IntersectionResult;
	import com.geom.Point2D;
	import com.geom.Point3D;
	import com.info.components.location.LocationInfo;
	import com.info.components.location.navigation.Edge;
	import com.info.components.location.navigation.NavigationInfo;
	import com.info.components.location.navigation.Node;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class NavigationPlugin extends BasePlugin 
	{
		private var _locationInfo:LocationInfo;
		private var _navigationInfo:NavigationInfo
		private var _notUsedSpawners:Vector.<Point3D>
		
		private var _helperV1:Vector3D = new Vector3D();
		private var _helperV2:Vector3D = new Vector3D();
		
		
		private var _helperP1:Point2D = new Point2D();
		private var _helperP2:Point2D = new Point2D();
		
		private var _helperUtil:NavigationUtil = new NavigationUtil();
		private var _intersectionHelper:IntersectionResult = new IntersectionResult();
		
		
		
		public function NavigationPlugin(owner:Game) 
		{
			super(owner);
			
		}
		
		override public function onEnter():void 
		{
			super.onEnter();
			owner.synchronizer.addInitializationTask(initialize, PriorityInitialization.NAVIGATION_INITIALIZATION);
			owner.synchronizer.addUpdateTask(advanceRespawnPolicy, PriorityUpdate.ADVANCE_RESPAWN_POLICY);
			
		}
		override public function onExit():void 
		{
			super.onExit();
			
			owner.synchronizer.removeInitializationTask(initialize);
			owner.synchronizer.removeUpdateTask(advanceRespawnPolicy);
		}
		
		
		private function initialize():void
		{
			_locationInfo = owner.settings.locationInfo;
			_navigationInfo = _locationInfo.navigationInfo;
		}
		private function advanceRespawnPolicy():void
		{
			advanceCharacterRespawnPolicy(owner.player);
			for each(var enemy:Enemy in owner.enemies) {
				advanceCharacterRespawnPolicy(enemy);
			}
			
		}
		private function advanceCharacterRespawnPolicy(target:Character):void
		{
			if (target.influence.wasInfluenced(InfluenceName.BORN)) {
				var spawnPoint:Point3D = getRandomSpawnerPosition();
				var angleY:Number = -Math.atan2(_locationInfo.locationDepth * 0.5 - spawnPoint.z, _locationInfo.locationWidth * 0.5 - spawnPoint.x);
				var displacementByY:int = target.bounds.height;
				target.position.locate(spawnPoint.x, spawnPoint.y-displacementByY, spawnPoint.z, angleY);
			}
		}
		
		
		private function getRandomSpawnerPosition():Point3D
		{
			if ((!_notUsedSpawners) || (!_notUsedSpawners.length)) {
				_notUsedSpawners = _locationInfo.spanersInfoList.slice();
			}
			var index:int = Math.random() * _notUsedSpawners.length;
			var reslt:Point3D = _notUsedSpawners[index];
			_notUsedSpawners.splice(index, 1);
			
			return reslt;
			
		}
		public function get spawners():Vector.<Point3D> { return _locationInfo.spanersInfoList }
		
		public function getClosestSpawner(x:Number, y:Number, z:Number):Point3D
		{
			var origin:Vector3D = _helperV1;
			var toSpawner:Vector3D = _helperV2;
			
			origin.x = x;
			origin.y = y;
			origin.z = z;
			
			var selectedSpawner:Point3D
			var distanceToSelectedSpawnerSq:int = int.MAX_VALUE;
			
			for each (var currentSpawner:Point3D in spawners) {
				toSpawner.x = currentSpawner.x - origin.x;
				toSpawner.y = currentSpawner.y - origin.y;
				toSpawner.z = currentSpawner.z - origin.z;
				
				if (distanceToSelectedSpawnerSq > toSpawner.lengthSquared) {
					selectedSpawner = currentSpawner;
					distanceToSelectedSpawnerSq = toSpawner.lengthSquared;
				}
			}
			return selectedSpawner;
			
		}
		public function getClossestNode(x:Number, y:Number, z:Number):Node
		{
			var selectedNode:Node;
			var currentNode:Node
			var toNode:Vector3D = _helperV1;
			var distanceToSelectedNodeSQ:int = int.MAX_VALUE;
			var distanceToCurrentNodeSQ:int;
			for (var i:uint = 0; i < _navigationInfo.nodesList.length; i++ ) {
				currentNode = _navigationInfo.nodesList[i];
				toNode.x = currentNode.position.x - x;
				toNode.y = currentNode.position.y - y;
				toNode.z = currentNode.position.z - z;
				distanceToCurrentNodeSQ = toNode.lengthSquared;
				if (distanceToCurrentNodeSQ < distanceToSelectedNodeSQ) {
					selectedNode = currentNode;
					distanceToSelectedNodeSQ = distanceToCurrentNodeSQ;
				}
				
			}
			
			return selectedNode;
		}
		public function getEdgesConnection(startNodeIndex:int, endNodeIndex:int):Vector.<Edge>
		{
			var result:Vector.<Edge> = _helperUtil.search(startNodeIndex, endNodeIndex, _navigationInfo);
			return result;
		}
		public function generateMovementPoints(origin:Vector3D, destination:Vector3D):Vector.<Vector3D>
		{
			var result:Vector.<Vector3D> = new Vector.<Vector3D>();
			var originNode:Node = getClossestNode(origin.x, origin.y, origin.z);
			var destinationNode:Node = getClossestNode(destination.x, destination.y, destination.z);
			
			var curentPosition:Vector3D
			var currentEdge:Edge;
			
			var edges:Vector.<Edge> = getEdgesConnection(originNode.index, destinationNode.index);
			for (var i:uint = 0; i < edges.length; i++ ) {
				currentEdge = edges[i];
				originNode = _navigationInfo.getNodeByIndex(currentEdge.originNodeIndex);
				
				
				curentPosition = new Vector3D();
				curentPosition.x = originNode.position.x;
				//curentPosition.y = originNode.position.y;
				curentPosition.y = destination.y;
				curentPosition.z = originNode.position.z;
				
				result.push(curentPosition);
				
				
			}
			if (currentEdge) {
				destinationNode = _navigationInfo.getNodeByIndex(currentEdge.destinationNodeIndex);
				curentPosition = new Vector3D();
				curentPosition.x = destinationNode.position.x;
				//curentPosition.y = destinationNode.position.y;
				curentPosition.y = destination.y;
				curentPosition.z = destinationNode.position.z;
				
				result.push(curentPosition);
			}
			
			curentPosition = new Vector3D();
			curentPosition.x = destination.x;
			curentPosition.y = destination.y;
			curentPosition.z = destination.z;
			
			result.push(curentPosition);
			
			//smoothing
			if (result.length > 1) {
				var toFirst:Vector3D = _helperV1;
				var toSecond:Vector3D = _helperV2;
				
				toFirst.x = result[0].x - origin.x;
				toFirst.y = result[0].y - origin.y;
				
				toSecond.x = result[1].x - origin.x;
				toSecond.y = result[1].y - origin.y;
				
				var dot:Number = toFirst.dotProduct(toSecond);
				if (dot<0) {
					result.shift();
				}
				
			}
			//smoothing
			if (result.length > 2) {
				var distanceToFirstFromEnd:Number = Vector3D.distance(result[result.length-3], result[result.length - 1]);
				var distanceToSecondFromEnd:Number = Vector3D.distance(result[result.length - 3], result[result.length - 2]);
				if (distanceToFirstFromEnd <= distanceToSecondFromEnd) {
					result.splice(result.length - 2, 1);
				}
			}
			
			return result;
			
		}
		
		public function isInFieldOfView(observer:Character, target:Character):Boolean
		{
			var angle:Number = -observer.position.worldAngleY;
			var heading:Vector3D = _helperV1;
			heading.x = Math.cos(angle);
			heading.y = Math.sin(angle);
			
			
			_helperP1.x = observer.position.worldCoordinates.x;
			_helperP1.y = observer.position.worldCoordinates.z;
			
			var toTarget:Vector3D = _helperV2;
			toTarget.x = target.position.worldCoordinates.x - _helperP1.x;
			toTarget.y = target.position.worldCoordinates.z - _helperP1.y;
			toTarget.z = 0;
			
			var dotProduct:Number = heading.dotProduct(toTarget);
			if (dotProduct <= 0) return false;
			for each(var wall:Wall in owner.walls) {
				
				if (wall.info.angleX != 0) continue;
				angle = -wall.info.angleY;
				
				_helperP2.x = wall.info.originX;
				_helperP2.y = wall.info.originZ;
				
				_helperV1.x = Math.cos(angle);
				_helperV1.y = Math.sin(angle);
				_helperV1.z = 0;
				
				_helperV1.scaleBy(wall.width);

				_intersectionHelper.test(_helperP1, _helperP2, toTarget, _helperV1)
				if (_intersectionHelper.validIntersection) {
					return false;
				}
			}
			
			
			return true;
		}
		
	}

}