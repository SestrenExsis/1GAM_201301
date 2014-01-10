package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class PuzzleFrame extends WindowFrame
	{
		protected var currentTool:int = 0;
		protected var currentFill:int = 0xffff0000;
		protected var _currentFrame:int;
						
		public function PuzzleFrame(X:Number, Y:Number, Target:TargetFrame)
		{
			super(X, Y, 292, 292);
			
			target = Target;
			resetFrame(target.frameWidth, target.frameHeight, 0xffff00ff);
			setSelection(0, 0, frameWidth, frameHeight);
		}
		
		public function get currentFrame():int
		{
			return _currentFrame;
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
		}
		
		public function clampSelection():void
		{
			_selection.x = FlxU.bound(_selection.x, 0, frameWidth - 1);
			_selection.width = FlxU.bound(_selection.width, 1, frameWidth - _selection.x);
			_selection.y = FlxU.bound(_selection.y, 0, frameHeight - 1);
			_selection.height = FlxU.bound(_selection.height, 1, frameHeight - _selection.y);
			target.setSelection(_selection.x, _selection.y, _selection.width, _selection.height);
		}
		
		public function updateSelection(SelectionMode:int):void
		{
			var _x:int = 0;
			var _y:int = 0;
			if (GameInput.keyWest || GameInput.keyNorthwest || GameInput.keySouthwest)
				_x = -1;
			else if (GameInput.keyEast || GameInput.keyNortheast || GameInput.keySoutheast)
				_x = 1;
			if (GameInput.keyNorth || GameInput.keyNorthwest || GameInput.keyNortheast)
				_y = -1;
			else if (GameInput.keySouth || GameInput.keySouthwest || GameInput.keySoutheast)
				_y = 1;
			
			switch (SelectionMode)
			{
				case GameInput.NORTHWEST:
					selection.x += _x;
					selection.width -= _x;
					selection.y += _y;
					selection.height -= _y;
					break;
				case GameInput.NORTHEAST:
					selection.width += _x;
					selection.y += _y;
					selection.height -= _y;
					break;
				case GameInput.SOUTHWEST:
					selection.x += _x;
					selection.width -= _x;
					selection.height += _y;
					break;
				case GameInput.SOUTHEAST:
					selection.width += _x;
					selection.height += _y;
					break;
				case GameInput.CENTER:
					selection.x += _x;
					selection.y += _y;
					break;
			}
			if (_x != 0 || _y != 0)
				clampSelection();
		}
		
		public function updateFill(Color:uint):void
		{
			var _x:int = 0;
			var _y:int = 0;
			if (GameInput.keyWest || GameInput.keyNorthwest || GameInput.keySouthwest)
				_x = -1;
			else if (GameInput.keyEast || GameInput.keyNortheast || GameInput.keySoutheast)
				_x = 1;
			if (GameInput.keyNorth || GameInput.keyNorthwest || GameInput.keyNortheast)
				_y = -1;
			else if (GameInput.keySouth || GameInput.keySouthwest || GameInput.keySoutheast)
				_y = 1;
			
			selection.x += _x * selection.width;
			selection.y += _y * selection.height;
			
			fillArea(selection, Color);
		}
		
		public function fillArea(FillArea:Rectangle, FillColor:uint):void
		{
			for (var _x:int = selection.x; _x < selection.x + selection.width; _x++)
			{
				for (var _y:int = selection.y; _y < selection.y + selection.height; _y++)
				{
					if (_x >= 0 && _x < framePixels.width && _y >= 0 && _y < framePixels.height)
						framePixels.setPixel32(_x, _y, FillColor);
				}
			}
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
			
			var _pixelColor:uint = framePixels.getPixel32(X, Y);
			var _pixelAlpha:uint = 0xff & (_pixelColor >> 24);
			
			if (_pixelAlpha > 0)
				FlxG.camera.buffer.fillRect(_flashRect, _pixelColor);
		}
	}
}