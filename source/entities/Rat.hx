package entities;

import entities.organs.FSM;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Tym17
 */
class Rat extends Radioactive 
{
	private var toplay:String;
	private var brain:FSM;
	public var prey:FlxSprite;
	private var idleTimer:Float = 0;
	public var seesFood:Bool = false;
	private var _moveDir:Float = 0;
	private var speed:Float = 100;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.mouse__png, true, 64, 64);
		animation.add("n", [0]);
		animation.add("r", [1]);
		toplay = "n";
		radMorph = 3;
		brain = new FSM(idle);
		prey = new FlxSprite();
		prey.alive = false;
	}
	
	override public function morph():Void
	{
		toplay = "r";
	}
	
	override public function update(elapsed:Float):Void
	{
		animation.play(toplay);
		brain.update();
		super.update(elapsed);
	}
	
	public function idle():Void
	{
		if (prey.alive)
		{
			brain.activeState = chase;
		}
		else if (idleTimer <= 0)
		{
			if (FlxG.random.bool(1))
			{
				_moveDir = -1;
				velocity.x = velocity.y = 0;
			}
			else
			{
				if (!morphed())
				{
				_moveDir = FlxG.random.int(0, 8) * 45;
				velocity.set(speed * 0.5, 0);
				velocity.rotate(FlxPoint.weak(), _moveDir);
				angle = _moveDir;
				}
				else
				{
					velocity.set(0, 0);
				}
			}
			idleTimer = FlxG.random.int(1, 4);
		}
		else
			idleTimer -= FlxG.elapsed;
	}
	
	public function chase():Void
	{
		if (!prey.alive)
		{
			brain.activeState = idle;
		}
		else
		{
			FlxVelocity.moveTowardsPoint(this, prey.getMidpoint(), Std.int(speed));
			
		}
	}
	
	override public function getName():String
	{
		return "rat";
	}
}