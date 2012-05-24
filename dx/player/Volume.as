package dx.player{

	import dx.common.debugging.console;
	import dx.common.util;

	import dx.gfx.Container;
	import dx.gfx.Button;
	import dx.gfx.theme;
	import dx.gfx.Button;

	import flash.events.MouseEvent;

	public class Volume extends Button{



		public function Volume(parent:Object):void{
			super(theme.volume, parent);
			addEventListener(MouseEvent.CLICK, onBtnClick);
		}

		private function onBtnClick(evt:Object):void{
			if(state == 0){
				//console.log("Play.click (", state, ")")
				state = 1;
				util.pub("video_volume", 0);
			}else{
				//console.log("Play.click (", state, ")")
				state = 0;
				util.pub("video_volume", container.container.container.config.volume); // whew! ugly!
			}
		}
	}
}
