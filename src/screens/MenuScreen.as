package screens
{
	import org.flixel.*;
	import frames.ButtonFrame;
	import frames.PuzzleFrame;
	import frames.TargetFrame;
	import frames.ToolboxFrame;
	import frames.TrackerFrame;
	import flash.geom.Rectangle;
	
	public class MenuScreen extends ScreenState
	{
		[Embed(source="../assets/images/objects.png")] public var imgObjects:Class;
		[Embed(source="../assets/images/buttons.png")] public var imgButtons:Class;
		
		private var puzzle:PuzzleFrame;
		private var tracker:TrackerFrame;
		private var toolbox:ToolboxFrame;
		private var cursor:FlxSprite;
		
		public function MenuScreen()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xff464646;
			UserSettings.load();
			
			GameInfo.actions = 0;
			GameInfo.currentTime = 0;
			FlxG.bgColor = 0xff464646;
			
			background = new ScrollingSprite(0, 0, GameInfo.worldNames[(int)(FlxG.random() * 3)]);
			add(background);
			
			var target:TargetFrame = new TargetFrame(8, 8, 208, 208, 9);
			add(target);
			
			puzzle = new PuzzleFrame(288, 8, 336, 336, target);
			add(puzzle);
			
			tracker = new TrackerFrame(148, 232, target, puzzle);
			add(tracker);
			
			toolbox = new ToolboxFrame(8, 232, 104, 104, target, puzzle);
			toolbox.visible = false;
			add(toolbox);
			
			cursor = new FlxSprite(-100, -100);
			cursor.loadGraphic(imgObjects, true, false, 32, 32);
			cursor.addAnimation("grab",[9]);
			cursor.play("grab");
			add(cursor);
			
			if (puzzle.element.width <= 24)
			{
				cursor.scale.x = cursor.scale.y = puzzle.element.width / 24;
				cursor.width *= cursor.scale.x;
				cursor.height *= cursor.scale.y;
			}
			
			add(new FlxButton(8, 232, "Play Game", onButtonLevelSelect));
			add(new FlxButton(8, 232 + 40, "Configure", onButtonSettings));
			
			/*var _button:ButtonFrame;
			_button = new ButtonFrame(8, 232, 104, 48, 10, "play");
			_button.loadButtonImage(imgButtons, new Rectangle(0, 0, 32, 32));
			add(_button);
			
			_button = new ButtonFrame(8, 232 + 56, 104, 48, 11, "settings");
			_button.loadButtonImage(imgButtons, new Rectangle(0, 32, 88, 32));
			add(_button);*/
			
			GameInput.beginRandomPlayback();
		}
		
		override public function update():void
		{	
			GameInput.update();
			if (FlxG.keys.justPressed("P"))
			{
				UserSettings.erase();
			}
			
			super.update();
			
			var _cursorPos:FlxPoint = toolbox.cursorLocationVisual;
			cursor.x = _cursorPos.x - 0.5 * cursor.width;
			cursor.y = _cursorPos.y - 0.5 * cursor.height;
			
			if (!tracker.wasSolved && tracker.solved)
			{
				GameInput.playbackMode = false;
			}
		}
	}
}