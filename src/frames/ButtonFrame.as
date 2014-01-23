package frames
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class ButtonFrame extends FrameSprite
	{		
		protected var type:String;
		protected var clickFunction:Function;
		
		public function ButtonFrame(X:Number, Y:Number, Width:Number, Height:Number, ButtonID:uint, Type:String)
		{
			super(X, Y, Width, Height);
			
			numbers = new FlxSprite();
			numbers.loadGraphic(imgNumbers, true, false, 14, 17);
			
			ID = ButtonID;
			type = Type;
			if (type == "level")
				clickFunction = ScreenState.fadeToGame;
			else if (type == "world")
				clickFunction = ScreenState.fadeToLevelSelect;
		}
		
		public function loadButtonImage(Image:Class, SourceRect:Rectangle):void
		{
			elements.loadGraphic(Image);
			
			if((elements.framePixels == null) || (elements.framePixels.width != SourceRect.width) || (elements.framePixels.height != SourceRect.height))
				elements.framePixels = new BitmapData(SourceRect.width, SourceRect.height);
			elements.framePixels.copyPixels(elements.pixels, SourceRect, _flashPointZero, null, null, false);
			elements.frameWidth = elements.framePixels.width;
			elements.frameHeight = elements.framePixels.height;
			
			var _blockX:Number = maxSize.x / elements.frameWidth;
			var _blockY:Number = maxSize.y / elements.frameHeight;
			
			if (_blockX > _blockY)
				_blockX = _blockY;
			else if (_blockY > _blockX)
				_blockY = _blockX;
			
			element.width = _blockX;
			element.height = _blockY;
			
			resetWindowFrame(2 * buffer.x + maxSize.x, 2 * buffer.y + maxSize.y);
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.mouse.justPressed() && overlapsPoint(FlxG.mouse))
			{
				if (type == "level")
					GameInfo.level = ID;
				else if (type == "world")
					GameInfo.world = ID;
				clickFunction();
			}
		}
		
		override public function draw():void
		{
			super.draw();
			
			_flashRect.x = numbers.width * (ID % 10);
			_flashRect.y = 0;
			_flashRect.width = numbers.width;
			_flashRect.height = numbers.height;
			_flashPoint.x = x + buffer.x;
			_flashPoint.y = y + height - buffer.y - numbers.height;
			FlxG.camera.buffer.copyPixels(numbers.pixels, _flashRect, _flashPoint, null, null, true);
		}
		
		override public function drawElement(X:uint, Y:uint):void
		{
			_flashRect.width = element.width;
			_flashRect.height = element.height;
			
			_flashRect.x = x + buffer.x + element.width * X;
			_flashRect.y = y + buffer.y + element.height * Y;
			
			var _pixelColor:uint = elements.framePixels.getPixel32(X, Y);
			var _pixelAlpha:uint = 0xff & (_pixelColor >> 24);
			
			if (_pixelAlpha > 0)
				FlxG.camera.buffer.fillRect(_flashRect, _pixelColor);
		}
	}
}