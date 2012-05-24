package dx.gfx {

	import dx.common.util;
	import dx.common.debugging.console;

	import flash.geom.Matrix;
	import flash.display.Graphics;
	import flash.display.GradientType;
	import flash.display.SpreadMethod

	public class Gradient {

		public var defaults:Object;

		public function Gradient(options:Object):void{
			defaults = options;
			defaults.matrix = getMatrix(defaults);
		}

		public function getGradient():Array{
			var d:Object = defaults;
			//console.log("grad use", d.alphas)
			return [d.fillType, d.colors, d.alphas, d.ratios, d.matrix, d.spreadMethod];
		}

		private function getMatrix(o:Object):Matrix{
			var m:Matrix = new Matrix();
			m.createGradientBox(o.w, o.h, (o.rotation*Math.PI)/180, 0, 0);
			return m;
		}
	}
}
