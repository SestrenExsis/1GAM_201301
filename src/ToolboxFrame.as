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
						
		public var currentTool:int = 0;
		public var lastToolSelected:int = 0;
		public var currentFill:int = 0xff000000;
								
		public function ToolboxFrame(X:Number, Y:Number, Puzzle:PuzzleFrame)
		{
			super(X, Y, 100, 100);
			
			block.x = block.y = 32;
			puzzle = Puzzle;
			loadGraphic(imgToolbox);
			frameWidth = frameHeight = 3;
			showGrid = false;
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
			//
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