package com.game.entity.components.indicator 
{
	import com.components.ComponentsFactory;
	import com.constants.AssetNamesConst;
	import com.game.entity.components.BaseComponent;
	import com.game.entity.components.influence.InfluenceName;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Indicator extends BaseComponent 
	{
		static public const NAME:String = "Indicator";
		static public const DISPLAY_BLOOD_DURATION:int = 1000;
		
		private var _helperM:Matrix = new Matrix();
		
		public var displaySighn:Boolean;
		public var displayBloodRequest:Boolean
		public var displayBlood:Boolean;
		
		public var timeToDisplayBlood:int
		
		public var sight:Sight;
		public var blood:Blood;
		public var bulletsInCageRenderer:TextField
		public var healthRenderer:TextField;
		
		
		public function Indicator():void
		{
			super(NAME);
			
			
			createSight();
			crateBulletsInCageRenderer();
			createHealthRenderer();
			createBlood();
			
			
			registerInfluenceHandler(InfluenceName.DAMAGED, onDamaged);
		}
		
		private function createSight():void
		{
			sight = new Sight();
			displaySighn = true;
			
		}
		
		private function crateBulletsInCageRenderer():void
		{
			bulletsInCageRenderer = new TextField();
			bulletsInCageRenderer.defaultTextFormat = ComponentsFactory.instance.getTextFormat(18, AssetNamesConst.COLOR_RED);
			bulletsInCageRenderer.filters=[AssetNamesConst.WHITE_LINE_THIN]
			bulletsInCageRenderer.embedFonts = true;
			bulletsInCageRenderer.text = "";
			bulletsInCageRenderer.autoSize = TextFieldAutoSize.LEFT;
			
			
		}
		
		private function createHealthRenderer():void
		{
			var format:TextFormat = ComponentsFactory.instance.getTextFormat(18, AssetNamesConst.COLOR_RED);
			
			
			
			healthRenderer = new TextField();
			healthRenderer.embedFonts = true;
			healthRenderer.filters = [AssetNamesConst.WHITE_LINE_THIN];
			healthRenderer.defaultTextFormat = format;
			healthRenderer.autoSize = TextFieldAutoSize.LEFT;
			
			healthRenderer.text = "";
		}
		
		private function createBlood():void
		{
			blood = new Blood();
		}
		
		public function render(screenPixels:BitmapData):void
		{
			if (displaySighn) {
				_helperM.identity();
				_helperM.translate(screenPixels.width * 0.5, screenPixels.height * 0.5);
				sight.rebuild();
				screenPixels.draw(sight, _helperM);
			}
			_helperM.identity();
			_helperM.translate(screenPixels.width - 180, 10);
			screenPixels.draw(bulletsInCageRenderer, _helperM);
			
			_helperM.identity();
			_helperM.translate(screenPixels.width - 180, 40);
			screenPixels.draw(healthRenderer, _helperM);
			
			if (displayBlood) {
				_helperM.identity();
				_helperM.translate(screenPixels.width * 0.4, screenPixels.height * 0.4);
				screenPixels.draw(blood, _helperM);
			}
		}
		private function onDamaged():void
		{
			displayBloodRequest = true;
		}
	}

}