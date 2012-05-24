package dx{

	import flash.display.Sprite;
	import flash.display.LoaderInfo;
	import flash.system.Security;
	import flash.events.Event;

	import dx.common.util;
	import dx.common.StageContainer;
	import dx.common.debugging.console;
	import dx.common.ei;
	//import dx.common.logic;
	import dx.common.parse.flashVars;
	import dx.media.VideoPlaylist;
	import dx.media.VideoContainer;

	import dx.gfx.theme;
	import dx.gfx.shapes.Rect;
	import dx.gfx.Container;

	import dx.player.Controls;
	import dx.player.Fullscreen;

	public class Video extends Container{

		private var playlist:VideoPlaylist;
		private var fullscreen:Fullscreen;
		public var standalone:Boolean = false; // are we wrapped in dx JavaScript?

		public var config:Object = {
			videoId:"",
			clientId:0,
			locationId:0,
			autoplay:true,
			volume:.5,
			path:"",
			standalone:false,
			loadEvent:""
		}

		public function Video():void{
			Security.allowDomain("*");
			console.log('Video constr')
			addEventListener(Event.ADDED_TO_STAGE, function(...a):void{
				console.warn('ADDED TO STAGE');
				//startup();
			});
		}


		public function startup(args:Object):void{

			console.log('video.startup');
			var obj:Object = flashVars.convert(args);


			for(var nm:String in obj){
				config[nm] = obj[nm];
			}
			console.isDebug(obj.isDebug);
			if(obj.debugPrefix) console.prefix = obj.debugPrefix;
			//console.isDebug(true);
			console.log(" * Video.params:", obj);
			console.log(" * Video.config:", config);

			id = "Main";
			console.log('add stage');
			try{
				util.stage = new StageContainer(this);
			}catch(e:Error){console.error('error adding stage', e); }
			console.log('stage added, id:', util.stage.id);
			standalone = obj.standalone; //config.path === "";

			//logic.playerUrl = LoaderInfo(this.root.loaderInfo).loaderURL.toString();
			if(standalone && !config.path){
				console.log('standalone, no config.path');
				//config.path = logic.getVideoPath(config.videoId, config.clientId, config.locationId);
				ei.available = false;
				trace("Derived Video Path:", config.path);
			}else{
				standalone = config.standalone;
				console.log('standalone:', standalone);
				trace("Passed Video Path:", config.path);
				if(standalone){
					trace("standalone");
					ei.available = false;
				}
			}

			build();



			new Controls(this);

			ei.add("getLoadTest", function():Boolean{
				return true;
			});
			ei.add("startup", function():Boolean{
				console.info('swf.ei.startup called!');
				playlist.add(config.path);
				return true;
			});


			if(config.loadEvent){
				ei.call(""+config.loadEvent, true);
			}else{
				ei.call("dxMediaFlashVideo.onPlayerLoaded", true);
			}


			if(!standalone && !obj.noFullscreen){
				util.setTimeout(function():void{
					buildFS();
				}, 500);
			}
		}

		private function buildFS():void{
			fullscreen = new Fullscreen(this);

			ei.add("hideFullscreen", function(...a):void{
				//console.log('hideFullscreen');
				fullscreen.show = false;
			});
			ei.add("showFullscreen", function(...a):void{
				//console.log('showFullscreen');
				fullscreen.show = true;
			});
		}

		private function build():void{
			var r:Rect = new Rect(theme.playerBack, this);
			playlist = new VideoPlaylist(this, config.autoplay, config.volume);
			!standalone && subscribes();
			if(config.path){// && !config.loadEvent){
				playlist.add(config.path);
			}

			if(!standalone){
				publishes();
			}
			standaloneSubscribe();
		}

		private function standaloneSubscribe():void{
			console.log("standaloneSubscribe");
			//
			// unsure of this method name
			//
			util.sub("video_play", playlist.play);
			util.sub("video_pause", playlist.pause);
			util.sub("video_seek", playlist.seek);
		}

		private function subscribes():void{
			console.log("subscribes")
			util.sub("video_path_meta", function(meta:Object):void{
				ei.call("dxMediaFlashVideo.onMeta", meta);
			});
			util.sub("video_status", function(obj:Object):void{
				ei.call("dxMediaFlashVideo.onStatus", obj);
			});
			util.sub("stage_resize", function(obj:Object):void{
				ei.call("dxMediaFlashVideo.onStatus", obj);
			});
			util.pub("stage_click", function(obj:Object):void{
				console.log('swf.click');
				ei.call("dxMediaFlashVideo.onClick");
			});
		}

		private function publishes():void{
			ei.add("doPlay", playlist.play);
			ei.add("doPause", playlist.pause);
			ei.add("seek", playlist.seek);
			ei.add("setVideo", playlist.setVideo);
			ei.add("add", playlist.add);




			console.log("***publishes***");
			ei.add("getTime", function():Number{
				return playlist.current.getTime();
			});

			ei.add("setVolume", function(v:Number):void{
				playlist.setVolume(v);
			});

			//ei.call("dx.flash.onPlayerLoaded");
		}
	}
}
