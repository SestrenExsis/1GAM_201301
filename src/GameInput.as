package
{
	import org.flixel.*;
	
	public class GameInput
	{
		public static var keyUndo:Boolean;
		public static var keyCenter:Boolean;
		public static var keyNorth:Boolean;
		public static var keyNortheast:Boolean;
		public static var keyEast:Boolean;
		public static var keySoutheast:Boolean;
		public static var keySouth:Boolean;
		public static var keySouthwest:Boolean;
		public static var keyWest:Boolean;
		public static var keyNorthwest:Boolean;
		
		public function GameInput()
		{
			super();
		}
		
		public static function update():void
		{
			keyUndo = false;
			keyCenter = false;
			keyNorth = false;
			keyNortheast = false;
			keyEast = false;
			keySoutheast = false;
			keySouth = false;
			keySouthwest = false;
			keyWest = false;
			keyNorthwest = false;
			
			if (FlxG.keys.justPressed("NUMPADZERO"))
				keyUndo = true;
			else if (FlxG.keys.justPressed("NUMPADEIGHT"))
				keyNorth = true;
			else if (FlxG.keys.justPressed("NUMPADSIX"))
				keyEast = true;
			else if (FlxG.keys.justPressed("NUMPADTWO"))
				keySouth = true;
			else if (FlxG.keys.justPressed("NUMPADFOUR"))
				keyWest = true;
			else if (FlxG.keys.justPressed("NUMPADNINE"))
				keyNortheast = true;
			else if (FlxG.keys.justPressed("NUMPADTHREE"))
				keySoutheast = true;
			else if (FlxG.keys.justPressed("NUMPADONE"))
				keySouthwest = true;
			else if (FlxG.keys.justPressed("NUMPADSEVEN"))
				keyNorthwest = true;
			else if (FlxG.keys.justPressed("NUMPADFIVE"))
				keyCenter = true;
		}
	}
}
