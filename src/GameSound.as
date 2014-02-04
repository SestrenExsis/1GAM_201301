package
{
	import org.flixel.*;
	
	public class GameSound
	{
		[Embed(source="../assets/sounds/brush.mp3")] public static var sfxBrush01:Class;
		[Embed(source="../assets/sounds/brush2.mp3")] public static var sfxBrush02:Class;
		public static var sfxBrush:Array = [sfxBrush01, sfxBrush02];
			
		[Embed(source="../assets/sounds/coin.mp3")] public static var sfxCoin01:Class;
		public static var sfxCoin:Array = [sfxCoin01];
		
		[Embed(source="../assets/sounds/menu.mp3")] public static var sfxMenu01:Class;
		public static var sfxMenu:Array = [sfxMenu01];
		
		[Embed(source="../assets/sounds/selection.mp3")] public static var sfxSelection01:Class;
		public static var sfxSelection:Array = [sfxSelection01];
		
		public function GameSound()
		{
			super();
		}
		
		public static function play(Sounds:Array, VolumeMultiplier:Number = 1.0):void
		{
			if (GameInput.playbackMode)
				return;
			
			var _seed:Number = Math.floor(Sounds.length * Math.random());
			FlxG.play(Sounds[_seed], VolumeMultiplier, false, false);
		}
	}
}
