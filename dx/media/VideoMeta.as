package dx.media{

	import dx.common.util;
	import dx.common.debugging.console;

	public class VideoMeta{

		public function VideoListener():void{}

		public function onMetaData(info:Object):void {
			var obj:Object = {
				duration:info.duration,
				canSeekToEnd: info.canSeekToEnd,
				audiocodecid: info.audiocodecid,
				width: info.width,
				videocodecid: info.videocodecid,
				framerate: info.framerate,
				audiodelay: info.audiodelay,
				height: info.height,
				videodatarate: info.videodatarate,
				audiodatarate: info.audiodatarate
			};
			console.log("* * * onMetaData * * * ", obj);
			util.pub("video_meta", obj);
		}
	}
}
