package tests.octtree
{
	import flash.geom.Vector3D;
	
	public class TestParticle implements IParticle
	{
		private var _position:Vector3D ;
		
		public function TestParticle()
		{
		}
		
		public function set position( position:Vector3D ):void
		{
			_position = position ;
		}
		
		public function get position():Vector3D
		{
			return _position ;
		}
		
		public function get radius():Number
		{
			return 20;
		}
	}
}