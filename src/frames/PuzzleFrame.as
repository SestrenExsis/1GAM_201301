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
			resetElementFrame(target.elements.frameWidth, target.elements.frameHeight, 0x00000000);
			setSelection(0, 0, elements.frameWidth, elements.frameHeight);
			
			showGrid = true;
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
				case GameInput.NORTHWEST:
					selection.x += GameInput.x;
					selection.width -= GameInput.x;
					selection.y += GameInput.y;
					selection.height -= GameInput.y;
					break;
				case GameInput.NORTHEAST:
					selection.width += GameInput.x;
					selection.y += GameInput.y;
					selection.height -= GameInput.y;
					break;
				case GameInput.SOUTHWEST:
					selection.x += GameInput.x;
					selection.width -= GameInput.x;
					selection.height += GameInput.y;
					break;
				case GameInput.SOUTHEAST:
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
						case GameInput.NORTHWEST:
							selection.x = _originalX + _originalWidth - selection.width;
							selection.y = _originalY + _originalHeight - selection.height;
							break;
						case GameInput.NORTHEAST:
							selection.x = _originalX;
							selection.y = _originalY + _originalHeight - selection.height;
							break;
						case GameInput.SOUTHWEST:
							selection.x = _originalX + _originalWidth - selection.width;
							selection.y = _originalY;
							break;
						case GameInput.SOUTHEAST:
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
		
		public function updateClone():void
		{
			_flashPoint.x = selection.x;
			_flashPoint.y = selection.y;
			selection.x += GameInput.x * selection.width;
			selection.y += GameInput.y * selection.height;
			cloneArea(_flashPoint, selection);
		}
		
		public function cloneArea(SourcePoint:Point, DestinationArea:Rectangle):void
		{
			var _fill:uint;
			var _destX:Number;
			var _destY:Number;
			for (var _x:int = 0; _x < DestinationArea.width; _x++)
			{
				for (var _y:int = 0; _y < DestinationArea.height; _y++)
				{
					_destX = DestinationArea.x + _x;
					_destY = DestinationArea.y + _y;
					if (_destX >= 0 && _destX < elements.framePixels.width && _destY >= 0 && _destY < elements.framePixels.height)
					{
						_fill = elements.framePixels.getPixel32(SourcePoint.x + _x, SourcePoint.y + _y);
						elements.framePixels.setPixel32(_destX, _destY, _fill);
					}
				}
			}
		}
		
		public function updateOrientation():void
		{
			_bitmapData = new BitmapData(selection.width, selection.height, true, 0x00000000);
			//_bitmapData.copyPixels(elements.framePixels, selection, _flashPointZero, null, null, true);
			
			var _switchXAndY:Boolean = GameInput.keyNortheast || GameInput.keyEast || GameInput.keyWest || GameInput.keySouthwest;
			var _switchXDirection:Boolean = GameInput.keyNorth || GameInput.keyNortheast || GameInput.keyEast || GameInput.keySoutheast;
			var _switchYDirection:Boolean = GameInput.keyEast || GameInput.keySoutheast || GameInput.keySouth || GameInput.keySouthwest;
			
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
						_destX = selection.width - _x;
					if (_switchYDirection)
						_destY = selection.height - _y;
					if (_switchXAndY)
					{
						_destTemp = _destX;
						_destX = _destY;
						_destY = _destTemp;
					}
					_bitmapData.setPixel32(_destX, _destY, _fill);
					FlxG.log("x: " + _destX + ", y: " + _destY + ", Color: " + _fill);
				}
			}
			
			_flashRect.x = _flashRect.y = 0;
			_flashRect.width = _bitmapData.width;
			_flashRect.height = _bitmapData.height;
			
			_flashPoint.x = selection.x;
			_flashPoint.y = selection.y;
			elements.framePixels.copyPixels(_bitmapData, _flashRect, _flashPoint, null, null, true);
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