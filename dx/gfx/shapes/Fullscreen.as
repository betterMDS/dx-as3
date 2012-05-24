package dx.gfx.shapes {

	import dx.common.debugging.console;
	import dx.common.util;
	import dx.gfx.Base;


	public class Fullscreen extends Base{

		public var direction:String = "right";

		public function Fullscreen(options:Object, parent:Object):void{

			// This is the icon, not the button.

			try{
			super(options, parent);
			}catch(e:Error){ console.error("Fullscreen.super failed", e); }

			draw(defaults);

		}

		private function pt(px:Number, py:Number, move:int = 0, change:String = null):Object{
			return {x:px, y:py, m:move, c:change};
		}



		override public function draw(... obj):void{

			var d:Object = obj[0] || defaults;
			start(d);
			setLineStyle({caps:"none", hinting:true, joints:"bevel"}, true);

			var w:Number = d.w - d.gap,
				h:Number = d.h - d.gap,

				w2:Number =.25*w,
				w3:Number =.75*w,
				h2:Number = h*.25,
				h3:Number = .75*h;

			var a:Array = [
				pt(w2,h2,1),
				pt(0,h2),
				pt(0,h),
				pt(w3,h),
				pt(w3,h3),

				pt(w2 , h/2, 1 ),
				pt(w2, 0),
				pt(w, 0),
				pt(w, h3),
				pt(w/2, h3),

				pt(w*.2, h*.8, 1, "thickness"),
				pt(w*.8, h*.2),

				pt(w*.5, h*.2, 1, "joints"),
				pt(w*.8, h*.2),
				pt(w*.8, h*.5)
			];


			for(var i:int=0;i<a.length;i++){
				var p:Object = a[i];
				if(p.c == "thickness") setLineStyle({thickness:d.thickness*1.5});
				if(p.c == "joints") setLineStyle({joints:"miter", thickness:d.thickness*1.5});
				if(p.m){
					graphics.moveTo(p.x, p.y);
				}else{
					graphics.lineTo(p.x, p.y);
				}

			}

			//end();
		}
	}
}
