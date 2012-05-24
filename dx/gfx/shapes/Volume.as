package dx.gfx.shapes {

	import dx.common.debugging.console;
	import dx.common.util;
	import dx.gfx.Base;


	public class Volume extends Base{

		public var direction:String = "right";

		public function Volume(options:Object, parent:Object):void{

			try{
			super(options, parent);
			}catch(e:Error){ console.error("Volume.super failed", e); }

			draw(defaults);

		}

		private function pt(px:Number, py:Number, move:int = 0, change:String = null):Object{
			return {x:px, y:py, m:move, c:change};
		}



		override public function draw(... obj):void{

			var d:Object = obj[0] || defaults;
			var i:int;

			start(d);
			setLineStyle({caps:"none", hinting:true, joints:"bevel"}, true);

			var w:Number = d.w - d.gap,
				h:Number = d.h - d.gap,

				w2:Number =.25*w,
				w3:Number =.75*w,
				h2:Number = h*.25,
				h3:Number = .75*h;

			var a:Array = [
				pt(0, h*.375,1),
				pt(w*.25, h*.375),
				pt(w*.5, 0),
				pt(w*.5,h),
				pt(w*.25,h*.625),
				pt(0,h*.625),
				pt(0, h*.375),

				pt(w*.5 +1, h/2-2, 1 ),
				pt(w*.5 +1, h/2+2 ),

				pt(2, h*.375, 1),
				pt(2, h*.625),

				/*,

				pt(w2 , h/2, 1 ),
				pt(w2, 0),
				pt(w, 0),
				pt(w, h3),
				pt(w/2, h3),

				pt(w*.2, h*.8, 1, "thickness"),
				pt(w*.8, h*.2),

				pt(w*.5, h*.2, 1, "joints"),
				pt(w*.8, h*.2),
				pt(w*.8, h*.5)*/
			];


			/*a = a.concat([
				pt(w*.5+2, )
			]);*/


			for(i=0;i<a.length;i++){
				var p:Object = a[i];
				if(p.c == "thickness") setLineStyle({thickness:d.thickness*1.5});
				if(p.c == "joints") setLineStyle({joints:"miter", thickness:d.thickness*1.5});
				if(p.m){
					graphics.moveTo(p.x, p.y);
				}else{
					graphics.lineTo(p.x, p.y);
				}

			}

			var drawArc:Function = function(x:Number, y:Number, w:Number, h:Number):void{
				graphics.moveTo(x, y);
				graphics.curveTo(x+w, y, x+w, y+(h/2));
				graphics.curveTo(x+w, y+h, x, y+h);
			}

			var cw:Number = w/2;
			var cx:Number = w/2 + 3;
			var ch:Number = h;
			var cy:Number = 0;


			drawArc(cx, cy, cw, ch);

			ch*=.7;
			cw*=.7;
			cy = (h-ch)/2;
			drawArc(cx, cy, cw, ch);

			ch*=.6;
			cw*=.6;
			cy = (h-ch)/2;
			drawArc(cx, cy, cw, ch);



			//end();
		}
	}
}
