package  {
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.net.*;
	
	public class Preloader extends Sprite {
		
		private var preload:PreloadScreen = new PreloadScreen();
		private var segoe:Font = new SegoeBold();
		private var loadTextFmt:TextFormat = new TextFormat(segoe.fontName, 18, 0xFFFFFF, true);
		private var loadTxtFld:TextField = new TextField();
		private var req:URLRequest = new URLRequest("RvA.swf");
		private var loader:Loader = new Loader();

		public function Preloader() {
			addChild(preload);
			preload.gotoAndStop(1);
			
			loadTxtFld.defaultTextFormat = loadTextFmt;
			loadTxtFld.embedFonts = true;
			loadTxtFld.multiline = false;
			loadTxtFld.selectable = false;
			loadTxtFld.autoSize = TextFieldAutoSize.CENTER;
			loadTxtFld.x = preload.width * 0.4;
			loadTxtFld.y = 410;
			loadTxtFld.text = "LOADING...";
			addChild(loadTxtFld);
			
			//addEventListener(Event.ENTER_FRAME, loading);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loading);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			loader.load(req);
		}
		
		private function loading(e:ProgressEvent):void{
			var bytestotal = loader.contentLoaderInfo.bytesTotal;
			var bytesloaded = loader.contentLoaderInfo.bytesLoaded;
			var rectangle = Math.round(bytesloaded*100/bytestotal);
			preload.gotoAndPlay(rectangle);
			
			loadTxtFld.replaceText(0, loadTxtFld.length, "LOADING...    " + rectangle + "% COMPLETE");
		}
		
		private function loaded(e:Event):void{
			preload.gotoAndStop(100);
			removeChild(preload);
			removeChild(loadTxtFld);
			removeEventListener(Event.ENTER_FRAME, loading);
			addChild(loader);
		}

	} //end class
} //end package