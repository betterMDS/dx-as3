package dx.common.parse{

	import dx.common.debugging.console;
	import dx.common.util;

	public class flashVars{

		public static function convert(obj:Object):Object{
			//
			// The public method
			//
			//console.warn("FLASHVARS")
			var nm:String;

			for(nm in obj){
				if(nm.indexOf('amp;')>-1){
					obj[nm.replace('amp;','')] = obj[nm];
					delete obj[nm];
				}
			}

			for(nm in obj){
				if(/\|/.test(nm)) {
					var newName:String = nm.split("|")[0];
					//console.log("   newname:", newName, nm, obj[nm])
					obj[newName] = util.mix((obj[newName] || {}), strToObj(nm+"="+obj[nm])[newName]);
					delete obj[nm];
				}else{
					obj[nm] = util.normalize(obj[nm], true);
				}
			}
			return obj;
		}

		public static function strToObj(str:String):Object{
			//
			// Shouldn't be called directly
			// expects | seperated strings for objects
			//
			var o:Object = {};
			var toObj:Function = function(ps:String):Object{
				var p:Array = ps.split("|");
				var c:Object = o;
				for(var i:int = 0; i < p.length; i++){
					if(i == p.length - 1){
					   c[p[i].split("=")[0]] = util.normalize(p[i].split("=")[1], true);
					}else{
						if(!c[p[i]]) c[p[i]] = {};
						c = c[p[i]];
					}
				}
				return o;
			}
			return toObj(str);
		}
	}
}
