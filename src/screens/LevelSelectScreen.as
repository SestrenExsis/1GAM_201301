package screens
{
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
		}
		
		override public function update():void
		{	
			super.update();
			
			GameInput.update();
			if (GameInput.keyPressed >= 0 && GameInput.keyPressed < 4)
			{
				FlxG.level = GameInput.keyPressed;
				fadeToGame();
			}
		}
	}
}