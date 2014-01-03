package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class PuzzleWindow extends FlxSprite
	{
		public var block:FlxPoint;
		public static var group:FlxGroup;
		
		protected var label:FlxText;
		protected var rows:uint;
		protected var columns:uint;
		protected var elements:Array;
		public var selected:Array;
		public var lastSelectedIndex:uint;
		
		// Embed images into these BitmapData vars to add column and row headings to a table.
		protected var columnHeaders:BitmapData;
		protected var rowHeaders:BitmapData;
		
		public var titleBarHeight:Number = 12;
		public var buffer:FlxPoint;
		public var spacing:FlxPoint;
		public var partitions:FlxPoint;
		public var partitionSize:FlxPoint;
				
		public function PuzzleWindow(X:Number, Y:Number, Label:String = "")
		{
			super(X, Y);
			
			block = new FlxPoint(8, 8);
			label = new FlxText(X, Y, 72, Label);
			label.color = 0x000000;
			
			buffer = new FlxPoint(2, 2);
			spacing = new FlxPoint();
			
		}
		
		protected function clearSelections():Boolean
		{
			var _selectionChanged:Boolean = false;
			if (selected)
			{
				for (var i:int = 0; i < elements.length; i++)
				{
					if (selected[i] == true)
						_selectionChanged = true;
					selected[i] = false;
				}
			}
			
			return _selectionChanged;
		}
		
		override public function update():void
		{
			super.update();
			
		}
		
		override public function draw():void
		{
			_flashRect.x = x + 1;
			_flashRect.y = y + 1;
			_flashRect.width = width;
			_flashRect.height = height;
			FlxG.camera.buffer.fillRect(_flashRect, 0xff000000);
							
			_flashRect.x = x;
			_flashRect.y = y;
			FlxG.camera.buffer.fillRect(_flashRect, 0xffffffff);
			
			_flashRect.x = x + 1;
			_flashRect.y = y + 8;
			_flashRect.width -= 2;
			_flashRect.height = 3;
			FlxG.camera.buffer.fillRect(_flashRect, 0xFFA4E4FC);
			
			label.draw();
			
			if (elements)
			{				
				var partitionX:int = 0;
				var partitionY:int = 0;
				var i:int;
				for (var _y:int = 0; _y < rows; _y++)
				{
					for (var _x:int = 0; _x < columns; _x++)
					{
						i = _y * columns + _x;
						
						_flashRect.width = block.x;
						_flashRect.height = block.y;
						
						// if row or column headers are present, then move drawn segments over based on what partition they are in
						if (partitionSize)
						{
							partitionX = (int)(_x / partitionSize.x) + 1;
							partitionY = (int)(_y / partitionSize.y) + 1;
						}
						
						if (partitions && (partitions.x > 0 || partitions.y > 0))
						{
							if (columnHeaders && (_y % partitionSize.y) == 0)
							{
								_flashPoint.x = x + buffer.x + (block.x + spacing.x) * (_x + partitionX);
								_flashPoint.y = y + titleBarHeight + buffer.y + (block.y + spacing.y) * (_y + partitionY - 1);
								_flashRect.x = (_x % partitionSize.x) * block.x;
								_flashRect.y = ((partitionY - 1) % partitionSize.y) * block.y;
								FlxG.camera.buffer.copyPixels(columnHeaders, _flashRect, _flashPoint, null, null, true);
							}
							if (rowHeaders && (_x % partitionSize.x) == 0)
							{
								_flashPoint.x = x + buffer.x + (block.x + spacing.x) * (_x + partitionX - 1);
								_flashPoint.y = y + titleBarHeight + buffer.y + (block.y + spacing.y) * (_y + partitionY);
								_flashRect.x = ((partitionX - 1) % partitionSize.x) * block.x;
								_flashRect.y = (_y % partitionSize.y) * block.y;
								FlxG.camera.buffer.copyPixels(rowHeaders, _flashRect, _flashPoint, null, null, true);
							}
						}
						
						_flashRect.x = x + buffer.x + (block.x + spacing.x) * (_x + partitionX);
						_flashRect.y = y + titleBarHeight + buffer.y + (block.y + spacing.y) * (_y + partitionY);
						
						drawElementBackground(i);
						
						// Place a selection box around the last color clicked on
						if (selected && selected[i])
						{
							_flashRect.x -= 1;
							_flashRect.y -= 1;
							_flashRect.width += 2;
							_flashRect.height += 2;
							FlxG.camera.buffer.fillRect(_flashRect, 0xff000000);
							
							_flashRect.x += 1;
							_flashRect.y += 1;
							_flashRect.width -= 2;
							_flashRect.height -= 2;
							FlxG.camera.buffer.fillRect(_flashRect, 0xffffffff);
							_flashRect.x += 1;
							_flashRect.y += 1;
							_flashRect.width -= 2;
							_flashRect.height -= 2;
						}
						
						drawElement(i);
					}
				}
			}
			
			if(FlxG.visualDebug && !ignoreDrawDebug)
				drawDebug(FlxG.camera);
		}
		
		public function drawElementBackground(ElementIndex:int):void
		{

		}
		
		public function drawElement(ElementIndex:int):void
		{
			
		}
	}
}