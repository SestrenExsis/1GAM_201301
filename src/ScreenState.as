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
		
		public static function onButtonLevelSelect():void
		{
			GameInput.playbackMode = false;
			fadeToLevelSelect();
		}
		
		public static function fadeToLevelSelect(Timer:FlxTimer = null):void
		{
			GameSound.play(GameSound.sfxMenu);
			FlxG.fade(0xff000000, 0.5, goToLevelSelect);
		}
		
		public static function goToLevelSelect():void
		{
			FlxG.switchState(new LevelSelectScreen);
		}
		
		public static function onButtonSettings():void
		{
			GameInput.playbackMode = false;
			fadeToSettings();
		}
		
		public static function fadeToSettings(Timer:FlxTimer = null):void
		{
			GameSound.play(GameSound.sfxMenu);
			FlxG.fade(0xff000000, 0.5, goToSettings);
		}
		
		public static function goToSettings():void
		{
			FlxG.switchState(new SettingsScreen);
		}
		
		public static function onButtonWorldSelect():void
		{
			fadeToWorldSelect();
		}
		
		public static function fadeToWorldSelect(Timer:FlxTimer = null):void
		{
			GameSound.play(GameSound.sfxMenu);
			FlxG.fade(0xff000000, 0.5, goToWorldSelect);
		}
		
		public static function goToWorldSelect():void
		{
			FlxG.switchState(new WorldSelectScreen);
		}
		
		public static function onButtonGame():void
		{
			fadeToGame();
		}
		
		public static function fadeToGame(Timer:FlxTimer = null):void
		{
			GameSound.play(GameSound.sfxMenu);
			FlxG.fade(0xff000000, 0.5, goToGame);
		}
		
		public static function goToGame():void
		{
			FlxG.switchState(new GameScreen);
		}
		
		public static function onButtonMenu():void
		{
			fadeToMenu();
		}
		
		public static function fadeToMenu(Timer:FlxTimer = null):void
		{
			GameSound.play(GameSound.sfxMenu);
			FlxG.fade(0xff000000, 0.5, goToMenu);
		}
		
		public static function goToMenu():void
		{
			FlxG.switchState(new MenuScreen);
		}
	}
}