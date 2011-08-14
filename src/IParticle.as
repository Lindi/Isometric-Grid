package
{
	import flash.geom.Vector3D;

	public interface IParticle
	{
		function get position():Vector3D ;
		function set position( position:Vector3D ):void ;
		function get radius():Number ;
	}
}