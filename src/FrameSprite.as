package
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import frames.PuzzleFrame;
	import frames.TargetFrame;
	
	import org.flixel.*;
	
	public class FrameSprite extends FlxSprite
	{
		[Embed(source="../assets/images/frame.png")] public var imgFrame:Class;
		
		private static const WINDOW_FRAME_TILE_SIZE:int = 32;
		
		protected var maxSize:FlxPoint;
		protected var _selection:Rectangle;
		protected var _selectionVisual:Rectangle;
		protected var selectionBorderWidth:uint = 2;
		protected var selectionBorderColor:uint = 0xffed008c;
		protected var showGrid:Boolean = false;
		protected var windowColor:uint = 0x88ffffff;
		protected var labelName:FlxText;
		protected var labelDescription:FlxText;
		
		public var windowFrame:FlxSprite;
		public var elements:FlxSprite;
		public var elementSize:FlxPoint;
		public var buffer:FlxPoint;
		public var puzzle:PuzzleFrame;
		public var target:TargetFrame;
		
		public function FrameSprite(X:Number, Y:Number, Width:Number, Height:Number)
		{
			super(X, Y);
			
			windowFrame = new FlxSprite();
			windowFrame.loadGraphic(imgFrame);
			
			elements = new FlxSprite(X, Y);
			buffer = new FlxPoint(8, 8);
			maxSize = new FlxPoint(Width - 2 * buffer.x, Height - 2 * buffer.y);
			elementSize = new FlxPoint();
		}
		
		public function resetWindowFrame(Width:uint, Height:uint):void
		{
			// draw the window background
			makeGraphic(Width, Height, 0x00000000);
			_flashRect.x = _flashRect.y = 0;
			_flashRect.width = frameWidth;
			_flashRect.height = frameHeight;
			framePixels.fillRect(_flashRect, windowColor);
			
			var _widthInFrameTiles:int = Math.ceil(Width / WINDOW_FRAME_TILE_SIZE);
			var _heightInFrameTiles:int = Math.ceil(Height / WINDOW_FRAME_TILE_SIZE);
			
			_flashRect.width = _flashRect.height = WINDOW_FRAME_TILE_SIZE;
			for (var _x:int = 0; _x < _widthInFrameTiles; _x++)
			{
				for (var _y:int = 0; _y < _heightInFrameTiles; _y++)
				{
					// Figure out which one of the 9 square tiles from the windowFrame graphic we're going to need for this part
					if (_x == 0)
						_flashRect.x = 0;
					else if (_x == _widthInFrameTiles - 1)
						_flashRect.x = 2;
					else
						_flashRect.x = 1;
					_flashRect.x *= WINDOW_FRAME_TILE_SIZE;
					
					if (_y == 0)
						_flashRect.y = 0;
					else if (_y == _heightInFrameTiles - 1)
						_flashRect.y = 2;
					else
						_flashRect.y = 1;
					_flashRect.y *= WINDOW_FRAME_TILE_SIZE;
					
					// Draw edge and corner tiles flush with the outer rim of the framePixels. Fill the inside with the center tile.
					_flashPoint.x = _x * WINDOW_FRAME_TILE_SIZE;
					if (_flashPoint.x > frameWidth - WINDOW_FRAME_TILE_SIZE)
						_flashPoint.x = frameWidth - WINDOW_FRAME_TILE_SIZE;
					_flashPoint.y = _y * WINDOW_FRAME_TILE_SIZE;
					if (_flashPoint.y > frameHeight - WINDOW_FRAME_TILE_SIZE)
						_flashPoint.y = frameHeight - WINDOW_FRAME_TILE_SIZE;
					
					framePixels.copyPixels(windowFrame.framePixels, _flashRect, _flashPoint, null, null, true);
				}
			}
		}
		
		public function resetElementFrame(Width:uint, Height:uint, DefaultColor:uint = 0x00000000):void
		{
			elements.makeGraphic(Width, Height, DefaultColor);
			
			var _blockX:Number = Math.floor(maxSize.x / elements.frameWidth);
			var _blockY:Number = Math.floor(maxSize.y / elements.frameHeight);
			
			if (elementSize)
			{
				elementSize.x = _blockX;
				elementSize.y = _blockY;
			}
			
			resetWindowFrame(2 * buffer.x + elementSize.x * Width, 2 * buffer.y + elementSize.y * Height);
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
				if ((elementSize.x * Math.abs(_diff)) < 1)
					selectionVisual.x = selection.x;
				else
					selectionVisual.x = FlxTween.linear(_lerp, selectionVisual.x, _diff, 1);
				
				_diff = selection.y - selectionVisual.y;
				if ((elementSize.y * Math.abs(_diff)) < 1)
					selectionVisual.y = selection.y;
				else
					selectionVisual.y = FlxTween.linear(_lerp, selectionVisual.y, _diff, 1);
				
				_diff = selection.width - selectionVisual.width;
				if ((elementSize.x * Math.abs(_diff)) < 1)
					selectionVisual.width = selection.width;
				else
					selectionVisual.width = FlxTween.linear(_lerp, selectionVisual.width, _diff, 1);
				
				_diff = selection.height - selectionVisual.height;
				if ((elementSize.y * Math.abs(_diff)) < 1)
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
			_flashRect.x = 0;
			_flashRect.y = 0;
			_flashRect.width = frameWidth;
			_flashRect.height = frameHeight;
			
			super.draw();
			
			// draw the elements
			if (elements.framePixels)
			{
				var _color:uint;
				var _alpha:uint;
				var _i:uint;
				for (var _y:int = 0; _y <= elements.frameHeight; _y++)
				{
					for (var _x:int = 0; _x <= elements.frameWidth; _x++)
					{
						if (_y < elements.frameHeight && _x < elements.frameWidth)
							drawElement(_x, _y);
						
						// draw the grid overlay
						if (showGrid)
						{
							_flashRect.width = elementSize.x;
							_flashRect.height = elementSize.y;
							_flashRect.x = x + buffer.x + elementSize.x * _x;
							_flashRect.y = y + buffer.y + elementSize.y * _y;
							
							if (_y < elements.frameHeight)
							{
								for (_i = 0; _i < elementSize.y; _i += 2)
								{
									FlxG.camera.buffer.setPixel32(_flashRect.x, _flashRect.y + _i, windowColor);
								}
							}
							if (_x < elements.frameWidth)
							{
								for (_i = 0; _i < elementSize.x; _i += 2)
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
					_flashRect.x = x + buffer.x - selectionBorderWidth + selectionVisual.x * elementSize.x;
					_flashRect.y = y + buffer.y - selectionBorderWidth + selectionVisual.y * elementSize.y;
					_flashRect.width = elementSize.x * selectionVisual.width + 2 * selectionBorderWidth;
					_flashRect.height = selectionBorderWidth;
					FlxG.camera.buffer.fillRect(_flashRect, selectionBorderColor);
					
					//bottom of selection box
					_flashRect.y = y + buffer.y + elementSize.y * selectionVisual.height + selectionVisual.y * elementSize.y;
					FlxG.camera.buffer.fillRect(_flashRect, selectionBorderColor);
					
					//left side of selection box
					_flashRect.x = x + buffer.x - selectionBorderWidth + selectionVisual.x * elementSize.x;
					_flashRect.y = y + buffer.y + selectionVisual.y * elementSize.y;
					_flashRect.width = selectionBorderWidth;
					_flashRect.height = elementSize.y * selectionVisual.height;
					FlxG.camera.buffer.fillRect(_flashRect, selectionBorderColor);
					
					//right side of selection box
					_flashRect.x = x + buffer.y + elementSize.x * selectionVisual.width + selectionVisual.x * elementSize.x;
					FlxG.camera.buffer.fillRect(_flashRect, selectionBorderColor);
				}
			}
		}
	}
}