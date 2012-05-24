package dx.player{

	import dx.common.debugging.console;
	import dx.common.util;

	import dx.gfx.Container;
	import dx.gfx.Button;
	import dx.gfx.theme;
	import dx.gfx.Button;

	import flash.events.MouseEvent;

	public class Fullscreen extends Button{

		private var standalone:Boolean = true;
		private var showing:Boolean = false;
		private var aniHandle:Number;

		public function Fullscreen(parent:Object):void{
			var thm:Object = theme.fullscreen;
			if(parent.id != "Main"){
				standalone = false;
				thm = theme.controlsFullscreen;
			}
			super(thm, parent);
			//log();
			addEventListener(MouseEvent.CLICK, onBtnClick);
		}

		override public function set show(vis:Boolean):void{
			util.clearInterval(aniHandle);
			aniHandle = util.setInterval(function():void{
				var o:Number = vis ? alpha+.1 : alpha-.1;
				if(o > 1){
					o = 1;
					util.clearInterval(aniHandle);
				}else if(o < 0){
					o = 0;
					util.clearInterval(aniHandle);
				}
				alpha = o;
			}, 30);
		}

		public function toggle():void{
			console.log("swf.toggle fs");
			showing = !showing;
			show = showing;
			console.log("swf.toggle fs", showing);
		}

		private function onBtnClick(evt:Object):void{
			util.pub("stage_fullscreen");
		}
	}
}
