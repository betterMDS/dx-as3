package dx.player{

	import dx.common.debugging.console;
	import dx.common.util;

	import dx.gfx.Container;
	import dx.gfx.Button;
	import dx.gfx.theme;
	import dx.gfx.Button;

	import flash.events.MouseEvent;

	public class Play extends Button{



		public function Play(parent:Object):void{
			super(theme.play, parent);
			addEventListener(MouseEvent.CLICK, onBtnClick);
			util.sub("video_status", onVideoStatus);
		}

		private function onVideoStatus(o:Object):void{
			if(o.state=="playing"||o.state=="buffering"){
				state = 1;
			}else if(o.state=="paused"){
				state = 0;
			}
			//state = o.state=="playing"||o.state=="buffering" ? 1 : 0;
			//console.log("PlayButton.onStatechange",  state, "(",o.state,")", "(", o.code, ", ", o.event, ")");
			//console.dir(o);
		}

		private function onBtnClick(evt:Object):void{
			if(state == 0){
				//console.log("Play.click (", state, ")")
				util.pub("video_play", null);
			}else{
				//console.log("Play.click (", state, ")")
				util.pub("video_pause", null);
			}
		}
	}
}
