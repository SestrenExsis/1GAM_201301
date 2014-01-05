package screens
{
	import org.flixel.*;
	
	public class MenuState extends ScreenState
	{
		private var displayText:FlxText;
		private var displayTimer:FlxTimer;
		
		public function MenuState()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xff464646;
			 
			displayTimer = new FlxTimer();
			displayTimer.start(1, 1, onTimerFlickerDisplay);
			
			displayText = new FlxText(0, FlxG.height - 32, FlxG.width, "Click to play REDRAWN.");
			displayText.setFormat(null, 16, 0xffffff, "center");
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
			
			if (FlxG.mouse.justPressed())
				fadeToGame();
		}
	}
}