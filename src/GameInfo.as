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
		
		public static const DAISY:uint = 0;
		public static const LOG:uint = 1;
		public static const BEANSTALK:uint = 2;
		public static const CUPCAKE:uint = 3;
		public static const CANDY_CANE:uint = 4;
		public static const COOKIE:uint = 5;
		public static const PORTCULLIS:uint = 6;
		public static const TREASURE_CHEST:uint = 7;
		public static const CROWN:uint = 8;
		
		public static var worldNames:Array = ["The Hills Familiar","Stuck in a Candy Jam","Castle in the Clouds","none","none","none","none","none","none"];
		public static var levelNames:Array =  ["Daisy","Log","Beanstalk","Cupcake","Candy Cane","Cookie","Portcullis","Chest","Crown"];
		
		public static var maxActionsToEarnCoin:Array = new Array(NUM_LEVELS);
		maxActionsToEarnCoin[DAISY] = 32;
		maxActionsToEarnCoin[LOG] = 60;
		maxActionsToEarnCoin[BEANSTALK] = 60;
		maxActionsToEarnCoin[CUPCAKE] = 140;
		maxActionsToEarnCoin[CANDY_CANE] = 250;
		maxActionsToEarnCoin[COOKIE] = 200;
		maxActionsToEarnCoin[PORTCULLIS] = 220;
		maxActionsToEarnCoin[TREASURE_CHEST] = 999;
		maxActionsToEarnCoin[CROWN] = 999;
		
		public static var maxFramesToEarnCoin:Array = new Array(NUM_LEVELS);
		maxFramesToEarnCoin[DAISY] = 900;
		maxFramesToEarnCoin[LOG] = 1800;
		maxFramesToEarnCoin[BEANSTALK] = 1800;
		maxFramesToEarnCoin[CUPCAKE] = 2700;
		maxFramesToEarnCoin[CANDY_CANE] = 3600;
		maxFramesToEarnCoin[COOKIE] = 9000;
		maxFramesToEarnCoin[PORTCULLIS] = 3600;
		maxFramesToEarnCoin[TREASURE_CHEST] = 9000;
		maxFramesToEarnCoin[CROWN] = 10800;
		
		public static var frameRects:Array = [
			new Rectangle(41, 0, 9, 9),
			new Rectangle(50, 0, 8, 8),
			new Rectangle(57, 16, 20, 20),
			new Rectangle(50, 36, 24, 24),
			new Rectangle(32, 36, 18, 36),
			new Rectangle(0, 36, 32, 32),
			new Rectangle(40, 72, 40, 40),
			new Rectangle(74, 36, 18, 18),
			new Rectangle(96, 40, 32, 32)
		];
		
		public function GameInfo()
		{
			super();
		}
		
		public static function formatTime(TimeInFrames:int):String
		{
			var _tenths:int = (TimeInFrames % 60) / 6;
			var _seconds:int = (TimeInFrames / 60) % 60;
			var _minutes:int = (TimeInFrames / 3600);
			var _leadingZero:String = "";
			
			if (_seconds < 10) _leadingZero = "0";
			
			return _minutes + ":" + _leadingZero + _seconds + "." + _tenths;
		}
		
		public static function updateStatistics():void
		{
			var _stage:int = world * 9 + level;
			var _maxActions:int = maxActionsToEarnCoin[_stage];
			var _maxTime:int = maxFramesToEarnCoin[_stage];
			var _newCoins:Boolean = false;
			var _newRecord:Boolean = false;
			
			if (coinsCollected[_stage] == 0)
			{
				FlxG.log("You gained a coin for completing the stage for the first time.");
				coinsCollected[_stage]++;
				_newCoins = true;
			}
			
			if ((fewestActions[_stage] > _maxActions) && (actions <= _maxActions))
			{ 
				FlxG.log("You gained a coin for using less than or equal to the par number of actions.");
				coinsCollected[_stage]++;
				_newCoins = true;
			}
			
			FlxG.log("Previous best: " + bestTimes[_stage] + ", Par: " + _maxTime);
			if ((bestTimes[_stage] > _maxTime) && (currentTime <= _maxTime))
			{ 
				FlxG.log("You gained a coin for finishing in less than or equal to the par time.");
				coinsCollected[_stage]++;
				_newCoins = true;
			}
			
			if (_newCoins)
				UserSettings.coins[_stage] = coinsCollected[_stage];
			
			if (actions < fewestActions[_stage])
			{
				fewestActions[_stage] = actions;
				UserSettings.fewestActions[_stage] = fewestActions[_stage];
				_newRecord = true;
			}
			
			if (currentTime < bestTimes[_stage])
			{
				bestTimes[_stage] = currentTime;
				UserSettings.bestTimes[_stage] = bestTimes[_stage];
				_newRecord = true;
			}
		}
	}
}
