package
{
	import org.flixel.FlxGame;
	import screens.MenuState;

	[SWF(width="440", height="400", backgroundColor="#888888")]
	
	public class OneGameAMonth extends FlxGame
	{
		public function OneGameAMonth()
		{
			super(440, 400, MenuState, 1.0, 60, 60, true);
			forceDebugger = true;
			useSoundHotKeys = false;
		}
	}
}
