package screens
{
	import org.flixel.*;
	
	public class GameState extends ScreenState
	{
		private var puzzle:PuzzleWindow;
		
		public function GameState()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xff464646;
			
			puzzle = new PuzzleWindow(126, 94);
			add(puzzle);
		}
		
		override public function update():void
		{	
			super.update();
			GameInput.update();
		}
	}
}