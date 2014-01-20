package screens
{
	import frames.ButtonFrame;
	
	import org.flixel.*;
	
	public class LevelSelectScreen extends ScreenState
	{
		
		public function LevelSelectScreen()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			background = new ScrollingSprite(0, 0, "hills");
			add(background);
			 
			displayTimer = new FlxTimer();
			displayTimer.start(1, 1, onTimerFlickerDisplay);
			
			displayText = new FlxText(0, FlxG.height - 48, FlxG.width, "Press NUMPAD keys [1-9] to start a level.");
			displayText.setFormat(null, 16, 0xffffff, "center");
			displayText.text += ScreenState.infoText;
			add(displayText);
			
			var _x:int;
			var _y:int;
			var _button:ButtonFrame;
			for (var _i:int = 1; _i <= 9; _i++)
			{
				_x = (_i - 1) % 3;
				_y = 2 - (int)((_i - 1) / 3);
				_button = new ButtonFrame(64 + _x * 104, 8 + _y * 104, 96, 96, _i);
				add(_button);
			}
		}
		
		override public function update():void
		{	
			GameInput.update();
			super.update();
			if (GameInput.keyPressed >= 0)
			{
				FlxG.level = GameInput.keyPressed;
				fadeToGame();
			}
		}
	}
}