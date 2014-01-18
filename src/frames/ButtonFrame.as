package frames
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class ButtonFrame extends FrameSprite
	{
		[Embed(source="../assets/images/pixelart.png")] public var imgPixelArt:Class;
		[Embed(source="../assets/images/numbers.png")] public var imgNumbers:Class;
				
		// references for the frameRects array below
		protected static const TITLE:uint = 0;
		protected static const FLOWER:uint = 1;
		protected static const HEART:uint = 2;
		protected static const LOG:uint = 3;
		protected static const LEAF:uint = 4;
		protected static const TREASURE_CHEST:uint = 5;
		
		// the bounding boxes for the various images within the imgPixelArt spritesheet itself
		protected var frameRects:Array = [
			new Rectangle(0, 27, 40, 36),
			new Rectangle(0, 0, 9, 9),
			new Rectangle(9, 0, 9, 9),
			new Rectangle(18, 0, 8, 8),
			new Rectangle(26, 0, 11, 12),
			new Rectangle(37, 0, 10, 12),
			new Rectangle(37, 0, 10, 12),
			new Rectangle(37, 0, 10, 12),
			new Rectangle(37, 0, 10, 12),
			new Rectangle(37, 0, 10, 12)
		];
		
		protected var _currentFrame:int;
		protected var numbers:FlxSprite;
		
		public function ButtonFrame(X:Number, Y:Number, Width:Number, Height:Number, CurrentFrame:uint)
		{
			super(X, Y, Width, Height);
			
			numbers = new FlxSprite();
			numbers.loadGraphic(imgNumbers, true, false, 14, 17);
			
			elements.loadGraphic(imgPixelArt);
			currentFrame = CurrentFrame;
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
			if((elements.framePixels == null) || (elements.framePixels.width != _rect.width) || (elements.framePixels.height != _rect.height))
				elements.framePixels = new BitmapData(_rect.width, _rect.height);
			_flashRect.x = _rect.x;
			_flashRect.y = _rect.y;
			_flashRect.width = _rect.width;
			_flashRect.height = _rect.height;
			elements.framePixels.copyPixels(elements.pixels, _flashRect, _flashPointZero, null, null, false);
			elements.frameWidth = elements.framePixels.width;
			elements.frameHeight = elements.framePixels.height;
			
			var _blockX:Number = maxSize.x / elements.frameWidth;
			var _blockY:Number = maxSize.y / elements.frameHeight;
			
			if (_blockX > _blockY)
				_blockX = _blockY;
			else if (_blockY > _blockX)
				_blockY = _blockX;
			
			elementSize.x = _blockX;
			elementSize.y = _blockY;
			
			resetWindowFrame(2 * buffer.x + maxSize.x, 2 * buffer.y + maxSize.y);
		}
		
		override public function update():void
		{
			super.update();
			
			if ((GameInput.keyPressed >= 0 && GameInput.keyPressed < 6) || (FlxG.mouse.justPressed() && overlapsPoint(FlxG.mouse)))
			{
				FlxG.level = _currentFrame;
				ScreenState.fadeToGame();
			}
		}
		
		override public function draw():void
		{
			super.draw();
			
			_flashRect.x = numbers.width * (_currentFrame % 10);
			_flashRect.y = 0;
			_flashRect.width = numbers.width;
			_flashRect.height = numbers.height;
			_flashPoint.x = x + buffer.x;
			_flashPoint.y = y + height - buffer.y - numbers.height;
			FlxG.camera.buffer.copyPixels(numbers.pixels, _flashRect, _flashPoint, null, null, true);
		}
		
		override public function drawElement(X:uint, Y:uint):void
		{
			_flashRect.width = elementSize.x;
			_flashRect.height = elementSize.y;
			
			_flashRect.x = x + buffer.x + elementSize.x * X;
			_flashRect.y = y + buffer.y + elementSize.y * Y;
			
			var _pixelColor:uint = elements.framePixels.getPixel32(X, Y);
			var _pixelAlpha:uint = 0xff & (_pixelColor >> 24);
			
			if (_pixelAlpha > 0)
				FlxG.camera.buffer.fillRect(_flashRect, _pixelColor);
		}
	}
}