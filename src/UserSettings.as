package
{
	import org.flixel.*;
	
	public class UserSettings
	{
		private static var _save:FlxSave;
		private static var _tempKeymap:Array;
		private static var _loaded:Boolean = false;
		private static var _tempHighScore:uint;
		
		public static function get keymap():Array
		{
			if (_loaded) return _save.data.keymap;
			else return _tempKeymap;
		}
		
		public static function set keymap(value:Array):void
		{
			if (_loaded) _save.data.keymap = value;
			else _tempKeymap = value;
		}

		public static function load():void
		{
			_save = new FlxSave();
			_loaded = _save.bind("redrawnSettings");
			
			if (_loaded)
			{
				if (_save.data.keymappingP1 == null) 
				{
					_save.data.keymap = new Array(
						"NUMPADSEVEN", "NUMPADEIGHT", "NUMPADNINE",
						"NUMPADFOUR", "NUMPADFIVE", "NUMPADSIX",
						"NUMPADONE", "NUMPADTWO", "NUMPADTHREE",
						"NUMPADZERO");
					FlxG.log("Loading default keymap.");
				}
				else 
				{
					FlxG.log("Loading saved keymap.");
					GameInput.keymap = UserSettings.keymap.slice();
				}
			}
		}
		
		public static function save():void
		{
			_save.flush();
		}
	}
}