package dx.gfx{

	import dx.common.debugging.console;
	import dx.common.util;

	import dx.gfx.shapes.Rect;
	import dx.gfx.shapes.Triangle;
	import dx.gfx.shapes.Circle;
	import dx.gfx.shapes.Bars;
	import dx.gfx.shapes.Fullscreen;
	import dx.gfx.shapes.Volume;
	import dx.gfx.shapes.Close;

	import dx.gfx.Container;
	import dx.gfx.style;

	import flash.display.*;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	public class Icon extends Container {

		private var state:int = 0;
		private var gfx1:Object = {};
		private var gfx2:Object = {};
		public var defaults1:Object = {};
		public var defaults2:Object;

		public var mc:Object;
		public var tf:Object;

		public function Icon(options:Object, parent:Object):void{
			container = parent;
			if(options.icon){
				try{
					defaults1 = style.getIconStyle(options.icon || {});
					defaults1.over = style.getIconStyle(util.mix(util.copy(options.icon), options.icon && options.icon.over ? options.icon.over : {}));
					defaults1.down = style.getIconStyle(util.mix(util.copy(options.icon), options.icon && options.icon.down ? options.icon.down : {}));
					//defaults1.over.thickness = 2
					if(options.toggledIcon){
						defaults2 = style.getIconStyle(options.toggledIcon || {});
						defaults2.over = style.getIconStyle(util.mix(options.toggledIcon, options.toggledIcon && options.toggledIcon.over ? options.toggledIcon.over : {}));
						defaults2.down = style.getIconStyle(util.mix(options.toggledIcon, options.toggledIcon && options.toggledIcon.down ? options.toggledIcon.down : {}));
					}
					gfx1 = buildIcon(defaults1);
					if(options.toggledIcon){
						gfx2 = buildIcon(defaults2);
						gfx2.show = false;
					}
				}catch(e:Error){ console.error("Icon gfx failed:", e)}
			}else if(options.text || options.textOptions){
				try{
					//trace(options.text ? "TEXT:" : "TEXTOPTIONS:"  + options.text || o.textOptions)
					// NOTE: Don't try and toggle the text. Just change it with "button.text".
					var o:Object = options;
					if(o.textOptions){
						//o.textOptions.text = o.text || o.textOptions.text;
						var c:Object = util.copy(o.textOptions);
						delete o.textOptions
						o = util.mix(c, o);
						//if(o.over){} // no workie. Don't know why, but just change format in button sub class.
					}
					//console.dir(o);
					//tf = gfx1 = new Text(o, container);
				}catch(e:Error){ console.error("Icon Text failed: ("+options.text || o.textOptions+")", e)}
			}
		}

		public function setMouseState(s:String):void{
			var g:Object = state ? gfx2 : gfx1;
			var d:Object = state ? defaults2 : defaults1;
			//console.log("Icon.setMouseState:", state?"main":"toggled", "(", s ,")")
			switch(s){

				case "over": d.over && g.draw(d.over); break;
				case "down": d.down && g.draw(d.down); break;
				case "norm":
				default:
					g.draw(d); break;
			}
		}

		public function setToggleState(s:uint):void{
			state = s;
			//console.log("Icon.setToggleState", state?"main":"toggled");
			if(gfx2){
				gfx1.show = state === 0;
				gfx2.show = state === 1;
			}
		}

		public function set text(s:String):void{
			gfx1.text = s;
		}

		public function get text():String{
			return gfx1.text;
		}

		public function align(vl:String = "center", hz:String = "center"):void{
			gfx1.align && gfx1.align(vl, hz);
			gfx2 && gfx2.align && gfx2.align(vl, hz);
		}

		private function buildIcon(d:Object):*{
			var shp:Object;
			if(d.mc){
				console.error("Icon.mc not supported");
				/*d.mc = settings.getAsset(d.mc);
				d.mc.addParent(container);
				d.mc.width = d.w;
				if(d.h){ d.mc.height = d.h; }
				d.mc.alpha = d.alpha === undefined ? 1 : d.alpha;
				d.mc.align(d.alignV || "center", d.alignH || "center");
				mc = d.mc;
				return d.mc;*/
			}else{
				switch(d.className){
					case "Triangle":	shp = new Triangle(d, container); break;
					case "Bars": 		shp = new Bars(d, container); break;
					case "Rect": 		shp = new Rect(d, container); break;
					case "Circle": 		shp = new Circle(d, container); break;
					case "Fullscreen": 		shp = new Fullscreen(d, container); break;
					case "Volume": 		shp = new Volume(d, container); break;

					case "Close": 		shp = new Close(d, container); break;

					/*
					case "LeftArrow": 	shp = new LeftArrow(d, container); break;
					case "RightArrow": 	shp = new RightArrow(d, container); break;

					case "UpArrow": 	d.type = "up"; 		shp = new Arrow(d, container); break;
					case "DownArrow": 	d.type = "down"; 	shp = new Arrow(d, container); break;

					case "Blank": 		shp = new Blank(d, container); break;*/
				}
				shp.align(d.alignV || "center", d.alignH || "center");
				return shp;
			}

		}
	}
}
