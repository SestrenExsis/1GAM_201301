package
{
	import org.flixel.*;
	
	import screens.*;
	
	public class ScreenState extends FlxState
	{
		protected var displayText:FlxText;
		protected var displayTimer:FlxTimer;
		protected var background:ScrollingSprite;
		
		public static var infoText:String = "";
		
		public function ScreenState()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			FlxG.flash(0xff000000, 0.5);
		}
		
		override public function update():void
		{	
			super.update();
		}
		
		protected function onTimerFlickerDisplay(Timer:FlxTimer = null):void
		{
			displayText.visible = !displayText.visible;
			if (displayText.visible)
				displayTimer.start(1.5, 1, onTimerFlickerDisplay);
			else
				displayTimer.start(0.75, 1, onTimerFlickerDisplay);
		}
		
		public function onButtonLevelSelect():void
		{
			fadeToLevelSelect();
		}
		
		public function fadeToLevelSelect(Timer:FlxTimer = null):void
		{
			FlxG.fade(0xff000000, 0.5, goToLevelSelect);
		}
		
		public function goToLevelSelect():void
		{
			FlxG.switchState(new LevelSelectScreen);
		}
		
		public function onButtonGame():void
		{
			fadeToGame();
		}
		
		public function fadeToGame(Timer:FlxTimer = null):void
		{
			FlxG.fade(0xff000000, 0.5, goToGame);
		}
		
		public function goToGame():void
		{
			FlxG.switchState(new GameScreen);
		}
		
		public function onButtonMenu():void
		{
			fadeToMenu();
		}
		
		public function fadeToMenu(Timer:FlxTimer = null):void
		{
			FlxG.fade(0xff000000, 0.5, goToMenu);
		}
		
		public function goToMenu():void
		{
			FlxG.switchState(new MenuScreen);
		}
	}
}