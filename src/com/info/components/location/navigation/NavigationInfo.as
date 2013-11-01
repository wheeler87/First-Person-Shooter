package com.info.components.location.navigation 
{
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class NavigationInfo 
	{
		
		private var _nodesList:Vector.<Node>;
		private var _edgesList:Vector.<Edge>;
		
		private var _nodesDict:Dictionary;
		private var _edgesGroupsDict:Dictionary;
		
		
		public function NavigationInfo() 
		{
			
		}
		public function init(source:XML):void
		{
			_nodesList = new Vector.<Node>();
			_edgesList = new Vector.<Edge>();
			
			_nodesDict = new Dictionary();
			_edgesGroupsDict = new Dictionary();
			
			var currentNode:Node
			for each(var nodeSource:XML in source["node"]) {
				currentNode = new Node();
				currentNode.index = parseInt(nodeSource["@index"]);
				currentNode.position.x= parseInt(nodeSource["@x"]);
				currentNode.position.y= parseInt(nodeSource["@y"]);
				currentNode.position.z = parseInt(nodeSource["@z"]);
				
				_nodesList.push(currentNode);
				_nodesDict[currentNode.index] = currentNode;
				_edgesGroupsDict[currentNode.index] = new Vector.<Edge>();
				
			}
			var currentEdge:Edge;
			var edgesGroup:Vector.<Edge>
			for each(var edgeSource:XML in source["edge"])
			{
				currentEdge = new Edge();
				currentEdge.originNodeIndex = parseInt(edgeSource["@originNodeIndex"]);
				currentEdge.destinationNodeIndex = parseInt(edgeSource["@destinationNodeIndex"]);
				var originNode:Node = getNodeByIndex(currentEdge.originNodeIndex);
				var destinationNode:Node = getNodeByIndex(currentEdge.destinationNodeIndex);
				currentEdge.length = Vector3D.distance(originNode.position, destinationNode.position);
				
				_edgesList.push(currentEdge);
				edgesGroup = getEdgesByOrigin(currentEdge.originNodeIndex);
				edgesGroup.push(currentEdge);
			}
			
		}
		
		public function getNodeByIndex(nodeIndex:int):Node
		{
			var result:Node = _nodesDict[nodeIndex];
			return result;
			
		}
		public function getEdgesByOrigin(originNodeIndex:int):Vector.<Edge>
		{
			var result:Vector.<Edge> = _edgesGroupsDict[originNodeIndex];
			return result;
		}
		
		public function get nodesList():Vector.<Node> 
		{
			return _nodesList;
		}
	}

}