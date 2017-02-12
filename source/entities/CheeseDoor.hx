package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Tym17
 */
class CheeseDoor extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0, ?ang:Float=0) 
	{
		super(X, Y);
		angle = ang;
		loadGraphic(AssetPaths.cheesedoor__png, false, 128, 128);
		immovable = true;
	}
	
}