package dx.player{

	import dx.common.debugging.console;
	import dx.common.util;

	import dx.gfx.Container;
	import dx.gfx.Button;
	import dx.gfx.Text;
	import dx.gfx.theme;
	import dx.gfx.shapes.Rect;

	import dx.player.Play;
	import dx.player.Progress;
	import dx.player.Volume;

	public class Controls extends Container{

		private var tfDur:Text;
		private var tfTime:Text;
		private var volume:Button;
		private var duration:Number = 0;
		private var fullscreen:Button;
		private var div:Container;
		//private var video:VideoContainer;

		public function Controls(parent:Object):void{

			console.log('build Controls');

			super(theme.controls, parent);

			var c:Object = theme.controls;

			var bar:Rect = new Rect(c.back, this);
			div = new Container({}, this);

			new Play(div);

			c.statusTime.x = 40;
			tfTime = new Text(util.copy(c.statusTime), div);
			tfTime.text = util.timeCode(0, "mm_ss");

			new Progress(div);

			c.statusTime.x += c.progressBar.progress.w + 43;
			tfDur = new Text(util.copy(c.statusTime), div);
			tfDur.text = util.timeCode(0, "mm_ss");

			new Volume(div);

			if(container.standalone){
				fullscreen = new Button(theme.controlsFullscreen, div);
				fullscreen.addEventListener(fullscreen.ONCLICK, function(...a):void{
					util.pub("stage_fullscreen");
				});
			}

			util.sub("video_status", onVideoStatus);
			util.sub("video_progress", onFrame);
			util.sub("video_meta", onMeta);
			util.sub("stage_resize", resize);
			resize();
log();
		}

		private function resize(...a):void{
			util.centerToContainer(div, this);
			div.y = 0;
			if(!container.standalone){
				if(!a[0]){
					show = false;
				}else if(a[0].state == "normal"){
					show = false;
				}else{
					show = true;
				}
			}
		}

		private function onMeta(m:Object):void{
			duration = m.duration;
			tfDur.text = util.timeCode(duration, "mm_ss");
		}

		private function onFrame(o:Object):void{
			tfTime.text = util.timeCode(o.time, "mm_ss");
			tfDur.text = util.timeCode(duration-o.time, "mm_ss");
		}

		private function onVideoStatus(o:Object):void{
			//console.log("Controls.onVideoStatus",  "(",o.state,")");
		}
	}
}
