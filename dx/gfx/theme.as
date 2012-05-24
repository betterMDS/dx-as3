package dx.gfx{

	import dx.common.debugging.console;
	import dx.common.util;
	import dx.gfx.style;

	public class theme{

		// for debuggin:
		public static var textBorder:Boolean = false;
		public static var textBackground:Boolean = false;

		public static var DEFAULTS:Object = style.DEFAULTS;

		private static var _controlButtonDefault:Object = {
			y:5,
			w:24,
			h:24,
			r:4,
			bgColor:0xffffff,
			thickness:0,
			alpha:0,
			over:{
				alpha:.1
			},
			icon:{
				className:"Bars",
				w:12,
				h:12,
				bgGrad:{
					colors:[0xFFFFFF, 0x00c6ff]
				},
				over:{
					bgGrad:{
						colors:[0xFFFFFF, 0x098dd7]
					}
				},
				down:{
					bgGrad:{
						colors:[0x098dd7, 0xFFFFFF]
					}
				}
			}
		};





		public static var _playerBack:Object = {
			id:"PlayerBack",
			x:0,
			y:0,
			w:"100%",
			h:"100%",
			bgColor:DEFAULTS.BACK, // this color won't work, but does in prefs - why??
			thickness:0
		};
		public static function set playerBack(o:Object):void{ util.mix(_playerBack, o); }
		public static function get playerBack():Object{ return _playerBack; }

		public static var _closeButton:Object = {
			id:"CloseButton",
			x:"100%-10",
			y:10,
			w:24,
			h:24,
			r:0,
			extras:true,
			color:0x000000,
			thickness:2,
			icon:{
				className:"Close",
				w:16,
				h:16,
				gap:2,
				thickness:1,
				color:0xCCCCCC,
				//lineAlpha:.2,
				bgColor:false,
				bgGrad:{
					none:true
				}
			}
		};
		public static function set closeButton(o:Object):void{ util.mix(_closeButton, o); }
		public static function get closeButton():Object{ return util.copy(_closeButton); }

		public static var _fullscreen:Object = {
			id:"FullscreenIcon",
			x:"100%-10",
			y:10,
			w:24,
			h:24,
			r:0,
			extras:true,
			color:0x000000,
			thickness:1,
			icon:{
				className:"Fullscreen",
				w:16,
				h:16,
				gap:2,
				thickness:1,
				color:0xCCCCCC,
				lineAlpha:.2,
				bgColor:false,
				bgGrad:{
					none:true
				}
			}/*,
			toggledIcon:{
				className:"Fullscreen",
				w:16,
				h:16,
				gap:2,
				thickness:1,
				color:0xFF0000,
				lineAlpha:.2,
				bgColor:false,
				bgGrad:{
					none:true
				}
			}*/
		};
		public static function set fullscreen(o:Object):void{ util.mix(_fullscreen, o); }
		public static function get fullscreen():Object{ return util.copy(_fullscreen); }
		public static function get controlsFullscreen():Object{
			var o:Object = util.mix(util.copy(_controlButtonDefault), _fullscreen);
			o.x = _volume.x + 30;
			o.y = _volume.y;
			o.thickness = 0;
			return o;
		}

		public static var _volume:Object = {
			id:"Volume",
			x:220,
			y:6,
			icon:{
				className:"Volume",
				w:20,
				h:16,
				gap:2,
				extras:true,
				thickness:1,
				color:0xCCCCCC,
				lineAlpha:.2,
				bgColor:false,
				bgGrad:{
					none:true
				}
			},
			toggledIcon:{
				className:"Volume",
				w:20,
				h:16,
				gap:2,
				extras:true,
				thickness:1,
				color:0xFF0000,
				lineAlpha:.2,
				bgColor:false,
				bgGrad:{
					none:true
				}
			}
		};
		public static function set volume(o:Object):void{ util.mix(_volume, o); }
		public static function get volume():Object{ return util.mix(util.copy(_controlButtonDefault), _volume); }



		public static var _play:Object = {
			id:"Play",
			x:5,
			toggledIcon:{
				className:"Bars",
				w:12,
				h:12,
				gap:2,
				bgGrad:{
					colors:[0xFFFFFF, 0x00c6ff]
				},
				over:{
					bgGrad:{
						colors:[0xFFFFFF, 0x098dd7]
					}
				},
				down:{
					bgGrad:{
						colors:[0x098dd7, 0xFFFFFF]
					}
				}
			},
			icon:{
				className:"Triangle", w:12, h:12
			}
		};
		public static function set play(o:Object):void{ util.mix(_play, o); }
		public static function get play():Object{ return util.mix(util.copy(_controlButtonDefault), _play); }


		public static var _controls:Object = {
			id:"Controls",
			x:-2,
			y:"100%",
			w:"100%",
			h:33,
			statusTime:{
				w:60,
				h:14,
				y:11,
				size:9,
				color:DEFAULTS.TEXT,
				align:"left",
				text:"00:00",
				timeFormat:"mm_ss"
			},
			back:{
				id:"ControlsBack",
				x:1,
				y:0,
				w:"100%+2",
				h:"100%",
				r:0,
				thickness:1,
				color:0xFFFFFF,
				bgColor:0x000000,
				alpha:.5
			},
			progressBar:{
				x:49,
				y:5,
				w:"100%-90",
				h:14,
				back:{
					id:"Progress.Back",
					x:0,
					y:0,
					h:"100%",
					w:"100%",
					r:0,
					bgColor:false,
					bgGrad: {
						colors:[0x000000, 0x000000],
						alphas:[.15,0],
						ratios:[0,255]
					},
					thickness:1
				},
				progress:{
					id:"Progress.Progress",
					x:75,
					y:14,
					h:7,
					w:100,
					r:3,
					bgColor:0xEEEEEE,
					thickness:0,
					downloaded:{
						bgColor:0x7b969d
					},
					position:{
						bgColor:0x068bd6
					}
				},
				scrub:util.copy(style.iconDefaults),
				scrubX:{
					id:"Progress.Scrub",
					h:14,
					w:14,
					thickness:0,
					bgColor:0xFF0000,
					alpha:0,
					icon:{
						className:"Circle",
						w:14,
						h:14,
						gap:0
					}
				},
				button:{
					id:"Progress.Button",
					x:0,
					y:0,
					h:"100%",
					w:"100%",
					alpha:0,
					r:0,
					bgColor:0xFFFFFF,
					thickness:0,
					color:0xffff00
				}
			}
		};
		public static function set controls(o:Object):void{ util.mix(_controls,o); }
		public static function get controls():Object{
			 //_controls.progressBar.scrub = util.mix(util.copy(_controlButtonDefault), _controls.progressBar.scrub);
			 _controls.progressBar.scrub.w = 14;
			 _controls.progressBar.scrub.h = 14;
			 return _controls;
		};


	}
}
