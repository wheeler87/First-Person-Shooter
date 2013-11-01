package  
{
	import com.components.ComponentsFactory;
	import com.geom.Matrix3D;
	import com.geom.Point2D;
	import com.geom.Point3D;
	import com.geom.Projection;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	[SWF(width="550", height="400", frameRate="25", backgroundColor="#CCCCCC")]
	public class Application extends Sprite 
	{
		private var _vertices:Vector.<Point3D>;
		private var _projectionP:Point2D;
		private var _camera:Sprite
		private var _focalLength:Number;
		
		private var _transformationMatrix:Matrix3D
		private var _origin:Point3D
		
		public function Application() 
		{
			super();
			Facade.instance.init(this);
			
			
			
			_vertices = new Vector.<Point3D>();
			_vertices.push(new Point3D( -100, -100, -100));
			_vertices.push(new Point3D( 100, -100, -100));
			_vertices.push(new Point3D( 100, 100, -100));
			_vertices.push(new Point3D( -100, 100, -100));
			_vertices.push(new Point3D( -100, -100, 100));
			_vertices.push(new Point3D( 100, -100, 100));
			_vertices.push(new Point3D( 100, 100, 100));
			_vertices.push(new Point3D( -100, 100, 100));
			
			_camera = new Sprite();
			addChild(_camera);
			
			_camera.x = stage.stageWidth * 0.5;
			_camera.y = stage.stageHeight * 0.5;
			
			_projectionP = new Point2D();
			_focalLength = 500;
			
			_transformationMatrix = new Matrix3D();
			_origin = new Point3D();
			//_origin.y = -20;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			applyTranformation();
			reRender();
		}
		
		private function applyTranformation():void
		{
			
			var angularStep:Number = Math.PI * 0.0001;
			//_transformationMatrix.rotateX(angularStep);
			//_transformationMatrix.rotateY(angularStep);
			//_transformationMatrix.rotateZ(angularStep);
			
			for each(var vertex:Point3D in _vertices) {
				_transformationMatrix.transform(vertex, _origin);
			}
		}
		
		private function reRender():void
		{
			//var g:Graphics = _camera.graphics;
			//g.clear();
			//g.beginFill(0);
			
			//for (var i:uint = 0; i < _vertices.length; i++ ) {
				//Projection.project(_vertices[i], _focalLength, _projectionP);
				//g.drawCircle(_projectionP.x, _projectionP.y, 5);
			//}
		}
		
	}

}