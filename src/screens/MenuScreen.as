package screens
{
	import org.flixel.*;
	
	public class MenuScreen extends ScreenState
	{
		
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
			
			displayText = new FlxText(0, 0.5 * FlxG.height - 16, FlxG.width, "Click to play.");
			displayText.setFormat(null, 16, 0xffffff, "center");
			displayText.text += ScreenState.infoText;
			add(displayText);
		}
		
		override public function update():void
		{	
			super.update();
			
			GameInput.update();
			if (GameInput.mouseJustClicked)
				fadeToLevelSelect();
		}
	}
}