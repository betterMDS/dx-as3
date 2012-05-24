package dx.media{

	import flash.display.Sprite;

	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.AsyncErrorEvent;

	import flash.media.Video;
	import flash.media.SoundTransform;
    import flash.net.NetConnection;
    import flash.net.NetStream;

	// For Player 11
	//import flash.events.StageVideoAvailabilityEvent;
	//import flash.events.StageVideoEvent;
	//import flash.media.StageVideo;
	//import flash.media.StageVideoAvailability;

	import dx.common.util;
	import dx.common.StageContainer;
	import dx.common.debugging.console;
	import dx.media.VideoMeta;

	public class VideoContainer extends Sprite {

		public var path:String = "";
		public var index:Number = -1;

		private var preloading:Boolean = false;

		private var initialVolume:Number = .5;
		private var video:Video;
		private var videoWidth:Number;
		private var videoHeight:Number;
		private var connection:NetConnection;
		private var videoStream:NetStream;
		private var wasPlaying:Boolean = false;
		private var progressTracked:Boolean = false;

		public var autoplay:Boolean = false;

		// No, these are not constants in a Flash Event object. weird.
		public var NOT_FOUND:String = "NetStream.Play.StreamNotFound";
		public var STOP:String = "NetStream.Play.Stop";
		public var START:String = "NetStream.Play.Start";
		public var EMPTY:String = "NetStream.Buffer.Empty";
		public var FLUSH:String = "NetStream.Buffer.Flush";
		public var CONNECTED:String = "NetConnection.Connect.Success";
		public var FULL:String = "NetStream.Buffer.Full";
		public var SEEK:String = "NetStream.Seek.Notify";

		public var status:String = "";
		public var loaded:Boolean = false;
		public var playing:Boolean = false;
		public var metaLoaded:Boolean = false;
		public var duration:Number;
		private var publishes:Boolean = true;
		private var downloaded:Boolean = false;

		public function VideoContainer(_path:String, _autoplay:Boolean, _volume:Number, _index:Number):void{
			path = _path;
			autoplay = _autoplay;
			initialVolume = _volume;
			index = _index;

			util.sub("video_meta", onMeta);
			util.sub("stage_resize", resizeVideo);
			util.sub("video_volume", setVolume);

			connect();

			if(autoplay){
				console.log('swf.video.autoplay')
				play();
			}else{
				console.log("VideoContainer preload...");
				preload();
			}

		}

		public function show():void{
			visible = true;
			publishes = true;
			if(downloaded){
				var o:Object = getLoaded();
				o.status = "end";
				o.percent = 1;

				pub("video_download", o);
				pub("video_status", {
					code:"Video.Load.Percentage",
					event:"onDownload",
					channel:"/swf/on/download",
					state:"loading",
					value:o
				});
			}
		}

		public function hide():void{
			visible = false;
			publishes = false;
		}

		private function pub(channel:String, obj:Object):void{
			if(publishes){
				obj.path = path;
				util.pub(channel, obj);
			}
		}

		public function preload():void{
			metaLoaded = false;
			preloading = true;

			var h:Array = util.sub("video_download", function(...a):void{
				console.log("swf.preload.pause");
				videoStream.pause();
				util.unsub(h);
				util.setTimeout(function():void{
					console.log("swf.preload.end");
					preloading = false;
					//pub("video_preloaded");
					pub("video_status", {
						code:"",
						event:"onPreload",
						channel:"/swf/on/preloaded",
						state:"paused"
					});
				}, 200);
			});
			console.log("swf.preload.play");
			videoStream.play(path);
		}

		public function load(...args):void{
			metaLoaded = false;
			videoStream.play(path);
			setVolume(initialVolume);
			loaded = true;
		}

		public function play(...args):void{
			console.log("swf.video.play index:", index);
			if(args[0]){
				console.log("swf play new file", path);
				var wasPlaying:Boolean = playing;
				pause();
				path = args[0];
				load();
				if(!wasPlaying) pause();
			}else if(!loaded){
				console.log("swf play loaded file")
				load();
			}else{
				console.log("swf resume file")
				loaded = true;
				playing = true;
				resume();
			}
		}

		public function resume():void{
			console.log("swf.video.resume", index, "loaded:", loaded);
			// resume unpauses without a path
			//if(playing) return; don't do that!!!
			playing = true;
			if(!loaded){
				load();
			}else{
				videoStream.resume();
			}
			pub("video_status", {
				code:"Video.Play.Start",
				event:"onPlay",
				channel:"/swf/on/play",
				state:"playing"
			});
		}
		public function togglePause():void{
			// resume unpauses without a path
			if(!loaded){
				play();
			}else if(!playing){
				resume();
			}else{
				pause();
			}
		}
		public function pause(...a):void{
			console.log("swf.video.pause", index);
			playing = false;
			videoStream.pause();
			pub("video_status", {
				code:"Video.Play.Stop",
				event:"onPause",
				channel:"/swf/on/pause",
				state:"paused"
			});
		}

		public function close():void{
			playing = false;
			videoStream.close();
		}

		public function seek(cmd:*):void{
			//console.log("swf.seek", cmd);
			if(!loaded){
				load();
				pause();
			}
			if(cmd === "start"){
				wasPlaying = playing;
				pause();
			}else if(cmd === "end"){
				if(wasPlaying) {
					play();
					util.setTimeout(play, 100);
				}
			}else{
				videoStream.seek(this.duration * cmd);
				//console.log("swf.seeked", this.duration * cmd);
			}

		}


		private function onMeta(meta:Object):void{
			//if(metaLoaded) return;
			console.log("FLASH VIDEO META--->", meta);
			duration = meta.duration;
			if(meta.width){
				metaLoaded = true;
				videoWidth = meta.width;
				videoHeight = meta.height;
				resizeVideo();
			}
			pub('video_path_meta', meta);
			//volume = currentVolume; //FIXME: This may happen a tad late

		}

		private function connect():void{
			connection = new NetConnection();
            connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            connection.connect(null);


        }

		private function connectStream():void {
            videoStream = new NetStream(connection);
            videoStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            videoStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			videoStream.client = new VideoMeta();
			videoStream.bufferTime = 5;
           	video = new Video();
            video.attachNetStream(videoStream);

			addChild(video);
			util.sizeToContainer(video);

			startProgress();
        }



		private function netStatusHandler(event:NetStatusEvent):void {
			//console.log("netStatusHandler:", event.info);
			if(preloading) return;
			var cmd:String = "";
			var channel:String = "";
			var state:String = "unknown";
			switch (event.info.code) {

                case NOT_FOUND:
                    console.log("Unable to locate video: ", path);
					pub("video_status", {
						code:event.info.code + " "+path,
						src:path,
						index:index,
						event:"onError",
						channel:"/swf/on/error",
						state:"error"
					});
					return;

				case STOP:
					loaded = false;
					playing = false;
					cmd = "onPause";
					channel = "/swf/on/pause";
					state = "paused";
					break;

				case START:
					loaded = true;
					playing = true;
					cmd = "onPlay";
					channel = "/swf/on/play";
					state = "playing";
					break;

				case SEEK:
					cmd = "onSeek";
					state = "seeking";
					break;

				case EMPTY:
					cmd = "onBufferEmpty";
					channel = "/swf/on/full";
					state = "full";
					break;

				case FLUSH:
					cmd = "onBufferFlush";
					state = "flushing";
					break;

				// Fall Throughs

				case CONNECTED:
					cmd = "onConnected";
					state = "connected";
                    connectStream();

				case FULL:
					//console.log("FULL META CHECK:", metaLoaded);
					//console.log("VIDEO WIDTH:", video.videoWidth);
					cmd = "onBufferFull";
					state = "buffering";
					if(!metaLoaded){
						// older FLV with no meta data
						metaLoaded = true;
						//console.log("*** NO META ***");
					}


				default:
					// nothing
			}

			status = event.info.code;

			if(cmd != "onBufferFlush"){
				pub("video_status", {
					code:event.info.code,
					event:cmd,
					channel:channel,
					state:state
				});
			}
        }

		public function setVolume(vol:Number):void{
			var transform:SoundTransform = videoStream.soundTransform;
            transform.volume = vol;
            videoStream.soundTransform = transform;
			//console.log("videoStream.soundTransform:", videoStream.soundTransform.volume, vol, initialVolume);
		}

		public function get volume():Number{
			//console.log("videoStream.soundTransform:", videoStream.soundTransform);
			return videoStream.soundTransform.volume;
		}
		public function set volume(vol:Number):void{

		}

		public function getTime():Number{
			//console.log("swf.getTime", videoStream.time);
			return videoStream.time;
		}

		private function startProgress():void{
			var last:Number = 0;
			var o:Object = getLoaded();
			o.status = "start"
			pub("video_download", o);

			var h:int = util.setInterval(function():void{
				o = getLoaded();
				if(o.percent == last) return;
				last = o.percent;
				if(o.percent >= 1){
					util.clearInterval(h);
					o.status = "end";
					o.percent = 1;
					downloaded = true;
				}else{
					o.status = "progress";
				}

				pub("video_download", o);
				pub("video_status", {
					code:"Video.Load.Percentage",
					event:"onDownload",
					channel:"/swf/on/download",
					state:"loading",
					value:o
				});

			}, 50);

			if(progressTracked) return;
			progressTracked = true;

			util.setInterval(function():void{
				pub("video_progress", {
					time:videoStream.time,
					percent:videoStream.time/duration
				});
			}, 250);

		}

		public function getLoaded():Object{
			var p:Number = videoStream.bytesLoaded ? videoStream.bytesLoaded/videoStream.bytesTotal : 0;
			return {
				buffer: videoStream.bufferLength,
				bytesLoaded:videoStream.bytesLoaded,
				bytesTotal:videoStream.bytesTotal,
				percent:p
			}
		}

		public function resizeVideo(...a):void{

			//console.log(" -------------- resizeVideo")
			if(video){
				util.setTimeout(function():void{
					var vw:Number = videoWidth;
					var vh:Number = videoHeight;
					var sw:Number = stage.stageWidth;
					var sh:Number = stage.stageHeight;
					var saspect:Number = sh/sw;
					var vaspect:Number = vh/vw;
					var adjust:Number;

					console.log("video size:", sw, sh, "(", saspect, vaspect, ")");

					if(saspect==vaspect){
						video.width = sw;
						video.height = sh;
						video.x = 0;
						video.y = 0;
					}else{
						adjust = sw/vw;
						if(adjust*vh > sh){
							adjust = sh/vh;
						}
						video.width = adjust*vw;
						video.height = adjust*vh;
						video.x = (sw-video.width)/2;
						video.y = (sh-video.height)/2;

						//console.log("video size:", video.x, video.y, video.width, video.height, "(", sw, sh, ")");
					}
				}, 20);
			}

		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
            console.log("securityErrorHandler: " + event);
		}

        private function asyncErrorHandler(event:AsyncErrorEvent):void {
            // ignore AsyncErrorEvent events.
        }
	}
}
