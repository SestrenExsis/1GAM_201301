package
{
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	
	public class GameInfo
	{
		public static var world:int = 0;
		public static var level:int = 0;
		public static var actions:int = 0;
		
		public static var NUM_LEVELS:int = 9;
		private static var i:int;
		public static var levelStats:Array = new Array(NUM_LEVELS);
		for (i = 0; i < NUM_LEVELS; i++)
		{
			levelStats[i] = {medals: 0, fewestActions: 999999, fastestTime: 999999};
		}
		
		protected static const DAISY:uint = 0;
		protected static const LOG:uint = 1;
		protected static const BEANSTALK:uint = 2;
		protected static const CUPCAKE:uint = 3;
		protected static const CANDY_CANE:uint = 4;
		protected static const COOKIE:uint = 5;
		protected static const LEVEL_7:uint = 6;
		protected static const LEVEL_8:uint = 7;
		protected static const TREASURE_CHEST:uint = 8;
		
		public static var worldNames:Array = ["The Hills Familiar","In a Candy Jam","Boo! Haunted House","none","none","none","none","none","none"];
		public static var levelNames:Array =  ["Daisy","Log","Beanstalk","Cupcake","Cookie","Candy Cane","Level 7","Level 8","Treasure Chest"];
		
		public static var levelParForMedals:Array = new Array(NUM_LEVELS);
		levelParForMedals[DAISY] = [32, 48, 99999];
		levelParForMedals[LOG] = [60, 90, 99999];
		levelParForMedals[BEANSTALK] = [60, 90, 99999];
		levelParForMedals[CUPCAKE] = [140, 210, 99999];
		levelParForMedals[CANDY_CANE] = [999, 9999, 99999];
		levelParForMedals[COOKIE] = [999, 9999, 99999];
		levelParForMedals[LEVEL_7] = [999, 9999, 99999];
		levelParForMedals[LEVEL_8] = [999, 9999, 99999];
		levelParForMedals[TREASURE_CHEST] = [999, 9999, 99999];
		
		public static var frameRects:Array = [
			new Rectangle(39, 0, 9, 9),
			new Rectangle(48, 0, 8, 8),
			new Rectangle(57, 16, 20, 20),
			new Rectangle(50, 36, 24, 24),
			new Rectangle(32, 36, 18, 36),
			new Rectangle(0, 36, 32, 32),
			new Rectangle(0, 0, 10, 10),
			new Rectangle(0, 0, 10, 10),
			new Rectangle(74, 36, 18, 18)
		];
		
		public function GameInfo()
		{
			super();
		}
	}
}
