package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class WindowFrame extends FlxSprite
	{
		protected var _selection:Rectangle;
		protected var selectionBorderWidth:uint = 2;
		protected var selectionBorderColor:uint = 0xffed008c;		
		protected var showGrid:Boolean = true;
		protected var windowColor:uint = 0xff5b5b5b;
		protected var dropShadowColor:uint = 0xff000000;
		protected var maxSize:FlxPoint;
		protected var buffer:FlxPoint;
		protected var dropShadowOffset:FlxPoint;
		protected var block:FlxPoint;
								
		public function WindowFrame(X:Number, Y:Number, Width:Number, Height:Number)
		{
			super(X, Y);
			
			maxSize = new FlxPoint(Width, Height);
			buffer = new FlxPoint(4, 4);
			dropShadowOffset = new FlxPoint(2, 3);
			block = new FlxPoint();
		}
		
		public function get selection():Rectangle
		{
			return _selection;
		}
		
		public function setSelection(X:int, Y:int, Width:int, Height:int):void
		{
			if (_selection == null)
				_selection = new Rectangle();
			
			_selection.x = X;
			_selection.y = Y;
			_selection.width = Width;
			_selection.height = Height;
		}
		
		override public function update():void
		{
			super.update();
		}
		
		public function drawElement(X:uint, Y:uint):void
		{
			
		}
		
		override public function draw():void
		{
			var _width:Number = frameWidth * block.x + 2 * buffer.x;
			var _height:Number = frameHeight * block.y + 2 * buffer.y;
			
			// draw the dropshadow in two pieces since the window background would cover up most of it, anyway
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
				var _alpha:uint;
				var _i:uint;
				for (var _y:int = 0; _y < frameHeight; _y++)
				{
					for (var _x:int = 0; _x < frameWidth; _x++)
					{
						drawElement(_x, _y);
						
						// draw the grid overlay
						if (showGrid)
						{
							_flashRect.width = block.x;
							_flashRect.height = block.y;
							_flashRect.x = x + buffer.x + block.x * _x;
							_flashRect.y = y + buffer.y + block.y * _y;
							
							if (_x > 0 && _x < frameWidth)
							{
								for (_i = 0; _i < block.y; _i += 2)
								{
									FlxG.camera.buffer.setPixel32(_flashRect.x, _flashRect.y + _i, windowColor);
								}
							}
							if (_y > 0 && _y < frameHeight)
							{
								for (_i = 0; _i < block.x; _i += 2)
								{
									FlxG.camera.buffer.setPixel32(_flashRect.x + _i, _flashRect.y, windowColor);
								}
							}
						}
					}
				}
				
				// draw the selection box
				if (selection && selection.width > 0 && selection.height > 0)
				{
					//top of selection box
					_flashRect.x = x + buffer.x - selectionBorderWidth + selection.x * block.x;
					_flashRect.y = y + buffer.y - selectionBorderWidth + selection.y * block.y;
					_flashRect.width = block.x * selection.width + 2 * selectionBorderWidth;
					_flashRect.height = selectionBorderWidth;
					FlxG.camera.buffer.fillRect(_flashRect, selectionBorderColor);
					
					//bottom of selection box
					_flashRect.y = y + buffer.y + block.y * selection.height + selection.y * block.y;
					FlxG.camera.buffer.fillRect(_flashRect, selectionBorderColor);
					
					//left side of selection box
					_flashRect.x = x + buffer.x - selectionBorderWidth + selection.x * block.x;
					_flashRect.y = y + buffer.y + selection.y * block.y;
					_flashRect.width = selectionBorderWidth;
					_flashRect.height = block.y * selection.height;
					FlxG.camera.buffer.fillRect(_flashRect, selectionBorderColor);
					
					//right side of selection box
					_flashRect.x = x + buffer.y + block.x * selection.width + selection.x * block.x;
					FlxG.camera.buffer.fillRect(_flashRect, selectionBorderColor);
				}
			}
			
			if(FlxG.visualDebug && !ignoreDrawDebug)
				drawDebug(FlxG.camera);
		}
	}
}