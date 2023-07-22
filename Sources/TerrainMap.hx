package;

import kha.Color;

interface TerrainMap
{
	private var name: String;

	public function heightAt(x: Int, y: Int): Float;

	public function colorAt(x: Int, y: Int): Color;

	public function getName(): String;
}