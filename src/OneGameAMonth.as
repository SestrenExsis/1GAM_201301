package
{
	import org.flixel.FlxGame;
	import screens.MenuScreen;

	[SWF(width="640", height="360", backgroundColor="#888888")]
	
	public class OneGameAMonth extends FlxGame
	{
		public function OneGameAMonth()
		{
			super(640, 360, MenuScreen, 1.0, 60, 60, true);
			forceDebugger = true;
			useSoundHotKeys = false;
		}
	}
}
