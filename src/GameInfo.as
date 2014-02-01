package
{
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	
	public class GameInfo
	{
		public static var world:int = 0;
		public static var level:int = 0;
		public static var actions:int = 0;
		public static var currentTime:int = 0;
		
		public static var NUM_LEVELS:int = 9;
		
		private static var i:int;
		public static var coinsCollected:Array = new Array(NUM_LEVELS);
		for (i = 0; i < NUM_LEVELS; i++)
		{
			coinsCollected[i] = 0;
		}
		public static var fewestActions:Array = new Array(NUM_LEVELS);
		for (i = 0; i < NUM_LEVELS; i++)
		{
			fewestActions[i] = 999999;
		}
		public static var bestTimes:Array = new Array(NUM_LEVELS);
		for (i = 0; i < NUM_LEVELS; i++)
		{
			bestTimes[i] = 999999999;
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
		levelParForMedals[CANDY_CANE] = [250, 375, 99999];
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
		
		public static function updateStatistics():void
		{
			ScreenState.infoText = "\nActions Previous Level: " + actions;
			var _stage:int = world * 9 + level;
			var _levelPar:Array = levelParForMedals[_stage].slice();
			var _newCoins:Boolean = false;
			
			if (actions <= _levelPar[0] && coinsCollected[_stage] < 3)
			{ // You now have 3 medals for this stage.
				_newCoins = true;
				coinsCollected[_stage] = 3;
				FlxG.log("You now have 3 medals for stage " + world + "-" + level);
			}
			else if (actions <= _levelPar[1] && coinsCollected[_stage] < 2)
			{ // You now have 2 medals for this stage.
				_newCoins = true;
				coinsCollected[_stage] = 2;
				FlxG.log("You now have 2 medals for stage " + world + "-" + level);
			}
			else if (actions <= _levelPar[2] && coinsCollected[_stage] < 1)
			{ // You now have 1 medal for this stage.
				_newCoins = true;
				coinsCollected[_stage] = 1;
				FlxG.log("You now have 1 medals for stage " + world + "-" + level);
			}
			
			if (_newCoins)
				UserSettings.coins[_stage] = coinsCollected[_stage];
			
			if (actions < fewestActions[_stage])
			{
				fewestActions[_stage] = actions;
				UserSettings.fewestActions[_stage] = fewestActions[_stage];
			}
			
			if (currentTime < bestTimes[_stage])
			{
				bestTimes[_stage] = currentTime;
				UserSettings.bestTimes[_stage] = bestTimes[_stage];
			}
		}
	}
}
