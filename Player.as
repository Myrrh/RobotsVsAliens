package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.utils.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.media.*;
	import flash.ui.*;
	
	public class Player extends MovieClip{
		
		// PUBLIC VARS
		
		//player properties
		public var movementSpeed:Number = 3 * RobotStart.speedFactor;
		public var playerHealthMax:Number = 1200 * RobotStart.pHealthFactor * RobotStart.difficultyFactor;
		public var playerHealthCurrent:Number = 1200 * RobotStart.pHealthFactor * RobotStart.difficultyFactor;
		public var playerHealthPercentage:Number = playerHealthCurrent / playerHealthMax;
		public var healthBar:Sprite = new Sprite();

		//player coordinates, grid position
		public var playerX:Number = new Number();
		public var playerY:Number = new Number();
		public var playerRow:int = 0;
		public var playerColumn:int = 0;
		
		// PRIVATE VARS
		
		private var player:RoboPC;
		
		//collision detection flags
		private var hitUp:Boolean = false;
		private var hitRight:Boolean = false;
		private var hitLeft:Boolean = false;
		private var hitDown:Boolean = false;
		
		//keyboard flags for movement
		private var keyW = false;
		private var keyA = false;
		private var keyS = false;
		private var keyD = false;
		private var playerDirection:String;
		
		//weapons
		private var _currentPrimary;
		private var _currentSecondary;
		
		//misc.
		private var stageRef:Stage;
		private var takeHit:Tween;	
		private var frameCounter:int;
		
		//sounds
		private var shot:Sound = new Shot();
		private var explosiveShot:Sound = new ExplosiveShot();
		private var reloader:Sound = new Reload();
		private var roboHit:Sound = new RoboHit();
		private var choir:Sound = new Choir();

		//CONSTRUCTOR - positions player with arguments passed from instantiating class, executes runPlayer
		public function Player(xPos:int, yPos:int){
			addEventListener(Event.ADDED_TO_STAGE, runPlayer);
			playerX = xPos;
			playerY = yPos;
			//rightClickMenu = new ContextMenu();
			//contextMenu = rightClickMenu;
		} //end constructor
		
		public function runPlayer(e:Event):void{
			
			removeEventListener(Event.ADDED_TO_STAGE, runPlayer);
			addEventListener("playerHit", takeDamage);
			addEventListener(Event.REMOVED_FROM_STAGE, removePlayer);
			
			//display object representing player
			player = new RoboPC();
			player.stop();
			this.hitArea = player.hit;
			
			//drop shadow, positioning, and adding player to stage
			var charShadow:DropShadowFilter = new DropShadowFilter(4, 135, 0x000000, .75, 0, 0, .5, 3);
			player.filters = [charShadow];
			player.x = playerX;
			player.y = playerY;
			addChild(player);
			
			//custom property - red offset which colors player when taking damage
			player.r0 = player.rr = 100;
			player.r1 = 0;

			//opacity flasher when player first spawns
			var flasher:Timer = new Timer(200, 6);
			flasher.start();
			flasher.addEventListener(TimerEvent.TIMER, flashPlayer);
			flasher.addEventListener(TimerEvent.TIMER_COMPLETE, endFlasher);
			function flashPlayer(e:TimerEvent){
				if(player.alpha == 1){
					player.alpha = 0;
				}
				else if(player.alpha == 0){
					player.alpha = 1;
				}
			}
			
			function endFlasher(e:TimerEvent){
				flasher.removeEventListener(TimerEvent.TIMER, flashPlayer);
				flasher.removeEventListener(TimerEvent.TIMER_COMPLETE, endFlasher);
				//events for firing weapons
				stage.addEventListener(MouseEvent.MOUSE_DOWN, firePrimary);
				stage.addEventListener(MouseEvent.MOUSE_UP, stopFiring);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardEvents);
			}
			
			//player health bar
			player.addChild(healthBar);
			healthBar.graphics.beginFill(0x00FF00, 1);
			healthBar.graphics.drawRect(-18, -40, 36*playerHealthPercentage, 8);
			healthBar.graphics.endFill();
			
			//player weapons
			switch(InterfaceElements.currentPrimary){
				case("p1"):
					_currentPrimary = new Primary1();
					break;
				case("p2"):
					_currentPrimary = new Primary2();
					break;
				case("p3"):
					_currentPrimary = new Primary3();
					break;
				case("p4"):
					_currentPrimary = new Primary4();
					break;
				default:
					_currentPrimary = new Primary1();
					break;
			}
			switch(InterfaceElements.currentSecondary){
				case("s1"):
					_currentSecondary = new Secondary1();
					break;
				case("s2"):
					_currentSecondary = new Secondary2();
					break;
				case("s3"):
					_currentSecondary = new Secondary3();
					break;
				case("s4"):
					_currentSecondary = new Secondary4();
					break;
				default:
					_currentSecondary = new Secondary1();
					break;
			}

			_currentPrimary.x = 11.35;
			_currentPrimary.y = 18;
			_currentPrimary.scaleX = _currentPrimary.scaleY = 0.213;
			_currentSecondary.x = 11.35;
			_currentSecondary.y = -18;
			_currentSecondary.scaleX = _currentSecondary.scaleY = 0.2;
			player.addChildAt(_currentPrimary, (getChildIndex(player)));
			player.addChildAt(_currentSecondary, (getChildIndex(player)));

			//keyboard events for movement
			stage.addEventListener(KeyboardEvent.KEY_DOWN, moveplayerKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, moveplayerKeyUp);
			stage.addEventListener(Event.DEACTIVATE, focusOutHandler);
			//rightClickMenu.addEventListener(ContextMenuEvent.MENU_SELECT, rightClickHandler);
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
		} //end runPlayer
			
		//movement of the PC (booleans/animation)
		private function moveplayerKeyDown(e:KeyboardEvent):void{
			
			switch(e.keyCode){
				
				case(87): //up (W)
					keyW = true;
					player.play();
					break;
				
				case(65): //left (A)
					keyA = true;
					player.play();
					break;
				
				case(68): //right (D)
					keyD = true;
					player.play();
					break;
				
				case(83): //down (S)
					keyS = true;
					player.play();
					break;
					
				default:
					//do nothing
			}
		} //end moveplayerKeyDown function
		
		//unflags key Booleans when they are not pressed
		private function moveplayerKeyUp(e:KeyboardEvent):void{
			switch(e.keyCode){
				
				case(87): //up (W)
					keyW = false;
					break;
				
				case(65): //left (A)
					keyA = false;
					break;
				
				case(68): //right (D)
					keyD = false;
					break;
				
				case(83): //down (S)
					keyS = false;
					break;
				
				default:
					//do nothing
			}
			if(keyW == false && keyA == false && keyS == false && keyD == false){
				player.stop();
			}
		} //end moveplayerKeyUp function
		
		//stops player movement if focus is lost
		private function focusOutHandler(e:Event):void{
			player.stop();
			keyW = false;
			keyA = false;
			keyD = false;
			keyS = false;
			if(this.hasEventListener(Event.ENTER_FRAME)){removeEventListener(Event.ENTER_FRAME, holdingMouse)}
			//trace('focus lost');
		}
		
		//(**enterFrameHandler**)movement of the PC, boundary collision testing
		private function enterFrameHandler(e:Event):void{
			
			//player bounding box for hit testing - basic corners
			var playerUpperLeft:Point = 
			new Point(player.x-player.width*0.5, player.y-player.height*0.5);
			var playerLowerLeft:Point = 
			new Point(player.x-player.width*0.5, player.y+player.height*0.5);
			var playerUpperRight:Point = 
			new Point(player.x+player.width*0.5, player.y-player.height*0.5);
			var playerLowerRight:Point = 
			new Point(player.x+player.width*0.5, player.y+player.height*0.5);
			
			/*side points offset from corners
			  B
			A   C
			  D*/
			  
			var playerUpperLeftA:Point = 
			new Point(player.x-player.width*0.5, (player.y-player.height*0.5)+(player.height*0.2));
			var playerLowerLeftA:Point = 
			new Point(player.x-player.width*0.5, (player.y+player.height*0.5)-(player.height*0.2));
			var playerUpperRightC:Point = 
			new Point(player.x+player.width*0.5, (player.y-player.height*0.5)+(player.height*0.2));
			var playerLowerRightC:Point = 
			new Point(player.x+player.width*0.5, (player.y+player.height*0.5)-(player.height*0.2));

			var playerUpperLeftB:Point = 
			new Point((player.x-player.width*0.5)+(player.width*0.2), player.y-player.height*0.5);
			var playerLowerLeftD:Point =
			new Point((player.x-player.width*0.5)+(player.width*0.2), player.y+player.height*0.5);
			var playerUpperRightB:Point = 
			new Point((player.x+player.width*0.5)-(player.width*0.2), player.y-player.height*0.5);
			var playerLowerRightD:Point = 
			new Point((player.x+player.width*0.5)-(player.width*0.2), player.y+player.height*0.5);
			
			//reset Booleans when not colliding with walls
			hitLeft = false;
			hitUp = false;
			hitRight = false;
			hitDown = false;

			if(keyW && !keyA && !keyS && !keyD){ //straight up (W)
				player.y -= movementSpeed;
				player.rotation = -90;
				healthBar.rotation = 90;
				if((RobotStart.playable.bounds.hitTestPoint
					(playerUpperLeftB.x, playerUpperLeftB.y, true))
				   ||(RobotStart.playable.bounds.hitTestPoint
					  (playerUpperRightB.x, playerUpperRightB.y, true))){
					player.y += movementSpeed;
					hitUp = true;
				}
			}
			
			else if(keyA && !keyW && !keyS && !keyD){ //straight left (A)
				player.x -= movementSpeed;
				player.rotation = 180;
				healthBar.rotation = 180;
				if((RobotStart.playable.bounds.hitTestPoint
					(playerLowerLeftA.x, playerLowerLeftA.y, true))
				   ||(RobotStart.playable.bounds.hitTestPoint
					  (playerUpperLeftA.x, playerUpperLeftA.y, true))){
					player.x += movementSpeed;
					hitLeft = true;
				}
			}

			else if(keyD && !keyW && !keyA && !keyS){ //straight right (D)
				player.x += movementSpeed;
				player.rotation = 0;
				healthBar.rotation = 0;
				if((RobotStart.playable.bounds.hitTestPoint
					(playerUpperRightC.x, playerUpperRightC.y, true))
				   ||(RobotStart.playable.bounds.hitTestPoint
					  (playerLowerRightC.x, playerLowerRightC.y, true))){
					player.x -= movementSpeed;
					hitRight = true;
				}
			}
			
			else if(keyS && !keyW && !keyA && !keyD){ //straight down (S)
				player.y += movementSpeed;
				player.rotation = 90;
				healthBar.rotation = -90;
				if((RobotStart.playable.bounds.hitTestPoint
					(playerLowerLeftD.x, playerLowerLeftD.y, true))
				   ||(RobotStart.playable.bounds.hitTestPoint
					  (playerLowerRightD.x, playerLowerRightD.y, true))){
					player.y -= movementSpeed;
					hitDown = true;
				}
			}

			else if(keyW && keyA && !keyS && !keyD){ //up + left (W + A)
				if(!hitUp && !hitLeft){
					player.x -= movementSpeed*0.7;
					player.y -= movementSpeed*0.7;
					player.rotation = -135;
					healthBar.rotation = 135;
					if((RobotStart.playable.bounds.hitTestPoint
						(playerUpperLeft.x, playerUpperLeft.y, true)) 
					   ||(RobotStart.playable.bounds.hitTestPoint
						  (playerUpperRightB.x, playerUpperRightB.y, true))
					   ||(RobotStart.playable.bounds.hitTestPoint
						  (playerLowerLeftA.x, playerLowerLeftA.y, true))){
						player.x += movementSpeed*0.7;
						player.y += movementSpeed*0.7;
					}
				}
			}
			
			else if(keyW && keyD && !keyS && !keyA){ //up + right (W + D)
				if(!hitUp && !hitRight){
					player.x += movementSpeed*0.7;
					player.y -= movementSpeed*0.7;
					player.rotation = -45;
					healthBar.rotation = 45;
					if((RobotStart.playable.bounds.hitTestPoint
						(playerUpperRight.x, playerUpperRight.y, true))
					   ||(RobotStart.playable.bounds.hitTestPoint
						  (playerUpperLeftB.x, playerUpperRightB.y, true))
					   ||(RobotStart.playable.bounds.hitTestPoint
						  (playerLowerRightC.x, playerUpperRightC.y, true))){
						player.x -= movementSpeed*0.7;
						player.y += movementSpeed*0.7;
					}
				}
			}


			else if(keyS && keyA && !keyD && !keyW){ //down + left (S + A)
				if(!hitDown && !hitLeft){
					player.x -= movementSpeed*0.7;
					player.y += movementSpeed*0.7;
					player.rotation = 135;
					healthBar.rotation = -135;
					if((RobotStart.playable.bounds.hitTestPoint
						(playerLowerLeft.x, playerLowerLeft.y, true))
					   ||(RobotStart.playable.bounds.hitTestPoint
						  (playerLowerRightD.x, playerLowerRightD.y, true))
					   ||(RobotStart.playable.bounds.hitTestPoint
						  (playerUpperLeftA.x, playerUpperLeftA.y, true))){
						player.x += movementSpeed*0.7;
						player.y -= movementSpeed*0.7;
					}
				}
			}
			
			else if(keyS && keyD && !keyA && !keyW){ //down + right (S + D)
				if(!hitDown && !hitRight){
					player.x += movementSpeed*0.7;
					player.y += movementSpeed*0.7;
					player.rotation = 45;
					healthBar.rotation = -45;
					if((RobotStart.playable.bounds.hitTestPoint
						(playerLowerRight.x, playerLowerRight.y, true))
					   ||(RobotStart.playable.bounds.hitTestPoint
						 (playerLowerLeftD.x, playerLowerLeftD.y, true))
					   ||(RobotStart.playable.bounds.hitTestPoint
						  (playerUpperRightC.x, playerUpperRightC.y, true))){
						player.x -= movementSpeed*0.7;
						player.y -= movementSpeed*0.7;
					} 
				}
			}
			
			
			// PLAYER POSITION FOR PATHFINDER
			
			playerX = player.x;
			playerY = player.y;
			
			playerRow = (Math.floor((playerY - RobotStart.STARTING_Y)/RobotStart.CELL_SIZE));
			playerColumn = (Math.floor((playerX - RobotStart.STARTING_X)/RobotStart.CELL_SIZE));
	
		} //end enterFrameHandler
		
		private function firePrimary(e:MouseEvent):void{
			
			//excludes area where the sound/music buttons are
			if(((mouseX > 865) && (mouseX < 935)) && (mouseY < 30)){}
			else{
				addEventListener(Event.ENTER_FRAME, holdingMouse);
				frameCounter = 0;
			}
		} //end firePrimary
		
		private function holdingMouse(e:Event):void{
			
			//fires on the Xth frame where X is the modulo value)
			if(frameCounter%10 == 0){
				var offsetX:int;
				var offsetY:int;
				
				playerDirection = new String();
				
				switch(player.rotation){
					
					case(0):
						playerDirection = "right";
						offsetX = player.x + _currentPrimary.x;
						offsetY = player.y;
						break;
					case(-90):
						playerDirection = "up";
						offsetX = player.x;
						offsetY = player.y - _currentPrimary.x;
						break;
					case(180):
						playerDirection = "left";
						offsetX = player.x - _currentPrimary.x;
						offsetY = player.y;
						break;
					case(90):
						playerDirection = "down";
						offsetX = player.x;
						offsetY = player.y + _currentPrimary.x ;
						break;
					case(-45):
						playerDirection = "upRight";
						offsetX = player.x + _currentPrimary.y + 3;
						offsetY = player.y;
						break;
					case(-135):
						playerDirection = "upLeft";
						offsetX = player.x;
						offsetY = player.y - _currentPrimary.y - 3;
						break;
					case(45):
						playerDirection = "downRight";
						offsetX = player.x;
						offsetY = player.y + _currentPrimary.y + 3;
						break;
					case(135):
						playerDirection = "downLeft";
						offsetX = player.x - _currentPrimary.y - 3;
						offsetY = player.y;
						break;
				}
				
				if(SoundMusicBtns.soundOn){shot.play()}
				stage.addChild(new PlayerProjectile(stageRef, offsetX, offsetY, 20, playerDirection, "bullet"));
				InterfaceElements.primaryClip--;
				InterfaceElements.updatePrimary();
				if(InterfaceElements.primaryClip == 0){
					reload();
				}
			} //end if
			frameCounter++;
		} //end holdingMouse
		
		private function stopFiring(e:MouseEvent):void{
			removeEventListener(Event.ENTER_FRAME, holdingMouse);
		}
		
		private function keyboardEvents(e:KeyboardEvent):void{
			
			// (Spacebar) FIRE SECONDARY
			
			var offsetX:int;
			var offsetY:int;
			
			if(e.keyCode == 32){

				var playerDirection:String = new String();
				switch(player.rotation){
					
					case(0):
						playerDirection = "right";
						offsetX = player.x + _currentSecondary.x + 20;
						offsetY = player.y;
						break;
					case(-90):
						playerDirection = "up";
						offsetX = player.x;
						offsetY = player.y - _currentSecondary.x - 20;
						break;
					case(180):
						playerDirection = "left";
						offsetX = player.x - _currentSecondary.x - 20;
						offsetY = player.y;
						break;
					case(90):
						playerDirection = "down";
						offsetX = player.x;
						offsetY = player.y + _currentSecondary.x + 20;
						break;
					case(-45):
						playerDirection = "upRight";
						offsetX = player.x;
						offsetY = player.y + _currentSecondary.y - 13;
						break;
					case(-135):
						playerDirection = "upLeft";
						offsetX = player.x + _currentSecondary.y - 13;
						offsetY = player.y;
						break;
					case(45):
						playerDirection = "downRight";
						offsetX = player.x - _currentSecondary.y + 13;
						offsetY = player.y;
						break;
					case(135):
						playerDirection = "downLeft";
						offsetX = player.x;
						offsetY = player.y - _currentSecondary.y + 13;
						break;
				}
				
				if(InterfaceElements.secondaryClip > 0){
					if(SoundMusicBtns.soundOn){explosiveShot.play()}
					stage.addChild(new PlayerProjectile(stageRef, offsetX, offsetY, 5, playerDirection, "missile"));
					InterfaceElements.secondaryClip--;
					InterfaceElements.updateSecondary();
				}
			}
			
			// ("r" key) RELOAD
			
			else if(e.keyCode == 82){
				reload();
			}
			
			// ("e" key) USE ACCESSORY
			
			else if(e.keyCode == 69){
				
			}
			
			else{}
		} //end keyboardEvents
		
		private function reload():void{
			
			if(SoundMusicBtns.soundOn){reloader.play()}
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, firePrimary);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyboardEvents);
			
			var reloadTimer:Timer = new Timer(2000, 1);
			reloadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, reloadFinished);
			reloadTimer.start();
			
			function reloadFinished(t:TimerEvent):void{
				
				reloadTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, reloadFinished);
				stage.addEventListener(MouseEvent.MOUSE_DOWN, firePrimary);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardEvents);
				
				//trace("reserve: " + InterfaceElements.secondaryRes +"\nclip: " + InterfaceElements.secondaryClip);
				//trace(InterfaceElements.secondaryRes + InterfaceElements.secondaryClip);

				//primary
				InterfaceElements.primaryClip = 18;
				InterfaceElements.updatePrimary();
				
				//secondary
				if((InterfaceElements.secondaryRes >= 5) || 
				(InterfaceElements.secondaryRes + InterfaceElements.secondaryClip > 5)){
					
					InterfaceElements.secondaryRes -= (5 - InterfaceElements.secondaryClip);
					InterfaceElements.secondaryClip = 5;
				}			
				else{
					InterfaceElements.secondaryClip += InterfaceElements.secondaryRes;
					InterfaceElements.secondaryRes = 0;
				}
				
				InterfaceElements.updateSecondary();
			} //end reloadFinished
		} //endReload
		
		private function takeDamage(e:DataEvent):void{
			//trace('player hit by: ' + e.data);
			
			if(SoundMusicBtns.soundOn){roboHit.play()}
			
			//color player red
			takeHit = new Tween(player, "rr", Strong.easeOut, player.r0, player.r1, 200, false);
			takeHit.addEventListener(TweenEvent.MOTION_CHANGE, setColor);
			takeHit.addEventListener(TweenEvent.MOTION_FINISH, removeTween);
			
			function setColor(e:TweenEvent):void{
				player.transform.colorTransform = new ColorTransform(1, 1, 1, 1, player.rr, 0, 0, 0);
			}
			function removeTween(e:TweenEvent):void{
				takeHit.removeEventListener(TweenEvent.MOTION_CHANGE, setColor);
				takeHit.removeEventListener(TweenEvent.MOTION_FINISH, removeTween);
			}
			
			//determine type of damage and adjust player health
			var damage:int = new int();
			if(e.data == "soldier"){
				damage = 50;
			}
			else if(e.data == "elite"){
				damage = 70;
			}
			else if(e.data == "juggernaut"){
				damage = 100;
			}
			else if(e.data == "bomber"){
				damage = 250;
			}
			
			playerHealthCurrent -= damage * RobotStart.DmgReceivedFactor;
			
			if(playerHealthCurrent > 0){
				redrawHealth();
			}
			//player dies
			else{
				if(RobotStart.guardian){
					trace('guardian angel used');
					playerHealthCurrent = playerHealthMax;
					redrawHealth();
					if(SoundMusicBtns.soundOn){choir.play()}
					RobotStart.guardian = false;
				}
				else{
					player.parent.parent.dispatchEvent
					(new DataEvent("playerDied", false, false, String(player.rotation)));
					player.removeChild(healthBar);
					//player.parent.removeChild(player);
					trace('player died');
				}
			}
			
		} //end takeDamage
		
		public function redrawHealth():void{
			
			playerHealthPercentage = playerHealthCurrent / playerHealthMax;
			
			var healthBarFill:int = new int();
			if(playerHealthPercentage >= .7){
				healthBarFill = 0x00FF00;
			}
			else if((playerHealthPercentage < .7) && (playerHealthPercentage >= .3)){
				healthBarFill = 0xFFFF00;
			}
			else if((playerHealthPercentage < .3) && (playerHealthPercentage > 0)){
				healthBarFill = 0xFF0000;
			}
			else{
				trace('error drawing health bar');
			}
			
			healthBar.graphics.clear();
			healthBar.graphics.beginFill(healthBarFill, 1);
			healthBar.graphics.drawRect(-18, -40, 36*playerHealthPercentage, 8);
			healthBar.graphics.endFill();
		}
		
		//important: removes event listeners from stage when player is removed (between levels)
		private function removePlayer(e:Event):void{
			if(this.hasEventListener(Event.ENTER_FRAME)){removeEventListener(Event.ENTER_FRAME, holdingMouse)}
			removeEventListener(Event.REMOVED_FROM_STAGE, removePlayer);
			removeEventListener("playerHit", takeDamage);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, moveplayerKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, moveplayerKeyUp);
			stage.removeEventListener(Event.DEACTIVATE, focusOutHandler);
			stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, firePrimary);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopFiring);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyboardEvents);
			trace('event listeners removed');
		}
		
		public function get currentP(){
			return(_currentPrimary);
		}
		public function get currentS(){
			return(_currentSecondary);
		}
	} //end class
} //end package