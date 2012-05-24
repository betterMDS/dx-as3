package dx.gfx.shapes {

	import dx.common.debugging.console;
	import dx.common.util;
	import dx.gfx.Base;
	import flash.geom.Point;

	public class Circle extends Base{

		public function Circle(options:Object, parent:Object):void{

			try{
				super(options, parent);
			}catch(e:Error){ console.error("Circle.super failed", e); }

			draw(defaults);

		}

		override public function draw(... obj):void{

			var d:Object = obj[0] || defaults;
			start(d);
			try{
				graphics.drawEllipse(d.x, d.y, d.w, d.h);
			}catch(e:Error){ console.error("Circle.draw failed", e, d); }
			end();
		}
	}
}
