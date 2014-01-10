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
		protected static const CLONE:uint = 2;
		protected static const SELECTION_DRAG_LOWER_RIGHT:uint = 3;
		protected static const FLIP_ROTATE:uint = 4;
		protected static const SELECTION_NUDGE:uint = 5;
		protected static const COLOR_PALETTE:uint = 6;
		protected static const SELECTION_DRAG_UPPER_LEFT:uint = 7;
		protected static const FILL_SELECTED_AREA:uint = 8;
		protected static const SELECTION_DRAG_UPPER_RIGHT:uint = 9;
		
		protected static const COLOR_PALETTE_INDEXES:Array = [1, 2, 3, 4, 6, 7, 8, 9];
		protected static const TOOL_NAMES:Array = ["Toolbox", "Drag Selection", "Clone",
			"Drag Selection", "Flip/Rotate", "Move Selection", "Color Palette", "Drag Selection", "Paintbrush", "Drag Selection"]
		protected static const TOOL_DESCRIPTIONS:Array = [
			"[1-9] : Select a tool.",
			"[1-4 or 6-9] : Move the LOWER LEFT corner of the selection box in that direction.\n[0] : Return to the Toolbox.",
			"[1-4 or 6-9] : Copy the contents of the selection to an adjacent cell.\n[0] : Return to the Toolbox.",
			"[1-4 or 6-9] : Move the LOWER RIGHT corner of the selection box in that direction.\n[0] : Return to the Toolbox.",
			"[1-9] : Choose a new orientation and/or facing for the contents of the selection.\n[0] : Return to the Toolbox.",
			"[1-4 or 6-9] : Move the entire selection box in that direction.\n[0] : Return to the Toolbox.",
			"[1-9] : Choose a color.\n[0] : Return to the Toolbox.",
			"[1-4 or 6-9] : Move the UPPER LEFT corner of the selection box in that direction.\n[0] : Return to the Toolbox.",
			"[1-9] : Fill the selection area or an adjacent one with the current color.\n[0] : Return to the Toolbox.",
			"[1-4 or 6-9] : Move the UPPER RIGHT corner of the selection box in that direction.\n[0] : Return to the Toolbox."];
						
		public var currentTool:int = 0;
		public var lastToolSelected:int = 0;
		public var currentFill:int = 0xff000000;
		protected var colorPalette:Array;
		
		protected var labelName:FlxText;
		protected var labelDescription:FlxText;

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
			
			labelName = new FlxText(X, Y - 12, 100, "Name");
			labelName.setFormat(null, 8, 0xffff00, "center");
			
			labelDescription = new FlxText(0, FlxG.height - 24, FlxG.width, "Description");
			labelDescription.setFormat(null, 8, 0xffffff, "center");
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
			labelName.text = TOOL_NAMES[currentTool];
			labelDescription.text = TOOL_DESCRIPTIONS[currentTool];
		}
		
		override public function draw():void
		{
			super.draw();
			
			labelName.draw();
			labelDescription.draw();
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