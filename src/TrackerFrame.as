package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class TrackerFrame extends WindowFrame
	{
		protected static const CORRECT_COLOR:uint = 0xff00ff00;
		protected static const INCORRECT_COLOR:uint = 0xffff0000;
		
		public function TrackerFrame(X:Number, Y:Number, Target:TargetFrame, Puzzle:PuzzleFrame)
		{
			super(X, Y, 56, 56);
			
			target = Target;
			puzzle = Puzzle;
			resetFrame(target.frameWidth, target.frameHeight);
			showGrid = false;
		}
		
		public function resetFrame(Width:uint, Height:uint, DefaultColor:uint = 0x00000000):void
		{
			makeGraphic(Width, Height, DefaultColor);
			frameWidth = Width;
			frameHeight = Height;
			
			var _blockX:Number = (maxSize.x - 2 * buffer.x) / frameWidth;
			var _blockY:Number = (maxSize.y - 2 * buffer.y) / frameHeight;
			block.x = _blockX;
			block.y = _blockY;
			
			FlxG.log("width: " + block.x + ", height: " + block.y);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function drawElement(X:uint, Y:uint):void
		{
			_flashRect.width = block.x;
			_flashRect.height = block.y;
			
			_flashRect.x = x + buffer.x + block.x * X;
			_flashRect.y = y + buffer.y + block.y * Y;
			
			var _targetColor:uint = target.framePixels.getPixel32(X, Y);
			var _puzzleColor:uint = puzzle.framePixels.getPixel32(X, Y);
			
			if (_targetColor == _puzzleColor)
				FlxG.camera.buffer.fillRect(_flashRect, CORRECT_COLOR);
			else
				FlxG.camera.buffer.fillRect(_flashRect, INCORRECT_COLOR);
		}
	}
}