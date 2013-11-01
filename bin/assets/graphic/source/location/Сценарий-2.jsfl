
fl.getDocumentDOM().library.selectItem("souce/Solder_stay.png");
var sourceImage=fl.getDocumentDOM().library.getSelectedItems()[0];
sourceImage.addData("sourceImage","integer",1);

addTile(0,1487,118,26,43)



function getSourceImageItem()
{
	var document=fl.getDocumentDOM();
	var library=document.library;
	var appropriateItem
	
	
	for(var i=0;i<library.items.length;i++){
		var libraryItem=library.items[i];
		
		if(!libraryItem.hasData("sourceImage")){
			fl.trace("skiped");
			continue
		}
		if(libraryItem.getData("sourceImage")!=1){
			fl.trace("skiped");
			continue
		}
		fl.trace(libraryItem.name);
		appropriateItem=libraryItem;
		break
		
	}
	return appropriateItem

}

function addTile(tileIndex,x,y,width,height)
{
	var document=fl.getDocumentDOM()
	var library=document.library
	var tileFolderName="tiles/tile_"+tileIndex
	if(library.itemExists(tileFolderName)){
		library.deleteItem(tileFolderName);
	}
	library.newFolder(tileFolderName)
	
}