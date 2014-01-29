package
{
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	
	public class GameInfo
	{
		public static var world:int = 0;
		public static var level:int = 0;
		public static var actions:int = 0;
		
		public static var NUM_LEVELS:int = 81;
		private static var i:int;
		public static var levelStats:Array = new Array(NUM_LEVELS);
		for (i = 0; i < 81; i++)
		{
			levelStats[i] = {medals: 0, fewestActions: -1, fastestTime: -1};
		}
		
		protected static const DAISY:uint = 0;
		protected static const LOG:uint = 1;
		protected static const TOADSTOOL:uint = 2;
		protected static const BEANSTALK:uint = 3;
		protected static const DIRT_BLOCK:uint = 4;
		protected static const ACORN:uint = 5;
		protected static const ROCKS:uint = 6;
		protected static const LEAF:uint = 7;
		protected static const OAK_TREE:uint = 8;
		
		public static var worldNames:Array = ["The Hills Familiar","In a Candy Jam","Boo! Haunted House","Dry Bones","none","none","none","none","none"];
		public static var levelNames:Array = new Array(9);
		levelNames[0] = ["Daisy","Log","Toadstool","Beanstalk","Dirt Block","Acorn","Rocks","Leaf","Oak Tree"];
		levelNames[1] = ["","","","","","","","",""];
		levelNames[2] = ["Lock","","","","","","","","Treasure Chest"];
		levelNames[3] = ["","","","","","","","","Fennec"];
		levelNames[4] = ["","","","","","","","",""];
		levelNames[5] = ["","","","","","","","",""];
		levelNames[6] = ["","","","","","","","",""];
		levelNames[7] = ["","","","","","","","",""];
		levelNames[8] = ["","","","","","","","",""];
		
		public static var levelParForMedals:Array = new Array(81);
		levelParForMedals[DAISY] = [32, 48, 9999];
		levelParForMedals[LOG] = [60, 90, 9999];
		levelParForMedals[2] = [0, 0, 9999];
		levelParForMedals[BEANSTALK] = [80, 120, 9999];
		for (i = 4; i < 81; i++)
		{
			levelParForMedals[i] = [0, 0, 9999];
		}
		
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
