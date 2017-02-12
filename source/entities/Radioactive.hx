package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Tym17
 */
class Radioactive extends FlxSprite 
{
	private var rad:Int;
	private var radMorph:Int;
	private var didit:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		rad = 0;
		radMorph = 10;
	}
	
	public function radiate():Void
	{
		if (rad < radMorph)
			rad++;
		else if (rad == radMorph)
		{
			morph();
			rad++;
			didit = true;
		}
		
	}
	
	public function morph():Void
	{
		
	}
	
	public function getName():String
	{
		return "none";
	}
	
	public function morphed():Bool
	{
		return didit;
	}
}