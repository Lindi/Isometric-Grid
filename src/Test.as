package
{
	import flash.display.Sprite;
	
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;
	import tests.matrix.Suite ;
	import tests.tree.Suite ;
	
	
	public class Test extends Sprite
	{
		private var core:FlexUnitCore;
		private var listener:TraceListener ;
		
		public function Test()
		{
			core = new FlexUnitCore();
			listener = new TraceListener();
			core.addListener( listener );
			core.run( tests.tree.Suite );
			core.run( tests.matrix.Suite );
		}
	}
}