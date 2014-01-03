package screens
{
	import org.flixel.*;
	
	public class GameState extends ScreenState
	{
		
		public function GameState()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xffff0000;
		}
		
		override public function update():void
		{	
			super.update();
			GameInput.update();
		}
	}
}