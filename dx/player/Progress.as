package dx.player{

	import dx.common.debugging.console;
	import dx.common.util;

	import dx.gfx.Container;
	import dx.gfx.Button;
	import dx.gfx.theme;
	import dx.gfx.Button;
	import dx.gfx.shapes.Rect;

	import dx.player.Scrub;

	public class Progress extends Container{

		private var downloaded:Rect;
		private var progress:Rect;
		private var scrub:Scrub;
		private var scrubBeg:Number;
		private var scrubEnd:Number;
		private var duration:Number = 0;
		private var dragging:Boolean = false;

		public function Progress(parent:Object):void{
			super(theme.controls.progressBar.progress, parent);
			//new Button(theme.play, this);

			var p:Object = theme.controls.progressBar.progress;
			var back:Rect = new Rect(p, this);

			p.bgColor = p.downloaded.bgColor;
			downloaded = new Rect(p, this);
			downloaded.scaleX = 0;

			p.bgColor = p.position.bgColor;
			progress = new Rect(p, this);
			progress.scaleX = .3;


			scrub = new Scrub(this);
			var sz:Number = scrub.w/2;
			scrub.setDragHorz({
				y:	back.y - sz/2 + 2,
				x:	back.x - sz + 4,
				dist:back.w,
				callback:onDrag
			});

			util.sub("video_download", onDownload);
			util.sub("video_meta", onMeta);
			util.sub("video_progress", onFrame);
		}

		private function onFrame(o:Object):void{
			progress.scaleX = o.percent;
			scrub.setPercent(o.percent);
		}

		private function onMeta(m:Object):void{
			duration = m.duration;
		}

		private function onDownload(o:Object):void{
			//console.log("swf.onDownload", o.percent)
			downloaded.scaleX = o.percent;
		}

		private function onStartDrag(...a):void{
			dragging = true;
		}

		private function onDrag(p:Number):void{
			//console.log("onDrag", p)
			progress.scaleX = p;
			container.visible = false;
			container.visible = true;
			util.pub("video_seek", p);

		}

		private function onEndDrag(...a):void{
			dragging = false;
		}
	}
}
