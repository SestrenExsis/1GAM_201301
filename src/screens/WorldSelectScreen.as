package screens
{
	import frames.ButtonFrame;
	import org.flixel.*;
	import flash.geom.Rectangle;
	
	public class WorldSelectScreen extends ScreenState
	{
		[Embed(source="../assets/images/worlds.png")] public var imgButtons:Class;
		
		// the bounding boxes for the button images
		protected var frameRects:Array = [
			new Rectangle(0, 200, 80, 80),
			new Rectangle(0, 8, 80, 80),
			new Rectangle(0, 104, 80, 80),
			new Rectangle(0, 200, 80, 80),
			new Rectangle(0, 200, 80, 80),
			new Rectangle(0, 200, 80, 80),
			new Rectangle(0, 200, 80, 80),
			new Rectangle(0, 200, 80, 80),
			new Rectangle(0, 200, 80, 80),
			new Rectangle(0, 200, 80, 80),
		];
		
		public function WorldSelectScreen()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			background = new ScrollingSprite(0, 0, "hills");
			add(background);
			 
			displayTimer = new FlxTimer();
			displayTimer.start(1, 1, onTimerFlickerDisplay);
			
			displayText = new FlxText(0, FlxG.height - 48, FlxG.width, "Press NUMPAD keys [1-9] to select a world.");
			displayText.setFormat(null, 16, 0xffffff, "center");
			displayText.text += ScreenState.infoText;
			add(displayText);
			
			var _x:int;
			var _y:int;
			var _button:ButtonFrame;
			for (var _i:int = 1; _i <= 9; _i++)
			{
				_x = (_i - 1) % 3;
				_y = 2 - (int)((_i - 1) / 3);
				_button = new ButtonFrame(64 + _x * 104, 8 + _y * 104, 96, 96, _i, fadeToLevelSelect);
				_button.loadButtonImage(imgButtons, frameRects[_i]);
				add(_button);
			}
		}
		
		override public function update():void
		{	
			GameInput.update();
			super.update();
			if (GameInput.keyPressed >= 0)
			{
				FlxG.level = GameInput.keyPressed;
				fadeToLevelSelect();
			}
		}
	}
}