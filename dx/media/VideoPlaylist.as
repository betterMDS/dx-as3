package dx.media{

	import flash.events.Event;
	import flash.display.Sprite;

	import dx.common.debugging.console;
	import dx.media.VideoContainer;

	public class VideoPlaylist{

		public var items:Object = {};
		public var current:VideoContainer;

		private var index:Number = -1;
		private var container:Sprite;
		private var autoplay:Boolean;
		private var volume:Number;

		public function VideoPlaylist(_container:Sprite, _autoplay:Boolean, _volume:Number):void{
			autoplay = _autoplay;
			volume = _volume;
			container = _container;
		}

		public function isPlaying():Boolean{
			return current.playing;
		}
		
		public function play(...a):void{
			current.play();
		}

		public function pause(...a):void{
			console.log("swf.playlist.pause", current.index, current.path);
			current.pause();
		}

		public function seek(n:Number):void{
			current.seek(n);
		}

		public function add(path:String, startPlaying:Boolean = false):void{
			console.log("playlist.add", path);
			index++;

			var ap:Boolean = startPlaying || autoplay;
			//console.log("swf.playlist autoplay?", startPlaying, autoplay);
			current = new VideoContainer(path, ap, volume, index);
			items[path] = current;
			container.addChild(current);

		}

		public function setVolume(vol:Number):void{
			volume = vol;
			current.setVolume(volume);
		}

		public function setVideo(path:String):void{
			console.log('swf pl setVideo', items.length, ' // ', path)
			if(current){
				if(current.path == path){
					current.resume();
					return;
				}
				current.pause();
				current.hide();
			}

			if(!items[path]){
				add(path, index > -1);
				//current.autoplay = true;// else it will preload and pause
				current.play();
			}else{
				current = items[path];
				current.show();
				current.play();
			}

			console.log("swf.playlist.setVideo", current.index, current.path);



		}


	}
}
