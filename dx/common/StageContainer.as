package dx.common{
	import dx.common.debugging.console;
	import dx.common.util;
	import dx.common.ei;

	import flash.events.EventDispatcher;
	import flash.events.*;
	import flash.events.KeyboardEvent;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	public class StageContainer extends Sprite{ // extend Stage?

		public var id:String = "StageContainer";
		public var isOver:Boolean = false;
		private var hasBeenOver:Boolean = false;
		private var isFullScreen: Boolean = false;
		private var isMouseDown: Boolean = false;
		private var container:Object;
		private var oHandle:uint;
		private var lastX:int = -99999;
		private var lastY:int = -99999;
		private var startX:int = 0;
		private var startY:int = 0;
		private var doubleClickHandler:Boolean;
		private var cursorMC:Object;

		private var cursorMap:Object = {
			left:"PointerLeft",
			right:"PointerRight"
		};

		private var cursorLeft:Object;
		private var cursorRight:Object;
		private var cursorCurrent:Object;
		private var cursorCurrentType:String = "";
		private var cursorConnected:Boolean = false;

		public function StageContainer(parent:Object):void{

			container = parent;
			container.addChild(this);

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			stage.addEventListener(Event.RESIZE, onStageResize);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN , onFullscreenChange);
			stage.addEventListener(MouseEvent.CLICK, onClick);

			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);

			// These do not work:::::
			//stage.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll);
			//stage.doubleClickEnabled = true;
			//stage.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);


			// connected via JavaScript
			if(ei.available){
				ei.add("onScroll",  function(amount:int, horizontal:Boolean = false):void{
					if(isOver) util.pub("stage_scroll", {amount:amount, horizontal:horizontal});
				});
			}

			// onMove fires on swf load for some reason. Timeout prevents that.
			util.setTimeout(function():void{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			}, 100);
			//stage.addEventListener(MouseEvent.MOUSE_OVER, onOver, false);
			//stage.addEventListener(MouseEvent.MOUSE_OUT, onOut, false);

			stage.addEventListener(MouseEvent.MOUSE_OVER, onOver, true, 1000);
			stage.addEventListener(MouseEvent.MOUSE_OUT, onOut, true, 1000);

			stage.addEventListener(KeyboardEvent.KEY_UP, function(evt:KeyboardEvent):void{
				util.pub("stage_key", evt);
			});


			util.sub("stage_fullscreen", toggleFullScreen );

		}

		private function toggleFullScreen(...a):void{
            switch(stage.displayState) {
                case "normal":
                    stage.displayState = "fullScreen";
                    break;
                case "fullScreen":
                default:
                    stage.displayState = "normal";
                    break;
            }
			util.pub("action", {
				type:"fullscreen",
				value:"social",
				state:stage.displayState
			});
        }

		public function onStageResize(evt:Event):void{
			// Not able to log events, but can toString() them
			// to see properties
			util.pub("stage_resize", getStageEvent());
		}

		public function poke(callback:Function):void{
			callback(getStageEvent());
		}

		public function getStageEvent():Object{
			var o:Object;
			try{

				//console.warn("onStageResize::::::::::::", stage.stageWidth + " x " + stage.stageHeight)
				o = {
					videoWidth:stage.stageWidth,
					videoHeight:stage.stageHeight,
					width:stage.stageWidth,
					stageWidth:stage.stageWidth,
					stageHeight:stage.stageHeight,
					height:stage.stageHeight,
					state:stage.displayState,
					cmd: "onFullscreen",
					channel: "/swf/on/fullscreen",
					state:stage.displayState
				};

			}catch(e:Error){ console.error("onStageResize failed", e); }

			return o;
		}

		public function onFullscreenChange(evt:Event):void{
			//console.log("onFullscreenChange::::::::::::", evt.toString())
			//isFullscreen = evt.fullScreen;
		}

		private function onScroll(evt:MouseEvent):void{
			console.log("scroll")
			console.safe(evt);
		}

		private function onMove(evt:MouseEvent):void{
			if(!hasBeenOver){
				hasBeenOver = true;
				isOver = true;
				util.pub("stage_mouseover", getParams());
			}
			util.pub("stage_mousemove", getParams());
		}
		private function onDown(evt:MouseEvent):void{
			isMouseDown = true;
			startX = stage.mouseX;
			startY = stage.mouseY;
			util.pub("stage_mousedown", getParams());
		}
		private function onUp(evt:MouseEvent):void{
			console.info('swf.stage.mouseup')
			isMouseDown = false;
			util.pub("stage_mouseup", getParams());
		}
		private function onOver(evt:MouseEvent):void{
			util.clearTimeout(oHandle);
			if(!isOver){
				isOver = true;
				util.pub("stage_mouseover", getParams());
			}
		}
		private function onOut(evt:MouseEvent):void{
			oHandle = util.setTimeout(function():void{
				isOver = false;
				util.pub("stage_mouseout", getParams());
			},500);
		}

		private function onClick(evt:MouseEvent):void{
			console.info('swf.stage.click')
			if(doubleClickHandler){
				onDoubleClick(evt);
			}
			doubleClickHandler = true;
			util.setTimeout(function():void{
				doubleClickHandler = false;
			}, 400);
			util.pub("stage_click", getParams());
		}

		private function onDoubleClick(evt:MouseEvent):void{
			util.pub("stage_double_click", getParams());
		}

		private function getParams():Object{
			var o:Object = {
				x:stage.mouseX,
				y:stage.mouseY,
				startX:startX,
				startY:startY,
				mousedown:isMouseDown,
				fromStartX:stage.mouseX-startX,
				fromStartY:stage.mouseY-startY,
				width:stage.stageWidth,
				height:stage.stageHeight,
				lastX:lastX===-99999 ? stage.mouseX : lastX,
				lastY:lastY===-99999 ? stage.mouseY : lastY,
				moveX:lastX===-99999 ? stage.mouseX : stage.mouseX - lastX,
				moveY:lastY===-99999 ? stage.mouseY : stage.mouseY - lastY
			};

			lastX = stage.mouseX;
			lastY = stage.mouseY;

			return o;
		}
	}
}
