package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class ToolboxFrame extends WindowFrame
	{
		[Embed(source="../assets/images/toolbox.png")] public var imgToolbox:Class;
		
		// tools
		protected static const TOOLBOX:uint = 0;
		protected static const SELECTION_DRAG_LOWER_LEFT:uint = 1;
		protected static const TOOL_2:uint = 2;
		protected static const SELECTION_DRAG_LOWER_RIGHT:uint = 3;
		protected static const TOOL_4:uint = 4;
		protected static const SELECTION_NUDGE:uint = 5;
		protected static const COLOR_PALETTE:uint = 6;
		protected static const SELECTION_DRAG_UPPER_LEFT:uint = 7;
		protected static const FILL_SELECTED_AREA:uint = 8;
		protected static const SELECTION_DRAG_UPPER_RIGHT:uint = 9;
		
		protected static const COLOR_PALETTE_INDEXES:Array = [1, 2, 3, 4, 6, 7, 8, 9];
						
		public var currentTool:int = 0;
		public var lastToolSelected:int = 0;
		public var currentFill:int = 0xff000000;
		protected var colorPalette:Array;

		public function ToolboxFrame(X:Number, Y:Number, Target:TargetFrame, Puzzle:PuzzleFrame)
		{
			super(X, Y, 100, 100);
			
			block.x = block.y = 32;
			target = Target;
			puzzle = Puzzle;
			loadGraphic(imgToolbox);
			loadColorPalette();
			frameWidth = frameHeight = 3;
			showGrid = false;
		}
		
		protected function loadColorPalette():void
		{
			if (!colorPalette)
				colorPalette = new Array(8);
			
			// reset all the palette colors to BLACK
			for (var i:int = 0; i < colorPalette.length; i++)
				colorPalette[i] = 0xff000000;
			
			// go through each pixel in the target image, and find the first 8 unique colors and load them into the palette
			var _currentPixel:uint;
			var _colorsInPalette:uint = 0;
			var _colorAlreadyInPalette:Boolean;
			if (target.framePixels)
			{
				for (var _x:int = 0; _x < target.frameWidth; _x++)
				{
					for (var _y:int = 0; _y < target.frameHeight; _y++)
					{
						_currentPixel = target.framePixels.getPixel32(_x, _y);
						_colorAlreadyInPalette = false;
						for (i = 0; i < colorPalette.length; i++)
						{
							if (_currentPixel == colorPalette[i])
								_colorAlreadyInPalette = true;

						}
						if (!_colorAlreadyInPalette && _colorsInPalette < colorPalette.length)
						{
							colorPalette[_colorsInPalette] = _currentPixel;
							_colorsInPalette++;
						}
					}
				}
				FlxG.log(_colorsInPalette);
			}
			
			// recolor the toolbox palette circles to match the color palette
			if (framePixels)
			{
				var _index:uint;
				for (i = 0; i < colorPalette.length; i++)
				{
					for (_x = 0; _x < block.x; _x++)
					{
						for (_y = 0; _y < block.y; _y++)
						{
							_index = COLOR_PALETTE_INDEXES[i];
							if(framePixels.getPixel32(_index * block.x + _x, COLOR_PALETTE * block.y + _y) == 0xffffffff)
								framePixels.setPixel32(_index * block.x + _x, COLOR_PALETTE * block.y + _y, colorPalette[i]);
						}
					}
				}
			}
		}
		
		protected function updateTool():void
		{
			switch (currentTool)
			{
				case SELECTION_DRAG_LOWER_LEFT:
					puzzle.updateSelection(currentTool);
					break;
				case SELECTION_DRAG_LOWER_RIGHT:
					puzzle.updateSelection(currentTool);
					break;
				case SELECTION_NUDGE:
					puzzle.updateSelection(currentTool);
					break;
				case COLOR_PALETTE:
					updatePalette();
					break;
				case SELECTION_DRAG_UPPER_LEFT:
					puzzle.updateSelection(currentTool);
					break;
				case FILL_SELECTED_AREA:
					puzzle.updateFill(currentFill);
					break;
				case SELECTION_DRAG_UPPER_RIGHT:
					puzzle.updateSelection(currentTool);
					break;
			}
			
			puzzle.clampSelection();
		}
		
		public function updatePalette():void
		{
			var _index:uint = GameInput.keyPressed - 1;
			if (_index > 3)
				_index--;
			currentFill = colorPalette[_index];
		}
		
		override public function update():void
		{
			super.update();
			
			if (GameInput.keyPressed > GameInput.SPECIAL) 
			{
				if (currentTool == TOOLBOX)
					currentTool = GameInput.keyPressed;
				else
					updateTool();
			}
			else if (GameInput.keyPressed == GameInput.SPECIAL)
			{
				if (currentTool == TOOLBOX)
				{
					//currentTool = lastToolSelected;
				}
				else
					currentTool = TOOLBOX;
			}
		}
		
		override public function drawElement(X:uint, Y:uint):void
		{
			var _i:int = Y * frameWidth + X + 1;
			_flashRect.x = _i * block.x;
			_flashRect.y = currentTool * block.y;
			_flashRect.width = block.x;
			_flashRect.height = block.y;
			_flashPoint.x = x + buffer.x + block.x * X;
			_flashPoint.y = y + buffer.y + block.y * (frameHeight - Y - 1);
			FlxG.camera.buffer.copyPixels(framePixels, _flashRect, _flashPoint, null, null, true);
		}
	}
}