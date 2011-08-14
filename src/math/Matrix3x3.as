package math
{
	import flash.geom.Vector3D;
	
	public class Matrix3x3
	{
		public var data:Vector.<Number> = new Vector.<Number>(9);
		
		public function Matrix3x3()
		{
		}
		
		
		public function setRows( row1:Vector3D, row2:Vector3D, row3:Vector3D ):Matrix3x3
		{
			data[0] = row1.x;
			data[3] = row1.y;
			data[6] = row1.z;
			
			data[1] = row2.x;
			data[4] = row2.y;
			data[7] = row2.z;
			
			data[2] = row3.x;
			data[5] = row3.y;
			data[8] = row3.z;
			
			return this ;
			
		}   
		
		public function setColumns( col1:Vector3D, col2:Vector3D, col3:Vector3D ):Matrix3x3
		{
			data[0] = col1.x;
			data[1] = col1.y;
			data[2] = col1.z;
			
			data[3] = col2.x;
			data[4] = col2.y;
			data[5] = col2.z;
			
			data[6] = col3.x;
			data[7] = col3.y;
			data[8] = col3.z;
			
			return this ;
			
		}
		
	}
}