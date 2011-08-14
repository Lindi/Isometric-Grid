package
{
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	import math.Matrix4x4;

	public class Automaton implements IParticle
	{
		private var _vertices:Vector.<Vector3D> ;
		private var _direction:Vector3D = new Vector3D( 1, 0, 0, 1 ) ;
		private var _side:Vector3D = new Vector3D( 0, 0, 1, 1 ) ;
		private var _up:Vector3D = new Vector3D( 0, 1, 0, 1 ) ;
		private var _down:Vector3D ;
		private var _position:Vector3D = new Vector3D( ) ;
		private var _scale:Number ;
		
		public function Automaton()
		{
			//	The automaton's local vertices
			_vertices = new Vector.<Vector3D>(4);
			_vertices[0] = new Vector3D( 0, 0, 0, 1 ) ;
			_vertices[1] = new Vector3D( 1, 0, 0, 1 ) ;
			_vertices[2] = new Vector3D( 1, 1, 0, 1 ) ;
			_vertices[3] = new Vector3D( 0, 1, 0, 1 ) ;
			
			//	Negate the up vector
			_down = _up.clone();
			_down.negate();
		}
		
		
		public function set position( position:Vector3D ):void
		{
			_position = position ;
		}
		
		public function get position():Vector3D
		{
			return _position.clone();
		}
		
		public function get radius():Number
		{
			return _scale ;
		}
		
		public function get direction():Vector3D
		{
			return _direction.clone();
		}
		
		public function set scale( scale:Number ):void
		{
			_scale = scale ;
		}
		
		public function reverse( ):void
		{
			_direction.negate();
			_side.negate();
		}
		
		public function get vertices( ):Vector.<Vector3D>
		{
			//	Make a copy of the local vertices
			var vertices:Vector.<Vector3D> = new Vector.<Vector3D>(4);
			vertices[0] = _vertices[0].clone();
			vertices[1] = _vertices[1].clone();
			vertices[2] = _vertices[2].clone();
			vertices[3] = _vertices[3].clone();
			return vertices ;
		}
		
		public function turn( direction:String ):void
		{
			switch ( direction )
			{
				case "left":
				case "up":
					//	Compute the cross product of the direction vector with the ground plane's
					//	positive normal (right-handed system)
					_direction = _direction.crossProduct( _up ) ;
					_side = _side.crossProduct( _up ) ;
					break ;
				case "right":
				case "down":
					//	Compute the cross product of the direction vector with the ground plane's
					//	negative normal (right-handded system.  Could pre-compute the negative of up and name it _down)
					var down:Vector3D = _up.clone();
					down.negate() ;
					_direction = _direction.crossProduct( _down ) ;
					_side = _side.crossProduct( _down ) ;
					break ;
			}
		}
		
		
		/**
		 * Returns a matrix that 
		 * 
		 */		
		public function localToWorldTransform( ):Matrix4x4
		{
			
			//	Scaling each component of the direction and up vectors is kind of jank
			//	But it's probably faster than creating a seperate scale matrix and concatenating both
			//	I suppose if we're doing things the right way, we're 
			
			//	Create a orientation matrix to orient the camera such that
			//	its direction vector lies along an arbitrary axis
			var matrix:Matrix4x4 = new Matrix4x4( );
			
			//	We align the direction vector with the world x-axis
			//	by modifying the first column (x-axis) of the matrix 
			matrix.data[0] = _side.x * _scale ;
			matrix.data[1] = _side.y * _scale ;
			matrix.data[2] = _side.z * _scale ;
			matrix.data[3] = 0 ;
			
			//	We align the up vector with the world y-axis
			//	by modifying the second column (y-axis) of the matrix 
			matrix.data[4] = _up.x * _scale ;
			matrix.data[5] = _up.y * _scale ;
			matrix.data[6] = _up.z * _scale ;
			matrix.data[7] = 0 ;
			
			//	We align the side vector with the world x-axis
			//	by modifying the third column (z-axis) of the matrix 
			matrix.data[8] = _direction.x * _scale ;
			matrix.data[9] = _direction.y * _scale ;
			matrix.data[10] = _direction.z * _scale ;
			matrix.data[11] = 0 ;
			
			//	Set the position
			matrix.data[12] = _position.x ;
			matrix.data[13] = _position.y ;
			matrix.data[14] = _position.z ;
			matrix.data[15] = 1 ;
			
			return matrix ;
			
		}
	}
}