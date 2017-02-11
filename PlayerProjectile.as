package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import fl.video.*;
	
	public class PlayerProjectile extends Sprite{
		
		private var stageRef:Stage;
		private var targetList:Array;
		private var _vel:Number = 0;
		private var _direction:String = new String();
		private var _damageType:String = new String();
		private var explosion:Sound = new Explosion();
		private var explosionCloud:ExplosionCloud;
		private var splashRadius:SplashDamage;
		
		public function PlayerProjectile(stageRef:Stage, initX:Number, initY:Number, 
										vel:int, playerDirection:String, damageType:String) {
			
			stageRef = stage;
			this.x = initX;
			this.y = initY;
			this._vel = vel;
			this._direction = playerDirection;
			this._damageType = damageType;
			targetList = RobotStart.enemyTarget();
			
			if(this._damageType == "missile"){
				addChild(new Missile);
				this._vel = this._vel * RobotStart.sSpdFactor;
			}
			else if(this._damageType == "bullet"){
				addChild(new Bullet);
			}
			
			addEventListener(Event.ENTER_FRAME, moveProjectile);
		} //end constructor
		
		private function moveProjectile(e:Event):void{
			
			switch(_direction){
				
				case("left"):
					this.x -= _vel;
					this.rotation = 180;
					break;
				case("up"):
					this.y -= _vel;
					this.rotation = -90;
					break;
				case("down"):
					this.y += _vel;
					this.rotation = 90;
					break;
				case("right"):
					this.x += _vel;
					this.rotation = 0;
					break;
				case("upRight"):
					this.x += _vel*0.7;
					this.y -= _vel*0.7;
					this.rotation = -45;
					break;
				case("upLeft"):
					this.x -= _vel*0.7;
					this.y -= _vel*0.7;
					this.rotation = -135;
					break;
				case("downRight"):
					this.x += _vel*0.7;
					this.y += _vel*0.7;
					this.rotation = 45;
					break;
				case("downLeft"):
					this.x -= _vel*0.7;
					this.y += _vel*0.7;
					this.rotation = 135;
					break;
				default:
					break;
			}
			
			if(this.x > stage.stageWidth || this.x < 0
			   || this.y > stage.stageHeight || this.y < 0){
				
				removeSelf();
			}
			
			//removes if hits wall
			if(RobotStart.playable.bounds.hitTestPoint(this.x, this.y, true)){
			   removeSelf();
			}
			
			if(targetList.length > 0){
				//removes if hits enemy and registers damage
				for(var i:int = 0; i < targetList.length; i++){
					if(hitTestObject(targetList[i])){
						targetList[i].dispatchEvent(new DataEvent("enemyHit", false, false, _damageType));
						removeSelf();
					}
				}
			}

		} //end moveProjectile
		
		
		private function removeSelf():void{
			
			if(this._damageType == "missile"){
				if(SoundMusicBtns.soundOn){explosion.play()}
				
				//create splash damage object
				splashRadius = new SplashDamage(this.x, this.y, RobotStart.sSplashFactor);
				addChild(splashRadius);
				
				//explosion display object
				explosionCloud = new ExplosionCloud();
				explosionCloud.blendMode = BlendMode.SCREEN;
				explosionCloud.x = this.x;
				explosionCloud.y = this.y;
				stage.addChild(explosionCloud);
				explosionCloud.addEventListener(Event.COMPLETE, removeExplosion);
				explosionCloud.addFrameScript(explosionCloud.totalFrames-1, function():void{
											  explosionCloud.dispatchEvent(new Event(Event.COMPLETE));
											  });
			}
			
			//avoid errors caused by potential duplicate function calls
			if(this.hasEventListener(Event.ENTER_FRAME)){
				removeEventListener(Event.ENTER_FRAME, moveProjectile);
			}
			
			if(this.numChildren > 0){
				for(var i:int = 0; this.numChildren > 0; removeChildAt(i)){}
			}

			if(stage.contains(this)){
				stage.removeChild(this);
			}

		} //end removeSelf
		
		
		//cleanup of explosion MC objects
		private function removeExplosion(e:Event):void{
			explosionCloud.removeEventListener(Event.COMPLETE, removeExplosion);
			explosionCloud.stop();
			explosionCloud.parent.removeChild(explosionCloud);
		}

	} //end class
	
} //end package