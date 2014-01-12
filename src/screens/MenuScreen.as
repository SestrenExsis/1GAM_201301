package screens
{
	import org.flixel.*;
	
	public class MenuScreen extends ScreenState
	{
		private var displayText:FlxText;
		private var displayTimer:FlxTimer;
		
		public function MenuScreen()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xff464646;
			 
			displayTimer = new FlxTimer();
			displayTimer.start(1, 1, onTimerFlickerDisplay);
			
			displayText = new FlxText(0, FlxG.height - 48, FlxG.width, "Press NUMPAD keys [1-3] to start a level.");
			displayText.setFormat(null, 16, 0xffffff, "center");
			displayText.text += ScreenState.infoText;
			add(displayText);
		}
		
		private function onTimerFlickerDisplay(Timer:FlxTimer = null):void
		{
			displayText.visible = !displayText.visible;
			if (displayText.visible)
				displayTimer.start(1.5, 1, onTimerFlickerDisplay);
			else
				displayTimer.start(0.75, 1, onTimerFlickerDisplay);
		}
		
		override public function update():void
		{	
			super.update();
			
			GameInput.update();
			if (GameInput.keyPressed > 0 && GameInput.keyPressed < 4)
			{
				FlxG.level = GameInput.keyPressed;
				fadeToGame();
			}
		}
	}
}