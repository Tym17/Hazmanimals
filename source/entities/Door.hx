package entities;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Tym17
 */
class Door extends FlxSprite 
{

	private var toplay:String = "n";
	private var broke:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0, ?angl:Int=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.door__png, true, 128, 128);
		animation.add("n", [0]);
		animation.add("b", [1]);
		immovable = true;
		setRot(angl);
		angle = angl;
	}
	
	public function setRot(ang:Int):Void
	{
		velocity.rotate(FlxPoint.weak(0, 0), ang);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		animation.play(toplay);
	}
	
	public function breakit():Void
	{
		toplay = "b";
		broke = true;
	}
	
	public function isBroken():Bool
	{
		return broke;
	}
	
}