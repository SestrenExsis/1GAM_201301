package
{
	import org.flixel.*;
	
	public class GameInput
	{
		public static var keyPressed:int = -1;
		public static var mouseJustClicked:Boolean;
		
		public static const NONE:int = -1;
		public static const SPECIAL:int = 0;
		public static const SOUTHWEST:int = 1;
		public static const SOUTH:int = 2;
		public static const SOUTHEAST:int = 3;
		public static const WEST:int = 4;
		public static const CENTER:int = 5;
		public static const EAST:int = 6;
		public static const NORTHWEST:int = 7;
		public static const NORTH:int = 8;
		public static const NORTHEAST:int = 9;
		
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
			
			keyPressed = -1;
			mouseJustClicked = FlxG.mouse.justPressed();
			
			if (FlxG.keys.justPressed("NUMPADZERO"))
			{
				keyUndo = true;
				keyPressed = SPECIAL;
			}
			else if (FlxG.keys.justPressed("NUMPADFIVE"))
			{
				keyCenter = true;
				keyPressed = CENTER;
			}
			else if (FlxG.keys.justPressed("NUMPADEIGHT"))
			{
				keyNorth = true;
				keyPressed = NORTH;
			}
			else if (FlxG.keys.justPressed("NUMPADSIX"))
			{
				keyEast = true;
				keyPressed = EAST;
			}
			else if (FlxG.keys.justPressed("NUMPADTWO"))
			{
				keySouth = true;
				keyPressed = SOUTH;
			}
			else if (FlxG.keys.justPressed("NUMPADFOUR"))
			{
				keyWest = true;
				keyPressed = WEST;
			}
			else if (FlxG.keys.justPressed("NUMPADNINE"))
			{
				keyNortheast = true;
				keyPressed = NORTHEAST;
			}
			else if (FlxG.keys.justPressed("NUMPADTHREE"))
			{
				keySoutheast = true;
				keyPressed = SOUTHEAST;
			}
			else if (FlxG.keys.justPressed("NUMPADONE"))
			{
				keySouthwest = true;
				keyPressed = SOUTHWEST;
			}
			else if (FlxG.keys.justPressed("NUMPADSEVEN"))
			{
				keyNorthwest = true;
				keyPressed = NORTHWEST;
			}
			
			if (keyPressed >= 0)
				FlxG.score++;
		}
	}
}
