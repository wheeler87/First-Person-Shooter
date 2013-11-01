package  
{
	import com.controller.GlobalController;
	import com.info.Info;
	import com.model.Model;
	
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Facade 
	{
		static private var _instance:Facade = new Facade();
		
		private var _view:Application;
		private var _model:Model;
		private var _controller:GlobalController
		
		private var _info:Info
		
		public function Facade() 
		{
			if (instance) {
				throw new Error("asas");
				return;
			}
		}
		
		public function init(view:Application):void
		{
			_info = new Info();
			
			
			_view = view;
			_model = new Model();
			_controller = new GlobalController();
			_controller.init();
		}
		
		
		
		static public function get instance():Facade 
		{
			return _instance;
		}
		
		public function get model():Model 
		{
			return _model;
		}
		
		public function get controller():GlobalController 
		{
			return _controller;
		}
		
		public function get view():Application 
		{
			return _view;
		}
		
		public function get info():Info {return _info;}
		
	}

}