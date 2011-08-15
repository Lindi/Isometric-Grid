package tests.tree
{
	import flash.geom.Vector3D;
	
	public class TestParticle implements IParticle
	{
		private var _position:Vector3D ;
		private var _direction:Vector3D ;
		
		public function TestParticle()
		{
		}
		
		public function set colliding( colliding:Boolean ):void
		{
			
		}
		
		public function get colliding():Boolean
		{
			return false ;
		}

		public function get position():Vector3D
		{
			return _position ;
		}

		public function set position( position:Vector3D ):void
		{
			_position = position ;
		}
				
		public function get direction():Vector3D
		{
			return _direction ;
		}
		
		public function set direction( direction:Vector3D ):void
		{
			_direction = direction ;
		}
		
		public function get radius():Number
		{
			return 20;
		}
	}
}