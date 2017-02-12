package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author Tym17
 */
class Player extends FlxSprite 
{

private var _speed:Float = 400;
	private var _rotTimer:Float;
	private var _maxTimer:Float = 0.1;
	public var isInteracting:Bool = false;
	private var cd:Float;
	private var firerate:Float = 0.2;
	public var firegroup:FlxTypedGroup<Ray>;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.pl__png, true, 128, 128);
		//makeGraphic(16, 16, FlxColor.BLUE);
		animation.add("f", [1]);
		animation.add("n", [0]);
		drag.x = drag.y = 2000;
		_rotTimer = _maxTimer;
		cd = 0;
	}
	
	public function setGroup(grp:FlxTypedGroup<Ray>):Void
	{
		firegroup = grp;
	}
	
	override public function update(elapsed:Float):Void
	{
		checkMoves(elapsed);
		makeRotation(elapsed);
		aimfire(elapsed);
		super.update(elapsed);
	}
	
	private function aimfire(elapsed:Float):Void
	{
		cd = cd + elapsed;
		if (isInteracting)
		{
			if (cd > firerate)
			{
				
				firegroup.add(new Ray(getMidpoint().x - 8, getMidpoint().y - 8, 800, Math.atan2(FlxG.mouse.getWorldPosition().y - getMidpoint().y - 8, FlxG.mouse.getWorldPosition().x - getMidpoint().x - 8) * 180 / Math.PI));
				cd = 0;
			}
		}
	}
	
	
	
	private function makeRotation(elapsed:Float):Void
	{
		
		
		angle = Std.int(Math.atan2(FlxG.mouse.getWorldPosition().y - (y + 64), FlxG.mouse.getWorldPosition().x - (x + 64)) * 180 / Math.PI);
		if (FlxG.keys.anyPressed([SPACE, E]) || FlxG.mouse.pressed)
		{
			animation.play("f");
			_rotTimer = 0;
			isInteracting = true;
		}
		else if (_rotTimer < _maxTimer)
		{
			animation.play("f");
			_rotTimer += elapsed;
			isInteracting = true;
		}
		else
		{
			animation.play("n");
			isInteracting = false;
		}
	}
	
	private function checkMoves(elapsed:Float):Void
	{
		var _up:Bool = FlxG.keys.anyPressed([Z, UP, W]);
		var _down:Bool = FlxG.keys.anyPressed([S, DOWN]);
		var _right:Bool = FlxG.keys.anyPressed([RIGHT, D]);
		var _left:Bool = FlxG.keys.anyPressed([Q, A, LEFT]);
		
		var _angle:Float = 0;
		if (_up || _down || _right || _left)
		{
			if (_up)
			{
				_angle = -90;
				if (_left)
					_angle -= 45;	
				else if (_right)
					_angle += 45;
			}
			else if (_down)
			{
				_angle = 90;
				if (_left)
					_angle += 45;	
				else if (_right)
					_angle -= 45;
			}
			else if (_left)
				_angle = 180;
			else if (_right)
				_angle = 0;
			velocity.set(_speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), _angle);
		}
		
	}

}