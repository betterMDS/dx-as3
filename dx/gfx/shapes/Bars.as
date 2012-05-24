package dx.gfx.shapes {

	import dx.common.debugging.console;

	import dx.gfx.Base;
	import dx.gfx.style;

	public class Bars extends Base{

		public function Bars(options:Object, parent:Object):void{

			try{
			super(options, parent);
			}catch(e:Error){ console.error("Bars.super failed", e); }

			defaults = style.getIconStyle(defaults);
			objectType = "Bars";
			draw(defaults);
			//addFilter();


		}

		override public function draw(... obj):void{
			var d:Object = obj[0] || defaults;
			start(d);
			try{
				var w:Number = (d.w/d.bars) - (d.gap * (d.bars-1));

				for(var i:uint=0; i<d.bars; i++){
					graphics.drawRoundRect(d.x + (w+d.gap)*i, d.y, w, d.h, d.r, d.r);
				}

			}catch(e:Error){ console.error("Bars.draw failed", e); }
			end();
		}
	}
}
