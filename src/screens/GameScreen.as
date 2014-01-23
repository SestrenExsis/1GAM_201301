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

		private var puzzle:PuzzleFrame;
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
			
			GameInfo.actions = 0;
			FlxG.bgColor = 0xff464646;
			
			background = new ScrollingSprite(0, 0, "candy");
			add(background);
			
			var target:TargetFrame = new TargetFrame(8, 8, 208, 208, GameInfo.level);
			add(target);
			
			puzzle = new PuzzleFrame(288, 8, 336, 336, target);
			add(puzzle);
			
			tracker = new TrackerFrame(148, 232, target, puzzle);
			add(tracker);
			
			toolbox = new ToolboxFrame(8, 232, 104, 104, target, puzzle)
			add(toolbox);
			
			cursor = new FlxSprite(-100, -100);
			cursor.loadGraphic(imgCursor, true, false, 32, 32);
			cursor.addAnimation("grab",[0]);
			cursor.play("grab");
			add(cursor);
			
			if (puzzle.element.width <= 24)
			{
				cursor.scale.x = cursor.scale.y = puzzle.element.width / 24;
				cursor.width *= cursor.scale.x;
				cursor.height *= cursor.scale.y;
			}
		}
		
		override public function update():void
		{	
			GameInput.update();
			super.update();
			
			var _cursorPos:FlxPoint = toolbox.cursorLocationVisual;
			cursor.x = _cursorPos.x - 0.5 * cursor.width;
			cursor.y = _cursorPos.y - 0.5 * cursor.height;
			
			if (tracker.solved)
			{
				ScreenState.infoText = "\nActions Previous Level: " + GameInfo.actions;
				fadeToMenu();
			}
		}
	}
}