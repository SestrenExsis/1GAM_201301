package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class PuzzleWindow extends FlxSprite
	{
		[Embed(source="../assets/images/pixelart.png")] public var imgPixelArt:Class;

		protected var windowColor:uint = 0xff5b5b5b;
		protected var dropShadowColor:uint = 0xff000000;
		
		protected var maxSize:FlxPoint;
		protected var buffer:FlxPoint;
		protected var dropShadowOffset:FlxPoint;
		
		public var block:FlxPoint;
		public static var group:FlxGroup;
		
		protected var rows:uint;
		protected var columns:uint;
		protected var elements:Array;
		public var selected:Array;
		public var lastSelectedIndex:uint;
						
		public function PuzzleWindow(X:Number, Y:Number)
		{
			super(X, Y);
			
			maxSize = new FlxPoint(292, 292);
			buffer = new FlxPoint(2, 2);
			dropShadowOffset = new FlxPoint(2, 3);
			block = new FlxPoint();
			
			loadGraphic(imgPixelArt);
			setFramePixels(0, 9, 18, 18);
		}
		
		public function setFramePixels(X:int, Y:int, Width:int, Height:int):BitmapData
		{
			if((framePixels == null) || (framePixels.width != Width) || (framePixels.height != Height))
				framePixels = new BitmapData(Width, Height);
			
			_flashRect.x = X;
			_flashRect.y = Y;
			_flashRect.width = Width;
			_flashRect.height = Height;
			framePixels.copyPixels(pixels, _flashRect, _flashPointZero, null, null, true);
			
			var _blockX:Number = (maxSize.x - 2 * buffer.x) / framePixels.width;
			var _blockY:Number = (maxSize.y - 2 * buffer.y) / framePixels.height;
			block.x = _blockX;
			block.y = _blockY;
			
			FlxG.log(block.x);
			return framePixels;
		}
		
		override public function update():void
		{
			super.update();
			
		}
		
		override public function draw():void
		{
			var _width:Number = framePixels.width * block.x + 2 * buffer.x;
			var _height:Number = framePixels.height * block.y + 2 * buffer.y;
			
			// draw the dropshadow in two pieces since the window background would otherwise cover up most of it
			_flashRect.x = x + _width;
			_flashRect.y = y + dropShadowOffset.y;
			_flashRect.width = dropShadowOffset.x;
			_flashRect.height = _height;
			FlxG.camera.buffer.fillRect(_flashRect, dropShadowColor);
			_flashRect.x = x + dropShadowOffset.x;
			_flashRect.y = y + _height;
			_flashRect.width = _width;
			_flashRect.height = dropShadowOffset.y;
			FlxG.camera.buffer.fillRect(_flashRect, dropShadowColor);
			
			// draw the window background
			_flashRect.x = x;
			_flashRect.y = y;
			_flashRect.width = _width;
			_flashRect.height = _height;
			FlxG.camera.buffer.fillRect(_flashRect, windowColor);
			
			// draw the pixels
			if (framePixels)
			{
				var _color:uint;
				for (var _y:int = 0; _y < framePixels.height; _y++)
				{
					for (var _x:int = 0; _x < framePixels.width; _x++)
					{
						_flashRect.width = block.x;
						_flashRect.height = block.y;
						
						_flashRect.x = x + buffer.x + block.x * _x;
						_flashRect.y = y + buffer.y + block.y * _y;
						
						_color = framePixels.getPixel32(_x, _y);
						FlxG.camera.buffer.fillRect(_flashRect, _color);
					}
				}
				
				// Place a selection box around the last color clicked on
				var i:int = _y * columns + _x;
				if (selected && selected[i])
				{
					_flashRect.x -= 1;
					_flashRect.y -= 1;
					_flashRect.width += 2;
					_flashRect.height += 2;
					FlxG.camera.buffer.fillRect(_flashRect, 0xff000000);
					
					_flashRect.x += 1;
					_flashRect.y += 1;
					_flashRect.width -= 2;
					_flashRect.height -= 2;
					FlxG.camera.buffer.fillRect(_flashRect, 0xffffffff);
					_flashRect.x += 1;
					_flashRect.y += 1;
					_flashRect.width -= 2;
					_flashRect.height -= 2;
				}
			}
			
			if(FlxG.visualDebug && !ignoreDrawDebug)
				drawDebug(FlxG.camera);
		}
	}
}