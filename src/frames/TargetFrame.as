package frames
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class TargetFrame extends FrameSprite
	{
		[Embed(source="../assets/images/world1.png")] public var imgPixelArt:Class;
				
		// references for the frameRects array below
		protected static const DAISY:uint = 0;
		protected static const LOG:uint = 1;
		protected static const TOADSTOOL:uint = 2;
		protected static const BEANSTALK:uint = 3;
		protected static const DIRT_BLOCK:uint = 4;
		protected static const ACORN:uint = 5;
		protected static const ROCKS:uint = 6;
		protected static const LEAF:uint = 7;
		protected static const OAK_TREE:uint = 8;
		
		// the bounding boxes for the starting images in the spriteSheet
		public var startFrameRects:Array = [
			new Rectangle(0, 0, 9, 9),
			new Rectangle(0, 0, 8, 8),
			new Rectangle(37, 16, 20, 20),
			new Rectangle(0, 0, 24, 24),
			new Rectangle(0, 0, 18, 36),
			new Rectangle(0, 0, 32, 32),
			new Rectangle(0, 0, 10, 10),
			new Rectangle(0, 0, 10, 10),
			new Rectangle(0, 0, 18, 18)
		];
		
		// the bounding boxes for the target images in the spritesheet
		public static var targetFrameRects:Array = [
			new Rectangle(39, 0, 9, 9),
			new Rectangle(48, 0, 8, 8),
			new Rectangle(57, 16, 20, 20),
			new Rectangle(50, 36, 24, 24),
			new Rectangle(32, 36, 18, 36),
			new Rectangle(0, 36, 32, 32),
			new Rectangle(0, 0, 10, 10),
			new Rectangle(0, 0, 10, 10),
			new Rectangle(74, 36, 18, 18)
		];
		
		protected var _currentFrame:int;
		protected var keyPresses:int = 0;
								
		public function TargetFrame(X:Number, Y:Number, Width:Number, Height:Number, CurrentFrame:uint)
		{
			super(X, Y, Width, Height);
			
			selectionBorderWidth = 1;
			elements.loadGraphic(imgPixelArt);
			currentFrame = CurrentFrame;
			setSelection(0, 0, elements.frameWidth, elements.frameHeight);
			
			showGrid = true;
		}
		
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		public function set currentFrame(Value:int):void
		{
			if (Value >= targetFrameRects.length)
				_currentFrame = 0;
			else if (Value < 0)
				_currentFrame = targetFrameRects.length - 1;
			else
				_currentFrame = Value;
			
			var _rect:Rectangle = targetFrameRects[_currentFrame];
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
			
			element.width = _blockX;
			element.height = _blockY;
			
			resetWindowFrame(2 * buffer.x + element.width * elements.frameWidth, 2 * buffer.y + element.height * elements.frameHeight);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function drawElement(X:uint, Y:uint):void
		{
			_flashRect.width = element.width;
			_flashRect.height = element.height;
			
			_flashRect.x = x + buffer.x + element.width * X;
			_flashRect.y = y + buffer.y + element.height * Y;
			
			var _pixelColor:uint = elements.framePixels.getPixel32(X, Y);
			var _pixelAlpha:uint = 0xff & (_pixelColor >> 24);
			
			if (_pixelAlpha > 0)
				FlxG.camera.buffer.fillRect(_flashRect, _pixelColor);
		}
	}
}