package screens
{
	import flash.display.Stage;
	
	import org.flixel.*;
	//import org.flixel.system.input.Input;
	
	public class SettingsScreen extends ScreenState
	{
		private var buttons:Array;
		private var listenForKey:Boolean = false;
		private var _select:int = -1;
		private var _textboxes:Array;
		private var _saveSettings:FlxButton;
		private var _defaultSettings:FlxButton;
		
		public function SettingsScreen()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xff888899;
			
			displayText = new FlxText(0, FlxG.height - 16, FlxG.width, "");
			add(displayText);

			buttons = new Array(10);
			_textboxes = new Array(10);
			for (var i:uint = 0; i < buttons.length; i++)
			{
				_textboxes[i] = new FlxText(FlxG.width / 2 - 200 - 2, 8 + 24 * i, 200, GameInput.actions[i]);
				(_textboxes[i] as FlxText).alignment = "right";
				(_textboxes[i] as FlxText).ID = i;
				add(_textboxes[i]);
				buttons[i] = new FlxButton(FlxG.width / 2 + 2, 8 + 24 * i, GameInput.keymap[i], remapKey);
				(buttons[i] as FlxButton).ID = i;
				add(buttons[i]);
			}
			
			displayText = new FlxText(0, FlxG.height - 24, FlxG.width, "Press ESC to return to main menu.");
			displayText.alignment = "center";
			add(displayText);
			
			_saveSettings = new FlxButton(FlxG.width / 2 - 102, FlxG.height - 48, "Save", saveSettings);
			add(_saveSettings);
			
			_defaultSettings = new FlxButton(FlxG.width / 2 + 2, FlxG.height - 48, "Default", defaultSettings);
			add(_defaultSettings);
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		override public function update():void
		{	
			super.update();
			
			if (FlxG.keys["ESCAPE"]) fadeToMenu();
			
			if (FlxG.keys.any() && listenForKey)
			{
				listenForKey = false;
				var _record:Array = FlxG.keys.record();
				var _key:int = _record[0].code;
				var _keyname:String = FlxG.keys.getKeyName(_record[0].code);
				if (_select >= 0) 
				{
					var _btn:FlxButton = buttons[_select];
					_btn.active = true;
					_btn.status = FlxButton.NORMAL;
					_btn.label.text = _keyname;
					displayText.text = GameInput.actions[_select] + " is now mapped to '" + _keyname + "'";
					GameInput.keymap[_select] = _keyname;
				}
			}
		}
		
		public function remapKey():void
		{
			displayText.text = "<Press any key>";
			for (var i:uint = 0; i < buttons.length; i++)
			{
				var _btn:FlxButton = buttons[i];
				if (_btn.status != FlxButton.NORMAL) _select = _btn.ID;
			}
			listenForKey = true;
			_btn = buttons[_select];
			_btn.label.text = "...";
			_btn.status = FlxButton.PRESSED;
			_btn.active = false;
		}
		
		public function saveSettings():void
		{
			UserSettings.keymap = GameInput.keymap.slice();
			displayText.text = "Settings have been saved.";
		}
		
		public function defaultSettings():void
		{
			GameInput.keymap = [
				"NUMPADSEVEN", "NUMPADEIGHT", "NUMPADNINE",
				"NUMPADFOUR", "NUMPADFIVE", "NUMPADSIX",
				"NUMPADONE", "NUMPADTWO", "NUMPADTHREE",
				"NUMPADZERO"];
			UserSettings.keymap = GameInput.keymap.slice();
			displayText.text = "Default settings have been restored.";
			
			for (var i:uint = 0; i < buttons.length; i++)
			{
				var _btn:FlxButton = buttons[i];
				_btn.label.text = GameInput.keymap[i];
			}
		}
	}
}