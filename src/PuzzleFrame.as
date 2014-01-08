package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class PuzzleFrame extends WindowFrame
	{
		[Embed(source="../assets/images/pixelart.png")] public var imgPixelArt:Class;
				
		// references for the frameRects array below
		protected static const FLOWER:uint = 0;
		protected static const HEART:uint = 1;
		protected static const TREASURE_CHEST:uint = 2;
		
		// the bounding boxes for the various images within the imgPixelArt spritesheet itself
		protected var frameRects:Array = [
			new Rectangle(0, 0, 9, 9),
			new Rectangle(9, 0, 9, 9),
			new Rectangle(0, 9, 18, 18)
		];
		
		public var selectionMode:int = 0;
		
		protected var _currentFrame:int;
		
		protected var currentTool:int = 0;
		protected var currentFill:int = 0xffff0000;
		
		protected var keyPresses:int = 0;
						
		public function PuzzleFrame(X:Number, Y:Number)
		{
			super(X, Y, 292, 292);
			
			loadGraphic(imgPixelArt);
			currentFrame = TREASURE_CHEST;
			setSelection(0, 0, frameWidth, frameHeight);
		}
		
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		public function set currentFrame(Value:int):void
		{
			if (Value >= frameRects.length)
				_currentFrame = 0;
			else if (Value < 0)
				_currentFrame = frameRects.length - 1;
			else
				_currentFrame = Value;
			
			var _rect:Rectangle = frameRects[_currentFrame];
			if((framePixels == null) || (framePixels.width != _rect.width) || (framePixels.height != _rect.height))
				framePixels = new BitmapData(_rect.width, _rect.height);
			_flashRect.x = _rect.x;
			_flashRect.y = _rect.y;
			_flashRect.width = _rect.width;
			_flashRect.height = _rect.height;
			framePixels.copyPixels(pixels, _flashRect, _flashPointZero, null, null, false);
			frameWidth = framePixels.width;
			frameHeight = framePixels.height;
			
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
			
			FlxG.log(keyPresses++);
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
			
			FlxG.log(keyPresses++);
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