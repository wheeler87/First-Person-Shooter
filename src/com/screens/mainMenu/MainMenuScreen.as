package com.screens.mainMenu 
{
	import com.components.ApplicationSprite;
	import com.components.ComponentsFactory;
	import com.constants.AssetNamesConst;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
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
	[Event(name="play_selected", type="com.screens.mainMenu.MainMenuScreen")]
	[Event(name="instructions_selected", type="com.screens.mainMenu.MainMenuScreen")]
	[Event(name="home_page_selected", type="com.screens.mainMenu.MainMenuScreen")]
	public class MainMenuScreen extends ApplicationSprite 
	{
		static public const PLAY_SELECTED:String = "play_selected";
		static public const INSTRUCTIONS_SELECTED:String = "instructions_selected";
		static public const HOME_PAGE_SELECTED:String = "home_page_selected";
		
		private var _width:Number
		private var _height:Number;
		
		private var _menusContainer:Sprite
		private var _menusList:Vector.<TextField>;
		
		private var _playMenuItem:TextField;
		private var _instructionsMenuItem:TextField;
		private var _homePage:TextField
		
		
		public function MainMenuScreen(width:Number,height:Number):void
		{
			super();
			
			_width = width;
			_height = height;
			
			drawBG();
			addMenuItems();
			addHomePage();
			align();
			
		}
		private function drawBG():void
		{
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(AssetNamesConst.COLOR_LIGHT_BLACK);
			g.drawRect(0, 0, _width, _height);
		}
		
		private function addMenuItems():void
		{
			_menusContainer = new Sprite();
			_menusList = new Vector.<TextField>();
			
			_playMenuItem = createMenuItem("Play",PLAY_SELECTED);
			_instructionsMenuItem = createMenuItem("Instructions",INSTRUCTIONS_SELECTED);
			_menusList.push(_playMenuItem);
			_menusList.push(_instructionsMenuItem);
			
			var currentMenuItem:TextField
			for (var i:uint = 0; i < _menusList.length; i++ ) {
				currentMenuItem = _menusList[i];
				_menusContainer.addChild(currentMenuItem);
			}
			addChild(_menusContainer);
			
			
			
		}
		
		private function createMenuItem(label:String,relatedEventType:String):TextField
		{
			var format:TextFormat = ComponentsFactory.instance.getMenuItemFormatFroMainMenu();
			
			var menu:TextField = new TextField();
			menu.defaultTextFormat = format;
			menu.autoSize = TextFieldAutoSize.LEFT;
			menu.embedFonts = true;
			menu.selectable = false;
			
			
			menu.text = label;
			menu.name = relatedEventType;
			menu.addEventListener(MouseEvent.ROLL_OVER, onMenuItemOver);
			menu.addEventListener(MouseEvent.ROLL_OUT, onMenuItemOut);
			menu.addEventListener(MouseEvent.CLICK, onMenuItemClick);
			return menu
		}
		
		private function onMenuItemClick(e:MouseEvent):void 
		{
			var menu:DisplayObject = e.currentTarget as DisplayObject;
			var eventType:String = menu.name;
			dispatchEvent(new Event(eventType));
		}
		
		private function onMenuItemOut(e:MouseEvent):void 
		{
			var menu:DisplayObject = e.currentTarget as DisplayObject;
			menu.filters = null;
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function onMenuItemOver(e:MouseEvent):void 
		{
			var menu:DisplayObject = e.currentTarget as DisplayObject;
			menu.filters = [AssetNamesConst.WHITE_LINE_THIN_4];
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		private function addHomePage():void
		{
			var format:TextFormat = ComponentsFactory.instance.getTextFormat(12, AssetNamesConst.COLOR_BLUE);
			_homePage = new TextField();
			_homePage.embedFonts = true;
			_homePage.defaultTextFormat = format;
			_homePage.selectable = false;
			_homePage.autoSize = TextFieldAutoSize.LEFT;
			
			_homePage.text = "home page";
			
			_homePage.addEventListener(MouseEvent.ROLL_OVER, homepageMouseHandler);
			_homePage.addEventListener(MouseEvent.ROLL_OUT, homepageMouseHandler);
			_homePage.addEventListener(MouseEvent.CLICK, homepageMouseHandler);
			
			addChild(_homePage);
		}
		
		
		private function align():void
		{
			var currentMenuItem:TextField
			var menuGroupWidth:Number = _menusContainer.width;
			for (var i:uint = 0; i < _menusList.length; i++ ) {
				currentMenuItem = _menusList[i];
				currentMenuItem.x = (menuGroupWidth - currentMenuItem.width) * 0.5;
				currentMenuItem.y = i * 50;
				
			}
			_menusContainer.x = (_width - _menusContainer.width) * 0.5;
			_menusContainer.y = 115;
			
			_homePage.x = 10;
			_homePage.y = _height - _homePage.height - 2;
		}
		
		public function activate():void
		{
			align();
			for each(var menuItem:TextField in _menusList) {
				menuItem.filters = null;
			}
		}
		public function deactivate():void
		{
			Mouse.cursor = MouseCursor.AUTO;
			stage.focus = null;
		}
		
		private function homepageMouseHandler(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case MouseEvent.ROLL_OVER:
					Mouse.cursor = MouseCursor.BUTTON;
				break;
				case MouseEvent.ROLL_OUT:
					Mouse.cursor = MouseCursor.AUTO;
				break;
				case MouseEvent.CLICK:
					dispatchEvent(new Event(HOME_PAGE_SELECTED));
				break;
				
			}
		}
	}

}