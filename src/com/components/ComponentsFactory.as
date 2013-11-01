package com.components 
{
	import com.constants.AssetNamesConst;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class ComponentsFactory 
	{
		[Embed(source='../../../bin/assets/embeded/nokiafc22.ttf', fontName="applicationFont", mimeType = "application/x-font",advancedAntiAliasing="true",      embedAsCFF="false")]
		private var fontSource:Class
		
		static private var _instance:ComponentsFactory = new ComponentsFactory();
		
		public function ComponentsFactory() 
		{
			if (instance) {
				throw new Error("SNGTN");
				return;
			}
		}
		public function getTextFormat(size:int=14,color:uint=0):TextFormat
		{
			var result:TextFormat = new TextFormat();
			result.font = "applicationFont";
			result.size = size;
			result.color = color;
			
			return result;
		}
		
		public function getMenuItemFormatFroMainMenu():TextFormat
		{
			var result:TextFormat = getTextFormat(38, AssetNamesConst.COLOR_GREEN);
			
			return result;
		}
		
		public function getTextField(foramt:TextFormat):TextField
		{
			var result:TextField = new TextField();
			result.embedFonts = true;
			result.defaultTextFormat = foramt;
			return result;
		}
		
		static public function get instance():ComponentsFactory 
		{
			return _instance;
		}
		
	}

}