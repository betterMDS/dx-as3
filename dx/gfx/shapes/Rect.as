package dx.gfx.shapes {

	import dx.gfx.Base;
	import dx.common.debugging.console;
	import dx.common.util;

	public class Rect extends Base{

		public function Rect(options:Object, parent:Object):void{
			try{
				super(options, parent);

				objectType = "Rect";

				draw(defaults);
				//addFilter();

			}catch(e:Error){ console.error("Rect.super failed", e); }

		}

		public override function draw(... obj):void{
			var d:Object = obj[0] || defaults;
			if(d.extras){
				setLineStyle({caps:"none", hinting:true, joints:"bevel"}, true);
			}
			start(d);
			try{
				if(d.r){
					if(d.r*2 == d.w && d.r*2 == d.h){
						graphics.drawEllipse(d.x, d.y, d.w, d.h);
					}else{
						graphics.drawRoundRect(d.x, d.y, d.w, d.h, d.r, d.r);
					}
				}else{
					// round rect has trouble with 1px lines
					graphics.drawRect(d.x, d.y, d.w, d.h);
				}
			}catch(e:Error){ console.error("Rect.draw failed", e, id, d); }
			end();
		}
	}
}
