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
		protected var icons:FlxSprite;
		protected var coinWidth:Number = 48;
		
		public function ButtonFrame(X:Number, Y:Number, Width:Number, Height:Number, ButtonID:uint, Type:String)
		{
			super(X, Y, Width, Height);
			
			numbers = new FlxSprite();
			numbers.loadGraphic(imgNumbers, true, false, 14, 17);
			
			icons = new FlxSprite();
			icons.loadGraphic(imgObjects, true, false, 32, 32);
			
			ID = ButtonID;
			labelName = new FlxText(x + 2 * buffer.x + maxSize.x, y, 120, "");
			labelName.setFormat(null, 16, 0xffffff, "left");
			labelName.shadow = 0xff000000;
			
			labelDescription = new FlxText(x + 2 * buffer.x + maxSize.x + 32, y + 32, 90, "");
			labelDescription.setFormat(null, 16, 0xffffff, "left");
			labelDescription.shadow = 0xff000000;
			
			type = Type;
			if (type == "level")
			{
				clickFunction = ScreenState.fadeToGame;
				//labelName.text = GameInfo.levelNames[ID];
				updateInfo();
			}
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
		
		public function updateInfo():void
		{
			var _actions:int = GameInfo.fewestActions[ID];
			var _bestTime:int = GameInfo.bestTimes[ID];
			
			if (_actions > 9999)
				labelDescription.text = "--";
			else
				labelDescription.text = _actions.toString();
			
			if (_bestTime > 99999)
				labelDescription.text += "\n\n--";
			else
				labelDescription.text += "\n\n" + _bestTime.toString();
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
				_flashRect.x = _coins * coinWidth;
				_flashRect.y = 0;
				_flashRect.width = coinWidth;
				_flashRect.height = icons.height;
				_flashPoint.x = x + 2 * buffer.x + maxSize.x;
				_flashPoint.y = y;
				FlxG.camera.buffer.copyPixels(icons.pixels, _flashRect, _flashPoint, null, null, true);
				
				_flashRect.x = 7 * icons.width;
				_flashRect.y = 0;
				_flashRect.width = icons.width;
				_flashRect.height = icons.height;
				_flashPoint.x = x + 2 * buffer.x + maxSize.x;
				_flashPoint.y = y + 32;
				FlxG.camera.buffer.copyPixels(icons.pixels, _flashRect, _flashPoint, null, null, true);
				
				_flashRect.x = 8 * icons.width;
				_flashPoint.y = y + 64;
				FlxG.camera.buffer.copyPixels(icons.pixels, _flashRect, _flashPoint, null, null, true);
				
				labelName.draw();
				labelDescription.draw();
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