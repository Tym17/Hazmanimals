package entities;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Tym17
 */
class Ray extends FlxSprite 
{

	private var speed:Float;
	
	
	public function new(X:Float, Y:Float, _speed:Float, _angle:Float)
	{
		super(X, Y);
		drag.x = drag.y = 0;
		speed = _speed;
		velocity.set(speed, 0);
		velocity.rotate(FlxPoint.weak(0, 0), _angle);
		loadGraphic(AssetPaths.fire__png, false, 16, 16);
	}
	
}