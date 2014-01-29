package
{
	import org.flixel.*;
	
	public class UserSettings
	{
		private static var _save:FlxSave;
		private static var _tempKeymap:Array;
		private static var _tempLevelStats:Array;
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
			FlxG.log("keyMap set");
		}
		
		public static function get levelStats():Array
		{
			if (_loaded) return _save.data.levelStats;
			else return _tempLevelStats;
		}
		
		public static function set levelStats(Value:Array):void
		{
			if (_loaded) _save.data.levelStats = Value;
			else _tempLevelStats = Value;
			FlxG.log("levelStats set");
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
				
				if(_save.data.levelStats == null)
				{
					var _levelStatArray:Array = new Array(GameInfo.NUM_LEVELS);
					var levelStat:Object = {medals: 0, fewestActions: -1, fastestTime: -1};
					for (var i:int = 0; i < GameInfo.NUM_LEVELS; i++)
					{
						_levelStatArray[i] = levelStat;
					}
					_save.data.levelStats = _levelStatArray.slice();
				}
				else
				{
					FlxG.log("Loading saved levelStats ...");
					GameInfo.levelStats = UserSettings.levelStats.slice();
				}
			}
		}
		
		public static function save():void
		{
			_save.flush();
		}
	}
}