package com.game.plugins.navigation 
{
	import com.info.components.location.navigation.Edge;
	import com.info.components.location.navigation.NavigationInfo;
	import com.info.components.location.navigation.Node;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class NavigationUtil 
	{
		private var _info:NavigationInfo
		
		private var _parentCostDict:Dictionary;
		private var _totalPriceDict:Dictionary
		
		private var _endIndex:int
		
		private var _exploredEdges:Vector.<Edge>
		private var _result:Vector.<Edge> 
		
		public function NavigationUtil() 
		{
			
		}
		public function search(startIndex:int, endIndex:int, info:NavigationInfo):Vector.<Edge>
		{
			_result= new Vector.<Edge>();
			if (startIndex == endIndex) return _result;
			
			
			
			_info = info;
			_parentCostDict = new Dictionary();
			_totalPriceDict = new Dictionary();
			_exploredEdges = new Vector.<Edge>();
			_endIndex = endIndex;
			
			var currentNodeIndex:int = startIndex;
			var currentParentPrice:int = 0;
			var currentEdge:Edge
			while (currentNodeIndex!=endIndex) {
				addNeighbors(currentNodeIndex, currentParentPrice);
				_exploredEdges.sort(edgesSorter);
				
				if (!_exploredEdges.length) {
					break;
				}
				currentEdge = _exploredEdges.shift();
				
				_result.push(currentEdge);
				currentNodeIndex = currentEdge.destinationNodeIndex;
			}
			return _result;
		}
		private function addNeighbors(nodeIndex:int,parentPrice:int):void
		{
			var group:Vector.<Edge> = _info.getEdgesByOrigin(nodeIndex);
			
			var edgeParentPrice:Number
			var edgeHeuristic:Number
			var edgeTotalPrice:Number;
			for each(var currentEdge:Edge in group) {
				if (getEdgeByDestinationIndex(currentEdge.destinationNodeIndex, _result)) {
					continue;
				}
				
				
				//if (_result.indexOf(currentEdge) >= (0)) {
					//continue;
				//}
				
				edgeParentPrice = parentPrice + currentEdge.length;
				edgeHeuristic = calculateHeuristic(currentEdge.destinationNodeIndex);
				
				if (_exploredEdges.indexOf(currentEdge)>=0) {
					edgeParentPrice = getEdgeParentPrice(currentEdge);
					edgeTotalPrice = getTotalPrice(currentEdge);
					if (edgeTotalPrice < (edgeParentPrice + edgeHeuristic)) {
						setEdgeParentPrice(currentEdge, edgeParentPrice);
						setTotalPrice(currentEdge, edgeParentPrice + edgeHeuristic);
					}
					
					
				}else {
					setEdgeParentPrice(currentEdge, edgeParentPrice);
					setTotalPrice(currentEdge, edgeParentPrice + edgeHeuristic);
					_exploredEdges.push(currentEdge);
				}
			}
		}
		
		
		private function getEdgeParentPrice(edge:Edge):Number
		{
			var result:Number = (_parentCostDict[edge])?_parentCostDict[edge]:0;
			return result;
		}
		private function setEdgeParentPrice(edge:Edge, price:Number):void
		{
			_parentCostDict[edge] = price;
		}
		private function getTotalPrice(edge:Edge):Number
		{
			var result:Number = (_totalPriceDict[edge])?_totalPriceDict[edge]:0;
			return result;
		}
		private function setTotalPrice(edge:Edge, price:Number):void
		{
			_totalPriceDict[edge] = price;
		}
		
		private function calculateHeuristic(edgeDestinationNodeIndex:int):Number
		{
			var edgeNode:Node = _info.getNodeByIndex(edgeDestinationNodeIndex);
			var endNode:Node = _info.getNodeByIndex(_endIndex);
			var heuristic:Number = Vector3D.distance(edgeNode.position, endNode.position);
			return heuristic;
			
		}
		
		private function edgesSorter(a:Edge, b:Edge):int
		{
			var aGPrice:Number = getTotalPrice(a);
			var bGPrice:Number = getTotalPrice(b);
			if (aGPrice < bGPrice) return -1;
			if (aGPrice > bGPrice) return 1;
			return 0;
		}
		private function getEdgeByDestinationIndex(destinationIndex:int,group:Vector.<Edge>):Edge {
			for each(var currentEdge:Edge in group) {
				if (currentEdge.destinationNodeIndex == destinationIndex) {
					return currentEdge;
				}
			}
			return null
		}
	}

}