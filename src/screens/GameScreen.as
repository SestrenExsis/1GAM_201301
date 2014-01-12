package screens
{
	import org.flixel.*;
	import frames.PuzzleFrame;
	import frames.TargetFrame;
	import frames.ToolboxFrame;
	import frames.TrackerFrame;
	
	public class GameScreen extends ScreenState
	{
		private var tracker:TrackerFrame;
		
		public function GameScreen()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.score = 0;
			FlxG.bgColor = 0xff464646;
			
			var target:TargetFrame = new TargetFrame(8, 8, FlxG.level);
			add(target);
			
			var puzzle:PuzzleFrame = new PuzzleFrame(126, 82, target);
			add(puzzle);
			
			tracker = new TrackerFrame(126, 16, target, puzzle);
			add(tracker);
			
			var toolbox:ToolboxFrame = new ToolboxFrame(8, 140, target, puzzle)
			add(toolbox);
		}
		
		override public function update():void
		{	
			super.update();
			GameInput.update();
			
			if (tracker.solved)
			{
				ScreenState.infoText = "\nActions Previous Level: " + FlxG.score;
				fadeToMenu();
			}
		}
	}
}