package screens
{
	import flash.geom.Rectangle;
	
	import frames.ButtonFrame;
	
	import org.flixel.*;
	
	public class LevelSelectScreen extends ScreenState
	{
		[Embed(source="../assets/images/pixelart.png")] public var imgButtons:Class;
		
		// the bounding boxes for the button images
		protected var frameRects:Array = [
			new Rectangle(0, 91, 40, 36),
			new Rectangle(0, 64, 9, 9),
			new Rectangle(9, 64, 9, 9),
			new Rectangle(18, 64, 8, 8),
			new Rectangle(26, 64, 11, 12),
			new Rectangle(38, 0, 10, 12),
			new Rectangle(40, 77, 20, 20),
			new Rectangle(38, 0, 10, 12),
			new Rectangle(38, 0, 10, 12),
			new Rectangle(38, 0, 10, 12)
		];
		
		public static const backgroundLayers:int = 2;
		
		public function LevelSelectScreen()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			background = new ScrollingSprite(0, 0, GameInfo.worldNames[GameInfo.world]);
			add(background);
			 
			displayTimer = new FlxTimer();
			displayTimer.start(1, 1, onTimerFlickerDisplay);
			
			displayText = new FlxText(0, FlxG.height - 48, FlxG.width, "Press NUMPAD keys [1-9] to start a level.");
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
				_button = new ButtonFrame(64 + _x * 104, 8 + _y * 104, 96, 96, _i, "level");
				_button.loadButtonImage(imgButtons, frameRects[_i]);
				add(_button);
			}
		}
		
		override public function update():void
		{	
			GameInput.update();
			super.update();
			if (GameInput.keyPressed == 0)
			{
				fadeToWorldSelect();
			}
			else if (GameInput.keyPressed > 0)
			{
				GameInfo.level = GameInput.keyPressed;
				FlxG.log("level" + GameInfo.level);
				fadeToGame();
			}
		}
	}
}