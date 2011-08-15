package tests.tree
{
	import flash.geom.Vector3D;

	public class TestOctTree
	{
		import org.flexunit.Assert;
		
		import tree.*;
		
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
			var octtree:OctTreeNode = OctTree.Create( new Vector3D(), halfWidth, 5 );
			
			//	Grab the node that the particle's in
			var node:OctTreeNode = octtree.locate( particle ) ;
			
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
			var octtree:OctTreeNode = OctTree.Create( new Vector3D(), halfWidth, 5 );
			
			//	Insert a particle into the tree
			var insertNode:OctTreeNode = octtree.insert( particle ) ;
			var removeNode:OctTreeNode = octtree.remove( particle ) ;
			
			//	Remove the particle and test that node returned
			//	by the remove method is the same as that returned by the insert method
			Assert.assertTrue( insertNode == removeNode );
			
			//	Make sure the particle is no longer in that node's list of objects
			Assert.assertTrue( insertNode.objects.indexOf( particle ) == -1 );
			Assert.assertTrue( removeNode.objects.indexOf( particle ) == -1 );
		}
	}
}