package
{
	import org.flixel.*;
	
	public class GameInput
	{
		public static const NORTHWEST:uint = 0;
		public static const NORTHEAST:uint = 1;
		public static const SOUTHWEST:uint = 2;
		public static const SOUTHEAST:uint = 3;
		
		public static const NUMPADZERO:uint 	= 0x0000;
		public static const NUMPADONE:uint 		= 0x0001;
		public static const NUMPADTWO:uint 		= 0x0010;
		public static const NUMPADTHREE:uint 	= 0x0011;
		public static const NUMPADFOUR:uint 	= 0x0100;
		public static const NUMPADFIVE:uint 	= 0x0101;
		public static const NUMPADSIX:uint 		= 0x0110;
		public static const NUMPADSEVEN:uint 	= 0x0111;
		public static const NUMPADEIGHT:uint 	= 0x1000;
		public static const NUMPADNINE:uint 	= 0x1001;
		public static const NUMPADSLASH:uint	= 0x1010;
		public static const NUMPADASTERISK:uint	= 0x1011; //not currently in Keyboard class. Needs to be added.
		public static const NUMPADMINUS:uint	= 0x1100;
		public static const NUMPADPLUS:uint		= 0x1101;
		public static const ENTER:uint			= 0x1110;
		public static const NUMPADPERIOD:uint	= 0x1111;
		
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
			else if (FlxG.keys.justPressed("NUMPADFIVE"))
				keyCenter = true;
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

		}
	}
}
