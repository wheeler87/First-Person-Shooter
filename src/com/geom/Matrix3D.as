package com.geom 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Viacheslav.Kolesnyk
	 */
	public class Matrix3D 
	{
		static private var _helper1:Matrix3D = new Matrix3D();
		static private var _helper2:Matrix3D = new Matrix3D();
		
		public var a11:Number;
		public var a12:Number;
		public var a13:Number;
		public var a14:Number
		
		public var a21:Number;
		public var a22:Number;
		public var a23:Number;
		public var a24:Number;
		
		public var a31:Number;
		public var a32:Number;
		public var a33:Number;
		public var a34:Number;
		
		public function Matrix3D() 
		{
			
			identity();
		}
		public function transform(target:Point3D, origin:Point3D = null):void
		{
			var originX:Number=0;
			var originY:Number=0;
			var originZ:Number=0;
			if (origin) {
				originX = origin.x;
				originY = origin.y;
				originZ = origin.z;
			}
			var startX:Number = target.x-originX;
			var startY:Number = target.y-originY;
			var startZ:Number = target.z-originZ;
			
			target.x = startX * a11 + startY * a12 + startZ * a13+a14+originX;
			target.y = startX * a21 + startY * a22 + startZ * a23+a24+originY;
			target.z = startX * a31 + startY * a32 + startZ * a33+a34+originZ;
		}
		
		public function transformVector(target:Vector3D, origin:* = null):void
		{
			var originX:Number=0;
			var originY:Number=0;
			var originZ:Number=0;
			if (origin) {
				originX = origin.x;
				originY = origin.y;
				originZ = origin.z;
			}
			var startX:Number = target.x-originX;
			var startY:Number = target.y-originY;
			var startZ:Number = target.z-originZ;
			
			target.x = startX * a11 + startY * a12 + startZ * a13+a14+originX;
			target.y = startX * a21 + startY * a22 + startZ * a23+a24+originY;
			target.z = startX * a31 + startY * a32 + startZ * a33+a34+originZ;
		}
		
		
		
		public function tranformGroup(group:Vector.<Point3D>, origin:Point3D=null):void
		{
			for each(var point:Point3D in group) {
				transform(point, origin);
			}
		}
		
		public function rotateX(value:Number):void
		{
			_helper1.identity();
			_helper1.a22 = Math.cos(value);
			_helper1.a23 = -Math.sin(value);
			
			_helper1.a32 = Math.sin(value);
			_helper1.a33 = Math.cos(value);
			
			_helper2.stamp(this);
			
			multiplyMatrices(_helper1, _helper2, this);
		}
		public function rotateY(value:Number):void
		{
			_helper1.identity();
			_helper1.a11 = Math.cos(value);
			_helper1.a13 = Math.sin(value);
			
			_helper1.a31 = -Math.sin(value);
			_helper1.a33 = Math.cos(value);
			
			_helper2.stamp(this);
			multiplyMatrices(_helper1, _helper2, this);
		}
		
		public function rotateZ(value:Number):void
		{
			_helper1.identity();
			_helper1.a11 = Math.cos(value);
			_helper1.a12 = -Math.sin(value);
			_helper1.a21 = Math.sin(value);
			_helper1.a22 = Math.cos(value);
			
			_helper2.stamp(this);
			
			multiplyMatrices(_helper1, _helper2, this);
		}
		public function translate(dx:Number, dy:Number, dz:Number):void
		{
			_helper1.identity();
			
			_helper1.a14 = dx;
			_helper1.a24 = dy;
			_helper1.a34 = dz;
			
			_helper2.stamp(this);
			multiplyMatrices(_helper1, _helper2, this);
		}
		
		public function stamp(source:Matrix3D):void 
		{
			a11 = source.a11;
			a12 = source.a12;
			a13 = source.a13;
			a14 = source.a14;
			
			a21 = source.a21;
			a22 = source.a22;
			a23 = source.a23;
			a24 = source.a24;
			
			a31 = source.a31;
			a32 = source.a32;
			a33 = source.a33;
			a34 = source.a34;
			
		}
		
		public function identity():void
		{
			a11 = 1;
			a22 = 1;
			a33 = 1;
			
			a12 = 0;
			a13 = 0;
			a14 = 0;
			
			a21 = 0;
			a23 = 0;
			a24 = 0;
			
			a31 = 0;
			a32 = 0;
			a34 = 0;
		}
		static public function multiplyMatrices(leftM:Matrix3D, rightM:Matrix3D, resultM:Matrix3D = null):Matrix3D
		{
			if (!resultM) {
				resultM = new Matrix3D();
			}
			resultM.a11 = leftM.a11 * rightM.a11 + leftM.a12 * rightM.a21 + leftM.a13 * rightM.a31;
			resultM.a12 = leftM.a11 * rightM.a12 + leftM.a12 * rightM.a22 + leftM.a13 * rightM.a32;
			resultM.a13 = leftM.a11 * rightM.a13 + leftM.a12 * rightM.a23 + leftM.a13 * rightM.a33;
			resultM.a14 = leftM.a11 * rightM.a14 + leftM.a12 * rightM.a24 + leftM.a13 * rightM.a34+leftM.a14;
			
			resultM.a21 = leftM.a21 * rightM.a11 + leftM.a22 * rightM.a21 + leftM.a23 * rightM.a31;
			resultM.a22 = leftM.a21 * rightM.a12 + leftM.a22 * rightM.a22 + leftM.a23 * rightM.a32;
			resultM.a23 = leftM.a21 * rightM.a13 + leftM.a22 * rightM.a23 + leftM.a23 * rightM.a33;
			resultM.a24 = leftM.a21 * rightM.a14 + leftM.a22 * rightM.a24 + leftM.a23 * rightM.a34+leftM.a24;
			
			resultM.a31 = leftM.a31 * rightM.a11 + leftM.a32 * rightM.a21 + leftM.a33 * rightM.a31;
			resultM.a32 = leftM.a31 * rightM.a12 + leftM.a32 * rightM.a22 + leftM.a33 * rightM.a32;
			resultM.a33 = leftM.a31 * rightM.a13 + leftM.a32 * rightM.a23 + leftM.a33 * rightM.a33;
			resultM.a34 = leftM.a31 * rightM.a14 + leftM.a32 * rightM.a24 + leftM.a33 * rightM.a34+leftM.a34;
			
			return resultM;
		}
		
		
		
	}

}