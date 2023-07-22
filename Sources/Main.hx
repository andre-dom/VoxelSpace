package;

import kha.Assets;
import kha.System;

#if kha_html5
import js.Browser.document;
import js.Browser.window;
import js.html.CanvasElement;
import kha.Macros;
#end

class Main
{
	public static function main()
		{
		setFullWindowCanvas();
		System.start({title: "Sneed", width: 1080, height: 720}, function (_) {
			var game = new Terrain();
			// Just loading everything is ok for small projects
			Assets.loadEverything(function () {
				// Avoid passing bgColorupdate/render directly,
				// so replacing them via code injection works
				// Scheduler.addTimeTask(function () { game.update(); }, 0, 1 / 60);
				System.notifyOnRender(function (frames) { game.render(frames); });
			});
		});
	}

	static function setFullWindowCanvas(): Void
	{
		#if kha_html5
		document.documentElement.style.padding = "0";
		document.documentElement.style.margin = "0";
		document.body.style.padding = "0";
		document.body.style.margin = "0";
		final canvas:CanvasElement = cast document.getElementById(Macros.canvasId());
		canvas.style.display = "block";
		final resize = function() {
			var w = document.documentElement.clientWidth;
			var h = document.documentElement.clientHeight;
			if (w == 0 || h == 0) {
				w = window.innerWidth;
				h = window.innerHeight;
			}
			canvas.width = Std.int(w * window.devicePixelRatio);
			canvas.height = Std.int(h * window.devicePixelRatio);
			if (canvas.style.width == "") {
				canvas.style.width = "100%";
				canvas.style.height = "100%";
			}
		}
		window.onresize = resize;
		resize();
		#end
	}
}
