package
{
	import flash.geom.Vector3D;

	public interface IParticle
	{
		function get position():Vector3D ;
		function set position( position:Vector3D ):void ;
		function get direction():Vector3D ;
		function set direction( direction:Vector3D ):void ;
		function get radius():Number ;
		function get colliding():Boolean ;
		function set colliding( colliding:Boolean ):void ;
	}
}