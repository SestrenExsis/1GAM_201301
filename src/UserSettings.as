package
{
	import org.flixel.*;
	
	public class UserSettings
	{
		private static var _save:FlxSave;
		private static var _tempKeymap:Array;
		private static var _tempCoins:Array;
		private static var _tempFewestActions:Array;
		private static var _tempBestTimes:Array;
		private static var _loaded:Boolean = false;
		
		public static function get keymap():Array
		{
			if (_loaded) return _save.data.keymap;
			else return _tempKeymap;
		}
		
		public static function set keymap(Value:Array):void
		{
			if (_loaded) _save.data.keymap = Value;
			else _tempKeymap = Value;
			FlxG.log("keymap set");
		}
		
		public static function get coins():Array
		{
			if (_loaded) return _save.data.coins;
			else return _tempCoins;
		}
		
		public static function set coins(Value:Array):void
		{
			if (_loaded) _save.data.coins = Value;
			else _tempCoins = Value;
			
			FlxG.log("Coins: " + Value.join(", "));
		}
		
		public static function get fewestActions():Array
		{
			if (_loaded) return _save.data.fewestActions;
			else return _tempFewestActions;
		}
		
		public static function set fewestActions(Value:Array):void
		{
			if (_loaded) _save.data.fewestActions = Value;
			else _tempFewestActions = Value;
			
			FlxG.log("Fewest Actions: " + Value.join(", "));
		}
		
		public static function get bestTimes():Array
		{
			if (_loaded) return _save.data.bestTimes;
			else return _tempBestTimes;
		}
		
		public static function set bestTimes(Value:Array):void
		{
			if (_loaded) _save.data.bestTimes = Value;
			else _tempBestTimes = Value;
			
			FlxG.log("Best Times: " + Value.join(", "));
		}

		public static function load():void
		{
			_save = new FlxSave();
			_loaded = _save.bind("RedrawnSettings");
			
			if (_loaded)
			{
				if (_save.data.keymap == null) 
				{
					_save.data.keymap = new Array( "NUMPADZERO", 
						"NUMPADONE", "NUMPADTWO", "NUMPADTHREE", 
						"NUMPADFOUR", "NUMPADFIVE", "NUMPADSIX",
						"NUMPADSEVEN", "NUMPADEIGHT", "NUMPADNINE");
					FlxG.log("Loading default keymap.");
				}
				else 
				{
					FlxG.log("Loading saved keymap ...");
					GameInput.keymap = UserSettings.keymap.slice();
				}
				
				if(_save.data.coins == null)
				{
					_save.data.coins = new Array(GameInfo.NUM_LEVELS);
					for (var i:int = 0; i < GameInfo.NUM_LEVELS; i++)
					{
						_save.data.coins[i] = 0;
					}
					FlxG.log("Clearing coins collected ...");
				}
				else
				{
					FlxG.log("Loading coins collected ...");
				}
				GameInfo.coinsCollected = coins.slice();
				
				if(_save.data.fewestActions == null)
				{
					_save.data.fewestActions = new Array(GameInfo.NUM_LEVELS);
					for (i = 0; i < GameInfo.NUM_LEVELS; i++)
					{
						_save.data.fewestActions[i] = 999999;
					}
					FlxG.log("Clearing coins collected ...");
				}
				else
				{
					FlxG.log("Loading coins collected ...");
				}
				GameInfo.fewestActions = fewestActions.slice();
				
				if(_save.data.fewestActions == null)
				{
					_save.data.fewestActions = new Array(GameInfo.NUM_LEVELS);
					for (i = 0; i < GameInfo.NUM_LEVELS; i++)
					{
						_save.data.fewestActions[i] = 999999;
					}
					FlxG.log("Clearing fewest actions ...");
				}
				else
				{
					FlxG.log("Loading fewest actions ...");
				}
				GameInfo.fewestActions = fewestActions.slice();
				
				if(_save.data.bestTimes == null)
				{
					_save.data.bestTimes = new Array(GameInfo.NUM_LEVELS);
					for (i = 0; i < GameInfo.NUM_LEVELS; i++)
					{
						_save.data.bestTimes[i] = 999999999;
					}
					FlxG.log("Clearing best times ...");
				}
				else
				{
					FlxG.log("Loading best times ...");
				}
				GameInfo.bestTimes = bestTimes.slice();
			}
		}
		
		public static function save():void
		{
			_save.flush();
		}
		
		public static function erase():void
		{
			_save.erase();
			FlxG.log("Saved data erased ...");
		}
	}
}