package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class PuzzleWindow extends FlxSprite
	{
		[Embed(source="../assets/images/pixelart.png")] public var imgPixelArt:Class;
				
		// references for the frameRects array below
		protected static const FLOWER:uint = 0;
		protected static const HEART:uint = 1;
		protected static const TREASURE_CHEST:uint = 2;
		
		// tools
		protected static const TOOLBOX:uint = 0;
		protected static const FILL:uint = 1;
		protected static const PALETTE:uint = 2;
		protected static const SELECTION:uint = 3;
		
		// different selection modes
		protected static const NUDGE:uint = 0;
		protected static const DRAG_CORNER:uint = 1;
		
		// the bounding boxes for the various images within the imgPixelArt spritesheet itself
		protected var frameRects:Array = [
			new Rectangle(0, 0, 9, 9),
			new Rectangle(9, 0, 9, 9),
			new Rectangle(0, 9, 18, 18)
		];
		
		protected var _currentFrame:int;
		protected var _selection:Rectangle;
		protected var _selectionCorner:int;
		protected var selectionMode:int = 0;
		protected var selectionBorderWidth:uint = 2;
		protected var selectionBorderColor:uint = 0xffed008c;
		
		protected var currentTool:int = 0;
		protected var currentFill:int = 0xffff0000;
		
		protected var showGrid:Boolean = true;
		protected var windowColor:uint = 0xff5b5b5b;
		protected var dropShadowColor:uint = 0xff000000;
		protected var maxSize:FlxPoint;
		protected var buffer:FlxPoint;
		protected var dropShadowOffset:FlxPoint;
		protected var block:FlxPoint;
		
		public static var group:FlxGroup;
		protected var elements:Array;
						
		public function PuzzleWindow(X:Number, Y:Number)
		{
			super(X, Y);
			
			maxSize = new FlxPoint(292, 292);
			buffer = new FlxPoint(4, 4);
			dropShadowOffset = new FlxPoint(2, 3);
			block = new FlxPoint();
			
			loadGraphic(imgPixelArt);
			currentFrame = TREASURE_CHEST;
			_selection = new Rectangle(0, 0, frameWidth, frameHeight);
			
			FlxG.watch(_selection, "x");
			FlxG.watch(_selection, "y");
			FlxG.watch(_selection, "width");
			FlxG.watch(_selection, "height");
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
		
		public function get selection():Rectangle
		{
			return _selection;
		}
		
		public function set selectionCorner(Value:int):void
		{
			Value = FlxU.bound(Value, 0, 3);
			_selectionCorner = Value;
		}
		
		public function clampSelection():void
		{
			_selection.x = FlxU.bound(_selection.x, 0, frameWidth - 1);
			_selection.width = FlxU.bound(_selection.width, 1, frameWidth - _selection.x);
			_selection.y = FlxU.bound(_selection.y, 0, frameHeight - 1);
			_selection.height = FlxU.bound(_selection.height, 1, frameHeight - _selection.y);
		}
		
		protected function updateSelection():void
		{
			var _x:int = 0;
			var _y:int = 0;
			if (GameInput.keyCenter)
			{
				selectionMode += 1;
				if (selectionMode > 1)
					selectionMode = 0;
			}
			else if (GameInput.keyWest)
				_x = -1;
			else if (GameInput.keyEast)
				_x = 1;
			else if (GameInput.keyNorth)
				_y = -1;
			else if (GameInput.keySouth)
				_y = 1;
			
			if (selectionMode == DRAG_CORNER)
			{
				if (GameInput.keyNorthwest) selectionCorner = GameInput.NORTHWEST;
				else if (GameInput.keyNortheast) selectionCorner = GameInput.NORTHEAST;
				else if (GameInput.keySouthwest) selectionCorner = GameInput.SOUTHWEST;
				else if (GameInput.keySoutheast) selectionCorner = GameInput.SOUTHEAST;
				
				switch (_selectionCorner)
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
				}
			}
			else if (selectionMode == NUDGE)
			{
				selection.x += _x;
				selection.y += _y;
			}
			if (_x != 0 || _y != 0)
				clampSelection();
		}
		
		protected function updateFill():void
		{
			var _x:int = 0;
			var _y:int = 0;
			if (GameInput.keyWest || GameInput.keyNorthwest || GameInput.keySouthwest)
				_x = -1;
			else if (GameInput.keyEast || GameInput.keyNortheast || GameInput.keySoutheast)
				_x = 1;
			else if (GameInput.keyNorth || GameInput.keyNorthwest || GameInput.keyNortheast)
				_y = -1;
			else if (GameInput.keySouth || GameInput.keySouthwest || GameInput.keySoutheast)
				_y = 1;

			selection.x += _x * selection.width;
			selection.y += _y * selection.height;
			
			if (_x != 0 || _y != 0 || GameInput.keyCenter)
				fillArea(selection, currentFill);
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
		
		public function updatePalette():void
		{
			
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.justPressed("UP"))
				currentTool++;
			else if (FlxG.keys.justPressed("DOWN"))
				currentTool--;
			
			if (currentTool > 3)
				currentTool = 0;
			else if (currentTool < 0)
				currentTool = 3;
			
			if (currentTool == SELECTION)
				updateSelection();
			else if (currentTool == FILL)
				updateFill();
			else if (currentTool == PALETTE)
				updatePalette();
		}
		
		override public function draw():void
		{
			var _width:Number = frameWidth * block.x + 2 * buffer.x;
			var _height:Number = frameHeight * block.y + 2 * buffer.y;
			
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
				var _alpha:uint;
				var _i:uint;
				for (var _y:int = 0; _y < frameHeight; _y++)
				{
					for (var _x:int = 0; _x < frameWidth; _x++)
					{
						_flashRect.width = block.x;
						_flashRect.height = block.y;
						
						_flashRect.x = x + buffer.x + block.x * _x;
						_flashRect.y = y + buffer.y + block.y * _y;
						
						_color = framePixels.getPixel32(_x, _y);
						_alpha = 0xff & (_color >> 24);
						
						if (_alpha > 0)
							FlxG.camera.buffer.fillRect(_flashRect, _color);
						
						// draw the grid overlay
						if (showGrid)
						{
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
				if (selection.width > 0 && selection.height > 0)
				{
					//top of selection box
					_flashRect.x = x + buffer.x- selectionBorderWidth + selection.x * block.x;
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