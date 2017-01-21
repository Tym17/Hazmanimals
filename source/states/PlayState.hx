package states;

import entities.Player;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var pl:Player;
	
	
	/* MAP */
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	
	
	override public function create():Void
	{
		super.create();
		set_bgColor(new FlxColor(0xFF8E8E8E));
		pl = new Player();
		loadMap();
		FlxG.camera.follow(pl, FlxCameraFollowStyle.TOPDOWN, 1);
		add(pl);
		_map.loadEntities(entityLoading, "entities");
	}

	private function loadMap():Void
	{
		_map = new FlxOgmoLoader(AssetPaths.testLevel__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tileset__png, 128, 128, "walls");
		
		var it:Int = 0;
		while (it <= 77)
		{
			_mWalls.setTileProperties(it, FlxObject.ANY);
			it++;
			trace(it);
		}
		_mWalls.setTileProperties(11, FlxObject.NONE);
		_mWalls.setTileProperties(22, FlxObject.NONE);
		add(_mWalls);
	}
	
	private function entityLoading(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x")) * 8;
		var y:Int = Std.parseInt(entityData.get("y")) * 8;
		if (entityName == "player")
		{
			pl.x = x;
			pl.y = y;
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(pl, _mWalls);
		
	}
}
