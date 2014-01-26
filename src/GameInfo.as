package
{
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	
	public class GameInfo
	{
		public static var world:int = 0;
		public static var level:int = 0;
		public static var actions:int = 0;
		
		public static var worldNames:Array = ["The Hills Familiar","In a Candy Jam","Boo! Haunted House","Dry Bones","none","none","none","none","none"];
		public static var levelNames:Array = new Array(9);
		levelNames[0] = ["Daisy","Mushroom","Log","Beanstalk","","","","",""];
		levelNames[1] = ["","","","","","","","",""];
		levelNames[2] = ["Lock","","","","","","","","Treasure Chest"];
		levelNames[3] = ["","","","","","","","","Fennec"];
		levelNames[4] = ["","","","","","","","",""];
		levelNames[5] = ["","","","","","","","",""];
		levelNames[6] = ["","","","","","","","",""];
		levelNames[7] = ["","","","","","","","",""];
		levelNames[8] = ["","","","","","","","",""];
		
		// Fewest Actions
		//   Daisy:			30
		//   Log:			54
		//   Beanstalk:		75
		
		public static var frameRects:Array = [
			new Rectangle(0, 64, 9, 9),
			new Rectangle(9, 64, 9, 9),
			new Rectangle(18, 64, 8, 8),
			new Rectangle(26, 64, 11, 12),
			new Rectangle(38, 0, 10, 12),
			new Rectangle(40, 77, 20, 20),
			new Rectangle(38, 0, 10, 12),
			new Rectangle(60, 88, 40, 40),
			new Rectangle(0, 91, 40, 36)
		];
		
		public function GameInfo()
		{
			super();
		}
	}
}
