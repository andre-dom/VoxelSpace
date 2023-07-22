package;

import kha.Color;

class ProceduralMap implements TerrainMap
{

    private var name: String;
    private var heightFn: (Int, Int)->Float;
    private var colorFn: (Int, Int)->Color;

	public function new(name: String, heightFn: (Int, Int)->Float, colorFn: (Int, Int)->Color)
	{
		this.name = name;
        this.heightFn = heightFn;
        this.colorFn = colorFn;
	}

	public function heightAt(x: Int, y: Int): Float
	{
		return heightFn(x, y);
	}

	public function colorAt(x: Int, y: Int): Color
	{
		return colorFn(x, y);
	}

	public function getName(): String
	{
		return name;
	}
}