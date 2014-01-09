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
			
			var target:TargetFrame = new TargetFrame(8, 8);
			add(target);
			
			var puzzle:PuzzleFrame = new PuzzleFrame(126, 94, target);
			add(puzzle);
			
			var tracker:TrackerFrame = new TrackerFrame(126, 8, target, puzzle);
			add(tracker);
			
			var toolbox:ToolboxFrame = new ToolboxFrame(8, 128, target, puzzle)
			add(toolbox);
		}
		
		override public function update():void
		{	
			super.update();
			GameInput.update();
		}
	}
}