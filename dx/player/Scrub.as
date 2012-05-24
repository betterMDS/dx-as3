package dx.player{

	import dx.common.debugging.console;
	import dx.common.util;

	import dx.gfx.Container;
	import dx.gfx.shapes.Circle;
	import dx.gfx.theme;

	import flash.events.MouseEvent;
	import flash.events.Event;

	public class Scrub extends Container{

		private var handle:Circle;
		private var callback:*;
		private var scrubBeg:Number;
		private var scrubEnd:Number;
		private var dragging:Boolean = false;
		private var verticalDrag:Boolean = false;
		private var distance:Number;

		public var percent:Number = 0;
		public var ONOVER:String = "onover";
		public var ONDOWN:String = "ondown";
		public var ONUP:String = "onup";
		public var ONOUT:String = "onout";
		public var ONDRAGSTART:String = "ondragstart";
		public var ONDRAGEND:String = "ondragend";
		public var ONDRAG:String = "ondrag";

		public function Scrub(parent:Object):void{
			super(theme.play, parent);

			handle = new Circle(theme.controls.progressBar.scrub, this);
		}

		public function setDragHorz(options:Object):void{
			if(!options.dist) console.error("dist property not provided for drag");
			for(var nm:String in options){
				switch(nm){
					case "x": x = options[nm]; break;
					case "y": y = options[nm]; break;
					case "callback": callback = options[nm]; break;
				}
			}

			scrubBeg = x;
			scrubEnd = x + options.dist;
			distance = options.dist;
			connect();

		}

		public function setPercent(p:Number):void{
			if(dragging) return;
			var dist:Number = (scrubEnd-scrubBeg);
			if(verticalDrag){
				y = scrubBeg + distance * p;
			}else{
				x = scrubBeg + distance * p;
			}
		}

		private function onMove(o:Object):void{
			if(!dragging) return;
			if(verticalDrag){
				y += o.moveY;
				if(y < scrubBeg) y = scrubBeg;
				if(y > scrubEnd) y = scrubEnd;
				percent = 1 - ((distance - (y-scrubBeg)) / distance);
			}else{
				x += o.moveX;
				if(x < scrubBeg) x = scrubBeg;
				if(x > scrubEnd) x = scrubEnd;
				//console.log("onMove", o.moveX, x, distance, scrubBeg)
				percent = 1 - ((distance - (x-scrubBeg)) / distance);
			}
			//dispatchEvent(new Event(ONDRAG));
			//console.log("onMove", percent)
			if(!!callback) callback(percent);

		}

		private function onStartDrag(...a):void{
			console.log("onStartDrag");
			dragging = true;
			//startDrag(false);
			dispatchEvent(new Event(ONDRAGSTART));
		}

		private function onEndDrag(...a):void{
			console.log("onEndDrag");
			dragging = false;
			//stopDrag();
			dispatchEvent(new Event(ONDRAGEND));
		}

		private function connect():void{
			addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
			addEventListener(MouseEvent.MOUSE_UP, onEndDrag);
			util.sub("stage_mouseup", onEndDrag);
			util.sub("stage_mousemove", onMove);
		}
	}
}
