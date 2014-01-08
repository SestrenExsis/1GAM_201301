package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class Toolbox extends FlxSprite
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
		
		public var puzzle:PuzzleWindow;
				
		public var currentTool:int = 0;
		public var lastToolSelected:int = 0;
		public var currentFill:int = 0xffff0000;
		
		protected var windowColor:uint = 0xff5b5b5b;
		protected var dropShadowColor:uint = 0xff000000;
		protected var maxSize:FlxPoint;
		protected var buffer:FlxPoint;
		protected var dropShadowOffset:FlxPoint;
		protected var block:FlxPoint;
								
		public function Toolbox(X:Number, Y:Number, Puzzle:PuzzleWindow)
		{
			super(X, Y);
			
			maxSize = new FlxPoint(292, 292);
			buffer = new FlxPoint(4, 4);
			dropShadowOffset = new FlxPoint(2, 3);
			block = new FlxPoint(32, 32);
			puzzle = Puzzle;
			
			loadGraphic(imgToolbox);
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
					puzzle.updatePalette();
					break;
				case SELECTION_DRAG_UPPER_LEFT:
					puzzle.updateSelection(currentTool);
					break;
				case FILL_SELECTED_AREA:
					puzzle.updateFill();
					break;
				case SELECTION_DRAG_UPPER_RIGHT:
					puzzle.updateSelection(currentTool);
					break;
			}
			
			puzzle.clampSelection();
		}
		
		override public function update():void
		{
			super.update();
			
			if (GameInput.keyPressed > GameInput.SPECIAL) 
			{
				if (currentTool == TOOLBOX)
				{
					currentTool = GameInput.keyPressed;
				}
				else
				{
					updateTool();
				}
			}
			else if (GameInput.keyPressed == GameInput.SPECIAL)
			{
				if (currentTool == TOOLBOX)
				{
					//currentTool = lastToolSelected;
				}
				else
				{
					currentTool = TOOLBOX;
				}
			}
		}
		
		override public function draw():void
		{
			var _width:Number = 3 * block.x + 2 * buffer.x;
			var _height:Number = 3 * block.y + 2 * buffer.y;
			
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
			
			// draw the boxes
			if (framePixels)
			{
				var _i:uint;
				for (var _y:int = 0; _y < 3; _y++)
				{
					for (var _x:int = 0; _x < 3; _x++)
					{
						_i = _y * 3 + _x + 1;
						_flashRect.x = _i * block.x;
						_flashRect.y = currentTool * block.y;
						_flashRect.width = block.x;
						_flashRect.height = block.y;
						_flashPoint.x = x + buffer.x + block.x * _x;
						_flashPoint.y = y + buffer.y + block.y * (2 - _y);
						FlxG.camera.buffer.copyPixels(framePixels, _flashRect, _flashPoint, null, null, true);
					}
				}
			}
			
			if(FlxG.visualDebug && !ignoreDrawDebug)
				drawDebug(FlxG.camera);
		}
	}
}