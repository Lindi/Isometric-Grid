package math
{
	public class Utils
	{
		public static var EPSILON:Number = .000001 ;
		
		public static function IsZero( number:Number ):Boolean {
			return Math.abs( number ) < EPSILON ;
		}
		
		public static function AreEqual( a:Number, b:Number ):Boolean {
			return IsZero(a-b);
		}
	}
}