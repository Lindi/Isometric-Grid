package tree
{
	import flash.geom.Point;
	import flash.geom.Vector3D ;

	public class OctTree
	{
		public function OctTree()
		{
		}
		
		public static function Create( center:Vector3D, halfWidth:Number, maxDepth:int ):OctTreeNode
		{
			if ( isNaN( maxDepth ))
				return null ;
			if ( maxDepth <= 0 )
				return null ;
			
			//	Create a node
			var node:OctTreeNode = new OctTreeNode();
			node.center = center ;
			node.halfWidth = halfWidth ;
			
			//	Halve the half width
			var quarterWidth:Number = halfWidth / 2 ;
			
			//	Create an offset point
			var offset:Vector3D = new Vector3D();
			
			//	Create all the children down to a specified depth
			for ( var i:int = 0; i < 8; i++ )
			{
				offset.x = ( i & 1 ? quarterWidth : -quarterWidth ) ;
				offset.y = ( i & 2 ? quarterWidth : -quarterWidth ) ;
				offset.z = ( i & 4 ? quarterWidth : -quarterWidth ) ;
				node.children[ i] = Create( center.add( offset ), quarterWidth, maxDepth-1 );
			}
			
			return node ;
		}
		
		
	}
}