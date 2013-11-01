package com.controller.childs 
{
	import com.info.Info;
	import com.model.Model;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class BaseChildController 
	{
		
		public function BaseChildController() 
		{
			
		}
		public function onEnter():void
		{
			
		}
		public function onExit():void
		{
			
		}
		
		protected function get model():Model { return Facade.instance.model }
		protected function get view():Application { return Facade.instance.view }
		protected function get info():Info { return Facade.instance.info }
	}

}