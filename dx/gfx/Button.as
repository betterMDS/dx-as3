package dx.gfx{

	import dx.common.debugging.console;
	import dx.common.util;

	import dx.gfx.Icon;
	import dx.gfx.shapes.Rect;
	import dx.gfx.Container;
	import dx.gfx.style;

	import flash.events.MouseEvent;
	import flash.events.Event;

	public class Button extends Container {

		private var pressCallbacks:Array = [];
		private var unpressCallbacks:Array = [];
		private var pressHandle:int;
		public var toggles:Boolean = false;
		public var _state:uint = 0;
		public var objectType:String = "Button";

		private var scrubBeg:Number;
		private var scrubEnd:Number;
		private var dragging:Boolean = false;
		private var verticalDrag:Boolean = false;
		public var percent:Number = 0;

		public var over:Object;
		public var down:Object;
		public var norm:Object;
		public var dsbd:Object;
		public var slct:Object;

		protected var btnBase:Object;

		public var btnDefaults:Object;
		public var _selected:Boolean = false;
		// Connect to these, else enabled=false will still fire
		public var ONCLICK:String = "onclick";
		public var ONOVER:String = "onover";
		public var ONDOWN:String = "ondown";
		public var ONUP:String = "onup";
		public var ONOUT:String = "onout";
		public var ONDRAGSTART:String = "ondragstart";
		public var ONDRAGEND:String = "ondragend";
		public var ONDRAG:String = "ondrag";
		public var icon:Icon;

		// disabled:
		// Not actually a getter/setter
		// if options.disabled, button is not rendered.
		public var disabled:Boolean = false;

		// enabled:
		// Different from disabled. If false, button
		// is rendered, but not clickable and styled
		// differently.
		public var _enabled:Boolean = true;

		public function Button(options:Object, _parent:Object):void{
			//
			// hmmmm... doesnt use super()
			//
			if(options.disabled) return;
			id = options.id || "Button";
			container = _parent;
			container.addChild(this);

			checkForLayout(options);

			x = options.x || 0;
			y = options.y || 0;
			options.x = 0; options.y = 0;

			try{

				// lotta mixes - but only 3ms
				over = style.getOverStyle(options);
				down = style.getDownStyle(options);
				dsbd = style.getDisabledStyle(options);
				slct = style.getSelectedStyle(options);
				defaults = style.getGfxStyle(options, true);

				btnDefaults = style.getButtonStyle(options);

			}catch(e:Error){ console.error("Btn.defaults failed", e); }

			draw(defaults);
			mouseChildren = false; // allows pointer over text
			connect();

			enabled  = defaults.enabled !== undefined ? defaults.enabled : true;
			selected = defaults.selected !== undefined ? defaults.selected : false;

		}

		public function draggable(dist:Number, vert:Boolean = false):void{
			cacheAsBitmap = true;
			verticalDrag = vert;
			scrubBeg = vert ? y : x;
			scrubEnd = vert ? y + dist : x + dist;
			addEventListener(ONDOWN, onStartDrag);
			addEventListener(ONUP, onEndDrag);
			util.sub("stage_mouseup", onEndDrag);
			util.sub("stage_mousemove", onMove);
		}

		private function onStartDrag(...a):void{
			dragging = true;
			dispatchEvent(new Event(ONDRAGSTART));
		}
		private function onEndDrag(...a):void{
			dragging = false;
			dispatchEvent(new Event(ONDRAGEND));
		}
		private function onMove(o:Object):void{
			if(!dragging) return;
			var dist:Number = (scrubEnd-scrubBeg);
			dispatchEvent(new Event(ONDRAGEND));
			if(verticalDrag){
				y += o.moveY;
				if(y < scrubBeg) y = scrubBeg;
				if(y > scrubEnd) y = scrubEnd;
				percent = 1 - ((dist - (y-scrubBeg)) / dist);
			}else{
				x += o.moveX;
				if(x < scrubBeg) x = scrubBeg;
				if(x > scrubEnd) x = scrubEnd;
				percent = 1 - ((dist - (x-scrubBeg)) / dist);
			}
			dispatchEvent(new Event(ONDRAG));
		}

		override public function set show(vis:Boolean):void{
			visible = vis;
			if(!vis) _onRelease();
		}

		override public function get show():Boolean{
			return visible;
		}

		private function _onPress(...a):void{
			if(!pressCallbacks.length) return;
			pressHandle = util.setInterval(function():void{
				for(var i:int=0;i<pressCallbacks.length;i++){
					pressCallbacks[i]();
				}
			}, 30);
		}

		private function _onRelease(...a):void{
			util.clearInterval(pressHandle);
			if(!unpressCallbacks.length) return;
			for(var i:int=0;i<unpressCallbacks.length;i++){
				unpressCallbacks[i]();
			}
		}

		public function onButtonPress(o:Object):void{
			pressCallbacks.push(o.press);
			if(o.unpress) unpressCallbacks.push(o.unpress);
		}


		public function connect():void{
			buttonMode = true;


			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			addEventListener(MouseEvent.MOUSE_DOWN, _onPress);
			addEventListener(MouseEvent.MOUSE_UP, _onRelease);
			addEventListener(MouseEvent.MOUSE_UP, onOver);
			addEventListener(MouseEvent.MOUSE_UP, onUp);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		private function disconnect():void{
			buttonMode = false;

			removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			removeEventListener(MouseEvent.MOUSE_UP, onOver);
			removeEventListener(MouseEvent.MOUSE_UP, onUp);
			removeEventListener(MouseEvent.CLICK, onClick);
			removeEventListener(MouseEvent.MOUSE_DOWN, _onPress);
			removeEventListener(MouseEvent.MOUSE_UP, _onRelease);
		}

		public function set toggled(sel:Boolean):void{
			_selected = sel;
			if(sel){
				draw(slct);
			}else{
				draw(defaults);
			}
		}

		public function get toggled():Boolean{
			return _selected;
		}

		public function set selected(sel:Boolean):void{
			if(_selected == sel) return;
			_selected = sel;
			if(sel){
				draw(slct);
				disconnect();
			}else{
				draw(defaults);
				connect();
			}
		}

		public function get selected():Boolean{
			return _selected;
		}

		public function set enabled(en:Boolean):void{
			if(en == _enabled) return;

			_enabled = en;

			if(en){
				draw(defaults);
				icon.tf.defaults.color = icon.tf.defaults.norm.color;
				connect();
			}else{
				draw(dsbd);
				icon.tf.defaults.color = icon.tf.defaults.dsbd.color;
				disconnect();
			}
			icon.tf.draw();
		}

		public function get enabled():Boolean{
			return _enabled;
		}

		protected function set state(s:uint):void{
			if(_state === s) return;
			_state = s===1 ? 1 : 0;
			//console.log("Button.icon.setToggleState", _state)
			icon.setToggleState(_state);
		}

		protected function get state():uint{
			return _state;
		}

		public function onUp(evt:Object):void{
			dispatchEvent(new Event(ONUP));
		}

		public function onOver(evt:Object):void{
			draw(this.mixSize(over));
			icon.setMouseState("over");
			dispatchEvent(new Event(ONOVER));
		}

		public function onDown(evt:Object):void{
			draw(this.mixSize(down));
			icon.setMouseState("down");
			dispatchEvent(new Event(ONDOWN));
		}

		public function onOut(evt:Object):void{
			if(toggled){
				draw(this.mixSize(slct));
			}else{
				draw(defaults);
			}
			icon.setMouseState("norm");
			dispatchEvent(new Event(ONOUT));
		}

		public function onClick(evt:Object):void{

			dispatchEvent(new Event(ONCLICK));
			console.log("Button.clicked")
		}

		override public function draw(... obj):void{
			var d:Object = obj[0] || defaults;

			if(!btnBase){
				// not built yet
				hasLayout && doLayout(defaults);
				btnBase = new Rect(defaults, this);
				icon = new Icon(btnDefaults, this);
				//icon.setMouseState("norm"); // some did not draw without this
			}else{
				hasLayout && doLayout(d);
				btnBase.draw(d);
				if(icon) icon.align("center","center");//d.alignV, d.alignH);
			}
		}

		private function toggle():void{
			state = state === 0 ? 1 : 0;
		}

		public function set text(s:String):void{
			icon.text = s;
		}

		public function get text():String{
			return icon.text;
		}
	}
}
