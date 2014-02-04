package screens
{
	import flash.geom.Rectangle;
	
	import frames.ButtonFrame;
	
	import org.flixel.*;
	
	public class LevelSelectScreen extends ScreenState
	{
		[Embed(source="../assets/images/world1.png")] public var imgButtons:Class;
				
		public function LevelSelectScreen()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xff000000;
			
			background = new ScrollingSprite(2, 240, GameInfo.worldNames[0]);
			background.scrollPosition.y = 180;
			background.maskWidth = 636;
			background.maskHeight = 118;
			add(background);
			background = new ScrollingSprite(2, 121, GameInfo.worldNames[1]);
			background.scrollSpeed.x *= -1;
			background.scrollPosition.y = 90;
			background.maskWidth = 636;
			background.maskHeight = 118;
			add(background);
			background = new ScrollingSprite(2, 2, GameInfo.worldNames[2]);
			background.scrollPosition.y = 200;
			background.maskWidth = 636;
			background.maskHeight = 118;
			add(background);
			 
			//displayTimer = new FlxTimer();
			//displayTimer.start(1, 1, onTimerFlickerDisplay);
			
			//displayText = new FlxText(0, FlxG.height - 48, FlxG.width, "Press NUMPAD keys [1-9] to start a level.");
			//displayText.setFormat(null, 16, 0xffffff, "center");
			//displayText.text += ScreenState.infoText;
			//add(displayText);
			
			var _x:int;
			var _y:int;
			var _button:ButtonFrame;
			for (var _i:int = 0; _i < 9; _i++)
			{
				_x = _i % 3;
				_y = 2 - (int)(_i / 3);
				_button = new ButtonFrame(8 + _x * 200, 12 + _y * 120, 96, 96, _i, "level");
				_button.loadButtonImage(imgButtons, GameInfo.frameRects[_i]);
				add(_button);
			}
		}
		
		override public function update():void
		{	
			GameInput.update();
			super.update();
			if (GameInput.keyPressed == 0 || FlxG.keys["ESCAPE"])
			{
				fadeToMenu();
			}
			else if (GameInput.keyPressed > 0)
			{
				GameInfo.level = GameInput.keyPressed - 1;
				fadeToGame();
			}
		}
	}
}