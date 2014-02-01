package
{
	import org.flixel.*;
	
	public class GameInput
	{
		public static var actions:Array = ["Escape","Down/Left","Down","Down/Right","Left","Center","Right","Up/Left","Up","Up/Right"];
		public static var keymap:Array = [
			"NUMPADZERO",
			"NUMPADONE", "NUMPADTWO", "NUMPADTHREE",
			"NUMPADFOUR", "NUMPADFIVE", "NUMPADSIX",
			"NUMPADSEVEN", "NUMPADEIGHT", "NUMPADNINE"];
		
		public static var keyPressed:int = -1;
		public static var mouseJustClicked:Boolean;
		public static var inputStream:String = "";
		public static var playbackStream:String = "";
		public static var playbackMode:Boolean = false;
		public static var playbackDelay:Number = 0.25;
		public static var playbackTimeLeft:Number;
		
		public static const NONE:int = -1;
		public static const ESCAPE:int = 0;
		public static const DOWN_LEFT:int = 1;
		public static const DOWN:int = 2;
		public static const DOWN_RIGHT:int = 3;
		public static const LEFT:int = 4;
		public static const CENTER:int = 5;
		public static const RIGHT:int = 6;
		public static const UP_LEFT:int = 7;
		public static const UP:int = 8;
		public static const UP_RIGHT:int = 9;
		
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
		
		public static var keyEscape:Boolean;
		public static var keyCenter:Boolean;
		public static var keyUp:Boolean;
		public static var keyUpRight:Boolean;
		public static var keyRight:Boolean;
		public static var keyDownRight:Boolean;
		public static var keyDown:Boolean;
		public static var keyDownLeft:Boolean;
		public static var keyLeft:Boolean;
		public static var keyUpLeft:Boolean;
		
		public static var x:int;
		public static var y:int;
		
		public function GameInput()
		{
			super();
		}
		
		public static function beginPlayback():void
		{
			playbackTimeLeft = playbackDelay;
			playbackMode = true;
			playbackStream = "357405602605454440260610554085";
		}
		
		public static function fetchPlayback():int
		{
			var Value:int = -1;
			if (playbackStream.length > 0)
			{
				var _char:int = playbackStream.charCodeAt(0);
				playbackStream = playbackStream.substr(1);
				if (_char >= 48 && _char <= 57)
					Value =  _char - 48;
			}
			FlxG.log(Value);
			return Value;
		}
		
		public static function update():void
		{
			GameInfo.currentTime++;
			
			if (FlxG.keys.justPressed("C"))
			{
				beginPlayback();
			}
				
			keyEscape = false;
			keyCenter = false;
			keyUp = false;
			keyUpRight = false;
			keyRight = false;
			keyDownRight = false;
			keyDown = false;
			keyDownLeft = false;
			keyLeft = false;
			keyUpLeft = false;
			
			keyPressed = -1;
			mouseJustClicked = false;
			
			if (playbackMode)
			{
				playbackTimeLeft -= FlxG.elapsed;
				if (playbackTimeLeft <= 0)
				{
					playbackTimeLeft = playbackDelay;
					keyPressed = fetchPlayback();
					if (keyPressed == -1)
						playbackMode = false;
				}
			}
			else
			{
				mouseJustClicked = FlxG.mouse.justPressed();
				if (FlxG.keys.justPressed(keymap[ESCAPE])) 			keyPressed = ESCAPE;
				else if (FlxG.keys.justPressed(keymap[CENTER])) 	keyPressed = CENTER;
				else if (FlxG.keys.justPressed(keymap[UP])) 		keyPressed = UP;
				else if (FlxG.keys.justPressed(keymap[RIGHT])) 		keyPressed = RIGHT;
				else if (FlxG.keys.justPressed(keymap[DOWN]))		keyPressed = DOWN;
				else if (FlxG.keys.justPressed(keymap[LEFT]))		keyPressed = LEFT;
				else if (FlxG.keys.justPressed(keymap[UP_RIGHT]))	keyPressed = UP_RIGHT;
				else if (FlxG.keys.justPressed(keymap[DOWN_RIGHT])) keyPressed = DOWN_RIGHT;
				else if (FlxG.keys.justPressed(keymap[DOWN_LEFT]))	keyPressed = DOWN_LEFT;
				else if (FlxG.keys.justPressed(keymap[UP_LEFT]))	keyPressed = UP_LEFT;
			}
			
			switch (keyPressed)
			{
				case ESCAPE: keyEscape = true; break;
				case CENTER: keyCenter = true; break;
				case UP: keyUp = true; break;
				case RIGHT: keyRight = true; break;
				case DOWN: keyDown = true; break;
				case LEFT: keyLeft = true; break;
				case UP_RIGHT: keyUpRight = true; break;
				case DOWN_RIGHT: keyDownRight = true; break;
				case DOWN_LEFT: keyDownLeft = true; break;
				case UP_LEFT: keyUpLeft = true; break;
			}
			
			x = y = 0;
			if (keyUp || keyUpRight || keyUpLeft)
				y = -1;
			else if (keyDown || keyDownRight || keyDownLeft)
				y = 1;
			
			if (keyLeft || keyUpLeft || keyDownLeft)
				x = -1;
			else if (keyRight || keyUpRight || keyDownRight)
				x = 1;
			
			if (keyPressed >= 0)
			{
				GameInfo.actions++;
				inputStream += keyPressed;
				if (inputStream.length > 10)
				{
					FlxG.log(inputStream);
					inputStream = "";
				}
			}
		}
	}
}
