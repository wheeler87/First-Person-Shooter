package com.screens.initialization 
{
	import com.components.ApplicationSprite;
	import com.components.ComponentsFactory;
	import com.components.LoaderIcon;
	import com.constants.AssetNamesConst;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class InitialiaztionScreen extends ApplicationSprite 
	{
		private var _width:Number;
		private var _height:Number;
		
		private var _loaderIcon:LoaderIcon
		private var _titleRenderer:TextField;
		
		
		public function InitialiaztionScreen(width:Number,height:Number):void
		{
			super();
			
			_width = width;
			_height = height;
			drawBG();
			addLoaderIcon();
			addTitleRenderer();
			align();
		}
		
		public function activate():void
		{
			align();
			_loaderIcon.activate();
		}
		public function deactivate():void
		{
			_loaderIcon.deactivate();
		}
		private function drawBG():void
		{
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(AssetNamesConst.COLOR_LIGHT_BLACK);
			g.drawRect(0, 0, _width, _height);
			
		}
		private function addLoaderIcon():void
		{
			_loaderIcon = new LoaderIcon();
			addChild(_loaderIcon);
		}
		private function addTitleRenderer():void
		{
			var format:TextFormat = ComponentsFactory.instance.getTextFormat(14, AssetNamesConst.COLOR_YELLOW);
			
			_titleRenderer = new TextField();
			_titleRenderer.defaultTextFormat = format;
			_titleRenderer.embedFonts = true;
			_titleRenderer.selectable = false;
			_titleRenderer.autoSize = TextFieldAutoSize.LEFT;
			
			_titleRenderer.text = "Loading game...";
			addChild(_titleRenderer);
		}
		private function align():void
		{
			_titleRenderer.x = (_width - _titleRenderer.width) * 0.5;
			_titleRenderer.y = _height * 0.5-_titleRenderer.height-5;
			
			_loaderIcon.x = _width * 0.5;
			_loaderIcon.y = _height * 0.5+_loaderIcon.height*0.5;
		}
	}

}