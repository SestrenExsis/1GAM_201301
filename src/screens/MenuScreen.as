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
			UserSettings.load();
			
			add(new FlxButton(FlxG.width / 2 - 40, FlxG.height / 2 + 10, "Play Game", onButtonLevelSelect));
			add(new FlxButton(FlxG.width / 2 - 40, FlxG.height / 2 + 32, "Configure", onButtonSettings));
		}
		
		override public function update():void
		{	
			super.update();
			
			if (FlxG.keys.justPressed("P"))
			{
				UserSettings.erase();
			}
		}
	}
}