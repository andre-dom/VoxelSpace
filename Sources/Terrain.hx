package;

import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.Image;
import kha.Scaler;
import kha.System;
import kha.input.Keyboard;
import kha.input.KeyCode;
import Math.*;

typedef Point = {var x:Float; var y:Float;}

class Terrain
{
	private static var bgColor = Color.fromValue(0x87CEEB);
	public static inline var screenWidth = 640;
	public static inline var screenHeight = 480;
  
	private var backbuffer: Image;

	private var maps: Array<TerrainMap>;

	private var camera: Camera;
	private var controls: Controls;
	private var timer: Timer;
	private var map: TerrainMap;

	public function new()
	{
	  // create a buffer to draw to
	  Assets.loadEverything(function () {
		backbuffer = Image.createRenderTarget(screenWidth, screenHeight);
		maps = [new ImageMap('Default', Assets.images.D0, Assets.images.C0),
				new ImageMap('Desert', Assets.images.D20, Assets.images.C20),
				new ImageMap('Canyon', Assets.images.D1137, Assets.images.C1137),
				new ImageMap('Island', Assets.images.D42, Assets.images.C42),
				new ImageMap('Volcano', Assets.images.VolcanoD, Assets.images.VolcanoC),
				new ProceduralMap('Procedural',
								 function (x, y) {return sin(x/2)*10 + sin(y/2)*10;},
								 function (x, y) {return Color.fromFloats((sin(x)+1)/2,
																		  (cos(x)+1)/2,
																		  (sin(y)+1)/2);}),
				new ProceduralMap('Procedural 2', function(x, y) {return 10;}, function(x, y) {return Black;})];
		map = maps[0];
		camera = new Camera(250, 250, 120, 45);
		controls = new Controls();
		Keyboard.get().notify(buttonDown, buttonUp, null);
		timer = new Timer();
	  });
	}

	private inline function drawVerticalLine(g: kha.graphics2.Graphics, x, yTop: Float, yBottom: Float, color: Color)
	{
		if(yTop < yBottom) {return;}
		g.color = color;
		g.drawLine(x, yBottom, x, yTop);
		g.color = White;
	}

	public function render(framebuffer: Framebuffer): Void
	{

		var g = backbuffer.g2;

		var position: Point = {x: camera.x, y: camera.y};
		var phi = camera.angle;
		var height = camera.h;
		var horizon = camera.tilt;
		var heightScalingFactor = 240;
		var renderDistance = 1000;
		
		var sinPhi = Math.sin(phi);
		var cosPhi = Math.cos(phi);

		var yBuffer:Array<Float> = [for (i in 0...screenWidth) screenHeight];

		// clear backbuffer
		g.begin(bgColor);

		var z: Float = 1;
		var dz: Float = 1;
		while(z < renderDistance)
		{
			var pLeft: Point = {x: (-cosPhi*z - sinPhi*z) + position.x,
								y: (sinPhi*z - cosPhi*z) + position.y};
			var pRight: Point = {x: (cosPhi*z - sinPhi*z) + position.x,
								y: (-sinPhi*z - cosPhi*z) + position.y};

			var dx: Float = (pRight.x - pLeft.x) / screenWidth;
			var dy: Float = (pRight.y - pLeft.y) / screenWidth;
		
			for(i in 0...screenWidth)
			{
				var segmentHeight: Float = (height - map.heightAt(Std.int(Math.abs(pLeft.x)), Std.int(Math.abs(pLeft.y)))) / z * heightScalingFactor + horizon;
				drawVerticalLine(g, i, yBuffer[i], segmentHeight, map.colorAt(Std.int(Math.abs(pLeft.x)), Std.int(Math.abs(pLeft.y))));
				if(segmentHeight < yBuffer[i])
				{
					yBuffer[i] = segmentHeight;
				}
				pLeft.x += dx;
				pLeft.y += dy;
			}
			z += dz;
			dz += .005;
		}
		
		// Draw Info Text
		g.font = Assets.fonts.kenpixel_mini_square;
		var fontHeight = Std.int(Assets.fonts.kenpixel_mini_square.height(24));
		g.fontSize = 24;
		g.color = Orange;
		var fps = Std.int(1/timer.deltaTime);
		g.drawString('FPS: $fps', 20, 20);
		g.drawString('Movement: WASD', 20, 20 + (fontHeight + 5) * 1);
		g.drawString('Turn: Q/E', 20, 20 + (fontHeight + 5) * 2);
		g.drawString('Tilt: Z/X', 20, 20 + (fontHeight + 5) * 3);
		g.drawString('Go Fast: Shift', 20, 20 + (fontHeight + 5) * 4);
		g.drawString('Current Map: ' + map.getName(), 20, 20 + (fontHeight + 5) * 5);
		g.drawString('Select map: 1-6', 20, 20 + (fontHeight + 5) * 6);
		g.color = White;
		g.end();
  
		framebuffer.g2.begin();
		Scaler.scale(backbuffer, framebuffer, System.screenRotation);
		framebuffer.g2.end();

		update();
	}

	private function update()
	{
		timer.update();
		var deltaTime = timer.deltaTime;
		if (controls.sprint) camera.speed = 250; else camera.speed = 50;
		if (controls.left)
		{
			camera.x -= Math.cos(camera.angle) * camera.speed * deltaTime;
			camera.y += Math.sin(camera.angle) * camera.speed * deltaTime;
		}
		if (controls.right)
		{
			camera.x += Math.cos(camera.angle) * camera.speed * deltaTime;
			camera.y -= Math.sin(camera.angle) * camera.speed * deltaTime;
		}
		if (controls.forward) 
		{
			camera.x -= Math.sin(camera.angle) * camera.speed * deltaTime;
			camera.y -= Math.cos(camera.angle) * camera.speed * deltaTime;
		}
		if (controls.backward)
		{
			camera.x += Math.sin(camera.angle) * camera.speed * deltaTime;
			camera.y += Math.cos(camera.angle) * camera.speed * deltaTime;
		}
		if (controls.up) camera.h +=  camera.speed*deltaTime;
		if (controls.down) camera.h -= camera.speed*deltaTime;
		if (controls.rotateLeft) camera.angle += .5 * deltaTime;
		if (controls.rotateRight) camera.angle -= .5 * deltaTime;
		if (controls.lookUp) camera.tilt += 250 * deltaTime;
		if (controls.lookDown) camera.tilt -= 250 * deltaTime;

		// collision detection
		var terrainHeight = map.heightAt(Std.int(Math.abs(camera.x)), Std.int(Math.abs(camera.y)));
		if(camera.h < terrainHeight + 10)
		{
			camera.h = terrainHeight + 10;
		}
	}

	function buttonDown(button: KeyCode): Void
	{
		if (button == One ) map = maps[0];
		else if (button == Two) map = maps[1];
		else if (button == Three) map = maps[2];
		else if (button == Four) map = maps[3];
		else if (button == Five) map = maps[4];
		else if (button == Six) map = maps[5];
		else if (button == Seven) map = maps[6];

        controls.buttonDown(button);

    }
    
    function buttonUp(button: KeyCode): Void
	{
        controls.buttonUp(button);
    }
}