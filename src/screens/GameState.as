package screens
{
	import org.flixel.*;
	
	public class GameState extends ScreenState
	{		
		public function GameState()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xff464646;
			
			var puzzle:PuzzleFrame = new PuzzleFrame(126, 94);
			add(puzzle);
			
			var toolbox:Toolbox = new Toolbox(8, 8, puzzle)
			add(toolbox);
		}
		
		override public function update():void
		{	
			super.update();
			GameInput.update();
		}
	}
}