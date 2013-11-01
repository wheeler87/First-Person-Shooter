package com.screens.istructions 
{
	import com.components.ApplicationSprite;
	import com.components.ComponentsFactory;
	import com.constants.AssetNamesConst;
	import com.model.Model;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	[Event(name="play_request", type="com.screens.istructions.InstructionsScreen")]
	[Event(name="back_request", type="com.screens.istructions.InstructionsScreen")]
	public class InstructionsScreen extends ApplicationSprite 
	{
		static public const PLAY_REQUEST:String = "play_request";
		static public const BACK_REQUEST:String = "back_request";
		
		private var _width:Number;
		private var _height:Number;
		private var _descriptionsIndentLeft:int = 50;
		private var _descriptionsIndentRight:int = 10;
		
		private var _model:Model
		
		private var _aboutGameTitleRenderer:TextField;
		private var _aboutGameDescriptionRenderer:TextField;
		private var _controllTitleRenderer:TextField;
		private var _controllDescriptionRenderer:TextField;
		
		private var _playMenuItem:TextField;
		private var _backMenuItem:TextField;
		
		public function InstructionsScreen(width:Number,height:Number) 
		{
			super();
			_width = width;
			_height = height;
			_model = Facade.instance.model;
			drawBG();
			createMenuItems();
			createTextRenderers();
			align();
		}
		
		private function drawBG():void
		{
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(AssetNamesConst.COLOR_LIGHT_BLACK);
			g.drawRect(0, 0, _width, _height);
		}
		private function createMenuItems():void
		{
			_backMenuItem = createMenuItem("Back", BACK_REQUEST);
			_playMenuItem = createMenuItem("Play", PLAY_REQUEST);
		}
		private function createTextRenderers():void
		{
			_aboutGameTitleRenderer = createTitleRenderer("About Game:");
			_controllTitleRenderer = createTitleRenderer("Controls:");
			
			var descriptionFieldWidth:int = _width - _descriptionsIndentLeft - _descriptionsIndentRight;
			_controllDescriptionRenderer = createDescriptionRenderer(_model.controllText, descriptionFieldWidth);
			_aboutGameDescriptionRenderer = createDescriptionRenderer(_model.aboutGameText, descriptionFieldWidth);
		}
		
		
		private function createMenuItem(label:String, relatedEventType:String):TextField
		{
			var format:TextFormat = ComponentsFactory.instance.getTextFormat(24, AssetNamesConst.COLOR_GREEN);
			
			var result:TextField = new TextField();
			result.embedFonts = true;
			result.defaultTextFormat = format;
			result.selectable = false;
			result.autoSize = TextFieldAutoSize.LEFT;
			
			result.addEventListener(MouseEvent.CLICK, menuItemMouseHander);
			result.addEventListener(MouseEvent.ROLL_OVER, menuItemMouseHander);
			result.addEventListener(MouseEvent.ROLL_OUT, menuItemMouseHander);
			
			addChild(result);
			
			result.text = label;
			result.name = relatedEventType;
			return result;
		}
		private function createTitleRenderer(label:String):TextField
		{
			var format:TextFormat = ComponentsFactory.instance.getTextFormat(22, AssetNamesConst.COLOR_WHITE);
			var result:TextField = new TextField();
			result.defaultTextFormat = format;
			result.embedFonts = true;
			result.selectable = false;
			result.autoSize = TextFieldAutoSize.LEFT;
			
			addChild(result);
			
			result.text = label;
			return result;
			
		}
		
		private function createDescriptionRenderer(text:String,width:Number):TextField
		{
			var format:TextFormat = ComponentsFactory.instance.getTextFormat(18, AssetNamesConst.COLOR_YELLOW);
			var result:TextField = new TextField();
			result.defaultTextFormat = format;
			result.embedFonts = true;
			result.selectable = false;
			result.autoSize = TextFieldAutoSize.LEFT;
			result.wordWrap = true;
			result.multiline = true;
			result.width = width;
			
			addChild(result);
			
			result.text = text;
			return result;
		}
		
		private function menuItemMouseHander(e:MouseEvent):void 
		{
			var menuItem:DisplayObject = e.currentTarget as DisplayObject;
			switch (e.type) 
			{
				case MouseEvent.ROLL_OVER:
					menuItem.filters = [AssetNamesConst.WHITE_LINE_THIN_4];
					Mouse.cursor = MouseCursor.BUTTON;
				break;
				case MouseEvent.ROLL_OUT:
					menuItem.filters = null;
					Mouse.cursor = MouseCursor.AUTO;
				break;
				case MouseEvent.CLICK:
					var eventType:String = menuItem.name;
					dispatchEvent(new Event(eventType));
				break;
				
			}
		}
		private function align():void
		{
			_controllTitleRenderer.x = 10;
			_controllTitleRenderer.y = 30;
			
			_controllDescriptionRenderer.x = _descriptionsIndentLeft;
			_controllDescriptionRenderer.y = _controllTitleRenderer.y + _controllTitleRenderer.height + 5;
			
			_aboutGameTitleRenderer.x = 10;
			_aboutGameTitleRenderer.y = _controllDescriptionRenderer.y + _controllDescriptionRenderer.height + 5;
			
			_aboutGameDescriptionRenderer.x = _descriptionsIndentLeft;
			_aboutGameDescriptionRenderer.y = _aboutGameTitleRenderer.y + _aboutGameTitleRenderer.height + 5;
			
			_backMenuItem.x = 10;
			_backMenuItem.y = _height - _backMenuItem.height - 10;
			
			_playMenuItem.x = _width-_playMenuItem.width-10;
			_playMenuItem.y = _height - _playMenuItem.height - 10;
			
		}
		
		
		public function activate():void
		{
			align();
		}
		public function deactivate():void
		{
			Mouse.cursor = MouseCursor.AUTO;
			_backMenuItem.filters = null;
			_playMenuItem.filters = null;
			stage.focus = null;
		}
	}

}