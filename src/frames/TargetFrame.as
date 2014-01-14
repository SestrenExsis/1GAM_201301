package frames
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class TargetFrame extends FrameSprite
	{
		[Embed(source="../assets/images/pixelart.png")] public var imgPixelArt:Class;
				
		// references for the frameRects array below
		protected static const NONE:uint = 0;
		protected static const FLOWER:uint = 1;
		protected static const HEART:uint = 2;
		protected static const TREASURE_CHEST:uint = 3;
		
		// the bounding boxes for the various images within the imgPixelArt spritesheet itself
		protected var frameRects:Array = [
			new Rectangle(0, 0, 1, 1),
			new Rectangle(0, 0, 9, 9),
			new Rectangle(9, 0, 9, 9),
			new Rectangle(0, 9, 18, 18)
		];
				
		protected var _currentFrame:int;
		protected var keyPresses:int = 0;
								
		public function TargetFrame(X:Number, Y:Number, CurrentFrame:uint)
		{
			super(X, Y, 112, 112);
			
			selectionBorderWidth = 1;
			elements.loadGraphic(imgPixelArt);
			currentFrame = CurrentFrame;
			setSelection(0, 0, frameWidth, frameHeight);
			
			showGrid = true;
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
			
			var _blockX:Number = (maxSize.x - 2 * buffer.x) / elements.frameWidth;
			var _blockY:Number = (maxSize.y - 2 * buffer.y) / elements.frameHeight;
			elementSize.x = _blockX;
			elementSize.y = _blockY;
		}
		
		override public function update():void
		{
			super.update();
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