package dx{

	import flash.display.Sprite;
	import flash.display.LoaderInfo;
	import flash.system.Security;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.IEventDispatcher;

	import dx.common.debugging.console;
	import dx.common.parse.flashVars;
	import dx.common.ei;
	import VPAIDEvent;

	[SWF(backgroundColor="0xffffff")]

	public class Loader extends Sprite{

		private var loader:flash.display.Loader;
		private var isVpaid:Boolean = false;
		private var moviewidth:int;
		private var movieheight:int;
		private var vastVersion:String = "2.0.23";
		private var vastId:String = "";
		private var bitrate:int = 1000;

		public function Loader():void{
			Security.allowDomain("*");
			var obj:Object = flashVars.convert(LoaderInfo(this.root.loaderInfo).parameters);
			console.isDebug(obj.isDebug || obj.debug);
			if(obj.debugPrefix) console.prefix = 'LDR '+obj.debugPrefix;
			//console.isDebug(true);
			trace('isDebug:', obj.isDebug);
			console.log("-------------------------------------------------------------------------------------swf.params:", obj);

			moviewidth = obj.width;
			movieheight = obj.height;


			var swf:String
			//if(/video\.swf/.test(obj.loadUrl)){
			//	console.log('fix video path for swf');
			//	swf = obj.url.replace(/\/\w+\.swf/, '/video.swf'); //"../code/Video.swf"; ---------?????
			//}else

			if(obj.loadUrl){
				console.log('swf:', swf)
				console.log('user determined swf', obj.loadUrl);
				swf = obj.loadUrl;
				console.log('swf is', swf);
			}else{
				//swf = loaderInfo.url.replace(/\/\w+\.swf/, '/video.swf'); //"../code/Video.swf";
			}

			swf += '?cb_' + (new Date().getTime());

			if(obj.isVpaid){
				isVpaid = true;
				if(obj.vastVersion) vastVersion = obj.vastVersion;
				if(obj.vastId) vastId = obj.vastId;
			}

			console.log('load swf:', swf);

			loader = new flash.display.Loader();
			addChild(loader);
			configureListeners(loader.contentLoaderInfo);

			loader.load(new URLRequest(swf));

			console.log('loading...');

		}

		public function load(obj:Object):void{

		}

		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(ProgressEvent.PROGRESS, onDownload);
			dispatcher.addEventListener(Event.COMPLETE, onComplete);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, onErrorIO);
        }

		private function onDownload (e:ProgressEvent):void{
			console.log("Downloaded " + e.bytesLoaded + " out of " + e.bytesTotal + " bytes");
		}

		private function configureVpaidListeners(movie:Object):void{
			var events:Array =
			["AdLoaded","AdStarted","AdStopped","AdLinearChange","AdExpandedChange",
			"AdRemainingTimeChange","AdVolumeChange","AdImpression","AdVideoStart",
			"AdVideoFirstQuartile","AdVideoMidpoint","AdVideoThirdQuartile","AdVideoComplete",
			"AdClickThru","AdUserAcceptInvitation","AdUserMinimize","AdUserClose","AdPaused",
			"AdPlaying","AdLog","AdError"];

			events.forEach(function(type:String, i:int, arr:Array):void{
				movie.addEventListener(type, function(e:VPAIDEvent):void{
					try{
						console.log(' --- EVENT:', e.type, e.data);

						ei.call("dx.vast.adEvent", {
							id:vastId,
							type:e.type,
							data:e.data
						});

					}catch(e:Error){
						console.error('error communicating with movie:', e);
					}
				});
			});
		}

		private function onComplete(event:Event):void {

			console.log('swf.load complete');
			var movie:Object = Object(loader.content);
			if(isVpaid){
				console.log('swf - handle vpaid methods; version', vastVersion);
				try{
				configureVpaidListeners(movie);

				movie.handshakeVersion(vastVersion);

				//movie.x = -100;
				//movie.y = 0;
				movie.initAd(moviewidth, movieheight, "normal", bitrate, "", "");
				movie.startAd();
				console.log('center swf:', movie.width, movie.height)
				}catch(e:Error){
					console.error('error initializing vpaid ad', e);
				}
				console.log('vpaid methods all called');
			}else{
				movie.startup(LoaderInfo(this.root.loaderInfo).parameters);
			}
		}

		private function onHttpStatus(event:HTTPStatusEvent):void {
			if(event.status != 200){
				console.error("onHttpStatus.Error: " + event.status, event);
			}
		}

		private function onErrorIO(event:IOErrorEvent):void {
			console.error("onErrorIO: " + event);
        }

	}
}
