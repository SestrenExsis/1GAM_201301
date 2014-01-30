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
			
			background = new ScrollingSprite(0, 0, GameInfo.worldNames[GameInfo.world]);
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
			
			if (!tracker.wasSolved && tracker.solved)
			{
				ScreenState.infoText = "\nActions Previous Level: " + GameInfo.actions;
				var _stage:int = GameInfo.world * 9 + GameInfo.level;
				var _levelPar:Array = GameInfo.levelParForMedals[_stage].slice();
				
				if (GameInfo.actions <= _levelPar[0] && GameInfo.levelStats[_stage].medals < 3)
				{ // You now have 3 medals for this stage
					GameInfo.levelStats[_stage].medals = 3;
					FlxG.log("You now have 3 medals for stage " + GameInfo.world + "-" + GameInfo.level);
				}
				else if (GameInfo.actions <= _levelPar[1] && GameInfo.levelStats[_stage].medals < 2)
				{ // You now have 2 medals for this stage
					GameInfo.levelStats[_stage].medals = 2;
					FlxG.log("You now have 2 medals for stage " + GameInfo.world + "-" + GameInfo.level);
				}
				else if (GameInfo.actions <= _levelPar[2] && GameInfo.levelStats[_stage].medals < 1)
				{ // You now have 1 medal for this stage
					GameInfo.levelStats[_stage].medals = 1;
					FlxG.log("You now have 1 medals for stage " + GameInfo.world + "-" + GameInfo.level);
				}
				
				if (GameInfo.actions < GameInfo.levelStats[_stage].fewestActions)
				{
					GameInfo.levelStats[_stage].fewestActions = GameInfo.actions;
					FlxG.log("Your fewest moves for stage " + GameInfo.world + "-" + GameInfo.level + " is now " + GameInfo.actions);
				}
				
				UserSettings.levelStats[_stage] = GameInfo.levelStats[_stage];
				FlxG.log("Game statistics have been saved.");
				
				fadeToLevelSelect();
			}
		}
	}
}