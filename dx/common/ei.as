package dx.common{

	import dx.common.debugging.console;
	import dx.common.util;
	import flash.events.Event;
	import flash.external.*;


	public class ei{

		public static function test():*{
			var r:String = call("document.location.toString", null);
			return r;
		}

		public static function call(...a):*{
			if(!available) return null;
			trace("ei.call:", a[0]);
			try{
				return 	ExternalInterface.call.apply(null, a);
			}catch(e:Error){
				trace("EI CALL ERROR")
				console.error("ei.call error", e)
			}
		}
		public static function add(method:String, callback:Function):*{
			if(!available) return null;
			trace("ei.add:", method);
			ExternalInterface.addCallback(method, callback)
		}

		private static var _varCache:Object = {};

		public static function get available():Boolean{
			if(_varCache.available === undefined){
				_varCache.available = false;
				if(ExternalInterface.available){
					try{
						var url:String = ExternalInterface.call.apply(null, ["document.location.href.toString"]);
						trace("EI AVAIL SUCCESS", url, !!url, ExternalInterface.available);
						if(/util_player\.swf/.test(url)){
							// if location returns the player, that means we don't have access to the page
							// ergo, we are in Facebook
							url = null;
						}
						_varCache.available = !!url;
					}catch(e:Error){
						trace("EI AVAIL ERROR")
						console.error("ei.call error", e);
					}
				}
				trace("EI AVAIL RESULT:", _varCache.available);
			}
			return _varCache.available;
		}

		public static function set available(b:Boolean):void{
			// set if flashVars indicate we are in Facebook
			_varCache.available = false;
		}
	}
}
