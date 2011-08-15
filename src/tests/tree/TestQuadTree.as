package tests.tree
{
	public class TestQuadTree
	{
		import org.flexunit.Assert;
		
		import tree.*;
		import flash.geom.Vector3D ;
		
		[Test]  
		public function insert():void 
		{ 
			//	Create a test region that the tree is in
			var width:int = 400 ;
			var halfWidth:int = width / 2 ;
			
			//	Create a position for our test particle
			var position:Vector3D = new Vector3D();
			position.x = ( Math.random() * width ) - halfWidth ;
			position.y = 0 ;
			position.z = ( Math.random() * width ) - halfWidth ;
			
			//	Create a test particle
			var particle:TestParticle = new TestParticle( ) ;
			particle.position = position ;
			
			//	Create an oct tree
			//	Passing ( 1 | 4 ) means we want the quadtree to be in the x-z plane
			var quadtree:QuadTreeNode = QuadTree.Create( new Vector3D(), halfWidth, 5, 5, ( 1 | 4 ) );
			
			//	Grab the node that the particle's in
			var node:QuadTreeNode = quadtree.locate( particle ) ;
			
			//	Test that the particle returned by the locate method is
			//	the same as that which the particle was inserted in
			Assert.assertTrue( node.insert( particle ).objects.indexOf( particle ) > -1 );
		}
		
		
		[Test]  
		public function remove():void 
		{ 
			//	Create a test region that the tree is in
			var width:int = 400 ;
			var halfWidth:int = width / 2 ;
			
			//	Create a position for our test particle
			var position:Vector3D = new Vector3D();
			position.x = ( Math.random() * width ) - halfWidth ;
			position.y = 0 ;
			position.z = ( Math.random() * width ) - halfWidth ;
			
			//	Create a test particle
			var particle:TestParticle = new TestParticle( ) ;
			particle.position = position ;
			
			//	Create an oct tree
			var quadtree:QuadTreeNode = QuadTree.Create( new Vector3D(), halfWidth, 5, 5, ( 1 | 4 ) );
			
			//	Insert a particle into the tree
			var insertNode:QuadTreeNode = quadtree.insert( particle ) ;
			var removeNode:QuadTreeNode = quadtree.remove( particle ) ;
			
			//	Remove the particle and test that node returned
			//	by the remove method is the same as that returned by the insert method
			Assert.assertTrue( insertNode == removeNode );
			
			//	Make sure the particle is no longer in that node's list of objects
			Assert.assertTrue( insertNode.objects.indexOf( particle ) == -1 );
			Assert.assertTrue( removeNode.objects.indexOf( particle ) == -1 );
		}
	}
}