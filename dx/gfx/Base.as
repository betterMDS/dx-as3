package dx.gfx {

	import dx.gfx.Gradient;
	import dx.gfx.style;
	import dx.common.util;
	import dx.common.debugging.console;


	import dx.gfx.Container;

	public class Base extends Container {

		public var objectType:String = "Base";

		public function Base(options:Object, parent:Object):void{
			super(options, parent);
			defaults = style.getGfxStyle(options, true);

			if(defaults.rotation){
				rotation = defaults.rotation
			}

			// **** shift object by line width
			// dubious but works... arg, no. over down no workie. crap!!
			//defaults.x += defaults.thickness/2;
			//defaults.y += defaults.thickness/2;
		}

		public function align(vr:String, hz:String):void{
			var cw:Number = container.width;
			var ch:Number = container.height;
			if(container.defaults && container.defaults.thickness){
				cw -= container.defaults.thickness;
				ch -= container.defaults.thickness;
			}
			if(vr == "center") y = (ch - height) / 2;
			if(hz == "center") x = (cw - width) / 2;

			//console.log(id, hz, vr, "ALIGN:", "x:", x, "y:", y, "width:", width, "height:", "height:", "cw:", container.width, "ch:", container.height)
		}

		public function change(o:Object):void{
			defaults = util.mix(defaults, o);
			draw();
		}

		public function once(o:Object):void{
			var copy:Object = util.copy(defaults);
			defaults = util.mix(defaults, o);
			draw();
			defaults = copy;
		}

		protected function setLineStyle(changes:Object, perm:Boolean = false):void{
			var d:Object = perm ? defaults : util.copy(defaults);
			d = util.mix(d, changes);

			//lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void
			graphics.lineStyle(d.thickness, d.color, d.alpha, d.hinting, "none", d.caps, d.joints, d.miterLimit);

		}

		protected function start(d:Object):void{
			graphics.clear();
			hasLayout && doLayout(d);
			startLine(d);
			startFill(d);
		}

		protected function end():void{
			endFill();
			updateFilters();
		}

		protected function startLine(d:Object):void{
			if(d.thickness) {
				if(d.color === false){
					graphics.lineStyle(d.thickness);
					graphics.lineGradientStyle.apply(graphics, (new Gradient(d.lnGrad)).getGradient());
				}else{
					//console.log("lineStyle:", d.id, d);
					graphics.lineStyle(d.thickness, d.lineColor || d.color, d.lineAlpha===undefined ? 1 : d.lineAlpha);
				}
			}
		}

		protected function startFill(d:Object):void{
			if(d.bgColor !== false){
				graphics.beginFill(d.bgColor, d.alpha);
			}else if(!d.bgGrad.none){
				//console.log("   startFill", d.bgGrad.colors[1])
				graphics.beginGradientFill.apply(graphics, (new Gradient(d.bgGrad)).getGradient());
			}
		}

		protected function endLine():void{
			// need this?
		}

		protected function endFill():void{
			graphics.endFill();
		}


	}
}
