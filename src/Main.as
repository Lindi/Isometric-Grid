package
{
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.GraphicsPathWinding ;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import math.*;
	
	import org.flexunit.Assert;

	[SWF(width='800',height='800',backgroundColor='#ffffff')]
	public class Main extends Sprite
	{
		
		private var rows:int = 20 ;
		private var cols:int = 20 ;
		private var gridSquareSize:int = 40 ;
		private var grid:Vector.<Vector3D> = new Vector.<Vector3D>(rows * cols, true);
		
		//	Todo: Declare these as instance properties
		private var right:int = 400 ;
		private var left:int = -400 ;
		private var top:int = 400 ;
		private var bottom:int = -400 ;
		private var nearZ:int = 200 ;
		private var farZ:int = 400 ;
		
		private var camera:Vector3D = new Vector3D(0, 0, 0) ;
		
		private var automatons:Array ;
		
		private static const SQRT3:Number = Math.sqrt(3);
		private static const SQRT6:Number = Math.sqrt(6);

		
		public function Main()
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
			automatons = new Array( );
			for ( i=0 ; i<20; i++ )
			{
				var automaton:Automaton = new Automaton( ) ;
				var x:int = Math.max(1, int(Math.random() * rows-1 )) ;
				var z:int = Math.max(1, int(Math.random() * cols-1 )) ;
				automaton.position = new Vector3D( x * gridSquareSize - (width/2), 0, z * gridSquareSize- (height/2) ) ;
				automaton.scale = gridSquareSize ;
				automatons.push( automaton ) ;
			}
			
			addEventListener( Event.ENTER_FRAME, 
				function ( event:Event ):void
				{
					main( ) ;
				});
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
//					left *= .95 ;
//					right *= .95 ;
//					top *= .95 ;
//					bottom *= .95 ;
					break ;
				
				//	Right Arrow
				case 39:
					camera.y += 20 ;
					break ;
				
				//	Down Arrow
				case 40:
					camera.z -= 20 ;
//					left *= 1.05 ;
//					right *= 1.05 ;
//					top *= 1.05 ;
//					bottom *= 1.05 ;
					break ;
			}
			//main(  ) ;
			
		}
		
		private function draw( grid:Vector.<Vector3D>, row:int = 0, col:int = 0 ):void 
		{
			if ( grid == null )
				grid = this.grid ;
			
			graphics.clear();
			graphics.lineStyle(.5,0xaaaaaa);
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
			
//			graphics.lineStyle( 2, 0x00ff00 );
//			graphics.moveTo( stage.stageWidth/2, 0 );
//			graphics.lineTo( stage.stageWidth/2, stage.stageHeight );
//			graphics.moveTo( 0, stage.stageHeight/2 ) ;
//			graphics.lineTo( stage.stageWidth, stage.stageHeight/2 );
//			graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
		}

		
		/**
		 * The main game loop 
		 * @param event
		 * 
		 */		
		private function main(  ):void
		{			
//			//	Grab a position in the world
//			var point:Vector3D = grid[ 0] ;
//			
//			var viewToWorld:Matrix4x4 = viewToWorldTransform( point ) ;
//			camera = viewToWorld.transform( new Vector3D( 0, 0, -1 ));
			
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
			
			
			
			for ( i = 0; i < automatons.length; i++)
			{
				//	Grab a reference to the automaton
				var automaton:Automaton = automatons[ i ] as Automaton ;
				
				//	Move the automatons and constrain their movement to the grid
				var direction:Vector3D = automaton.direction ;
				direction.scaleBy( 2 ) ;
				var position:Vector3D = automaton.position.add( direction );
				var w:int = ( cols - 1 ) * gridSquareSize / 2;
				var h:int = ( rows - 1 ) * gridSquareSize / 2;
				var outOfBounds:Boolean = position.x < -w ;
				outOfBounds ||= position.x > w ;
				outOfBounds ||= position.z < -w ;
				outOfBounds ||= position.z > w ;
				
				

				if ( outOfBounds )
				{
					//	Turn or reverse
					automaton.reverse( );
					
				} else {
					
					if (( position.x % gridSquareSize ) == 0 && ( position.z % gridSquareSize ) == 0 && int( Math.random() * 10 ) == 1 )
					{
						var random:int = int( Math.random() * 3 );
						switch ( random )
						{
							case 0:
								automaton.turn("left");
								break ;
							case 1:
								automaton.turn("right");
								break ;
							case 2:
								automaton.reverse( ) ;
								break ;
						}
					}
					automaton.position = position ;
				}
				
				//	Draw the automatons
				var localToWorld:Matrix4x4 = automaton.localToWorldTransform();
				var vertices:Vector.<Vector3D> = automaton.vertices ;
				for ( var j:int = 0; j < vertices.length; j++ )
				{
					vertices[ j ] = localToWorld.transform( vertices[ j]);
					vertices[ j ] = worldToView.transform( vertices[ j] ) ;
					vertices[ j ] = projection.transform( vertices[ j] );
					vertices[ j ] = screenTransform.transform( vertices[ j] ) ;
				}
				
				drawAutomaton( vertices ) ;
			}
		}
		
		

		
		private function drawAutomaton( vertices:Vector.<Vector3D> ):void
		{
			graphics.lineStyle(.5);
			
			var commands:Vector.<int> = new Vector.<int>(5,true);
			commands[0] = 1 ;
			
			for ( var i:int = 1; i < 5; i++ )
				commands[ i] = 2;//( i % 2 ) + 1 ;
			
			var a:Vector3D = vertices[ 0 ] ;	
			var b:Vector3D = vertices[ 1 ] ;
			var c:Vector3D = vertices[ 2 ] ;
			var d:Vector3D = vertices[ 3 ] ;
			var coordinates:Vector.<Number> = new Vector.<Number>(10,true);
			
			i = 0 ;
			for each ( var vector:Vector3D in [a,b,c,d,a] )
			{
				coordinates[ i++ ] = vector.x ;
				coordinates[ i++ ] = vector.y ;
			}
				
				
			//graphics.beginFill( 0xff0000 );
			graphics.drawPath( commands, coordinates, GraphicsPathWinding.EVEN_ODD );
			
//			graphics.moveTo( a.x, a.y );
//			graphics.lineTo( b.x, b.y );
//			graphics.moveTo( a.x, a.y );
//			graphics.lineTo( c.x, c.y );
//			graphics.moveTo( b.x, b.y );
//			graphics.lineTo( d.x, d.y );
//			graphics.moveTo( c.x, c.y );
//			graphics.lineTo( d.x, d.y );
			//graphics.endFill();
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