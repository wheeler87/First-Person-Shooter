package com.screens.preparation 
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
	public class PreparationScreen extends ApplicationSprite 
	{
		private var _width:Number;
		private var _height:Number;
		
		private var _loaderIcon:LoaderIcon;
		private var _labelRenderer:TextField;
		
		
		public function PreparationScreen(width:Number,height:Number) 
		{
			super();
			_width = width;
			_height = height;
			
			drawBG();
			addLoaderIcon();
			addLabelRenderer();
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
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(AssetNamesConst.COLOR_LIGHT_BLACK);
			g.drawRect(0, 0, _width, _height);
		}
		private function addLoaderIcon():void
		{
			_loaderIcon = new LoaderIcon();
			addChild(_loaderIcon);
		}
		private function addLabelRenderer():void
		{
			var format:TextFormat = ComponentsFactory.instance.getTextFormat(14, AssetNamesConst.COLOR_YELLOW);
			_labelRenderer = new TextField();
			_labelRenderer.defaultTextFormat = format;
			_labelRenderer.embedFonts = true;
			_labelRenderer.autoSize = TextFieldAutoSize.LEFT;
			
			_labelRenderer.text = "Loadin location...";
			addChild(_labelRenderer);
			
		}
		private function align():void
		{
			_labelRenderer.x = (_width - _labelRenderer.width) * 0.5;
			_labelRenderer.y = (_height) * 0.5 - _labelRenderer.height - 5;
			
			_loaderIcon.x = _width * 0.5;
			_loaderIcon.y = _height * 0.5; +_loaderIcon.height * 0.5;
		}
	}

}