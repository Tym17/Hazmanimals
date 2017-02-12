package states;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import openfl.system.System;

/**
 * ...
 * @author Tym17
 */
class WinState extends FlxState 
{
	
	override public function create():Void
	{
		super.create();
		add(new FlxSprite(0, 0, AssetPaths.good__png));
		var txt = new FlxText(0, 0, 0, "Victoire !", 30);
		txt.screenCenter();
		add(txt);
		#if desktop
		var quit:FlxButton = new FlxButton(txt.x, txt.y + 35, "Quitter", function():Void { System.exit(0); });
		quit.screenCenter();
		quit.y = txt.y + 50;
		add(quit);
		#end
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}