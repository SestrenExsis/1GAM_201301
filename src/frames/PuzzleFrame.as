package frames
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class PuzzleFrame extends FrameSprite
	{
		protected var currentTool:int = 0;
		protected var currentFill:int = 0xffff0000;
		protected var _currentFrame:int;
		protected var _bitmapData:BitmapData;
						
		public function PuzzleFrame(X:Number, Y:Number, Width:Number, Height:Number, Target:TargetFrame)
		{
			super(X, Y, Width, Height);
			
			target = Target;
			spacing.x = spacing.y = 2;
			resetElements(target.elements.frameWidth, target.elements.frameHeight);
			setSelection(0, 0, elements.frameWidth, elements.frameHeight);
			
			showGrid = true;
		}
		
		override public function resetElements(Width:uint, Height:uint, DefaultColor:uint = 0x00000000):void
		{
			super.resetElements(Width, Height, DefaultColor);
			
			_flashRect.copyFrom(target.startFrameRects[target.currentFrame]);
			elements.framePixels.copyPixels(target.elements.pixels, _flashRect, _flashPointZero);
			
			var _i:int;
			var _color:uint;
			for (var _x:int = 0; _x < element.width; _x++)
			{
				for (var _y:int = 0; _y < element.height; _y++)
				{
					_i = 0;
					
					if (_x >= (element.width - 1))
						_i += 2;
					else if (_x > 0)
						_i += 1;
					
					if (_y >= (element.height - 1))
						_i += 6;
					else if (_y > 0)
						_i += 3;
					
					if (_i == 2 || _i == 6)
						_color = 0x80808080;
					else if (_i <= 3)
						_color = 0x80ffffff;
					else if (_i == 4)
						_color = 0x00000000;
					else
						_color = 0x80000000;
					
					element.pixels.setPixel32(_x, _y, _color);
				}
			}
		}
		
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		public function clampSelection():void
		{
			_selection.x = FlxU.bound(_selection.x, 0, elements.frameWidth - 1);
			_selection.width = FlxU.bound(_selection.width, 1, elements.frameWidth - _selection.x);
			_selection.y = FlxU.bound(_selection.y, 0, elements.frameHeight - 1);
			_selection.height = FlxU.bound(_selection.height, 1, elements.frameHeight - _selection.y);
			target.setSelection(_selection.x, _selection.y, _selection.width, _selection.height);
		}
		
		public function updateSelection(CurrentTool:int, SelectionMode:int):void
		{
			var _originalX:int = selection.x;
			var _originalY:int = selection.y;
			var _originalWidth:int = selection.width;
			var _originalHeight:int = selection.height;
			
			switch (CurrentTool)
			{
				case GameInput.UP_LEFT:
					selection.x += GameInput.x;
					selection.width -= GameInput.x;
					selection.y += GameInput.y;
					selection.height -= GameInput.y;
					break;
				case GameInput.UP_RIGHT:
					selection.width += GameInput.x;
					selection.y += GameInput.y;
					selection.height -= GameInput.y;
					break;
				case GameInput.DOWN_LEFT:
					selection.x += GameInput.x;
					selection.width -= GameInput.x;
					selection.height += GameInput.y;
					break;
				case GameInput.DOWN_RIGHT:
					selection.width += GameInput.x;
					selection.height += GameInput.y;
					break;
				case GameInput.CENTER:
					selection.x += GameInput.x;
					selection.y += GameInput.y;
					break;
			}

			if (SelectionMode == ToolboxFrame.SELECTION_BOX)
			{
				if (CurrentTool == GameInput.CENTER)
				{
					selection.x = _originalX + GameInput.x * _originalWidth;
					selection.y = _originalY + GameInput.y * _originalHeight;
				}
				else
				{
					var _halfWidth:int = Math.max(1, Math.floor(0.5 * _originalWidth));
					var _halfHeight:int = Math.max(1, Math.floor(0.5 * _originalHeight));
					var _twiceWidth:int = 2 * _originalWidth;
					var _twiceHeight:int = 2 * _originalHeight;
					
					if (selection.width > _originalWidth)
						selection.width = _twiceWidth;
					else if (selection.width < _originalWidth)
						selection.width = _halfWidth;
					
					if (selection.height > _originalHeight)
						selection.height = _twiceHeight;
					else if (selection.height < _originalHeight)
						selection.height = _halfHeight;
					
					switch (CurrentTool)
					{
						case GameInput.UP_LEFT:
							selection.x = _originalX + _originalWidth - selection.width;
							selection.y = _originalY + _originalHeight - selection.height;
							break;
						case GameInput.UP_RIGHT:
							selection.x = _originalX;
							selection.y = _originalY + _originalHeight - selection.height;
							break;
						case GameInput.DOWN_LEFT:
							selection.x = _originalX + _originalWidth - selection.width;
							selection.y = _originalY;
							break;
						case GameInput.DOWN_RIGHT:
							selection.x = _originalX;
							selection.y = _originalY
							break;
						case GameInput.CENTER:
							selection.x += GameInput.x;
							selection.y += GameInput.y;
							break;
					}
				}
			}
			
			if (GameInput.x != 0 || GameInput.y != 0)
				clampSelection();
		}
		
		public function updateFill(Color:uint):void
		{
			selection.x += GameInput.x * selection.width;
			selection.y += GameInput.y * selection.height;
			
			fillArea(selection, Color);
		}
		
		public function fillArea(FillArea:Rectangle, FillColor:uint):void
		{
			for (var _x:int = FillArea.x; _x < FillArea.x + FillArea.width; _x++)
			{
				for (var _y:int = FillArea.y; _y < FillArea.y + FillArea.height; _y++)
				{
					if (_x >= 0 && _x < elements.framePixels.width && _y >= 0 && _y < elements.framePixels.height)
						elements.framePixels.setPixel32(_x, _y, FillColor);
				}
			}
		}
		
		public function updateClone(SelectionMode:int):void
		{
			_flashPoint.x = selection.x;
			_flashPoint.y = selection.y;
			if (SelectionMode == ToolboxFrame.SELECTION_BOX)
			{
				selection.x += GameInput.x * selection.width;
				selection.y += GameInput.y * selection.height;
			}
			else
			{
				selection.x += GameInput.x;
				selection.y += GameInput.y;
			}
			cloneArea(_flashPoint, selection);
		}
		
		public function cloneArea(SourcePoint:Point, DestinationArea:Rectangle):void
		{
			_flashRect.x = SourcePoint.x
			_flashRect.y = SourcePoint.y;
			_flashRect.width = DestinationArea.width;
			_flashRect.height = DestinationArea.height;
			
			_flashPoint.x = DestinationArea.x;
			_flashPoint.y = DestinationArea.y;
			elements.framePixels.copyPixels(elements.framePixels, _flashRect, _flashPoint);
		}
		
		public function updateOrientation():void
		{
			var _switchXAndY:Boolean = GameInput.keyDownLeft || GameInput.keyRight || GameInput.keyLeft || GameInput.keyUpRight;
			var _switchXDirection:Boolean = GameInput.keyUp || GameInput.keyDownLeft || GameInput.keyRight || GameInput.keyDownRight;
			var _switchYDirection:Boolean = GameInput.keyRight || GameInput.keyDownRight || GameInput.keyDown || GameInput.keyUpRight;
			
			var _sourceWidth:int;
			var _sourceHeight:int;
			if (_switchXAndY)
			{
				_sourceWidth = selection.height;
				_sourceHeight = selection.width;
			}
			else
			{
				_sourceWidth = selection.width;
				_sourceHeight = selection.height;
			}
			_bitmapData = new BitmapData(_sourceWidth, _sourceHeight, true, 0x00000000);
			
			var _fill:uint;
			var _destX:int;
			var _destY:int;
			var _destTemp:int;
			for (var _x:int = 0; _x < selection.width; _x++)
			{
				for (var _y:int = 0; _y < selection.height; _y++)
				{
					_destX = selection.x + _x;
					_destY = selection.y + _y;
					_fill = elements.framePixels.getPixel32(_destX, _destY);
					
					if (_switchXDirection)
						_destX = selection.width - _x - 1;
					else
						_destX = _x;
					if (_switchYDirection)
						_destY = selection.height - _y - 1;
					else
						_destY = _y;
					if (_switchXAndY)
					{
						_destTemp = _destX;
						_destX = _destY;
						_destY = _destTemp;
					}
					_bitmapData.setPixel32(_destX, _destY, _fill);
				}
			}
			
			_flashRect.x = _flashRect.y = 0;
			_flashRect.width = _bitmapData.width;
			_flashRect.height = _bitmapData.height;
			
			if (_switchXAndY)
			{
				var _bias:Number = 0;
				_flashPoint.x = selection.x + Math.floor(0.5 * (selection.width + _bias)) - Math.floor(0.5 * (selection.height + _bias));
				_flashPoint.y = selection.y + Math.floor(0.5 * (selection.height + _bias)) - Math.floor(0.5 * (selection.width + _bias));
			}
			else
			{
				_flashPoint.x = selection.x;
				_flashPoint.y = selection.y;
			}
			elements.framePixels.copyPixels(_bitmapData, _flashRect, _flashPoint);
			
			if (_switchXAndY)
			{
				selection.x = _flashPoint.x;
				selection.y = _flashPoint.y;
				selection.width = _sourceWidth;
				selection.height = _sourceHeight;
			}
			
		}
		
		public function cheat():void
		{
			var _fill:uint;
			for (var _x:int = selection.x; _x < selection.x + selection.width; _x++)
			{
				for (var _y:int = selection.y; _y < selection.y + selection.height; _y++)
				{
					_fill = target.elements.framePixels.getPixel32(_x, _y);
					elements.framePixels.setPixel32(_x, _y, _fill);
				}
			}
		}
		
		override public function update():void
		{
			super.update();
			
			//if (FlxG.keys.justPressed("C")) cheat();
		}
		
		override public function drawElement(X:uint, Y:uint):void
		{
			_flashRect.width = element.width;
			_flashRect.height = element.height;
			
			_flashRect.x = x + buffer.x + (element.width + spacing.x) * X + 0.5 * spacing.x;
			_flashRect.y = y + buffer.y + (element.height + spacing.y) * Y + 0.5 * spacing.y;
			
			var _pixelColor:uint = elements.framePixels.getPixel32(X, Y);
			var _pixelAlpha:uint = 0xff & (_pixelColor >> 24);
			
			if (_pixelAlpha > 0)
			{
				FlxG.camera.buffer.fillRect(_flashRect, _pixelColor);
				_flashPoint.x = _flashRect.x;
				_flashPoint.y = _flashRect.y;
				_flashRect.x = _flashRect.y = 0;
				FlxG.camera.buffer.copyPixels(element.pixels, _flashRect, _flashPoint, null, null, true);
			}
		}
	}
}