package dx.gfx{

	import dx.common.util;
	import dx.common.debugging.console;

	//import dx.gfx.filters.filterHandler;

	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;

	public class Container extends Sprite{

		public var id:String = "Container";
		public var hasLayout:Boolean = false;
		public var defaults:Object = {x:0, y:0, w:0, h:0, thickness:0};
		protected var layouts:Object = {};
		public var container:Object;
		private var layoutProperties:Array = ['x','y','w','h'];
		private var lastStageParams:Object = {
			stageWidth:100,
			stageHeight:100
		};

		public function log():void{
			console.log(id, " x:",x, " y:",y, " d.w:",defaults.w, " d.h:",defaults.h, " w:",w, " h:",h, "visible:",visible," ( width:", width, " height:", height, " scaleX:", scaleX, " scaleY:",scaleY, ") ", defaults, layouts);
			if(container){
				console.log("  parent:", container.id)
			}
		}
		public function debug(...args):void{
			//if(id == "TextEditor" || id == "Editor"  || id == "RichText") console.log.apply(console, args);
			//if(id == "Main") console.log.apply(console, args);
			//if(/ListItem/.test(id)) console.log.apply(console, args);
		}

		public function Container(... options):void{

			if(options[0]){
					if(options[0].id){ // if "id not found on String", then this should be an object
					id = options[0].id;
					//delete options[0].id;
				}else{
					id = util.className(this);
				}

				checkForLayout(options[0]); // layout set here

				x = options[0].x;
				options[0].x = 0;
				y = options[0].y;
				options[0].y = 0;
				updateFilters();
				defaults.w = options[0].w;
				defaults.h = options[0].h;
			}

			if(options[1]){
				container = options[1];
				if(options[0] && options[0].zindex !== undefined){
					container.addChildAt(this, options[0].zindex);
				}else{
					container.addChild(this);
				}
				doLayout(defaults);
			}

		}



		public function set w(_w:Number):void{

			defaults.w = _w;
			debug("set w......", defaults.w);
		}

		public function get stg():Object{
			return stage || lastStageParams;
		}

		public function get w():Number{
			// debug doesn't work here very well.
			// note that this is usually accessed as the parent.
			//
			debug("get w....", id, width, defaults.w, "container:", util.className(container));//, container.w)
			if(util.className(this) == "Player" || id == "Main"){
				return stg.stageWidth;
			}
			if(defaults.w > 0){
				//debug("return defaults.w", defaults.w);
				return defaults.w;
			}
			if(width > 0){
				//debug("return width", width);
				return width;
			}

			if(container && container.w){
				debug("return cont:", container.w);
				return container.w;
			}
			//debug("return stg.");
			return stg.stageWidth;
		}

		public function get h():Number{
			//debug("h....", id)
			if(util.className(this) == "Player" || id == "Main"){
				return stg.stageHeight - 0;
			}
			if(defaults.h > 0){ return defaults.h;}
			if(height > 0) return height;
			if(container && container.h) return container.h;
			return stg.stageHeight;
		}

		public function set show(vis:Boolean):void{
			visible = vis;
		}

		public function get show():Boolean{
			return visible;
		}

		public function draw(... obj):void{
			//debug("Stage Resize!!");
			doLayout(defaults);
			//updateFilters();
		}

		protected function doLayout(d:Object):void{
			d = defaults;
			debug("doLayout", id, "layouts:", layouts, "defaults:", d);
			debug("container:", util.className(container), container.w, container.h)
			try{
				var nm:String,
					p:Number,
					b:Number = 0,//container.defaults.thickness !== undefined ? container.defaults.thickness-2 : 0,
					ww:* = container.w - b,// - container.x,  //stg.stageWidth - container.x,
					hh:* = container.h - b,// - container.y,  //stg.stageHeight - container.y;
					nam:*, val:*;
				layoutProperties.forEach(function(nm:String, i:uint, ar:Array):void{
					//debug("    nm:", nm, "has layout:", layouts[nm])
					nam = nm; val = layouts[nm]
					if(typeof(layouts[nm]) != "string") return;

					if(nm == "y"){

						p = parseInt(layouts.y.split("%")[0], 10) * .01;

						y = (hh * p) - (d.h || 0) * p;
						if(layouts.y.split("%")[1]){
							y += parseFloat(layouts.y.split("%")[1]);
						}
						debug("   ---> Y", y, defaults.h, hh, "::", h, p);

					}else if(nm == "x"){
						p = parseInt(layouts.x.split("%")[0], 10) * .01;
						x = (ww * p) - (d.w || 0) * p; // Subtracting the item width does not always seem to work. See VolumeSlider
						debug("   X.1:", x)
						if(layouts.x.split("%")[1]){
							x += parseFloat(layouts.x.split("%")[1]);
						}
						debug("   X.2: ", x, layouts.x, defaults.w, ww, "added:", parseFloat(layouts.x.split("%")[1]));

					}else if(nm == "w"){
						p = parseInt(layouts.w.split("%")[0], 10) * .01;
						//debug("   p", p)
						//debug("   x", x)
						if(isNaN(ww)){
							console.error("NaN in", id);
							console.warn(d.w, container.w, d, "Parent:", container.id, container.defaults)
						}
						d.w = ww * p;
						d.w -= x;
						if(layouts.w.split("%")[1]){
							d.w += parseFloat(layouts.w.split("%")[1]);
						}
						if(layouts.w == "100%" && d.w > stg.stageWidth) d.w = stg.stageWidth;
						defaults.w = d.w;
						mixWidth(d);
						debug("   ww:", d.w, ww, w)

					}else if(nm == "h"){
						p = parseInt(layouts.h.split("%")[0], 10) * .01;
						d.h = hh * p;
						d.h -= y;
						if(layouts.h.split("%")[1]){
							d.h += parseFloat(layouts.h.split("%")[1]);
						}

						defaults.h = d.h;
						mixHeight(d);
						//debug("   hh:", hh, "d.h", d.h, "h:", h)
					}

				});

			}catch(e:Error){
				console.error("Container.doLayout:", e, nam, val, defaults, "stg:::", stg);
				//console.dir(defaults);
				//console.dir(layouts);
			}

		}

		protected function checkForLayout(o:Object):void{
			//debug(".....................................\n\ncheckForLayout:", id, o)
			layoutProperties.forEach(function(prop:String, i:uint, ar:Array):void{
				if(typeof(o[prop]) == "string"){
					layouts[prop] = o[prop];
					hasLayout = true;
				}
			});

			if(hasLayout){
				util.sub("stage_resize", function(obj:Object):void{
					//console.debug("    resize:", id)
					//console.log("resize. stg:", stg);
					lastStageParams = obj;
					draw(); // we don't want 'obj' passed
				});
			}

		}

		protected function mix(m:Object, s:Object, option:String = ""):Object{
			// gratuitous shortcut
			if(option == "copy"){
				m = util.copy(m);
			}
			var includeUndef:Boolean = option == "undef";
			return util.mix(m,s,includeUndef);
		}

		protected function mixCoords(o:Object):Object{
			return mixXY(mixSize(o));
		}

		protected function mixXY(o:Object):Object{
			return mixY(mixX(o));
		}

		protected function mixY(o:Object):Object{
			return o.y = defaults.y;
		}

		protected function mixX(o:Object):Object{
			return o.x = defaults.x;
		}

		protected function mixSize(o:Object):Object{
			return mixHeight(mixWidth(o));
		}

		protected function mixWidth(o:Object):Object{
			o.w = defaults.w;
			if(o.bgGrad) o.bgGrad.w = defaults.w;
			if(o.lnGrad) o.lnGrad.w = defaults.w;
			return o;
		}

		protected function mixHeight(o:Object):Object{
			o.h = defaults.h;
			if(o.bgGrad) o.bgGrad.h = defaults.h;
			if(o.lnGrad) o.lnGrad.h = defaults.h;
			return o;
		}



		protected function updateFilters():void{
			//filterHandler.updateFilters(defaults, this);
		}

		public function addFilter(options:Object):void{
			//filterHandler.addFilter(options, defaults, this);
		}

		public function destroy():void{
			//disconnect();
			container.removeChild(this);
		}


	}
}
