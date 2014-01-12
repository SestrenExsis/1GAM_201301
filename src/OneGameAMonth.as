package
{
	import org.flixel.FlxGame;
	import screens.MenuScreen;

	[SWF(width="440", height="400", backgroundColor="#888888")]
	
	public class OneGameAMonth extends FlxGame
	{
		public function OneGameAMonth()
		{
			super(440, 400, MenuScreen, 1.0, 60, 60, true);
			forceDebugger = true;
			useSoundHotKeys = false;
		}
	}
}
