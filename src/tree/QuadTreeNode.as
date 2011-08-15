package tree
{
	import flash.geom.Vector3D;

	public class QuadTreeNode
	{
		public var center:Vector3D ;
		public var halfWidth:Number ;
		public var objects:Array ;
		public var children:Array ;
		public var depth:int ;
		public var maxDepth:int ;
		public var planes:int ;

		public function QuadTreeNode( planes:int )
		{
			objects = new Array();
			children = new Array( 4 ) ;
			this.planes = planes ;
		}
		/**
		 * Inserts an object into the octtree
		 * @param object - the object being inserted
		 * 
		 */		
		public function insert( object:IParticle ):QuadTreeNode
		{
			var node:QuadTreeNode = locate( object ) ;
			node.objects.push( object ) ;
			return node ;
		}
		/**
		 * Removes an object from the octtree
		 * @param object - the object being removed
		 * 
		 */		
		public function remove( object:IParticle ):QuadTreeNode
		{
			var node:QuadTreeNode = locate( object ) ;
			var index:int ;
			if (( index = node.objects.indexOf( object )) == -1 )
				throw new Error("Invalid object removal.");
			node.objects.splice( index, 1 ) ;
			return node ;
		}
		
		/**
		 * Tests collisions among objects in the tree 
		 * @param a
		 * @param b
		 * 
		 */		
		public function testCollisions( stack:Array, depth:int ):void
		{
			if ( stack == null )
				stack = new Array( maxDepth );
			stack[depth++] = this ;
			
			for ( var i:int = 0; i < depth; i++ )
			{
				for ( var j:int = 0; j < stack[ i].objects.length; j++ )
				{
					var a:IParticle = ( stack[ i].objects[ j] as IParticle );
					
					for ( var k:int = 0; k < objects.length; k++ )
					{
						var b:IParticle = ( objects[ k] as IParticle );
						
						if ( a == b )
							break ;
						
						//	Test the collision here between a and b
						if (QuadTree.TestCollision(a,b,planes))
						{
							//a.colliding = b.colliding = false ;
							//	Should probably include reverse in the IParticle interface
							( a as Automaton ).reverse();
							( b as Automaton ).reverse();
						}
					}
				}
			}
			
			for ( i = 0; i < 4; i++ )
			{
				var child:QuadTreeNode = children[ i] as QuadTreeNode ;
				if ( child != null )
				{
					child.testCollisions( stack, depth );
				}
			}
			
			//	Decrement the stack when we're done
			--depth ;
		}
		
		/**
		 * Returns the OctTreeNode which should contain a given particle. 
		 * @param object - The object that we're going to insert or remove
		 * from the OctTree
		 * @return - The node to which the object belongs
		 * 
		 */		
		public function locate( object:IParticle ):QuadTreeNode
		{
			var index:int ;
			var straddle:Boolean = false ;
			
			//	Determine which octant the particle belongs to
			//	by figuring out whether or not it straddles any of this
			//	node's bisecting planes.  If it does, it remains in this
			//	node, otherwise it gets assigned to a child node
			for ( var i:int = 0; i < 2; i++ )
			{
				//	Get the difference between the center of the object and the center of 
				//	the tree
				var p:Number ; 
				var c:Number ;
				
				switch ( planes )
				{
					case 3:
						// x-y
						p = ( i ? object.position.y : object.position.x );
						c = ( i ? center.y : center.x );
						break ;
					case 5:
						// x-z
						p = ( i ? object.position.z : object.position.x );
						c = ( i ? center.z : center.x );
						break ;
					case 6:
						// y-z
						p = ( i ? object.position.z : object.position.y );
						c = ( i ? center.z : center.y );
						break ;
				}
				
				

				var d:Number = p - c ;
				
				//	Now this is the line I don't understand
				//	Why on earth are we adding the halfWidth to the center?
				//	If the absolute value of the distance between the particle's
				//	position and the node center is less than the particle's radius
				//	then we know that the particle straddles one of the three planes
				//	that bisect the node's center.
				if ( straddle = ( Math.abs( d ) < halfWidth + object.radius ))
				{
					break ;	
				}
				
				//	Compute the octant the particle should be in
				//	If the difference between the particle's location and
				//	the node's center is positive, we bitshift 1 by the current
				//	value of the loop counter, and add it to the value of index
				//	to determine the octant value
				
				//	So for example, if the difference between the node center's x-value
				//	and the particle's x-value is positive, we'd add 1 ( or 1 << 0 ) to the
				//	current value of index.  
				
				//	Then, if the difference between the node center's y-value
				//	and the particle's y-value is positive, we'd add 2 ( or 1 << 1 ) to the
				//	current value of the index
				
				//	If the difference between the node center's z-value
				//	and the particle's z-value is positive, we'd add 4 ( or 1 << 2 ) to the
				//	current value of the index
				
				//	If the difference is always positive, we'd get a node value of 7
				//	If the difference is always negative, we'd get a node value of 0
				//	Otherwise, we get a number between [0..7] as expected
				if ( d > 0 )
				{
					index |= ( 1 << i );
				}
				
			}
			
			//	If the particle doesn't straddle any of the node center's bisecting planes
			//	we add it to the octant we computed
			if ( !straddle )
			{
				if ( children[index] == null )
				{
					children[index] = new QuadTreeNode( planes );
				}
				
				//	Add the object to the node
				return ( children[index] as QuadTreeNode ).locate( object ) ;
				
			} else
			{
				return this ; 
			}
		}
	}
}