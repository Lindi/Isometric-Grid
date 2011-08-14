package math
{
	import flash.geom.Vector3D;

	public class Matrix4x4
	{
		public var data:Vector.<Number> ;
		
		public function Matrix4x4( data:Vector.<Number> = null )
		{
			if ( data != null )
				this.data = data ;
			else this.data = new Vector.<Number>(16);
		}
		
		public function copy( matrix:Matrix4x4 ):void
		{
			data[0] = matrix.data[0];
			data[1] = matrix.data[1];
			data[2] = matrix.data[2];
			data[3] = matrix.data[3];
			data[4] = matrix.data[4];
			data[5] = matrix.data[5];
			data[6] = matrix.data[6];
			data[7] = matrix.data[7];
			data[8] = matrix.data[8];
			data[9] = matrix.data[9];
			data[10] = matrix.data[10];
			data[11] = matrix.data[11];
			data[12] = matrix.data[12];
			data[13] = matrix.data[13];
			data[14] = matrix.data[14];
			data[15] = matrix.data[15];
			
		}
		
		public function clone():Matrix4x4
		{
			var matrix:Matrix4x4 = new Matrix4x4( ) ;
			matrix.copy( this );
			return matrix ;
		}
		
		public function identity( ):Matrix4x4
		{
			data[0] = 1.0;
			data[1] = 0.0;
			data[2] = 0.0;
			data[3] = 0.0;
			data[4] = 0.0;
			data[5] = 1.0;
			data[6] = 0.0;
			data[7] = 0.0;
			data[8] = 0.0;
			data[9] = 0.0;
			data[10] = 1.0;
			data[11] = 0.0;
			data[12] = 0.0;
			data[13] = 0.0;
			data[14] = 0.0;
			data[15] = 1.0;
			return this ;
		}
		
		public function inverse( ):Matrix4x4
		{
			return Inverse( this ) ;
		}
		
		public function transpose():Matrix4x4
		{
			var temp:Number = data[1];
			data[1] = data[4];
			data[4] = temp;
			
			temp = data[2];
			data[2] = data[8];
			data[8] = temp;
			
			temp = data[3];
			data[2] = data[12];
			data[12] = temp;
			
			temp = data[6];
			data[6] = data[9];
			data[9] = temp;
			
			temp = data[7];
			data[7] = data[13];
			data[13] = temp;
			
			temp = data[11];
			data[11] = data[14];
			data[14] = temp;
			
			return this ;
		}
		
		
		
		public function translate( vector:Vector3D ):Matrix4x4
		{
			data[0] = 1.0;
			data[1] = 0.0;
			data[2] = 0.0;
			data[3] = 0.0;
			data[4] = 0.0;
			data[5] = 1.0;
			data[6] = 0.0;
			data[7] = 0.0;
			data[8] = 0.0;
			data[9] = 0.0;
			data[10] = 1.0;
			data[11] = 0.0;
			data[12] = vector.x;
			data[13] = vector.y;
			data[14] = vector.z;
			data[15] = 1.0;
			return this ;
			
		}
		
		public function scale( scale:Number ):Matrix4x4
		{
			data[0] = scale;
			data[1] = 0.0;
			data[2] = 0.0;
			data[3] = 0.0;
			data[4] = 0.0;
			data[5] = scale;
			data[6] = 0.0;
			data[7] = 0.0;
			data[8] = 0.0;
			data[9] = 0.0;
			data[10] = scale;
			data[11] = 0.0;
			data[12] = 0;
			data[13] = 0;
			data[14] = 0;
			data[15] = 1.0;
			return this ;
			
		}
				
		
		public function multiply( matrix:Matrix4x4 ):Matrix4x4
		{
			
			var product:Matrix4x4 = new Matrix4x4( );
			product.data[0] = data[0]*matrix.data[0] + data[4]*matrix.data[1] + data[8]*matrix.data[2] 
				+ data[12]*matrix.data[3];
			product.data[1] = data[1]*matrix.data[0] + data[5]*matrix.data[1] + data[9]*matrix.data[2] 
				+ data[13]*matrix.data[3];
			product.data[2] = data[2]*matrix.data[0] + data[6]*matrix.data[1] + data[10]*matrix.data[2] 
				+ data[14]*matrix.data[3];
			product.data[3] = data[3]*matrix.data[0] + data[7]*matrix.data[1] + data[11]*matrix.data[2] 
				+ data[15]*matrix.data[3];
			
			product.data[4] = data[0]*matrix.data[4] + data[4]*matrix.data[5] + data[8]*matrix.data[6] 
				+ data[12]*matrix.data[7];
			product.data[5] = data[1]*matrix.data[4] + data[5]*matrix.data[5] + data[9]*matrix.data[6] 
				+ data[13]*matrix.data[7];
			product.data[6] = data[2]*matrix.data[4] + data[6]*matrix.data[5] + data[10]*matrix.data[6] 
				+ data[14]*matrix.data[7];
			product.data[7] = data[3]*matrix.data[4] + data[7]*matrix.data[5] + data[11]*matrix.data[6] 
				+ data[15]*matrix.data[7];
			
			product.data[8] = data[0]*matrix.data[8] + data[4]*matrix.data[9] + data[8]*matrix.data[10] 
				+ data[12]*matrix.data[11];
			product.data[9] = data[1]*matrix.data[8] + data[5]*matrix.data[9] + data[9]*matrix.data[10] 
				+ data[13]*matrix.data[11];
			product.data[10] = data[2]*matrix.data[8] + data[6]*matrix.data[9] + data[10]*matrix.data[10] 
				+ data[14]*matrix.data[11];
			product.data[11] = data[3]*matrix.data[8] + data[7]*matrix.data[9] + data[11]*matrix.data[10] 
				+ data[15]*matrix.data[11];
			
			product.data[12] = data[0]*matrix.data[12] + data[4]*matrix.data[13] + data[8]*matrix.data[14] 
				+ data[12]*matrix.data[15];
			product.data[13] = data[1]*matrix.data[12] + data[5]*matrix.data[13] + data[9]*matrix.data[14] 
				+ data[13]*matrix.data[15];
			product.data[14] = data[2]*matrix.data[12] + data[6]*matrix.data[13] + data[10]*matrix.data[14] 
				+ data[14]*matrix.data[15];
			product.data[15] = data[3]*matrix.data[12] + data[7]*matrix.data[13] + data[11]*matrix.data[14] 
				+ data[15]*matrix.data[15];
			
			return product;
			
		}
		
		public function isIdentity( ):Boolean
		{
			return Utils.AreEqual( 1.0, data[0] )
				&& Utils.AreEqual( 1.0, data[5] )
				&& Utils.AreEqual( 1.0, data[10] )
				&& Utils.AreEqual( 1.0, data[15] )
				&& Utils.IsZero( data[1] ) 
				&& Utils.IsZero( data[2] )
				&& Utils.IsZero( data[3] )
				&& Utils.IsZero( data[4] ) 
				&& Utils.IsZero( data[6] )
				&& Utils.IsZero( data[7] )
				&& Utils.IsZero( data[8] )
				&& Utils.IsZero( data[9] )
				&& Utils.IsZero( data[11] )
				&& Utils.IsZero( data[12] )
				&& Utils.IsZero( data[13] )
				&& Utils.IsZero( data[14] );
		}
		
		public static function Inverse( matrix:Matrix4x4 ):Matrix4x4
		{
			
			var inverse:Matrix4x4 = new Matrix4x4( ); 
			
			var cofactor0:Number = matrix.data[5]*matrix.data[10] - matrix.data[6]*matrix.data[9];
			var cofactor4:Number = matrix.data[2]*matrix.data[9] - matrix.data[1]*matrix.data[10];
			var cofactor8:Number = matrix.data[1]*matrix.data[6] - matrix.data[2]*matrix.data[5];
			var determinant:Number = matrix.data[0]*cofactor0 + matrix.data[4]*cofactor4 + matrix.data[8]*cofactor8;
			
			if (Utils.IsZero( determinant ))
			{
				throw new Error( "Matrix has no inverse." );
			}
			
			var inverseDeterminant:Number = 1.0/determinant;
			inverse.data[0] = inverseDeterminant*cofactor0;
			inverse.data[1] = inverseDeterminant*cofactor4;
			inverse.data[2] = inverseDeterminant*cofactor8;
			
			inverse.data[4] = inverseDeterminant*(matrix.data[6]*matrix.data[8] - matrix.data[4]*matrix.data[10]);
			inverse.data[5] = inverseDeterminant*(matrix.data[0]*matrix.data[10] - matrix.data[2]*matrix.data[8]);
			inverse.data[6] = inverseDeterminant*(matrix.data[2]*matrix.data[4] - matrix.data[0]*matrix.data[6]);
			
			inverse.data[8] = inverseDeterminant*(matrix.data[4]*matrix.data[9] - matrix.data[5]*matrix.data[8]);
			inverse.data[9] = inverseDeterminant*(matrix.data[1]*matrix.data[8] - matrix.data[0]*matrix.data[9]);
			inverse.data[10] = inverseDeterminant*(matrix.data[0]*matrix.data[5] - matrix.data[1]*matrix.data[4]);
			
			inverse.data[12] = -matrix.data[0]*matrix.data[12] - matrix.data[4]*matrix.data[13] - matrix.data[8]*matrix.data[14];
			inverse.data[13] = -matrix.data[1]*matrix.data[12] - matrix.data[5]*matrix.data[13] - matrix.data[9]*matrix.data[14];
			inverse.data[14] = -matrix.data[2]*matrix.data[12] - matrix.data[6]*matrix.data[13] - matrix.data[10]*matrix.data[14];
			inverse.data[15] = 1 ;
			
			return inverse;
			
		}
		
		/**
		 * Transforms a vector by this matrix ;
		 * @param vector
		 * @return The transformed vector
		 * 
		 */		
		public function transform( vector:Vector3D ):Vector3D
		{
			var transform:Vector3D = new Vector3D( );
			transform.x = data[0]*vector.x + data[4]*vector.y + data[8]*vector.z + data[12]*vector.w;
			transform.y = data[1]*vector.x + data[5]*vector.y + data[9]*vector.z + data[13]*vector.w;
			transform.z = data[2]*vector.x + data[6]*vector.y + data[10]*vector.z + data[14]*vector.w;
			transform.w = data[3]*vector.x + data[7]*vector.y + data[11]*vector.z + data[15]*vector.w;
			return transform;
		}
		
		
		
		
		public static function Transpose( matrix:Matrix4x4 ):Matrix4x4
		{
			var transpose:Matrix4x4 = new Matrix4x4();
			transpose.data[0] = matrix.data[0];
			transpose.data[1] = matrix.data[4];
			transpose.data[2] = matrix.data[8];
			transpose.data[3] = matrix.data[12];
			transpose.data[4] = matrix.data[1];
			transpose.data[5] = matrix.data[5];
			transpose.data[6] = matrix.data[9];
			transpose.data[7] = matrix.data[13];
			transpose.data[8] = matrix.data[2];
			transpose.data[9] = matrix.data[6];
			transpose.data[10] = matrix.data[10];
			transpose.data[11] = matrix.data[14];
			transpose.data[12] = matrix.data[3];
			transpose.data[13] = matrix.data[7];
			transpose.data[14] = matrix.data[11];
			transpose.data[15] = matrix.data[15];
			return transpose ;
			
		}
		
		public function rotate( matrix:Matrix3x3 ):Matrix4x4
		{
			data[0] = matrix.data[0];
			data[1] = matrix.data[1];
			data[2] = matrix.data[2];
			data[3] = 0;
			data[4] = matrix.data[3];
			data[5] = matrix.data[4];
			data[6] = matrix.data[5];
			data[7] = 0;
			data[8] = matrix.data[6];
			data[9] = matrix.data[7];
			data[10] = matrix.data[8];
			data[11] = 0;
			data[12] = 0;
			data[13] = 0;
			data[14] = 0;
			data[15] = 1;
			
			return this;
		}

	}
}