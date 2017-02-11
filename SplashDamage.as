package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class SplashDamage extends MovieClip{

		private var _thisX:Number;
		private var _thisY:Number;
		private var splash:SplashRadius;
		private var targetList:Array;

		public function SplashDamage(thisX:Number, thisY:Number, scaleFactor:Number) {
			_thisX = thisX;
			_thisY = thisY;
			splash = new SplashRadius;
			splash.x = _thisX;
			splash.y = _thisY;
			splash.alpha = 0;
			splash.scaleX = splash.scaleY = scaleFactor;
			targetList = RobotStart.enemyTarget();
			this.addEventListener(Event.ADDED_TO_STAGE, addSplash);
		} //end constructor
		
		private function addSplash(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, addSplash);
			stage.addChild(splash);
			
			if(targetList.length > 0){
				for(var i:int = 0; i < targetList.length; i++){
					var splashTarget:Point = targetList[i].enemyPosition;
					if(splash.hitTestPoint(splashTarget.x, splashTarget.y, true)){
						targetList[i].dispatchEvent(new DataEvent("enemyHit", false, false, "splash"));
					}
				}
			}
			stage.removeChild(splash);
			parent.removeChild(this);
			
		} //end addSplash
		
	} //end class
} //end package