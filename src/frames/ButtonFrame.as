package frames
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class ButtonFrame extends FrameSprite
	{
		[Embed(source="../assets/images/objects.png")] public var imgObjects:Class;
		
		protected var type:String;
		protected var clickFunction:Function;
		protected var medals:FlxSprite;
		
		public function ButtonFrame(X:Number, Y:Number, Width:Number, Height:Number, ButtonID:uint, Type:String)
		{
			super(X, Y, Width, Height);
			
			numbers = new FlxSprite();
			numbers.loadGraphic(imgNumbers, true, false, 14, 17);
			
			medals = new FlxSprite();
			medals.loadGraphic(imgObjects, true, false, 32, 32);
			
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
			
			var _width:Number = SourceRect.width;
			var _height:Number = SourceRect.height;
			if (_width < _height)
				_width = _height;
			else if (_height < _width)
				_height = _width;
			
			if((elements.framePixels == null) || (elements.framePixels.width != _width) || (elements.framePixels.height != _height))
				elements.framePixels = new BitmapData(_width, _height, true, 0x00000000);
			_flashPoint.x = (int)(0.5 * (_width - SourceRect.width));
			_flashPoint.y = (int)(0.5 * (_height - SourceRect.height));
			elements.framePixels.copyPixels(elements.pixels, SourceRect, _flashPoint, null, null, false);
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
			
			if ((GameInput.mouseJustClicked && overlapsPoint(FlxG.mouse)) || GameInput.keyPressed == (ID + 1))
			{
				if (type == "level")
					GameInfo.level = ID;
				else if (type == "world")
					GameInfo.world = ID;
				FlxG.log("Loading stage " + GameInfo.world + "-" + GameInfo.level);
				clickFunction();
			}
		}
		
		override public function draw():void
		{
			super.draw();
			
			_flashRect.x = numbers.width * ((ID + 1) % 10);
			_flashRect.y = 0;
			_flashRect.width = numbers.width;
			_flashRect.height = numbers.height;
			_flashPoint.x = x + buffer.x;
			_flashPoint.y = y + height - buffer.y - numbers.height;
			FlxG.camera.buffer.copyPixels(numbers.pixels, _flashRect, _flashPoint, null, null, true);
			
			if (type == "level")
			{
				var _i:int = GameInfo.world * 9 + ID;
				var _coins:int = GameInfo.coinsCollected[_i];
				for (var i:int = 1; i <= _coins; i++)
				{
					_flashRect.x = 0;
					_flashRect.y = 0;
					_flashRect.width = medals.width;
					_flashRect.height = medals.height;
					_flashPoint.x = x + buffer.x + width - medals.width;
					_flashPoint.y = y + buffer.y + height - i * medals.height;
					FlxG.camera.buffer.copyPixels(medals.pixels, _flashRect, _flashPoint, null, null, true);
				}
			}
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