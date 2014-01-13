package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import frames.PuzzleFrame;
	import frames.TargetFrame;
	
	import org.flixel.*;
	
	public class FrameSprite extends FlxSprite
	{
		protected var _selection:Rectangle;
		protected var _selectionVisual:Rectangle;
		protected var selectionBorderWidth:uint = 2;
		protected var selectionBorderColor:uint = 0xffed008c;
		protected var showGrid:Boolean = false;
		protected var windowColor:uint = 0xff5b5b5b;
		protected var dropShadowColor:uint = 0xff000000;
		protected var maxSize:FlxPoint;
		protected var dropShadowOffset:FlxPoint;
		protected var labelName:FlxText;
		protected var labelDescription:FlxText;
		
		public var buffer:FlxPoint;
		public var block:FlxPoint;
		public var puzzle:PuzzleFrame;
		public var target:TargetFrame;
		
		public function FrameSprite(X:Number, Y:Number, Width:Number, Height:Number)
		{
			super(X, Y);
			
			maxSize = new FlxPoint(Width, Height);
			buffer = new FlxPoint(4, 4);
			dropShadowOffset = new FlxPoint(2, 3);
			block = new FlxPoint();
		}
		
		public function resetFrame(Width:uint, Height:uint, DefaultColor:uint = 0x00000000):void
		{
			makeGraphic(Width, Height, DefaultColor);
			frameWidth = Width;
			frameHeight = Height;
			
			var _blockX:Number = (maxSize.x - 2 * buffer.x) / frameWidth;
			var _blockY:Number = (maxSize.y - 2 * buffer.y) / frameHeight;
			
			if (block)
			{
				block.x = _blockX;
				block.y = _blockY;
			}
		}
		
		public function get selection():Rectangle
		{
			return _selection;
		}
		
		public function get selectionVisual():Rectangle
		{
			return _selectionVisual;
		}
		
		public function setSelection(X:int, Y:int, Width:int, Height:int):void
		{
			if (_selection == null)
				_selection = new Rectangle();
			if (_selectionVisual == null)
				_selectionVisual = new Rectangle(0, 0, 1, 1);
			
			_selection.x = X;
			_selection.y = Y;
			_selection.width = Width;
			_selection.height = Height;
		}
		
		override public function update():void
		{
			super.update();
			
			if (selection && selectionVisual)
			{
				var _lerp:Number = 0.2;
				var _diff:Number = selection.x - selectionVisual.x;
				if ((block.x * Math.abs(_diff)) < 1)
					selectionVisual.x = selection.x;
				else
					selectionVisual.x = FlxTween.linear(_lerp, selectionVisual.x, _diff, 1);
				
				_diff = selection.y - selectionVisual.y;
				if ((block.y * Math.abs(_diff)) < 1)
					selectionVisual.y = selection.y;
				else
					selectionVisual.y = FlxTween.linear(_lerp, selectionVisual.y, _diff, 1);
				
				_diff = selection.width - selectionVisual.width;
				if ((block.x * Math.abs(_diff)) < 1)
					selectionVisual.width = selection.width;
				else
					selectionVisual.width = FlxTween.linear(_lerp, selectionVisual.width, _diff, 1);
				
				_diff = selection.height - selectionVisual.height;
				if ((block.y * Math.abs(_diff)) < 1)
					selectionVisual.height = selection.height;
				else
					selectionVisual.height = FlxTween.linear(_lerp, selectionVisual.height, _diff, 1);
			}
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
				if (selectionVisual && selectionVisual.width > 0 && selectionVisual.height > 0)
				{
					//top of selection box
					_flashRect.x = x + buffer.x - selectionBorderWidth + selectionVisual.x * block.x;
					_flashRect.y = y + buffer.y - selectionBorderWidth + selectionVisual.y * block.y;
					_flashRect.width = block.x * selectionVisual.width + 2 * selectionBorderWidth;
					_flashRect.height = selectionBorderWidth;
					FlxG.camera.buffer.fillRect(_flashRect, selectionBorderColor);
					
					//bottom of selection box
					_flashRect.y = y + buffer.y + block.y * selectionVisual.height + selectionVisual.y * block.y;
					FlxG.camera.buffer.fillRect(_flashRect, selectionBorderColor);
					
					//left side of selection box
					_flashRect.x = x + buffer.x - selectionBorderWidth + selectionVisual.x * block.x;
					_flashRect.y = y + buffer.y + selectionVisual.y * block.y;
					_flashRect.width = selectionBorderWidth;
					_flashRect.height = block.y * selectionVisual.height;
					FlxG.camera.buffer.fillRect(_flashRect, selectionBorderColor);
					
					//right side of selection box
					_flashRect.x = x + buffer.y + block.x * selectionVisual.width + selectionVisual.x * block.x;
					FlxG.camera.buffer.fillRect(_flashRect, selectionBorderColor);
				}
			}
			
			if(FlxG.visualDebug && !ignoreDrawDebug)
				drawDebug(FlxG.camera);
		}
	}
}