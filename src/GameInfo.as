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
		protected static const PORTCULLIS:uint = 6;
		protected static const TREASURE_CHEST:uint = 7;
		protected static const CROWN:uint = 8;
		
		public static var worldNames:Array = ["The Hills Familiar","Stuck in a Candy Jam","Castle in the Clouds","none","none","none","none","none","none"];
		public static var levelNames:Array =  ["Daisy","Log","Beanstalk","Cupcake","Cookie","Candy Cane","Portcullis","Treasure Chest","King's Crown"];
		
		public static var maxActionsToEarnCoin:Array = new Array(NUM_LEVELS);
		maxActionsToEarnCoin[DAISY] = 32;
		maxActionsToEarnCoin[LOG] = 60;
		maxActionsToEarnCoin[BEANSTALK] = 60;
		maxActionsToEarnCoin[CUPCAKE] = 140;
		maxActionsToEarnCoin[CANDY_CANE] = 250;
		maxActionsToEarnCoin[COOKIE] = 999;
		maxActionsToEarnCoin[PORTCULLIS] = 220;
		maxActionsToEarnCoin[TREASURE_CHEST] = 999;
		maxActionsToEarnCoin[CROWN] = 999;
		
		public static var maxTimeToEarnCoin:Array = new Array(NUM_LEVELS);
		maxActionsToEarnCoin[DAISY] = 30;
		maxActionsToEarnCoin[LOG] = 60;
		maxActionsToEarnCoin[BEANSTALK] = 60;
		maxActionsToEarnCoin[CUPCAKE] = 90;
		maxActionsToEarnCoin[CANDY_CANE] = 120;
		maxActionsToEarnCoin[COOKIE] = 150;
		maxActionsToEarnCoin[PORTCULLIS] = 60;
		maxActionsToEarnCoin[TREASURE_CHEST] = 150;
		maxActionsToEarnCoin[CROWN] = 180;
		
		public static var frameRects:Array = [
			new Rectangle(39, 0, 9, 9),
			new Rectangle(48, 0, 8, 8),
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
		
		public static function updateStatistics():void
		{
			ScreenState.infoText = "\nActions Previous Level: " + actions;
			var _stage:int = world * 9 + level;
			var _maxActions:int = maxActionsToEarnCoin[_stage];
			var _maxTime:int = maxTimeToEarnCoin[_stage];
			var _newCoins:Boolean = false;
			var _newRecord:Boolean = false;
			
			if (coinsCollected[_stage] == 0)
			{ // You gained a coin for completing the stage for the first time.
				coinsCollected[_stage]++;
				_newCoins = true;
			}
			
			if ((fewestActions[_stage] > _maxActions) && (actions <= _maxActions))
			{ // You gained a coin for using less than or equal to the par number of actions.
				coinsCollected[_stage]++;
				UserSettings.coins[_stage] = coinsCollected[_stage];
				_newCoins = true;
			}
			
			if ((bestTimes[_stage] > _maxTime) && (currentTime <= _maxTime))
			{ // You gained a coin for finishing in less than or equal to the par time.
				coinsCollected[_stage]++;
				UserSettings.coins[_stage] = coinsCollected[_stage];
				_newCoins = true;
			}
			
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
