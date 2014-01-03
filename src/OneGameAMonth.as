package
{
	import org.flixel.FlxGame;
	import screens.MenuState;

	[SWF(width="512", height="480", backgroundColor="#888888")]
	
	public class OneGameAMonth extends FlxGame
	{
		public function OneGameAMonth()
		{
			super(256, 240, MenuState, 2.0, 60, 60, true);
			forceDebugger = true;
			useSoundHotKeys = false;
		}
	}
}
