package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.utils.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.media.*;
	
	public class DroppedItem extends MovieClip{
		
		private var target:Player;
		private var itemType:String;
		private var itemTimer:Timer;
		private var flashTimer:Timer;
		private var healthBarTimer:Timer;
		
		//display objects & filters
		private var coin:CreditCoin;
		private var health:Health;
		private var itemShadow:DropShadowFilter = new DropShadowFilter(5, 45, 0x000000, 0.6, 4, 4, 1, 3);
		
		//sounds
		private var kaching:Sound = new KaChing();
		private var chargeUp:Sound = new ChargeUp();
		private var choir:Sound = new Choir();

		public function DroppedItem(xPos:int, yPos:int, target:Player, type:String) {
			this.x = xPos;
			this.y = yPos;
			this.target = target;
			this.itemType = type;
			this.filters = [itemShadow];
			
			if(this.itemType == "coin"){
				addChild(new CreditCoin);
			}
			else if(this.itemType == "health"){
				addChild(new Health);
			}
			else if(this.itemType == "ammo"){
				var secAmmo:Missile = new Missile;
				secAmmo.scaleX = secAmmo.scaleY = 1.2;
				secAmmo.rotation = -45;
				addChild(secAmmo);
			}
			
			itemTimer = new Timer(60000, 1);
			itemTimer.start();
			itemTimer.addEventListener(TimerEvent.TIMER_COMPLETE, flashOff);
		
			addEventListener(Event.ENTER_FRAME, pickUpItem);
			addEventListener(Event.REMOVED_FROM_STAGE, removeSelfNow);
			
		} //end constructor
		
		private function pickUpItem(e:Event){
			
			if(hitTestObject(target.hitArea)){
				
				switch(this.itemType){
					
					case("coin"):
						trace('coin picked up');
						if(SoundMusicBtns.soundOn){kaching.play()}
						InterfaceElements.updateCredits(Math.round(500 * RobotStart.difficultyFactor));
						break;
					
					case("health"):
						trace('health picked up');
						if(SoundMusicBtns.soundOn){chargeUp.play()}
						if(target.playerHealthCurrent + 500 * RobotStart.difficultyFactor < target.playerHealthMax){
							target.playerHealthCurrent += 500 * RobotStart.difficultyFactor;
						}
						else{
							target.playerHealthCurrent = target.playerHealthMax;
						}
						
						target.playerHealthPercentage = target.playerHealthCurrent / target.playerHealthMax;
						target.healthBar.graphics.clear();
						target.healthBar.graphics.beginFill(0xFFFFFF, 1);
						target.healthBar.graphics.drawRect(-18, -40, 36*target.playerHealthPercentage, 8);
						target.healthBar.graphics.endFill();
						healthBarTimer = new Timer(3000, 1);
						healthBarTimer.start();
						healthBarTimer.addEventListener(TimerEvent.TIMER_COMPLETE, redrawHealth);
						break;
						
					case("ammo"):
						trace('ammo picked up');
						if(SoundMusicBtns.soundOn){choir.play()}
						if(InterfaceElements.secondaryClip <= 2){
							InterfaceElements.secondaryClip += 3;
						}
						else if(InterfaceElements.secondaryClip == 3){
							InterfaceElements.secondaryClip += 2;
							InterfaceElements.secondaryRes += 1;
						}
						else if(InterfaceElements.secondaryClip == 4){
							InterfaceElements.secondaryClip += 1;
							InterfaceElements.secondaryRes += 2;
						}
						else if(InterfaceElements.secondaryClip >= 5){
							InterfaceElements.secondaryRes += 3;
						}
						InterfaceElements.updateSecondary();
						break;
				} //end switch
				
				removeSelf();
				
			}//end if
			
		} //end pickUpItem
		
		private function redrawHealth(t:TimerEvent):void{
			healthBarTimer.stop();
			healthBarTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, redrawHealth);
			target.redrawHealth();
		}
		
		private function flashOff(t:TimerEvent):void{
			//1009 error handling
			try{
				itemTimer.reset();
				itemTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, flashOff);
			}
			catch(err:Error){
				//do nothing
			}
			itemTimer = null;
			flashTimer = new Timer(333, 9);
			flashTimer.start();
			flashTimer.addEventListener(TimerEvent.TIMER, flasher);
			flashTimer.addEventListener(TimerEvent.TIMER_COMPLETE, removeTimer);
		}
		
		private function flasher(t:TimerEvent):void{
			if(this.alpha == 1){
				this.alpha = 0;
			}
			else{
				this.alpha = 1;
			}
		}
		
		private function removeTimer(t:TimerEvent):void{
			flashTimer.reset();
			flashTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, removeTimer);
			flashTimer = null;
			removeSelf();
		}
		
		private function removeSelf():void{
			
			//problematic causing error 1009
			try{
				this.removeEventListener(Event.REMOVED_FROM_STAGE, removeSelfNow);
				this.removeEventListener(Event.ENTER_FRAME, pickUpItem);
			}
			catch(err:Error){
				//do nothing
			}
			for(var i:int = 0; this.numChildren > 0; removeChildAt(i)){}
			RobotStart.droppedItemArray.splice(RobotStart.droppedItemArray.indexOf(this), 1);
			this.parent.removeChild(this);
			//trace('dropped item removed self');
		} //end removeSelf
		
		private function removeSelfNow(e:Event):void{
			itemTimer = null;
			flashTimer = null;
			removeEventListener(Event.REMOVED_FROM_STAGE, removeSelfNow);
			removeEventListener(Event.ENTER_FRAME, pickUpItem);
			RobotStart.droppedItemArray.splice(RobotStart.droppedItemArray.indexOf(this), 1);
		}

	} //end class
	
} //end package