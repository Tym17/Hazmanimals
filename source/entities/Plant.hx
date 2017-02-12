package entities;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * ...
 * @author Tym17
 */
class Plant extends Radioactive 
{
	
	private var toplay:String;
	private var grp:FlxTypedGroup<Cheese>;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		radMorph = 2;
		loadGraphic(AssetPaths.plant__png, true, 64, 64);
		animation.add("n", [0]);
		animation.add("r", [1]);
		toplay = "n";
	}
	
	override function morph():Void
	{
		toplay = "r";
		grp.add(new Cheese(getMidpoint().x - 16, getMidpoint().y - 16));
	}
	
	public function setCheeseGrp(_grp:FlxTypedGroup<Cheese>):Void
	{
		grp = _grp;
	}
	
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		animation.play(toplay);
	}
	
}