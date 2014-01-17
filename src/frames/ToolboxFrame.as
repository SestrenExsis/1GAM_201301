package frames
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class ToolboxFrame extends FrameSprite
	{
		[Embed(source="../assets/images/toolbox.png")] public var imgToolbox:Class;
		
		// tools
		public static const TOOLBOX:uint = 0;
		public static const SELECTION_DRAG_LOWER_LEFT:uint = 1;
		public static const CLONE:uint = 2;
		public static const SELECTION_DRAG_LOWER_RIGHT:uint = 3;
		public static const FLIP_ROTATE:uint = 4;
		public static const SELECTION_NUDGE:uint = 5;
		public static const COLOR_PALETTE:uint = 6;
		public static const SELECTION_DRAG_UPPER_LEFT:uint = 7;
		public static const FILL_SELECTED_AREA:uint = 8;
		public static const SELECTION_DRAG_UPPER_RIGHT:uint = 9;
		
		// selection mode
		public static const ONE_PIXEL:uint = 0;
		public static const SELECTION_BOX:uint = 1;
		
		protected static const TOOLBOX_TIP:String = "  [0] : Return to the Toolbox.";
		
		protected static const COLOR_PALETTE_INDEXES:Array = [1, 2, 3, 4, 6, 7, 8, 9];
		protected static const TOOL_NAMES:Array = ["Toolbox", "Drag Selection", "Clone",
			"Drag Selection", "Flip/Rotate", "Move Selection", "Color Palette", "Drag Selection", "Paintbrush", "Drag Selection"]
		protected static const TOOL_DESCRIPTIONS:Array = [
			"[1-9] : Select a tool.",
			"[1-4 or 6-9] : Move the LOWER LEFT corner of the selection box in that direction.",
			"[1-4 or 6-9] : Copy the contents of the selection to an adjacent cell.",
			"[1-4 or 6-9] : Move the LOWER RIGHT corner of the selection box in that direction.",
			"[1-9] : Choose a new orientation and/or facing for the contents of the selection.",
			"[1-4 or 6-9] : Move the entire selection box in that direction.",
			"[1-9] : Choose a color.",
			"[1-4 or 6-9] : Move the UPPER LEFT corner of the selection box in that direction.",
			"[1-9] : Fill the selection area or an adjacent one with the current color.",
			"[1-4 or 6-9] : Move the UPPER RIGHT corner of the selection box in that direction."];
						
		public var currentTool:int = TOOLBOX;
		public var lastToolSelected:int = 0;
		public var currentFill:int = 0xff000000;
		public var currentSelectionMode:uint = ONE_PIXEL;
		
		protected var colorPalette:Array;
		protected var _cursorLocation:FlxPoint;
		protected var _cursorLocationVisual:FlxPoint;

		public function ToolboxFrame(X:Number, Y:Number, Width:Number, Height:Number, Target:TargetFrame, Puzzle:PuzzleFrame)
		{
			super(X, Y, Width, Height);
			
			elementSize.x = elementSize.y = 32;
			target = Target;
			puzzle = Puzzle;
			elements.loadGraphic(imgToolbox);
			loadColorPalette();
			elements.frameWidth = elements.frameHeight = 3;
			
			labelName = new FlxText(X, Y - 12, 100, "Name");
			labelName.setFormat(null, 8, 0xffff00, "center");
			
			labelDescription = new FlxText(0, FlxG.height - 16, FlxG.width, "Description");
			labelDescription.setFormat(null, 8, 0xffffff, "center");
			
			_cursorLocation = new FlxPoint(-32, -32);
			_cursorLocationVisual = new FlxPoint(-32, -32);
			
			resetWindowFrame(2 * buffer.x + elementSize.x * elements.frameWidth, 2 * buffer.y + elementSize.y * elements.frameHeight);
			
			showGrid = true;
		}
		
		public function get cursorLocationVisual():FlxPoint
		{			
			if (puzzle && puzzle.selection)
			{
				_cursorLocation.x = puzzle.x + puzzle.buffer.x + puzzle.elementSize.x * puzzle.selection.x;
				_cursorLocation.y = puzzle.y + puzzle.buffer.y + puzzle.elementSize.y * puzzle.selection.y;
				
				if (currentTool == SELECTION_DRAG_UPPER_RIGHT || currentTool == SELECTION_DRAG_LOWER_RIGHT)
					_cursorLocation.x += puzzle.elementSize.x * puzzle.selection.width;
				if (currentTool == SELECTION_DRAG_LOWER_LEFT || currentTool == SELECTION_DRAG_LOWER_RIGHT)
					_cursorLocation.y += puzzle.elementSize.y * puzzle.selection.height;
				if (currentTool == SELECTION_NUDGE)
				{
					_cursorLocation.x += 0.5 * puzzle.elementSize.x * puzzle.selection.width;
					_cursorLocation.y += 0.5 * puzzle.elementSize.y * puzzle.selection.height;
				}
			}
			else
				_cursorLocation.x = _cursorLocation.y = -32;
			
			var _lerp:Number = 0.2;
			var _diff:Number = _cursorLocation.x - _cursorLocationVisual.x;
			if (Math.abs(_diff) < 1)
				_cursorLocationVisual.x = _cursorLocationVisual.x;
			else
				_cursorLocationVisual.x = FlxTween.linear(_lerp, _cursorLocationVisual.x, _diff, 1);
			
			_diff = _cursorLocation.y - _cursorLocationVisual.y;
			if (Math.abs(_diff) < 1)
				_cursorLocationVisual.y = _cursorLocationVisual.y;
			else
				_cursorLocationVisual.y = FlxTween.linear(_lerp, _cursorLocationVisual.y, _diff, 1);
			
			return _cursorLocationVisual;
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
			if (target.elements.framePixels)
			{
				for (var _x:int = 0; _x < target.elements.frameWidth; _x++)
				{
					for (var _y:int = 0; _y < target.elements.frameHeight; _y++)
					{
						_currentPixel = target.elements.framePixels.getPixel32(_x, _y);
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
			}
			
			// recolor the toolbox palette circles to match the color palette
			if (elements.framePixels)
			{
				var _index:uint;
				for (i = 0; i < colorPalette.length; i++)
				{
					for (_x = 0; _x < elementSize.x; _x++)
					{
						for (_y = 0; _y < elementSize.y; _y++)
						{
							_index = COLOR_PALETTE_INDEXES[i];
							if(elements.framePixels.getPixel32(_index * elementSize.x + _x, COLOR_PALETTE * elementSize.y + _y) == 0xffffffff)
								elements.framePixels.setPixel32(_index * elementSize.x + _x, COLOR_PALETTE * elementSize.y + _y, colorPalette[i]);
						}
					}
				}
			}
		}
		
		protected function updateTool():void
		{
			// If one of the selection tools is active, the center key toggles the selection mode.
			if ((currentTool % 2) == 1 && GameInput.keyCenter)
			{
				currentSelectionMode += 1;
				if (currentSelectionMode > SELECTION_BOX)
					currentSelectionMode = ONE_PIXEL;
			}
				
			switch (currentTool)
			{
				case SELECTION_DRAG_LOWER_LEFT:
					puzzle.updateSelection(currentTool, currentSelectionMode);
					break;
				case CLONE:
					puzzle.updateClone();
					break;
				case SELECTION_DRAG_LOWER_RIGHT:
					puzzle.updateSelection(currentTool, currentSelectionMode);
					break;
				case SELECTION_NUDGE:
					puzzle.updateSelection(currentTool, currentSelectionMode);
					break;
				case COLOR_PALETTE:
					updatePalette();
					break;
				case SELECTION_DRAG_UPPER_LEFT:
					puzzle.updateSelection(currentTool, currentSelectionMode);
					break;
				case FILL_SELECTED_AREA:
					puzzle.updateFill(currentFill);
					break;
				case SELECTION_DRAG_UPPER_RIGHT:
					puzzle.updateSelection(currentTool, currentSelectionMode);
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
				currentTool = TOOLBOX;
			}
			labelName.text = TOOL_NAMES[currentTool];
			labelDescription.text = TOOL_DESCRIPTIONS[currentTool];
			if (currentTool > TOOLBOX)
				labelDescription.text += TOOLBOX_TIP;
		}
		
		override public function draw():void
		{
			super.draw();
			
			labelName.draw();
			labelDescription.draw();
			
			_flashRect.x = x + buffer.x;
			_flashRect.y = y + buffer.y + elementSize.y * (frameHeight + 0.5);
			_flashRect.width = 3 * elementSize.x;
			_flashRect.height = 32;
			FlxG.camera.buffer.fillRect(_flashRect, currentFill);
		}
		
		override public function drawElement(X:uint, Y:uint):void
		{
			var _i:int = Y * elements.frameWidth + X + 1;
			_flashRect.x = _i * elementSize.x;
			_flashRect.y = currentTool * elementSize.y;
			_flashRect.width = elementSize.x;
			_flashRect.height = elementSize.y;
			_flashPoint.x = x + buffer.x + elementSize.x * X;
			_flashPoint.y = y + buffer.y + elementSize.y * (elements.frameHeight - Y - 1);
			
			// all the selection tools are odd-numbered tools, and their center key is reserved for toggling the selection mode
			if ((currentTool % 2) == 1 && _i == 5)
			{
				_flashRect.x = currentSelectionMode * elementSize.x;
				_flashRect.y = 10 * elementSize.y;
			}
			FlxG.camera.buffer.copyPixels(elements.framePixels, _flashRect, _flashPoint, null, null, true);
		}
	}
}