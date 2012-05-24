package dx.gfx.shapes {

	import dx.common.debugging.console;
	import dx.common.util;
	import dx.gfx.Base;
	import flash.geom.Point;

	public class Triangle extends Base{

		public var direction:String = "right";

		public function Triangle(options:Object, parent:Object):void{

			try{
			super(options, parent);
			}catch(e:Error){ console.error("Triangle.super failed", e); }

			direction = options.direction || direction;
			objectType = "Triangle";
			draw(defaults);
			//addFilter();

		}

		override public function draw(... obj):void{

			//console.log("draw triangle", obj[0].bgGrad.colors[1])

			var d:Object = obj[0] || defaults;
			//console.log("draw triangle", d.bgGrad.colors[1])
			start(d);

			var w:Number = d.w, h:Number = d.h, r:Number = d.r;

			var pt1:Point = new Point(0, 0);
			var pt2:Point = new Point(w, h/2);
			var pt3:Point = new Point(0, h);

			if(direction == "left"){
				pt1 = new Point(0, h/2);
				pt2 = new Point(w, 0);
				pt3 = new Point(w, h);
			}

			graphics.moveTo(pt1.x, pt1.y);
			graphics.lineTo(pt2.x, pt2.y);
			graphics.lineTo(pt3.x, pt3.y);
			graphics.lineTo(pt1.x, pt1.y);

			end();
		}
	}
}
