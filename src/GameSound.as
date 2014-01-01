package
{
	import org.flixel.*;
	
	public class GameSound
	{
		
		public function GameSound()
		{
			super();
		}
		
		public static function play(Sounds:Array, VolumeMultiplier:Number = 1.0):void
		{
			var _seed:Number = Math.floor(Sounds.length * Math.random());
			FlxG.play(Sounds[_seed], VolumeMultiplier, false, false);
		}
	}
}
