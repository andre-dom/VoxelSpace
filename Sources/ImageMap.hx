package;

import kha.Color;
import kha.Image;


class ImageMap implements TerrainMap
{
	private var heightmap: Image;
	private var colormap: Image;
	private var name: String;

	public function new(name, heightmap, colormap)
	{
		this.name = name;
		this.colormap = colormap;
		this.heightmap = heightmap;
	}

	public function heightAt(x: Int, y: Int): Float
	{
		return heightmap.at(x % heightmap.width, y % heightmap.height).Rb;
	}

	public function colorAt(x: Int, y: Int): Color
	{
		return colormap.at(x % colormap.width, y % colormap.height).value;
	}

	public function getName(): String
	{
		return name;
	}
}