package
{
	
	import collisiondetection.IntersectingAABB;
	
	import flash.display.GraphicsPathWinding;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import geometry.AABB;
	import math.*;
	import util.Iterator;
	
	
	[SWF(width='600',height='600',backgroundColor='#ffffff')]
	public class SweepLine extends Sprite
	{
		
		private var rows:int = 20 ;
		private var cols:int = 20 ;
		private var gridSquareSize:int = 20 ;
		private var grid:Vector.<Vector3D> = new Vector.<Vector3D>(rows * cols, true);
		
		private var right:int = 200 ;
		private var left:int = -200 ;
		private var top:int = 200 ;
		private var bottom:int = -200 ;
		private var nearZ:int = 40 ;
		private var farZ:int = 80 ;
		
		private var camera:Vector3D = new Vector3D(0, 0, 0) ;
		
		private var automatons:Array ;
		private var intersection:AABB = new AABB();
		
		private static const SQRT3:Number = Math.sqrt(3);
		private static const SQRT6:Number = Math.sqrt(6);
		
		
		private var _aabb:Vector.<AABB> ;
		private var _intersectingAABB:IntersectingAABB ;
		
		public function SweepLine()
		{
			//	Create the grid
			var width:int = cols * gridSquareSize ;
			var height:int = rows * gridSquareSize ;
			var n:int = ( rows * cols ) ;
			for ( var i:int = 0; i < n; i++ )
			{
				var row:int = i / cols ;
				var col:int = i % cols ;
				grid[i] = new Vector3D(col * gridSquareSize - (width/2), 0, row * gridSquareSize - (height/2), 1 );
			}
			draw( grid ) ;
			
			//	Listen for key events
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );
			
			//	Don't scale the stage
			stage.scaleMode = StageScaleMode.NO_SCALE ;
			stage.align = StageAlign.TOP_LEFT ;
						
			//	Create a list of automatons, and positon them
			//	in our world
			n = 30 + int( Math.random() * 30 ) ;
			automatons = new Array(  );
			
			//	Create our new list of axis-aligned bounding boxes that we're going to use for
			//	collision detection
			_aabb = new Vector.<AABB>( n ) ;
			
			//	Iterate over the automatons and position them
			for ( i=0 ; i < n; i++ )
			{
				var automaton:Automaton = new Automaton( ) ;
				var x:int = ( i % 9 ) * 2 + 1;
				var z:int = ( i / 4 ) + 1;
				automaton.position = new Vector3D(( x + .5 ) * gridSquareSize - (width/2), 0, ( z + .5 ) * gridSquareSize- (height/2) ) ;
				automaton.scale = gridSquareSize /2;
				automatons.push( automaton ) ;
				
				if ( int( Math.random() * 3 ) == 1 )
					automaton.turn("right");
				
				switch (i % 4)
				{
					case 0:
						automaton.color = 0xff0000 ;
						break ;
					case 1:
						automaton.color = 0x00ff00 ;
						break ;
					case 2:
						automaton.color = 0x0000ff ;
						break ;
					case 3:
						automaton.color = 0xffff00 ;
						break ;
				}
				
				//	Add an axis-aligned bounding box to the AABB collection
				var aabb:AABB = new AABB();
				_aabb[ i ] = aabb ;
				updateAABB( aabb, automaton.position );
				
			}
			
			//	Create an instance of the collision detection algorithm implementation
			_intersectingAABB = new IntersectingAABB( _aabb ) ;
			_intersectingAABB.initialize();
			
			addEventListener( Event.ENTER_FRAME, 
				function ( event:Event ):void
				{
					main( ) ;
				});
		}
		
		/**
		 * Updates the properties of an axis aligned bounding box. 
		 * @param aabb
		 * @param position
		 * 
		 */		
		private function updateAABB( aabb:AABB, position:Vector3D ):void
		{
			aabb.xmin = position.x - gridSquareSize / 2;
			aabb.xmax = position.x + gridSquareSize / 2;
			aabb.ymin = position.z - gridSquareSize / 2;
			aabb.ymax = position.z + gridSquareSize / 2;			
		}
		
		
		private function keyDown( event:KeyboardEvent ):void
		{
			switch ( event.keyCode )
			{
				//	Left Arrow
				case 37:
					camera.y -= 20 ;
					break ;
				
				//	Up Arrow
				case 38:
					camera.z += 20 ;
					break ;
				
				//	Right Arrow
				case 39:
					camera.y += 20 ;
					break ;
				
				//	Down Arrow
				case 40:
					camera.z -= 20 ;
					break ;
			}
		}
		
		private function draw( grid:Vector.<Vector3D>, row:int = 0, col:int = 0 ):void 
		{
			if ( grid == null )
				grid = this.grid ;
			
			graphics.clear();
			graphics.lineStyle(.35,0xaaaaaa);
			var n:int = ( rows * cols ) ;
			for ( var i:int = row; i < rows-1; i++ )
			{
				for ( var j:int = col; j < cols-1; j++ )
				{
					var m:int = j + cols * i;
					var a:Vector3D = grid[ m ] ;	
					var b:Vector3D = grid[ m + 1] ;
					var c:Vector3D = grid[ m + cols] ;
					var d:Vector3D = grid[ m + 1 + cols] ;
					graphics.moveTo( a.x, a.y );
					graphics.lineTo( b.x, b.y );
					graphics.moveTo( a.x, a.y );
					graphics.lineTo( c.x, c.y );
					graphics.moveTo( b.x, b.y );
					graphics.lineTo( d.x, d.y );
					graphics.moveTo( c.x, c.y );
					graphics.lineTo( d.x, d.y );
				}
			}
		}
		
		
		/**
		 * The main game loop 
		 * @param event
		 * 
		 */		
		private function main(  ):void
		{						
			//	Grab the worldToView matrix
			var worldToView:Matrix4x4 = worldToViewTransform( camera );
			var projection:Matrix4x4 = getParallelProjectionMatrix( ) ;
			var screenTransform:Matrix4x4 = getScreenTransformMatrix( );
			
			//	Transform each of the points in our grid
			var points:Vector.<Vector3D> = new Vector.<Vector3D>( grid.length ); 
			for ( var i:int = 0; i < grid.length; i++ )
			{
				points[ i] = worldToView.transform(grid[i].clone()) ;
				points[ i] = projection.transform(points[i]) ;
				points[ i] = screenTransform.transform(points[i]) ;
				
			}
			draw( points );
			
						
			//	Create a list for z-sorting
			var sort:Array = new Array();
			
			for ( i = 0; i < automatons.length; i++)
			{
				//	Grab a reference to the automaton
				var automaton:Automaton = automatons[ i ] as Automaton ;
								
				//	Move the automatons and constrain their movement to the grid
				var direction:Vector3D = automaton.direction ;
				var velocity:Number = ( i % 3 ) + 2 ;
				direction.scaleBy( velocity ) ;
				
				//	Create a position vector
				var position:Vector3D = automaton.position.add( direction );
				
				//	Determine whether or not the collision is in-bounds
				w = ( cols - 2 ) * gridSquareSize / 2;
				var h:Number = ( rows - 2 ) * gridSquareSize / 2;
				var outOfBounds:Boolean = position.x < -w ;
				outOfBounds ||= position.x > w ;
				outOfBounds ||= position.z < -w ;
				outOfBounds ||= position.z > w ;
				
				
				
				if ( outOfBounds )
				{
					//	Turn or reverse
					automaton.reverse( );
					
				} else {
					
					if (( int( position.x % gridSquareSize/2 ) == 5 
						&& int( position.z % gridSquareSize/2 ) == 5 )
						|| ( int( position.x % gridSquareSize ) == 10 
							&& int( position.z % gridSquareSize ) == 10 ))
					{
						if ( !automaton.colliding )
						{
							var random:int = int( Math.random() * 2 );
							switch ( random )
							{
								case 0:
									automaton.turn("left");
									break ;
								case 1:
									automaton.turn("right");
									break ;
							}
						}
					}
					
					//	Set the automaton's position
					automaton.position = position ;
					
					//	Grab a reference to this automaton's AABB
					var aabb:AABB = _aabb[i] ;
					updateAABB( aabb, position ) ;
				}
			}
			
			
			//	Perform collision detection
			_intersectingAABB.update();
			
			//	Now the set of intersections should be updated
			var iterator:Iterator = _intersectingAABB.intersections ;
			while ( iterator.hasNext())
			{
				var array:Array = ( iterator.next() as Array ) ;
				i = array[0] as int ;
				j = array[1] as int ;
				var a:AABB = _aabb[ i] ;
				var b:AABB = _aabb[ j] ;
				intersection.xmin =
					intersection.xmax =
					intersection.ymin =
					intersection.ymax = 0 ;
				
				if ( a.findIntersection( b, intersection ))
				{
					
					//	First, figure out whether or not the automatons are moving towards or away from each
					//	other
					var p:Automaton = automatons[ i ] as Automaton ;
					var q:Automaton = automatons[ j ] as Automaton ;
					var v:Vector3D = q.position.subtract( p.position );
					var dotProduct:Number = p.direction.dotProduct( v ) ;
					if ( dotProduct >= 0 )
					{
						var dx:Number = Math.abs( intersection.xmax - intersection.xmin ) ;
						var dy:Number = Math.abs( intersection.ymax - intersection.ymin ) ;
						
						p.reverse();
						p.position.x += ( p.direction.x * dx/2 );
						p.position.y += ( p.direction.y * dy/2 );
						
					} else if ( p.position.x >= q.position.x ) {
						
						p.position.x += p.direction.x * ( intersection.xmax - intersection.xmin ) ;
						p.position.y += p.direction.y * ( intersection.ymax - intersection.ymin ) ;
					}
					v = p.position.subtract( q.position );
					dotProduct = q.direction.dotProduct( v ) ;
					
					if ( dotProduct >= 0 )
					{
						q.reverse();
						q.position.x += ( q.direction.x * dx/2 );
						q.position.y += ( q.direction.y * dy/2 );
						
					} else if ( q.position.x >= q.position.x ) {
						
						q.position.x += q.direction.x * ( intersection.xmax - intersection.xmin ) ;
						q.position.y += q.direction.y * ( intersection.ymax - intersection.ymin ) ;
					}
					
					updateAABB( a, p.position );
					updateAABB( b, q.position );
				}
				
			}
			
			var w:int = gridSquareSize / 2 ;

			//	Transform the automaton's vertices
			for ( i = 0; i < automatons.length; i++ )
			{
				//	Grab a reference to the automaton
				automaton = automatons[i] as Automaton ;
				
				//	Draw the automatons
				var localToWorld:Matrix4x4 = automaton.localToWorldTransform();
				var vertices:Vector.<Vector3D> = automaton.vertices ;
				
				//	Average z
				var avgz:Number = 0 ;
				
				//	Render the box being used for collision detection
				//	So we can see what's going on
				var footprint:Vector.<Vector3D> = new Vector.<Vector3D>( 4 ) ;
				footprint[0] = new Vector3D( 1, 0, 1, 1 ) ;
				footprint[1] = new Vector3D( -1, 0, 1, 1 ) ;
				footprint[2] = new Vector3D( -1, 0, -1, 1 ) ;
				footprint[3] = new Vector3D( 1, 0, -1, 1 ) ;
				for ( var j:int = 0; j < vertices.length; j++ )
				{
					vertices[ j ] = localToWorld.transform( vertices[ j]);
					vertices[ j ] = worldToView.transform( vertices[ j] ) ;
					avgz += vertices[ j ].z ;
					vertices[ j ] = projection.transform( vertices[ j] );
					vertices[ j ] = screenTransform.transform( vertices[ j] ) ;
					
					footprint[ j] = localToWorld.transform( footprint[ j]);
					footprint[ j] = worldToView.transform( footprint[ j] ) ;
					footprint[ j] = projection.transform( footprint[ j] );
					footprint[ j] = screenTransform.transform( footprint[ j] ) ;
				}
				
				avgz /= vertices.length ;
				sort.push( { automaton: automaton, z: avgz, vertices: vertices, footprint: footprint } );
				
			}

			
			sort.sort(foo);
			
			for each ( var object:Object in sort )
			{
				vertices = object.vertices as Vector.<Vector3D> ;
				footprint = object.footprint as Vector.<Vector3D> ;
				automaton = object.automaton as Automaton ;
				drawAutomaton( vertices, footprint, automaton.color  ) ;
			}
		}
		
		
		private function foo( a:Object, b:Object ):int
		{
			if ( a.z > b.z )
				return -1 ;
			if ( a.z < b.z )
				return 1 ;
			return 0 ;
		}
		
		
		
		private function drawAutomaton( vertices:Vector.<Vector3D>, footprint:Vector.<Vector3D>, color:Number ):void
		{
			
			var commands:Vector.<int> = new Vector.<int>(5,true);
			commands[0] = 1 ;
			
			var coordinates:Vector.<Number> = new Vector.<Number>(10,true);
			for ( var i:int = 1; i < 5; i++ )
				commands[ i] = 2;
			
			var a:Vector3D = footprint[ 0 ] ;	
			var b:Vector3D = footprint[ 1 ] ;
			var c:Vector3D = footprint[ 2 ] ;
			var d:Vector3D = footprint[ 3 ] ;
			
			i = 0 ;
			for each ( var vector:Vector3D in [a,b,c,d,a] )
			{
				coordinates[ i++ ] = vector.x ;
				coordinates[ i++ ] = vector.y ;
			}
			graphics.lineStyle( 1, color, .35 );
			graphics.beginFill( color, .25 );	
			graphics.drawPath( commands, coordinates, GraphicsPathWinding.NON_ZERO );
			graphics.endFill();
 
			a = vertices[ 0 ] ;	
			b = vertices[ 2 ] ;
			c = vertices[ 3 ] ;
			d = vertices[ 1 ] ;
			
			
			i = 0 ;
			for each ( vector in [a,b,c,d,a] )
			{
				coordinates[ i++ ] = vector.x ;
				coordinates[ i++ ] = vector.y ;
			}
			
			graphics.lineStyle(.5);
			graphics.beginFill( color, .9 );	
			graphics.drawPath( commands, coordinates, GraphicsPathWinding.NON_ZERO );
			graphics.endFill();
			
		}
		
		/**
		 * Returns a matrix that maps points from view space
		 * into world space 
		 * @return 
		 * 
		 */		
		private function viewToWorldTransform( camera:Vector3D ):Matrix4x4
		{
			//	Designate a world up vector (Yay! I understand that now!)
			//	This should be an instance property
			
			//	Create a orientation matrix to orient the camera such that
			//	its direction vector lies along an arbitrary axis
			var orientation:Matrix4x4 = new Matrix4x4( );
			
			//	We align the camera's zxaxis to the world's x-axis
			//	The first row (x-axis row) of the orientation is
			//	1	0	0	0
			orientation.data[0] = 1 ;
			orientation.data[4] = 0 ;
			orientation.data[8] = 0 ;
			orientation.data[12] = 0 ;
			
			//	We align the camera's z-axis to the world's -y-axis
			//	The second row (y-axis row) of the orientation is
			//	0	0	-1	0
			orientation.data[1] = 0 ;
			orientation.data[5] = 0 ;
			orientation.data[9] = -1 ;
			orientation.data[13] = 0 ;
			
			//	We then align the camera's -y-axis to the world's z-axis
			//	The third row (z-axis row) of the orientation is
			//	0	-1	0	0
			orientation.data[2] = 0 ;
			orientation.data[6] = -1 ;
			orientation.data[10] = 0 ;
			orientation.data[14] = 0 ;
			
			//	Make this an affine orientation
			orientation.data[15] = 1 ;
			
			
			var invSqrt6:Number = 1/SQRT6 ;
			var col1:Vector3D = new Vector3D( SQRT3, 0, -SQRT3 )
			col1.scaleBy( invSqrt6 ) ;
			var col2:Vector3D = new Vector3D( 1, 2, 1 );
			col2.scaleBy( invSqrt6 ) ;
			var col3:Vector3D = new Vector3D( Math.SQRT2 , -Math.SQRT2, Math.SQRT2 );
			col3.scaleBy( invSqrt6 ) ;
			
			//	Create a new matrix that represents the camera's rotation
			//	about the x, y and z-axes
			var rotation:Matrix4x4 = new Matrix4x4( ).rotate( new Matrix3x3().setColumns( col1, col2, col3 )) ;
			
			//	Multiply the rotation matrix by the orientation
			var matrix:Matrix4x4 = rotation.multiply( orientation ) ;
			
			//	Create a translation matrix
			var translate:Matrix4x4 = new Matrix4x4( ).translate( camera ) ;
			
			//	Multiply the translate matrix by the product of the rotation and orientation matrices
			//	And return that as the view-to-world transform
			return translate.multiply( matrix ) ;
		}
		
		private function worldToViewTransform( camera:Vector3D ):Matrix4x4
		{
			return viewToWorldTransform( camera ).inverse( ) ;
		}
		
		
		private function getScreenTransformMatrix( ):Matrix4x4
		{
			var matrix:Matrix4x4 = new Matrix4x4( ) ;
			matrix.data[0] = stage.stageWidth/2 ;
			matrix.data[12] = stage.stageWidth/2 ;			
			matrix.data[5] = -stage.stageHeight/2 + (nearZ * (1/SQRT3)) ;
			matrix.data[13] = stage.stageHeight/2 ;
			matrix.data[10] = .5;
			matrix.data[14] = .5;
			matrix.data[15] = 1 ;
			return matrix ;
		}
		/**
		 * Get cabinet projection matrix
		 * 
		 **/
		private function getCabinetProjectionMatrix( ):Matrix4x4
		{
			
			var recipX:Number = 1.0/(right-left);
			var recipY:Number = 1.0/(top-bottom);
			var recipZ:Number = 1.0/(nearZ-farZ);
			
			var projection:Matrix4x4 = new Matrix4x4( ) ;
			projection.identity();
			
			
			//	This is the cos and sin of 45 degrees
			var halfsqrt2:Number = Math.SQRT2/2 ;
			
			projection.data[0] = 2.0*recipX;
			projection.data[8] = -1*recipX;
			projection.data[12] = (-1*nearZ - right - left)*recipX; 
			
			projection.data[5] = 2.0*recipY;
			projection.data[9] = -1*recipY;
			projection.data[13] = (-1*nearZ - top - bottom)*recipY;
			
			projection.data[10] = 2.0*recipZ;
			projection.data[14] = (nearZ+farZ)*recipZ;
			
			return projection ;
			
		}
		
		/**
		 * Return a matrix that performs a parallel projection
		 * and which converts all points to NDC space 
		 * @return Matrix that performs a parallel projection
		 * 
		 */		
		private function getParallelProjectionMatrix( ):Matrix4x4
		{
			var recipX:Number = 1.0/(right-left);
			var recipY:Number = 1.0/(top-bottom);
			var recipZ:Number = 1.0/(nearZ-farZ);
			
			var projection:Matrix4x4 = new Matrix4x4( ) ;
			projection.identity();
			
			projection.data[0] = 2.0*recipX;
			projection.data[8] = 0 ;
			projection.data[12] = -(right + left)*recipX; 
			
			projection.data[5] = 2.0*recipY;
			projection.data[9] = 0 ;
			projection.data[13] = -(top + bottom)*recipY;
			
			projection.data[10] = 2.0*recipZ;
			projection.data[14] = -(nearZ+farZ)*recipZ;
			
			return projection ;
			
		}
	}
}