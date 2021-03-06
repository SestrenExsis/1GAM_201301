package frames
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class TrackerFrame extends FrameSprite
	{
		protected static const CORRECT_COLOR:uint = 0xff00ff00;
		protected static const INCORRECT_COLOR:uint = 0xffff0000;
		
		private var incorrectPixelCount:int;
		public var wasSolved:Boolean;
		public var solved:Boolean;
		
		public function TrackerFrame(X:Number, Y:Number, Target:TargetFrame, Puzzle:PuzzleFrame)
		{
			super(X, Y, 104, 104);
			
			target = Target;
			puzzle = Puzzle;
			resetElements(target.elements.frameWidth, target.elements.frameHeight);
			solved = wasSolved = false;
			
			labelName = new FlxText(X, Y - 8, 100, "Actions: " + GameInfo.actions);
			labelName.setFormat(null, 8, 0xffff00, "left");
		}
		
		override public function update():void
		{
			super.update();
			
			labelName.text = "Actions: " + GameInfo.actions;
		}
		
		override public function draw():void
		{
			incorrectPixelCount = 0;
			super.draw();
			
			labelName.draw();
			
			wasSolved = solved;
			if (incorrectPixelCount == 0)
				solved = true;
			else
				solved = false;
		}
		
		override public function drawElement(X:uint, Y:uint):void
		{
			_flashRect.width = element.width;
			_flashRect.height = element.height;
			
			_flashRect.x = x + buffer.x + element.width * X;
			_flashRect.y = y + buffer.y + element.height * Y;
			
			var _targetColor:uint = target.elements.framePixels.getPixel32(X, Y);
			var _puzzleColor:uint = puzzle.elements.framePixels.getPixel32(X, Y);
			
			if (_targetColor == _puzzleColor)
				FlxG.camera.buffer.fillRect(_flashRect, CORRECT_COLOR);
			else
			{
				FlxG.camera.buffer.fillRect(_flashRect, INCORRECT_COLOR);
				incorrectPixelCount++;
			}
		}
	}
}