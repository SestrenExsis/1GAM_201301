package frames
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class PuzzleFrame extends FrameSprite
	{
		protected var currentTool:int = 0;
		protected var currentFill:int = 0xffff0000;
		protected var _currentFrame:int;
						
		public function PuzzleFrame(X:Number, Y:Number, Target:TargetFrame)
		{
			super(X, Y, 336, 336);
			
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
			var _x:int = 0;
			var _y:int = 0;
			if (GameInput.keyWest || GameInput.keyNorthwest || GameInput.keySouthwest)
				_x = -1;
			else if (GameInput.keyEast || GameInput.keyNortheast || GameInput.keySoutheast)
				_x = 1;
			if (GameInput.keyNorth || GameInput.keyNorthwest || GameInput.keyNortheast)
				_y = -1;
			else if (GameInput.keySouth || GameInput.keySouthwest || GameInput.keySoutheast)
				_y = 1;
			
			var _originalX:int = selection.x;
			var _originalY:int = selection.y;
			var _originalWidth:int = selection.width;
			var _originalHeight:int = selection.height;
			
			switch (CurrentTool)
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
				case GameInput.CENTER:
					selection.x += _x;
					selection.y += _y;
					break;
			}

			if (SelectionMode == ToolboxFrame.SELECTION_BOX)
			{
				if (CurrentTool == GameInput.CENTER)
				{
					selection.x = _originalX + _x * _originalWidth;
					selection.y = _originalY + _y * _originalHeight;
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
							selection.x += _x;
							selection.y += _y;
							break;
					}
				}
			}
			
			if (_x != 0 || _y != 0)
				clampSelection();
		}
		
		public function updateFill(Color:uint):void
		{
			var _x:int = 0;
			var _y:int = 0;
			if (GameInput.keyWest || GameInput.keyNorthwest || GameInput.keySouthwest)
				_x = -1;
			else if (GameInput.keyEast || GameInput.keyNortheast || GameInput.keySoutheast)
				_x = 1;
			if (GameInput.keyNorth || GameInput.keyNorthwest || GameInput.keyNortheast)
				_y = -1;
			else if (GameInput.keySouth || GameInput.keySouthwest || GameInput.keySoutheast)
				_y = 1;
			
			selection.x += _x * selection.width;
			selection.y += _y * selection.height;
			
			fillArea(selection, Color);
		}
		
		public function fillArea(FillArea:Rectangle, FillColor:uint):void
		{
			for (var _x:int = selection.x; _x < selection.x + selection.width; _x++)
			{
				for (var _y:int = selection.y; _y < selection.y + selection.height; _y++)
				{
					if (_x >= 0 && _x < elements.framePixels.width && _y >= 0 && _y < elements.framePixels.height)
						elements.framePixels.setPixel32(_x, _y, FillColor);
				}
			}
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