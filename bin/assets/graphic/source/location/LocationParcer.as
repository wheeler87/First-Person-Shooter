import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.net.FileReference;
import flash.text.TextField;
import flash.utils.getQualifiedClassName
import flash.system.ApplicationDomain;


var description:XML =<location/>;
var currentChild:DisplayObject
var floorNameReg:RegExp =/floorMap/i;
var roofNameReg:RegExp =/roofMap/i;
var wallNameReg:RegExp =/wall_/i;
var spawnerNameReg:RegExp =/spawner/i;
var navigationNameReg:RegExp=/navigation/i

var tileS:int;

var tiledW:int;
var tiledH:int;
var tiledD:int;

var locationWidth:Number;
var locationHeight:Number;
var locationDepth:Number;

setGeneralLocationParamers(description);
parceWalls(description);
parceSpawners(description);
parceNavigation(description);
makeSaveRequest(description);




function setGeneralLocationParamers(target:XML) {
	tileS = this.tileSize;
	
	tiledW = this.tiledWidth;
	tiledH = this.tiledHeight;
	tiledD = this.tiledDepth;
	
	locationWidth = tiledW * tileS;
	locationHeight = tiledH * tileS;
	locationDepth = tiledD * tileS;
	
	
	description["@tileSize"] = tileS;
	description["@tilesSource"] = this.tilesSource;
	description["@locationWidth"] = locationWidth;
	description["@locationHeight"] = locationHeight;
	description["@locationDepth"] = locationDepth;
	
}

function parceWalls(target:XML):void
{
	var wallDesciption:XML;

	for(var i:uint = 0; i < this.numChildren; i++ ) {
		currentChild = this.getChildAt(i);
		wallDesciption=<wall/>
		if (floorNameReg.test(currentChild.name)) {
			setWallMapData(currentChild, wallDesciption);
			setWallPositionData(wallDesciption, 0, locationHeight, locationDepth, -Math.PI * 0.5, 0);
			target.appendChild(wallDesciption);
			
		}else if (roofNameReg.test(currentChild.name)) {
			setWallMapData(currentChild, wallDesciption);
			setWallPositionData(wallDesciption, 0, 0, 0, Math.PI * 0.5, 0);
			target.appendChild(wallDesciption);
		}else if (wallNameReg.test(currentChild.name)) {
			var definitionName:String = currentChild.name.replace(wallNameReg, "");
			var wallSource:Class = ApplicationDomain.currentDomain.getDefinition(definitionName) as Class;
			var wallInstance:DisplayObject = new wallSource();
			
			setWallMapData(wallInstance, wallDesciption);
			setWallPositionData(wallDesciption, currentChild.x, 0, locationDepth - currentChild.y, 0, currentChild.rotation / 180.0 * Math.PI);
			target.appendChild(wallDesciption);
		}
	}
	
}
function parceSpawners(target:XML):void
{
	var length:int = (this as Sprite).numChildren;
	var child:DisplayObject;
	var spawnerDescription:XML
	for (var i:uint = 0; i < length; i++ ) {
		child = (this as Sprite).getChildAt(i);
		if (spawnerNameReg.test(child.name)) {
			spawnerDescription =<spawner/>;
			spawnerDescription["@x"] = child.x;
			spawnerDescription["@y"] = locationHeight;
			spawnerDescription["@z"] = locationDepth - child.y;
			
			target.appendChild(spawnerDescription);
		}
	}
}
function parceNavigation(target:XML):void
{
	var navigationDescription:XML =<navigation/>;
	target.appendChild(navigationDescription);
	
	var length:int = this.numChildren;
	var child:DisplayObjectContainer
	
	var length2:int
	var nodeSource:TextField;
	var nodeSourceS:String;
	var combinedSources:Array;
	var destinationNodeIndicesS:Array
	
	var originNodeIndex:int;
	var destinationNodeIndex:int;
	
	var nodeDescription:XML;
	var edgeDescription:XML;
	for (var i:uint = 0; i < length; i++ ) {
		child = this.getChildAt(i) as DisplayObjectContainer;
		if (!child) continue;
		if (navigationNameReg.test((child as DisplayObject).name)) {
			
			length2 = (child as DisplayObjectContainer).numChildren;
			for (var j:int = 0; j < length2; j++ ) {
				nodeSource = (child as DisplayObjectContainer).getChildAt(j) as TextField;
				if ((!nodeSource) || (!nodeSource.text) || (!nodeSource.text.length)) {
					continue;
				}
				nodeSourceS = nodeSource.text;
				combinedSources = nodeSourceS.split("_");
				destinationNodeIndicesS = (combinedSources[1] as String).split(",");
				
				originNodeIndex = parseInt(combinedSources[0]);
				
				nodeDescription =<node/>
				nodeDescription["@index"] = originNodeIndex;
				nodeDescription["@x"] = nodeSource.x;
				nodeDescription["@z"] = locationDepth - nodeSource.y;
				nodeDescription["@y"] = 0;
				
				navigationDescription.appendChild(nodeDescription);
				
				
				for (var k:uint = 0; k < destinationNodeIndicesS.length; k++ ) {
					if ((!destinationNodeIndicesS[k]) || (!(destinationNodeIndicesS[k] as String).length)) {
						continue;
					}
					destinationNodeIndex = parseInt(destinationNodeIndicesS[k]);
					
					edgeDescription =<edge/>;
					edgeDescription["@originNodeIndex"] = originNodeIndex;
					edgeDescription["@destinationNodeIndex"] = destinationNodeIndex;
					navigationDescription.appendChild(edgeDescription);

				}

			}
			
			
			
			
			break;
		}
	}
	
}

function makeSaveRequest(target:XML):void
{
	var reference:FileReference = new FileReference();
	(reference as FileReference).save(target, "locationDescription.xml");
}

function setWallMapData(source:DisplayObject, destination:XML):void
{
	var columns:int = Math.round((source as DisplayObject).width / tileS);
	var rows:int = Math.round((source as DisplayObject).height / tileS);
	
	
	var childs:Array = [];
	
	
	var childData:Object
	var tileName:String;
	
	for (var i:int = (source as MovieClip).numChildren-1; i >=0 ; i-- ) {
		childs.push((source as DisplayObjectContainer).getChildAt(i))
	}
	childs.sort(childSorter);
	var tilesString:String = "";
	for (i = 0; i < childs.length; i++ ) {
		tileName = getQualifiedClassName((childs[i] as Bitmap).bitmapData);
		if (i != 0) {
			tilesString+=","
		}
		tilesString += tileName;
	}
	
	destination["@columns"] = columns;
	destination["@rows"] = rows;
	destination["@tiles"] = tilesString;
	
}
function setWallPositionData(target:XML, originX:Number, originY:Number, originZ:Number, angleX:Number, angleY:Number):void
{
	target["@originX"] = originX;
	target["@originY"] = originY;
	target["@originZ"] = originZ;
	target["@angleX"] = angleX;
	target["@angleY"] = angleY;
}

function childSorter(a:flash.display.DisplayObject, b:flash.display.DisplayObject):int
{
	var aColumn:int = Math.round(a.x / tileS);
	var aRow:int = Math.round(a.y / tileS);
	
	var bColumn:int = Math.round(b.x / tileS);
	var bRow:int = Math.round(b.y / tileS);
	if ((aColumn < 0) || (aRow < 0)) {
		trace(aColumn, aRow);
	}
	
	if (aRow < bRow) return -1;
	if (aRow > bRow) return 1;
	if (aColumn < bColumn) return -1;
	if (aColumn > bColumn) return 1;
	return 0;
}