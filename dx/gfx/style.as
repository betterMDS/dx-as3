package dx.gfx{

	import dx.common.util;
	import dx.common.debugging.console;

	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.filters.BitmapFilterQuality;
    import flash.filters.BitmapFilterType;


	import flash.utils.getQualifiedClassName;

	public class style{
		public static function init(type:String = "default"):void{
			switch(type){
				case "steel": DEFAULTS = STEEL; break;
			}

		}

		public static var DEFAULTS:Object = {
			name:"default style",
			A:0x999999, // primary (lighter, top)
			B:0x333333, // secondary (darker, bottom)
			C:0x000000, // primary Line Grad (darker)
			D:0xCCCCCC, // secondary Line Grad (lighter)
			E:0xc6d5db,	// over primary (down secondary)
			F:0x5e6a74,	// over secondary (down primary)
			G:0xFFFFFF, // icon primary
			H:0x8cd3fa, // icon secondary
			H:0x098dd7, // icon secondary hover

			TEXT:0xb3e1f3, // status and dur
			BTNTEXT:0xFF0000,
			DISABLED:0xCCCCCC,
			SELECTED:0xFFFF00,
			BACK:0x333333
		};

		public static var STEEL:Object = {
			name:"steel style",
			A:0xb1b1b1, // primary
			B:0x2a2a2a, // secondary
			C:0x202020, // primary Line Grad (darker)
			D:0xa8a8a8, // secondary Line Grad (lighter)
			E:0x8d9bb0,	// over primary (down secondary)
			F:0x202020,	// over secondary (down primary)
			G:0xdce8f0, // icon primary (not used?)
			H:0x8c9aa7, // icon secondary (not used?)

			TEXT:0xb3e1f3, // status and dur
			BTNTEXT:0xFFFFFF,
			DISABLED:0xCCCCCC,
			SELECTED:0xFFFF00,
			BACK:0x000000
		};

		public static var LTBLUE:Object = {
			name:"light blue style",
			A:0xdce2e6, // primary
			B:0xbac4cc, // secondary
			C:0x202020, // primary Line Grad (darker)
			D:0xa8a8a8, // secondary Line Grad (lighter)
			E:0x8d9bb0,	// over primary (down secondary)
			F:0x202020,	// over secondary (down primary)
			G:0xdce8f0, // icon primary (not used?)
			H:0x8c9aa7, // icon secondary (not used?)

			TEXT:0x236596, // status and dur
			BTNTEXT:0x236596,
			DISABLED:0xCCCCCC,
			SELECTED:0xFFFF00,
			BACK:0x000000
		};

		public static var iconLine:Object = {
			thickness:2,
			color:0xFFFFFF,
			bgColor:0xFFFF00,
			bgGrad:{}
		};

		public static function getIconLine(options:Object, includeUndef:Boolean = false):Object{
			var d:Object = util.mix(util.copy(iconLine), options, includeUndef);
			return d;
		}

		public static function getGfxStyle(options:Object, includeUndef:Boolean = false):Object{
			var d:Object = util.mix(util.copy(gfxDefaults), options, includeUndef);

			if(!!options.filter) d.filter = options.filter;

			if(d.alpha < 1){
				d.bgGrad.alphas = d.bgGrad.alphas.map(function(a:Number, i:uint, ar:Array):Number{
					return d.alpha;
				});
			}

			d.bgGrad.w = d.lnGrad.w = d.w;
			d.bgGrad.h = d.lnGrad.h = d.h;

			return d;
		}

		public static function get gfxDefaults():Object{
			return {
				bgColor:false,
				w:100,
				h:100,
				x:0,
				y:0,
				r:0,
				alpha:1,
				// only used if bgColor = false
				bgGrad: {
					colors:[DEFAULTS.A, DEFAULTS.B],
					alphas:[1,1],
					ratios:[0,255],
					rotation:90,
					fillType:  GradientType.LINEAR,
					matrix:null,
					spreadMethod:  SpreadMethod.PAD,
					w:  100,
					h:  100
				},
				thickness:1,
				color:false,
				lineColor:false,
				lineAlpha:1.0,
				pixelHinting:false,
				scaleMode:"normal",
				//caps:null,
				//joints:String,
				miterLimit:3,
				strokePlacement:"inside", // inside outside center
				// only used if color = false
				lnGrad: {
					colors:  [DEFAULTS.C, DEFAULTS.D],
					fillType:  GradientType.LINEAR,
					alphas:  [1,1],
					ratios:  [0,255],
					//matrix:null,
					rotation:  45,
					spreadMethod:  SpreadMethod.PAD,
					w:  100,
					h:  100
				}
			}
		}

		public static function _getStateStyle(obj:Object, options:Object, state:String):Object{
			obj = getGfxStyle(obj); // hmmm.... doesn't need to be done more than once
			//console.log(" mixing state", state, options[state])
			obj = util.mix(obj, options);
			obj = util.mix(obj, options[state] || {}, true);

			obj.w = obj.bgGrad.w = obj.lnGrad.w = options.w || obj.w;
			obj.h = obj.bgGrad.h = obj.lnGrad.h = options.h || obj.h;
			return obj;
		}

		public static function getOverStyle(options:Object):Object{
			return _getStateStyle(overDefaults, options, "over");
		}

		public static function get overDefaults():Object{
			return {
				bgColor:false,
				bgGrad:{
					colors:[DEFAULTS.E, DEFAULTS.F],
					alphas:[1,1],
					ratios:[0,255],
					rotation:90
				}
			};
		};

		public static function getDownStyle(options:Object):Object{
			return _getStateStyle(downDefaults, options, "down");
		}

		public static function getDisabledStyle(options:Object):Object{
			return _getStateStyle(disabledDefaults, options, "dsbd");
		}
		public static function getSelectedStyle(options:Object):Object{
			return _getStateStyle(selectedDefaults, options, "slct");
		}

		public static function get downDefaults():Object{
			return {
				bgColor:false,
				bgGrad:{
					colors:[DEFAULTS.F, DEFAULTS.E],
					alphas:[1,1],
					ratios:[0,255],
					rotation:90
				}
			};
		};

		public static function get selectedDefaults():Object{
			return {
				bgColor:false,
				bgGrad:{
					colors:[DEFAULTS.F, DEFAULTS.E],
					alphas:[1,1],
					ratios:[0,255],
					rotation:90
				}
			};
		};


		public static var disabledDefaults:Object = {
			bgColor:DEFAULTS.DISABLED
		};


		public static function getIconStyle(options:Object):Object{
			var obj:Object = {};
			if(!!options.mc && !options.text) {
				var mc:* = options.mc;
				delete options.mc;
				obj = util.mix(util.copy(iconDefaults), options, true);
				obj.mc = mc
				return obj;
			}
			obj = style.getGfxStyle(util.copy(style.iconDefaults), true);
			return util.mix(obj, options, true);
		}

		public static var iconDefaults:Object = {
			w:30,
			h:30,
			r:0,
			bars:2,
			gap:5,
			alignV:"center",
			alignH:"center",

			bgColor:false,
			thickness:0,
			bgGrad:{
				colors:[DEFAULTS.G, DEFAULTS.H],
				alphas:[1,1],
				ratios:[0,255],
				rotation:90
			},
			over:{
				bgGrad:{
					colors:[DEFAULTS.G, DEFAULTS.I]
				}
			},
			down:{
				bgGrad:{
					colors:[DEFAULTS.I, DEFAULTS.G]
				}
			}
		}

		public static function getButtonStyle(options:Object):Object{
			//trace("GET BUTTON STYLE:", DEFAULTS.name)
			var d:Object = util.mix(util.copy(style.btnDefaults), options);
			d.w = options.w;
			d.h = options.h;
			return d;
		}

		public static function get btnDefaults():Object { // seems more of a layout and content type object
			return {
				icon:false,
				toggledIcon:false,
				textOptions:{
					verticalAlign:"center",
					parentAlignV:"center",
					parentAlignH:"center",
					color:DEFAULTS.BTNTEXT,
					align:"center",
					text:"The Button"
				}
			};
		}



		public static function getFilterStyle(obj:Object, options:Object):Object{
			var d:Object = util.mix(util.copy(obj), options);
			return d;
		}

		public static var filterDefaults:Object = {
			bevel:{
				distance       : 5,
				angle		   : 45,
				highlightColor : 0xFFFFFF,
				highlightAlpha : 0.8,
				shadowColor    : 0x000000,
				shadowAlpha    : 0.8,
				blurX          : 5,
				blurY          : 5,
				strength       : 5,
				quality        : BitmapFilterQuality.HIGH,
				type           : BitmapFilterType.INNER,
				knockout       : false
			},
			blur:{
				blurX:5,
				blurY:5
			},
			shadow:{
				blurX:5,
				blurY:5,
				alpha:.9,
				angle:45,
				color:0x000000,
				distance:5,
				hideObject:false,
				inner:false,
				knockout:false,
				quality: BitmapFilterQuality.HIGH,
				strength:1

			}
		}

		public static function getTxtStyle(options:Object):Object{
			var obj:Object = style.txtDefaults;
			var d:Object = util.mix(util.copy(obj), options, true);
			return d;
		}

		public static var txtDefaults:Object = {
			x:0,
			y:0,
			w:200,
			h:30,
			align:"left",
			verticalAlign:"top",
			text:"default text",
			color: 0x000000,
			font: "Arial",
			size: 14,
			bold:false,
			italic:false,
			multiline:false,
			wrap:false,
			parentAlignV:"none",
			parentAlignH:"none",
			norm:{
				color:0x000000
			},
			dsbd:{
				color:0x666666
			}
			/*,
			filters:{
				blur:{},
				bevel:{}
			}*/
		};
	}
}
