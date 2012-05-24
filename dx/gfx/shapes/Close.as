package dx.gfx.shapes {

	import dx.gfx.Base;
	import dx.common.debugging.console;
	import dx.gfx.style;
	//import dx.gfx.theme;

	public class Close extends Base{

		public function Close(options:Object, parent:Object):void{

			try{
			super(options, parent);
			}catch(e:Error){ console.error("Close.super failed", e); }

			defaults = style.getIconLine(options, true);
			objectType = "Close";
			draw(defaults);
			//addFilter();
		}

		override public function draw(... obj):void{
			var d:Object = obj[0] || defaults;
			start(d);

			try{
				// NOTE: icon gets aligned after. x and y should always be zero
				var g:Number = d.gap * 2,
					x1:Object = {
						x:0,
						y:0
					},
					x2:Object = {
						x:d.w - g,
						y:0
					},
					x3:Object = {
						x:d.w - g,
						y:d.h - g
					},
					x4:Object = {
						x:0,
						y:d.h - g
					};

			graphics.moveTo(x1.x, x1.y);
			graphics.lineTo(x3.x, x3.y);
			graphics.moveTo(x2.x, x2.y);
			graphics.lineTo(x4.x, x4.y);

			//console.log("DRAW CLOSE", x1.x, x1.y, x2.x, x2.y, x3.x, x3.y)
			//console.dir(defaults)

			}catch(e:Error){ console.error("Close.draw failed", e); }

			end();
		}
	}
}
