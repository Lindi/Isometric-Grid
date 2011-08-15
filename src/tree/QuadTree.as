package tree
{
	import flash.geom.Vector3D;
	public class QuadTree
	{
		public function QuadTree()
		{
		}
		
		
		public static function Create( center:Vector3D, halfWidth:Number, maxDepth:int, depth:int, planes:int ):QuadTreeNode
		{			
			if ( depth < 0 )
				return null ;
			//	Create a node
			var node:QuadTreeNode = new QuadTreeNode( planes );
			node.center = center ;
			node.halfWidth = halfWidth ;
			node.maxDepth = maxDepth ; 
			node.depth = depth ;
			
			//	Halve the half width
			var quarterWidth:Number = halfWidth / 2 ;
			
			//	Create an offset point
			var offset:Vector3D = new Vector3D();
			
			//	Create all the children down to a specified depth
			for ( var i:int = 0; i < 4; i++ )
			{
				switch ( planes )
				{
					case 5:
						// x-z
						offset.x = ( i & 1 ? quarterWidth : -quarterWidth ) ;
						offset.z = ( i & 2 ? quarterWidth : -quarterWidth ) ;
						break ;
					case 3:
						// x-y
						offset.x = ( i & 1 ? quarterWidth : -quarterWidth ) ;
						offset.y = ( i & 2 ? quarterWidth : -quarterWidth ) ;
						break ;
					case 6:
						// y-z
						offset.y = ( i & 1 ? quarterWidth : -quarterWidth ) ;
						offset.z = ( i & 2 ? quarterWidth : -quarterWidth ) ;
						break ;
				}
				node.children[ i] = Create( center.add( offset ), quarterWidth, maxDepth, depth-1, planes );
			}
			
			return node ;
		}
		
		public static function TestCollisions( node:QuadTreeNode ):void
		{
			node.testCollisions( new Array(5),0);
		}
		/**
		 * Test for collision between min/widths AABBs 
		 * @param a - First collision particle
		 * @param b - Second collision particle
		 * @param planes - An integer representing the planes we're testing
		 * @return 
		 * 
		 */		
		public static function TestCollision( a:IParticle, b:IParticle, planes:int ):Boolean
		{
			switch ( planes )
			{
				case 3:
					// x-y
					// Exit with no intersection if separated along an axis 
					if ( Math.abs( a.position.x - b.position.x ) > a.radius ) 
						return false ; 
					if ( Math.abs( a.position.y - b.position.y ) > a.radius ) 
						return false ; 
					// Overlapping on all axes means AABBs are intersecting 
					return ( a.direction.dotProduct( b.direction ) <= 0 ) ;			
				case 5:
					// x-z
					// Exit with no intersection if separated along an axis 
					if ( Math.abs( a.position.x - b.position.x ) > a.radius ) 
						return false ; 
					if ( Math.abs( a.position.z - b.position.z ) > a.radius ) 
						return false ; 
					// Overlapping on all axes means AABBs are intersecting 
					return ( a.direction.dotProduct( b.direction ) <= 0 ) ;			
				case 6:
					// y-z
					// Exit with no intersection if separated along an axis 
					if ( Math.abs( a.position.z - b.position.z ) > a.radius ) 
						return false ; 
					if ( Math.abs( a.position.y - b.position.y ) > a.radius ) 
						return false ; 
					// Overlapping on all axes means AABBs are intersecting 
					return ( a.direction.dotProduct( b.direction ) <= 0 ) ;			
				default:
					return false ;
			}
		}
	}
}