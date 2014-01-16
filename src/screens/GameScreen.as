package screens
{
	import frames.PuzzleFrame;
	import frames.TargetFrame;
	import frames.ToolboxFrame;
	import frames.TrackerFrame;
	
	import org.flixel.*;
	
	public class GameScreen extends ScreenState
	{
		[Embed(source="../assets/images/cursor.png")] public var imgCursor:Class;

		private var tracker:TrackerFrame;
		private var toolbox:ToolboxFrame;
		private var cursor:FlxSprite;
		
		public function GameScreen()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.score = 0;
			FlxG.bgColor = 0xff464646;
			
			background = new ScrollingSprite(0, 0, "hills");
			add(background);
			
			var target:TargetFrame = new TargetFrame(8, 8, FlxG.level);
			add(target);
			
			var puzzle:PuzzleFrame = new PuzzleFrame(288, 8, target);
			add(puzzle);
			
			tracker = new TrackerFrame(148, 232, target, puzzle);
			add(tracker);
			
			toolbox = new ToolboxFrame(8, 232, target, puzzle)
			add(toolbox);
			
			cursor = new FlxSprite(-100, -100);
			cursor.loadGraphic(imgCursor, true, false, 32, 32);
			cursor.addAnimation("grab",[0]);
			cursor.play("grab");
			add(cursor);
		}
		
		override public function update():void
		{	
			super.update();
			GameInput.update();
			
			var _cursorPos:FlxPoint = toolbox.cursorLocationVisual;
			cursor.x = _cursorPos.x - 0.5 * cursor.width;
			cursor.y = _cursorPos.y - 0.5 * cursor.height;
			
			if (tracker.solved)
			{
				ScreenState.infoText = "\nActions Previous Level: " + FlxG.score;
				fadeToMenu();
			}
		}
	}
}