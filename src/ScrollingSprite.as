package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import frames.PuzzleFrame;
	import frames.TargetFrame;
	
	import org.flixel.*;
	
	public class ScrollingSprite extends FlxSprite
	{
		[Embed(source="../assets/images/background.png")] public var imgBackground:Class;
		
		protected var scrollPosition:FlxPoint;
		protected var scrollSpeed:FlxPoint;
		
		public function ScrollingSprite(X:Number, Y:Number, Animation:String)
		{
			super(X, Y);
			
			loadGraphic(imgBackground, true, false, FlxG.width, FlxG.height);
			addAnimation("hills",[0]);
			play(Animation);
			
			scrollPosition = new FlxPoint();
			scrollSpeed = new FlxPoint(0.25, 0);
		}
		
		override public function update():void
		{
			super.update();
			
			scrollPosition.x += scrollSpeed.x;
			scrollPosition.y += scrollSpeed.y;
			if (scrollPosition.x >= frameWidth)
				scrollPosition.x -= frameWidth;
			else if (scrollPosition.x < 0)
				scrollPosition.x += frameWidth;
			
			if (scrollPosition.y >= frameHeight)
				scrollPosition.y -= frameHeight;
			else if (scrollPosition.y < 0)
				scrollPosition.y += frameHeight;
		}
		
		override public function draw():void
		{
			// Draw the scrolling background in 1, 2, or 4 pieces depending on scrolling position.
			var _scrollX:Number = Math.floor(scrollPosition.x);
			var _scrollY:Number = Math.floor(scrollPosition.y);
			
			// Draw the upper-left quadrant of the scrolling background.
			_flashRect.x = _scrollX;
			_flashRect.y = _scrollY;
			_flashRect.width = frameWidth - _scrollX;
			_flashRect.height = frameHeight - _scrollY;
			_flashPoint.x = 0;
			_flashPoint.y = 0;
			FlxG.camera.buffer.copyPixels(framePixels, _flashRect, _flashPoint, null, null, true);
			
			// Split the background in half along the x-axis and/or y-axis if the scrollPosition is far enough along
			
			// Draw the upper-right quadrant of the scrolling background.
			if (_scrollX > 0)
			{
				_flashRect.x = 0;
				_flashRect.y = _scrollY;
				_flashRect.width = _scrollX;
				_flashRect.height = frameHeight - _scrollY;
				_flashPoint.x = frameWidth - _scrollX;
				_flashPoint.y = 0;
				FlxG.camera.buffer.copyPixels(framePixels, _flashRect, _flashPoint, null, null, true);
			}
			
			// Draw the lower-left quadrant of the scrolling background.
			if (_scrollY > 0)
			{
				_flashRect.x = _scrollX;
				_flashRect.y = 0;
				_flashRect.width = frameWidth - _scrollX;
				_flashRect.height = _scrollY;
				_flashPoint.x = 0;
				_flashPoint.y = frameHeight - _scrollY;
				FlxG.camera.buffer.copyPixels(framePixels, _flashRect, _flashPoint, null, null, true);
			}
			
			// Draw the lower-right quadrant of the scrolling background.
			if (_scrollX > 0 && _scrollY > 0)
			{
				_flashRect.x = 0;
				_flashRect.y = 0;
				_flashRect.width = _scrollX;
				_flashRect.height = _scrollY;
				_flashPoint.x = frameWidth - _scrollX;
				_flashPoint.y = frameHeight - _scrollY;
				FlxG.camera.buffer.copyPixels(framePixels, _flashRect, _flashPoint, null, null, true);
			}
			
			if(FlxG.visualDebug && !ignoreDrawDebug)
				drawDebug(FlxG.camera);
		}
	}
}