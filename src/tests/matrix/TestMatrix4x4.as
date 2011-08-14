package tests.matrix
{
	public class TestMatrix4x4
	{
		import math.Matrix4x4;
		
		import org.flexunit.Assert;
				
		[Test]  
		public function identity():void 
		{ 
			var matrix:Matrix4x4 = new Matrix4x4( ) ;
			matrix.identity();
			Assert.assertTrue( matrix.isIdentity());
		}

		
		[Test]  
		public function inverse():void 
		{ 
			var matrix:Matrix4x4 = getCabinetProjectionMatrix( ) ;
			matrix.identity();
			var inverse:Matrix4x4 = matrix.clone().inverse();
			var identity:Matrix4x4 = matrix.multiply(inverse);
			Assert.assertTrue( identity.isIdentity());
		}
		
		private function getCabinetProjectionMatrix( ):Matrix4x4
		{
			
			var right:int = 1 ;
			var left:int = -1 ;
			var top:int = 1 ;
			var bottom:int = -1 ;
			var nearZ:int = 20 ;
			var farZ:int = 40 ;
			
			var recipX:Number = 1.0/(right-left);
			var recipY:Number = 1.0/(top-bottom);
			var recipZ:Number = 1.0/(nearZ-farZ);
			
			var projection:Matrix4x4 = new Matrix4x4( ) ;
			projection.identity();
			
			
			//	This is the cos and sin of 45 degrees
			var halfsqrt2:Number = Math.SQRT2/2 ;
			
			projection.data[0] = 2.0*recipX;
			projection.data[8] = -halfsqrt2*recipX;
			projection.data[12] = (-halfsqrt2*nearZ - right - left)*recipX; 
			
			projection.data[5] = 2.0*recipY;
			projection.data[9] = -halfsqrt2*recipY;
			projection.data[13] = (-halfsqrt2*nearZ - top - bottom)*recipY;
			
			projection.data[10] = 2.0*recipZ;
			projection.data[14] = (nearZ+farZ)*recipZ;
			
			return projection ;
			
		}
	}
}