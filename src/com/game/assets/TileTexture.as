package com.game.assets 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class TileTexture 
	{
		private static const PADDING:int = 2;
		
		public var topTriangleTexture:Sprite
		public var bottomTriangleTexture:Sprite;
		public var width:Number
		public var height:Number
		
		public function TileTexture() 
		{
			
		}
		public function init(sourcePixels:BitmapData):void
		{
			width = sourcePixels.width;
			height = sourcePixels.height;
			
			topTriangleTexture = new Sprite();
			bottomTriangleTexture = new Sprite();
			
			var helperB:Bitmap;
			var helperBD:BitmapData
			
			var g:Graphics = topTriangleTexture.graphics;
			g.beginBitmapFill(sourcePixels);
			g.moveTo(0, 0);
			g.lineTo(sourcePixels.width,0);
			g.lineTo(0, sourcePixels.height);
			g.lineTo(0, 0);
			
			//seams avoidance
			g.moveTo(0, sourcePixels.height);
			g.lineTo(sourcePixels.width * 0.8, sourcePixels.height * 0.8);
			g.lineTo(sourcePixels.width, 0);
			g.lineTo(0, sourcePixels.height);
			
			helperB = new Bitmap();
			helperBD = new BitmapData(sourcePixels.width, sourcePixels.height, true, 0);
			helperBD.draw(topTriangleTexture);
			helperB.bitmapData = helperBD;
			
			g.clear();
			topTriangleTexture.addChild(helperB);
			
			
			g = bottomTriangleTexture.graphics;
			
			g.beginBitmapFill(sourcePixels);
			g.moveTo(0, sourcePixels.height);
			g.lineTo(sourcePixels.width, 0);
			g.lineTo(sourcePixels.width, sourcePixels.height);
			g.lineTo(0, sourcePixels.height);
			
			//seams avoidance
			g.drawRect(0, sourcePixels.height, sourcePixels.width + PADDING, PADDING);
			g.drawRect(sourcePixels.width, 0, PADDING, sourcePixels.height);
			
			helperB = new Bitmap();
			helperBD = new BitmapData(sourcePixels.width+PADDING, sourcePixels.height+PADDING, true, 0);
			helperBD.draw(bottomTriangleTexture);
			helperB.bitmapData = helperBD;
			helperB.x = -sourcePixels.width;
			helperB.y = -sourcePixels.height;
			
			
			g.clear();
			bottomTriangleTexture.addChild(helperB);
			
		}
	}

}