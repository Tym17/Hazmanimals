package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import openfl.system.System;

class MenuState extends FlxState
{
	override public function create():Void
	{
		super.create();
		add(new FlxSprite(0, 0, AssetPaths.title__png));
		var btn:FlxButton = new FlxButton(0, 0, "Jouer", function():Void { FlxG.switchState(new PlayState()); });
		btn.screenCenter();
		#if desktop
		var quit:FlxButton = new FlxButton(btn.x, btn.y + 35, "Quitter", function():Void { System.exit(0); });
		add(quit);
		#end
		add(btn);
		set_bgColor(new FlxColor(0xFF8E8E8E));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
