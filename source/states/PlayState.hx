package states;

import entities.Cheese;
import entities.CheeseDoor;
import entities.Door;
import entities.Exit;
import entities.Plant;
import entities.Player;
import entities.Radioactive;
import entities.Rat;
import entities.Ray;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import openfl.system.System;

class PlayState extends FlxState
{
	private var pl:Player;
	private var exit:Exit;
	private var found:Bool;
	
	/* MAP */
	public var _map:FlxOgmoLoader;
	public var _mWalls:FlxTilemap;
	
	/* GROUPS */
	public var _rays:FlxTypedGroup<Ray>;
	public var _doors:FlxTypedGroup<Door>;
	public var _radio:FlxTypedGroup<Radioactive>;
	public var _cheese:FlxTypedGroup<Cheese>;
	public var _cheeseDoor:FlxTypedGroup<CheeseDoor>;
	
	override public function create():Void
	{
		super.create();
		set_bgColor(new FlxColor(0xFF8E8E8E));
		pl = new Player();
		loadMap();
		FlxG.camera.follow(pl, FlxCameraFollowStyle.TOPDOWN, 1);
		_rays = new FlxTypedGroup<Ray>();
		pl.setGroup(_rays);
		add(_rays);
		_radio = new FlxTypedGroup<Radioactive>();
		_cheese = new FlxTypedGroup<Cheese>();
		_cheeseDoor = new FlxTypedGroup<CheeseDoor>();
		exit = new Exit();
		add(exit);
		add(_radio);
		add(_cheese);
		add(_cheeseDoor);
		_map.loadEntities(entityLoading, "entities");
		add(pl);
		add(new FlxButton(10, 10, "Relancer", function():Void {
			FlxG.switchState(new PlayState());
		}));
		add(new FlxButton(10, 35, "Quitter", function():Void {
			System.exit(0);
		}));
	}

	private function loadMap():Void
	{
		_map = new FlxOgmoLoader(AssetPaths.newtest__oel);
		FlxG.worldBounds.width = 5000;
		FlxG.worldBounds.height = 5000;
		_mWalls = _map.loadTilemap(AssetPaths.tileset__png, 128, 128, "walls");
		
		var it:Int = 0;
		while (it <= 76)
		{
			_mWalls.setTileProperties(it, FlxObject.ANY);
			it++;
		}
		//FlxG.debugger.drawDebug = true;
		
		_mWalls.setTileProperties(11, FlxObject.NONE);
		_mWalls.setTileProperties(22, FlxObject.NONE);
		add(_mWalls);
		_doors = new FlxTypedGroup<Door>();
		add(_doors);
	}
	
	private function entityLoading(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			pl.x = x;
			pl.y = y;
		}
		if (entityName == "door")
		{
			_doors.add(new Door(x, y, Std.parseInt(entityData.get("angle"))));
		}
		if (entityName == "plant")
		{
			var plant = new Plant(x, y);
			plant.setCheeseGrp(_cheese);
			_radio.add(plant);
		}
		if (entityName == "end")
		{
			exit.x = x;
			exit.y = y;
		}
		if (entityName == "rat")
		{
			_radio.add(new Rat(x, y));
		}
		if (entityName == "cheesedoor")
		{
			_cheeseDoor.add(new CheeseDoor(x, y, Std.parseInt(entityData.get("angle"))));
		}
		
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(pl, _mWalls);
		FlxG.collide(_radio, _mWalls);
		FlxG.collide(_radio, _mWalls);
		FlxG.collide(pl, _cheeseDoor);
		FlxG.collide(_radio, _cheeseDoor, function(R:Radioactive, C:CheeseDoor):Void {
			if (R.getName() == "rat")
			{
				if (R.morphed())
				{
					C.kill();
				}
			}
		});
		FlxG.collide(_rays, _mWalls, function(R:Ray, W:Dynamic):Void {
			R.kill();
		});
		FlxG.overlap(pl, _doors, function(P:Player, D:Door):Void {
			if (!D.isBroken())
				D.breakit();
		});
		FlxG.overlap(_rays, _doors, function(R:Ray, D:Door):Void {
			if (!D.isBroken())
				R.kill();
		});
		FlxG.overlap(_rays, _radio, function(R:Ray, Rd:Radioactive):Void {
			if (R.alive && !Rd.morphed())
			{
				Rd.radiate();
				R.kill();
			}
		});
		FlxG.overlap(pl, exit, function(P:Player, E:Exit):Void {
			FlxG.switchState(new WinState());
		});
		_radio.forEachAlive(function(R:Radioactive):Void {
			if (R.getName() == "rat")
			{
				checkRatVision(cast(R, Rat));
			}
		});
		FlxG.overlap(_cheese, _radio, function(C:Cheese, R:Radioactive):Void {
			if (R.getName() == "rat")
			{
				C.kill();
			}
		});
	}
	
	private function checkRatVision(R:Rat):Void
	{
		found = false;
		if (R.morphed())
		{
			_cheeseDoor.forEachAlive(function(C:CheeseDoor):Void {
				if (_mWalls.ray(R.getMidpoint(), C.getMidpoint()))
				{
					R.seesFood = true;
					R.prey = C;
					found = true;
				}
			});
		}
		else
		{
			_cheese.forEachAlive(function(C:Cheese):Void {
				if (_mWalls.ray(R.getMidpoint(), C.getMidpoint()))
				{
					R.seesFood = true;
					R.prey = C;
					found = true;
				}
			});
		}
		if (found = false)
		{
			R.seesFood = false;
		}
	}
}
