package dx.gfx {

	import dx.common.debugging.console;
	import dx.common.util;
	import dx.gfx.style;
	import dx.gfx.theme;
	import dx.gfx.Container;

	import flash.display.Sprite;
    import flash.text.*;
	import flash.display.BlendMode;
	import flash.text.AntiAliasType;
	import flash.events.Event;

	public class Text extends Container{
		private var textFormat:TextFormat;
		public var ONCHANGE:String = "onchange";
		//private var container:Object;
		public var tf:TextField;
		public function Text(options:Object, parent:Object):void{

			super(options, parent);
			defaults = style.getTxtStyle(options);
			doLayout(defaults)

			try{
				draw();
			}catch(e:Error){ console.error("Error adding text:", e)}
			//addFilter();
		}

		public function once(format:Object = null):void{
			tempFormat(format);
		}

		public function tempFormat(format:Object = null):void{
// NO EL WORKO
			if(format == null){
				//trace("TEMP NULL")
				createFormat();
				setFormat(textFormat);
			}else{
				var f:* = textFormat; //new TextFormat();
				//f = util.mix(f, format);
				//trace("TEMP SET", f)
				for(var nm:String in format){
					//trace("   temp:", nm, format[nm])
					f[nm] = format[nm];
				}
				setTextAndFormat(text, f)
				//setFormat(f);
			}
		}

		public function setTextAndFormat(s:String, format:Object):void{
			// summary:
			//		Use this when changing text AND setting the format.
			//		Stupid formatting won't set without a timeout.
			text = s;
			var f:TextFormat = new TextFormat();
			util.mix(f, format);
			setFormat(f);
			util.setTimeout(function():void{
				setFormat(f);
			}, 100);
			util.setTimeout(function():void{
				setFormat(f);
			}, 200);
			util.setTimeout(function():void{
				setFormat(f);
			}, 500);
		}

		public function set htmlText(s:String):void{
			if(s == tf.htmlText) return;
			s = '<FONT FACE="Arial" SIZE="14">' + s + '</FONT>';
			if(!s){
				tf.text = "";
			}else{
				tf.htmlText = s;
			}
			defaults.text = tf.text;
			onChange();
			// formatting wipes out bold, italic, etc.
		}

		public function set text(s:String):void{
			if(s == tf.text) return;
			if(!s){
				tf.text = "";
			}else if(s.charAt(0)== "<"){
				tf.htmlText = s;
				// fullscreen breaks the clickability of a link *** FIXME
				//console.warn("SET HTML TEXT:", tf.htmlText)
			}else{
				if(s.indexOf("&lt;") == 0) s = s.replace("&lt;", "<");
				tf.text = s;
			}
			defaults.text = tf.text;
			setFormat(textFormat);
			onChange();
		}

		public function setFormat(f:TextFormat):void{
			tf.defaultTextFormat = f;
			tf.setTextFormat(f);

		}

		public function get text():String{
			return tf.text;
		}

		private function createFormat():TextFormat{
			var d:Object = defaults;
			textFormat = new TextFormat();
			textFormat.color = d.color;
			textFormat.font = d.font;
			textFormat.size = d.size;
			textFormat.align = d.align;
			textFormat.italic = d.italic;
			textFormat.bold = d.bold;
			textFormat.underline = d.underline;
			return textFormat;
		}

		public override function draw(... obj):void{
			// to center multiline text:
			//	set width and height first, then autoSize
			//	then multiline/wordWrap
			//	then format with align = center
			// ** multiline must be false to shrink width to text
			// ** autoSize should be "left" else the x-position
			// 		will be based off of center

			var d:Object = defaults;
			var initializing:Boolean = false;
			hasLayout && doLayout(d);
			createFormat();

			if(!tf){
				tf = new TextField();
				initializing = true;
				addChild(tf);
				tf.multiline = d.multiline || false;
				tf.wordWrap = d.wrap || false;
				tf.selectable = d.type == "input" || d.selectable;
				//tf.embedFonts = false;
				//tf.antiAliasType = flash.text.AntiAliasType.ADVANCED
				//tf.defaultTextFormat = textFormat;
				if(d.restrict) tf.restrict = d.restrict;
			}

			//tf.x = d.x;
			//tf.y = d.y;
			tf.width = d.w;
			tf.height = d.h;
			text = d.text;

			tf.embedFonts = d.embedFonts;
		//	tf.blendMode = BlendMode.LAYER; // if we need opacity
			//tf.autoSize = "left";  // make a prop
			//tf.width = 10;//d.w;
			//tf.height = 10;//d.h;

			tf.border = d.border !== undefined ? d.border : theme.textBorder;
			tf.background = d.background !== undefined ? d.background : theme.textBackground;

			if(d.bgColor){
				tf.background = true;
				tf.backgroundColor = d.bgColor;
			}
			if(d.type){
				tf.type = d.type;
			}

			if(d.autoSize){
				tf.autoSize = d.autoSize
			}

			//may not need this? Where do I?
			setFormat(textFormat);


			if(d.parentAlignV != "none"){
				if(d.parentAlignV == "center"){
					tf.y = (container.h - tf.height) / 2;
				}
			}
			if(d.parentAlignH != "none"){
				if(d.parentAlignH == "center"){
					tf.x = (container.w - tf.width) / 2;
				}
			}

			updateFilters();

			if(initializing){
				tf.addEventListener(Event.CHANGE, onChange);
			}
		}

		private function onChange(...a):void{
			dispatchEvent(new Event(ONCHANGE));
		}

		public function align(v:String, h:String):void{
			if(v == "center"){
				y = (container.h - height) / 2;
			}else{
				y = 3;
			}
			if(h == "center"){
				x = (container.w - width) / 2;
			}
		}
/*
		public function set show(vis:Boolean):void{
			visible = vis;
		}

		public function get show():Boolean{
			return visible;
		}*/
	}
}
