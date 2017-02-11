package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class EnemyProjectile extends Sprite{
		
		private var stageRef:Stage;
		private var target:Player;
		private var _vel:Number = 0;
		private var _direction:String = new String();
		private var _damageType:String = new String();
		private var xOffset:int = 22;
		private var yOffset:int = 5;

		public function EnemyProjectile(stageRef:Stage, initX:Number, initY:Number, 
										vel:int, enemyDirection:String, target:Player, damageType:String) {
			
			//draw projectile based on enemy type
			var projectileColor:int;
			
			switch(damageType){
				case("soldier"):
					projectileColor = 0x00FF00;
					break;
				case("elite"):
					projectileColor = 0x00FFFF;
					break;
				case("juggernaut"):
					projectileColor = 0xFF0000;
					break;
				case("bomber"):
					projectileColor = 0xFFFF00;
					break;
			}
			
			var p:Sprite = new Sprite();
			p.graphics.lineStyle(1, 0x000000);
			p.graphics.beginFill(projectileColor, 1);
			p.graphics.drawCircle(0, 0, 7);
			p.graphics.endFill();
			addChild(p);
			
			//assign properties
			stageRef = stage;
			this.target = target;
			this.x = initX;
			this.y = initY;
			this._vel = vel;
			this._direction = enemyDirection;
			this._damageType = damageType;
			
			switch(_direction){
				
				case("left"):
					this.x -= xOffset;
					this.y += yOffset;
					break;
				
				case("up"):
					this.x -= yOffset;
					this.y -= xOffset;
					break;
				
				case("down"):
					this.x += yOffset;
					this.y += xOffset;
					break;
				
				case("right"):
					this.x += xOffset;
					this.y -= yOffset;
					break;
					
				case("upRight"):
					this.x += xOffset*0.7;
					this.y -= yOffset*0.7;
					break;
				
				case("upLeft"):
					this.x += xOffset*0.7;
					this.y -= yOffset*0.7;
					break;
				
				case("downRight"):
					this.x += xOffset*0.7;
					this.y -= yOffset*0.7;
					break;
				
				case("downLeft"):
					this.x += xOffset*0.7;
					this.y -= yOffset*0.7;
					break;
			}
			
			addEventListener(Event.ENTER_FRAME, moveProjectile);
			//target.addEventListener(Event.REMOVED_FROM_STAGE, playerDied);
		} //end constructor
		
		private function moveProjectile(e:Event):void{
			
			switch(_direction){
				
				case("left"):
					this.x -= _vel;
					break;
					
				case("up"):
					this.y -= _vel;
					break;
				
				case("down"):
					this.y += _vel;
					break;
				
				case("right"):
					this.x += _vel;
					break;
				
				case("upRight"):
					this.x += _vel*0.7;
					this.y -= _vel*0.7;
					break;
					
				case("upLeft"):
					this.y -= _vel*0.7;
					this.x -= _vel*0.7;
					break;
				
				case("downRight"):
					this.y += _vel*0.7;
					this.x += _vel*0.7;
					break;
				
				case("downLeft"):
					this.x -= _vel*0.7;
					this.y += _vel*0.7;
					break;
			}
			
			
			if((this.x > stage.stageWidth || this.x < 0)
			   || (this.y > stage.stageHeight || this.y < 0)){
				
				removeSelf();
			}
			
			//removes if hits wall
			else if(RobotStart.playable.bounds.hitTestPoint(this.x, this.y, true)){
			   removeSelf();
			}
			   
			//removes if hits player and registers damage
			else if(stage.contains(target)){
				if(hitTestObject(target.hitArea)){
					 target.dispatchEvent(new DataEvent("playerHit", false, false, _damageType));
					 removeSelf();
				}
			}
			else if(!stage.contains(target)){}
			else if(target == null){}

		} //end moveProjectile
		
		/*private function playerDied(e:Event):void{
			target.removeEventListener(Event.REMOVED_FROM_STAGE, playerDied);
			removeEventListener(Event.ENTER_FRAME, moveProjectile);
			trace('moveProjectile removed');
			removeSelf();
		}*/
		
		private function removeSelf():void{
			
			//avoid errors caused by potential duplicate function calls
			if(this.hasEventListener(Event.ENTER_FRAME)){
			   removeEventListener(Event.ENTER_FRAME, moveProjectile);
			   }
			else{}
			
			if(this.parent.contains(this)){
				this.parent.removeChild(this);
			}
			else{}
		}

	} //end class
	
} //end package