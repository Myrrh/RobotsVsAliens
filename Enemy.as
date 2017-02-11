package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.utils.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.media.*;
	
	public class Enemy extends MovieClip{
		
		// PUBLIC VARS
		
		//positioning of enemy upon instantiation
		public var enemyX:Number = new Number();
		public var enemyY:Number = new Number();
		public var enemyPos:Point;

		// PRIVATE VARS
		
		//enemy speed and health
		private var _enemySpeed:Number;
		private var _enemyHealthMax:Number;
		private var _enemyHealthCurrent:Number;
		private var _enemyHealthPercentage:Number = 1;

		//position vars
		private var _enemyRow:int = 0;
		private var _enemyColumn:int = 0;
		private var _playerPos:Point = new Point();
		private var _playerRow:int = new int();
		private var _playerColumn:int = new int();
		
		//directional Booleans
		private var _travelingUp:Boolean = false;
		private var _travelingDown:Boolean = false;
		private var _travelingLeft:Boolean = false;
		private var _travelingRight:Boolean = false;
		
		//line of sight testers
		private var _playerSameLine:Boolean = false;
		private var _playerLineOfSight:Boolean = false;
		
		//projectile vars
		private var _enemyProjectile:Sprite = new Sprite();
		private var _projectileSpeed:int = 9;
		private var _volleyTimer:Timer;
		
		//damage vars
		private var bulletDamage:Number = 20;
		private var missileDamage:Number = 150;
		
		//enemy properties
		private var newEnemy;
		private var enemyType:String = new String();
		private var stageRef:Stage;
		private var target:Player;
		private var healthBar:Sprite;
		private var enemyFactor:Number = new Number(); //affects item drop rate
		
		//tweens
		private var spawnIn:Tween;
		private var fadeOut:Tween;
		
		//sounds
		private var thud:Sound = new Thud();
		private var squish:Sound = new Squish();
		private var ping1:Sound = new Ping1();
		private var ping2:Sound = new Ping2();
		private var ping3:Sound = new Ping3();
		private var pingArray:Array = [ping1, ping2, ping3];
		private var explosion:Sound = new Explosion();
		
		//bomber-class
		private var bomberMoving:Boolean = true;
		private var bomberBombing:Boolean = false;
		private var bombRoll:Number;
		private var bombTimer:Timer;
		
		//misc
		private var randomDrop:DroppedItem;
		private var df:Number = RobotStart.difficultyFactor;
		private var splatTimer:Timer;
		
		//CONSTRUCTOR - positions enemy and executes runEnemy
		public function Enemy(xPos:int, yPos:int, target:Player, type:String) {
			
			addEventListener(Event.ADDED_TO_STAGE, runEnemy);
			enemyX = xPos;
			enemyY = yPos;
			this.target = target;
			this.enemyType = type;
			this.enemyFactor = 0;
			
			addEventListener("enemyHit", takeDamage);

		} //end constructor
		
		//runEnemy - adds enemy model to stage and executes enemyAI function	
		private function runEnemy(e:Event){	
		
		removeEventListener(Event.ADDED_TO_STAGE, runEnemy);
		
			if(this.enemyType == "soldier"){
				_enemySpeed = 1.25;
				_enemyHealthMax = 120/df;
				_enemyHealthCurrent = _enemyHealthMax;
				_volleyTimer = new Timer(800);
				newEnemy = new AlienSoldier();
				newEnemy.enemyType = "soldier";
				newEnemy.enemyFactor = 0.5;
			}
			else if(this.enemyType == "elite"){
				_enemySpeed = 2;
				_enemyHealthMax = 200/df;
				_enemyHealthCurrent = _enemyHealthMax;
				newEnemy = new AlienElite();
				_volleyTimer = new Timer(650);
				newEnemy.enemyType = "elite";
				newEnemy.enemyFactor = 0.75;
			}
			else if(this.enemyType == "juggernaut"){
				_enemySpeed = 1;
				_enemyHealthMax = 400/df;
				_enemyHealthCurrent = _enemyHealthMax;
				_volleyTimer = new Timer(300);
				newEnemy = new AlienJuggernaut();
				newEnemy.enemyType = "juggernaut";
				newEnemy.enemyFactor = 1;
			}
			else if(this.enemyType == "bomber"){
				_enemySpeed = 2.5;
				_enemyHealthMax = 300/df;
				_enemyHealthCurrent = _enemyHealthMax;
				_volleyTimer = new Timer (1000);
				newEnemy = new AlienBomber();
				newEnemy.enemyType = "bomber";
				newEnemy.enemyFactor = 0.9;
			}
			
			newEnemy.x = enemyX;
			newEnemy.y = enemyY;
			addChild(newEnemy);
			
			//custom property - green offset for spawning
			newEnemy.g0 = newEnemy.gg = 200;
			newEnemy.g1 = 0;
			
			//color green on spawn
			spawnIn = new Tween(newEnemy, "gg", Strong.easeOut, newEnemy.g0, newEnemy.g1, 1.5, true);
			spawnIn.FPS = 15;
			spawnIn.addEventListener(TweenEvent.MOTION_CHANGE, setColor);
			spawnIn.addEventListener(TweenEvent.MOTION_FINISH, removeTween);
				
			function setColor(e:TweenEvent):void{
				newEnemy.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, newEnemy.gg, 0, 0);
			}
			function removeTween(e:TweenEvent):void{
				spawnIn.removeEventListener(TweenEvent.MOTION_CHANGE, setColor);
				spawnIn.removeEventListener(TweenEvent.MOTION_FINISH, removeTween);
			}
			
			//health bars
			healthBar = new Sprite();
			newEnemy.addChild(healthBar);
			healthBar.graphics.beginFill(0x00FF00, 1);
			healthBar.graphics.drawRect(-18, -40, 36*_enemyHealthPercentage, 8);
			healthBar.graphics.endFill();
			
			addEventListener(Event.ENTER_FRAME, enemyAI);
			removeEventListener(Event.ADDED_TO_STAGE, runEnemy);
		} //end runEnemy
				
				
		// enemy AI ***RUNS EVERY FRAME, FOR EVERY ENEMY***
		private function enemyAI(e:Event):void{

				_enemyRow = (Math.floor((newEnemy.y - RobotStart.STARTING_Y)/RobotStart.CELL_SIZE))
				_enemyColumn = (Math.floor((newEnemy.x + - RobotStart.STARTING_Y)/RobotStart.CELL_SIZE))
				//trace(_enemyRow, _enemyColumn);
				
				_playerPos = RobotStart.getPlayerPos();
				_playerRow = (Math.floor((_playerPos.y - RobotStart.STARTING_Y)/RobotStart.CELL_SIZE));
				_playerColumn = (Math.floor((_playerPos.x - RobotStart.STARTING_X)/RobotStart.CELL_SIZE));
				//trace(_playerRow, _playerColumn);
				
				//detects when an enemy is at the center of a new cell, and changes direction
				//***IMPORTANT: enemy movement interval must always be a divisor of 25	
				if(((newEnemy.x-25)%50 == 0) && ((newEnemy.y-25)%50 == 0)){
					if(newEnemy.enemyType == "bomber"){
						if(!bomberBombing){bombRoll = new Number(Math.random())}
						
						//chance to drop bomb
						if((bombRoll > 0.95) && (!bomberBombing)){
							
							//stop movement
							newEnemy.stop();
							bombRoll = 0;
							bomberMoving = false;
							_travelingUp = false;
							_travelingDown = false;
							_travelingLeft = false;
							_travelingRight = false;
							
							//add random timer
							bombTimer = new Timer(Math.random()*1000+2000, Math.ceil(Math.random()*4));
							bombTimer.addEventListener(TimerEvent.TIMER, bombing);
							bombTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopBombing);
							bombTimer.start();
							
							dropBomb();
							bomberBombing = true;
						}
						else if(bomberMoving){cellCenter()}
						else{}
					} //end if for bomber
					
					else{cellCenter()}
				}

				if((_enemyRow == _playerRow) || (_enemyColumn == _playerColumn)){
					_playerSameLine = true;
					if(newEnemy.enemyType != "bomber"){LoScheck()}
				}
				else if(Math.abs(_enemyRow - _playerRow) == Math.abs(_enemyColumn - _playerColumn)){
					_playerSameLine = false;
					if(newEnemy.enemyType != "bomber"){LoScheck()}
				}
				else{
					_playerSameLine = false;
					_playerLineOfSight = false;
				}
				
			//random movement
			if(_travelingUp){
				newEnemy.y -= _enemySpeed; //up
				newEnemy.rotation = -90;
				healthBar.rotation = 90;
			}
			else if(_travelingDown){
				newEnemy.y += _enemySpeed; //down
				newEnemy.rotation = 90;
				healthBar.rotation = -90;
			}
			else if(_travelingLeft){
				newEnemy.x -= _enemySpeed; //left
				newEnemy.rotation = 180;
				healthBar.rotation = 180;
			}
			else if(_travelingRight){
				newEnemy.x += _enemySpeed; //right
				newEnemy.rotation = 0;
				healthBar.rotation = 0;
			}
		} //end enemyAI
		
		private function LoScheck():void{
			
			//vertical & horizontal distance between player and enemy
			var vDist:int = Math.abs(_enemyRow - _playerRow);
			var hDist:int = Math.abs(_enemyColumn - _playerColumn);
			var vDistVec:int = (_enemyRow - _playerRow); //player above = positive, below = neg.
			var hDistVec:int = (_playerColumn - _enemyColumn); //player right = positive, left = neg.
			
			//player is RIGHT of enemy
			if((_enemyRow == _playerRow) && (_enemyColumn < _playerColumn)){
				for(var i:int = 0; i < hDist; i++){
					if((RobotStart.levelGrid[_enemyRow][_enemyColumn+i])==10){
						//LoS is clear
						_playerLineOfSight = true;
					}
					else{
						//LoS not clear - some obstruction found
						_playerLineOfSight = false;
						break;
					}
				}
			}
			//player is LEFT of enemy
			if((_enemyRow == _playerRow) && (_enemyColumn > _playerColumn)){
				for(var a:int = 0; a < hDist; a++){
					if((RobotStart.levelGrid[_enemyRow][_enemyColumn-a])==10){
						//LoS is clear
						_playerLineOfSight = true;
					}
					else{
						//LoS not clear - some obstruction found
						_playerLineOfSight = false;
						break;
					}
				}
			}
			//player is ABOVE enemy
			if((_enemyColumn == _playerColumn) && (_enemyRow > _playerRow)){
				for(var b:int = 0; b < vDist; b++){
					if((RobotStart.levelGrid[_enemyRow-b][_enemyColumn])==10){
						//LoS is clear
						_playerLineOfSight = true;
					}
					else{
						//LoS not clear - some obstruction found
						_playerLineOfSight = false;
						break;
					}
				}
			}
			//player is BELOW enemy
			if((_enemyColumn == _playerColumn) && (_enemyRow < _playerRow)){
				for(var c:int = 0; c < vDist; c++){
					if((RobotStart.levelGrid[_enemyRow+c][_enemyColumn])==10){
						//LoS is clear
						_playerLineOfSight = true;
					}
					else{
						//LoS not clear - some obstruction found
						_playerLineOfSight = false;
						break;
					}
				}
			}
			
			//player is DIAGONAL to enemy - for loops executive successively looking for LoS
			if((vDist == hDist) && (vDist != 0)){
				
				//player is BELOW & RIGHT
				if((vDistVec < 0) && (hDistVec > 0)){
					for(var d:int = 0; d < vDist; d++){
						if((RobotStart.levelGrid[_enemyRow+d][_enemyColumn+d])==10){
						_playerLineOfSight = true;
						}
						else{
						_playerLineOfSight = false;
						break;  
						}
					}
				}
				//player is ABOVE & RIGHT
				else if((vDistVec > 0) && (hDistVec > 0)){
					for(var e:int = 0; e < vDist; e++){
						if((RobotStart.levelGrid[_enemyRow-e][_enemyColumn+e])==10){
						_playerLineOfSight = true;
						}
						else{
						_playerLineOfSight = false;
						break;  
						}
					}
				}
				//player is BELOW & LEFT
				else if((vDistVec < 0) && (hDistVec < 0)){
					for(var f:int = 0; f < vDist; f++){
						if((RobotStart.levelGrid[_enemyRow+f][_enemyColumn-f])==10){
						_playerLineOfSight = true;
						}
						else{
						_playerLineOfSight = false;
						break;  
						}
					}
				}
				//player is ABOVE & LEFT
				else if((vDistVec > 0) && (hDistVec < 0)){
					for(var g:int = 0; g < vDist; g++){
						if((RobotStart.levelGrid[_enemyRow-g][_enemyColumn-g])==10){
						_playerLineOfSight = true;
						}
						else{
						_playerLineOfSight = false;
						break;  
						}
					}
				}
			} //end if for diagonal
			else{}
		} //end LoScheck
			
		//called when enemy is at center of a cell. Checks for LoS and available directions
				//if LoS exists, faces the player and stops. otherwise runs chooseNewDirection function
		private function cellCenter():void{
			
			var goUp:Boolean = false;
			var goDown:Boolean = false;
			var goLeft:Boolean = false;
			var goRight:Boolean = false;
			
			var enemyDirection:String = new String();
			
			var availableDirections:Array = [goUp, goDown, goLeft, goRight];
			
			//determines available directions
			// up direction is available
			if((RobotStart.levelGrid[_enemyRow-1][_enemyColumn])== 10){
				goUp = true;
				availableDirections = [goUp, goDown, goLeft, goRight];
			}
			else{
				goUp = false;
				availableDirections = [goUp, goDown, goLeft, goRight];
			}
			
			// down
			if((RobotStart.levelGrid[_enemyRow+1][_enemyColumn])== 10){
				goDown = true;
				availableDirections = [goUp, goDown, goLeft, goRight];
			}
			else{
				goDown = false;
				availableDirections = [goUp, goDown, goLeft, goRight];
				}
			
			// left
			if((RobotStart.levelGrid[_enemyRow][_enemyColumn-1])== 10){
				goLeft = true;
				availableDirections = [goUp, goDown, goLeft, goRight];
			}
			else{
				goLeft = false;
				availableDirections = [goUp, goDown, goLeft, goRight];
				}
			
			// right
			if((RobotStart.levelGrid[_enemyRow][_enemyColumn+1])== 10){
				goRight = true;
				availableDirections = [goUp, goDown, goLeft, goRight];
			}
			else{
				goRight = false;
				availableDirections = [goUp, goDown, goLeft, goRight];
				}
				
			if(!_playerLineOfSight){
				chooseNewDirection();
				
				//problematic causing error 2007
				try{
					_volleyTimer.reset();
					if(_volleyTimer.hasEventListener(TimerEvent.TIMER)){
						_volleyTimer.removeEventListener(TimerEvent.TIMER, fireAtPlayer)
					   }
					}
				catch(err:Error){
					//do nothing
					}
				enemyDirection = "";
			}
			
			//*PLAYER LINE OF SIGHT DETECTED*
			
			else{
				
				newEnemy.stop();
				//stop movement
				_travelingUp = false;
				_travelingDown = false;
				_travelingLeft = false;
				_travelingRight = false;

				var onTop:Boolean = false;
				
				//turn to face player
				
				//player is RIGHT of enemy
				if((_enemyRow == _playerRow) && (_enemyColumn < _playerColumn)){
					newEnemy.rotation = 0;
					healthBar.rotation = 0;
					newEnemy.enemyDirection = "right";
					
				}
				//player is LEFT of enemy
				else if((_enemyRow == _playerRow) && (_enemyColumn > _playerColumn)){
					newEnemy.rotation = 180;
					healthBar.rotation = 180;
					newEnemy.enemyDirection = "left";
				}
				//player is ABOVE enemy
				else if((_enemyColumn == _playerColumn) && (_enemyRow > _playerRow)){
					newEnemy.rotation = -90;
					healthBar.rotation = 90;
					newEnemy.enemyDirection = "up";
				}
				//player is BELOW enemy
				else if((_enemyColumn == _playerColumn) && (_enemyRow < _playerRow)){
					newEnemy.rotation = 90;
					healthBar.rotation = -90;
					newEnemy.enemyDirection = "down";
				}
				//player is ABOVE & RIGHT of enemy
				else if(((_playerColumn - _enemyColumn) == (_enemyRow - _playerRow))
						&& ((_playerColumn - _enemyColumn) > 0)){
					newEnemy.rotation = -45;
					healthBar.rotation = 45;
					newEnemy.enemyDirection = "upRight";
				}
				//player is ABOVE & LEFT of enemy
				else if(((_enemyColumn - _playerColumn) == (_enemyRow - _playerRow))
						&& ((_enemyColumn - _playerColumn) > 0)){
					newEnemy.rotation = -135;
					healthBar.rotation = 135;
					newEnemy.enemyDirection = "upLeft";
				}
				//player is BELOW & RIGHT of enemy
				else if(((_playerColumn - _enemyColumn) == (_playerRow - _enemyRow))
						&& ((_playerColumn - _enemyColumn) > 0)){
					newEnemy.rotation = 45;
					healthBar.rotation = -45;
					newEnemy.enemyDirection = "downRight";
				}
				//player is BELOW AND LEFT of enemy
				else if(((_enemyColumn - _playerColumn) == (_playerRow - _enemyRow))
						&& ((_enemyColumn - _playerColumn) > 0)){
					newEnemy.rotation = 135;
					healthBar.rotation = -135;
					newEnemy.enemyDirection = "downLeft";
				}
				else{
					//player is on top of enemy
					onTop = true;
				}
				
				//fire volleys
				if((!_volleyTimer.running) && (!onTop) && (target.playerHealthCurrent > 0)){
					_volleyTimer.start();
					_volleyTimer.addEventListener(TimerEvent.TIMER, fireAtPlayer);
					
					if(SoundMusicBtns.soundOn){pingArray[Math.floor(Math.random()*2)].play()}
					stage.addChild(new EnemyProjectile
						(stageRef, newEnemy.x, newEnemy.y, _projectileSpeed, newEnemy.enemyDirection, target, newEnemy.enemyType));
				}
				else if(onTop){
					//player is on top of enemy
					chooseNewDirection();
					if(_volleyTimer.running){
						_volleyTimer.stop();
						_volleyTimer.removeEventListener(TimerEvent.TIMER, fireAtPlayer);
					}
				}
				
				function fireAtPlayer(t:TimerEvent):void{
					if(target.playerHealthCurrent > 0){
						if(SoundMusicBtns.soundOn){pingArray[Math.floor(Math.random()*2)].play()}
						stage.addChild(new EnemyProjectile
							(stageRef, newEnemy.x, newEnemy.y, _projectileSpeed, newEnemy.enemyDirection, target, newEnemy.enemyType));
					}
				} //end fireAtPlayer

			} //end else for *PLAYER LINE OF SIGHT DETECTED*
		
			// chooses a new direction
			function chooseNewDirection():void{
				
				newEnemy.play();
				
				//this roll determines whether the enemy chooses a new direction. weighted to prefer current direction if available
				var choiceRoll:Number = Math.random();
				if(((choiceRoll < 0.8) && (_travelingUp)) && (availableDirections[0] == true)){
					//do nothing (continue current direction)
				}
				else if(((choiceRoll < 0.8) && (_travelingDown)) && (availableDirections[1] == true)){}
				else if(((choiceRoll < 0.8) && (_travelingLeft)) && (availableDirections[2] == true)){}
				else if(((choiceRoll < 0.8) && (_travelingRight)) && (availableDirections[3] == true)){}
				
				//if the roll fails or the preferred direction isn't available, a random new direction is chosen
				else{
				
					var randomDirection:int = Math.floor(Math.random()*4);
					var newDirection = (availableDirections[randomDirection]);

					switch(newDirection){
						case(true):
							if(randomDirection == 0){ //up
								_travelingUp = true;
								_travelingDown = false;
								_travelingLeft = false;
								_travelingRight = false;
							}
							else if(randomDirection == 1){ //down
								_travelingUp = false;
								_travelingDown = true;
								_travelingLeft = false;
								_travelingRight = false;
							}
							else if(randomDirection == 2){ //left
								_travelingUp = false;
								_travelingDown = false;
								_travelingLeft = true;
								_travelingRight = false;
							}
							else if(randomDirection == 3){ //right
								_travelingUp = false;
								_travelingDown = false;
								_travelingLeft = false;
								_travelingRight = true;
							}
							break;
						case(false):
							cellCenter();
							break;
						default:
							cellCenter();
							break;
					} //end switch
				} //end else
			} //end chooseNewDirection
		} //end cellCenter

		private function takeDamage(e:DataEvent):void{
			//trace(this.enemyType + ' hit by: ' + e.data);
			//trace('enemy health: ' + _enemyHealthCurrent + "/" + _enemyHealthMax);
			
			//flash opacity
			newEnemy.alpha = 0.3;
			var flasher:Timer = new Timer(100, 1);
			flasher.start();
			flasher.addEventListener(TimerEvent.TIMER_COMPLETE, flashBack);
			function flashBack(t:TimerEvent):void{
				newEnemy.alpha = 1;
				flasher.removeEventListener(TimerEvent.TIMER_COMPLETE, flashBack);
			}
			
			//determine damage type and dock health
			switch(e.data){
				case("bullet"):
					_enemyHealthCurrent -= bulletDamage * RobotStart.pDmgFactor;
					if(SoundMusicBtns.soundOn){thud.play()}
					break;
				case("missile"):
					_enemyHealthCurrent -= missileDamage * RobotStart.sDmgFactor;
					break;
				case("splash"):
					_enemyHealthCurrent -= missileDamage * RobotStart.sDmgFactor * 0.5;
					break;
				default:
					break;
			}
			
			//redraw health bar
			_enemyHealthPercentage = _enemyHealthCurrent / _enemyHealthMax;
			var healthBarFill:int = new int()
			
			if(_enemyHealthPercentage >= .7){
				healthBarFill = 0x00FF00;
			}
			else if((_enemyHealthPercentage < .7) && (_enemyHealthPercentage >= .3)){
				healthBarFill = 0xFFFF00;
			}
			else if((_enemyHealthPercentage < .3) && (_enemyHealthPercentage > 0)){
				healthBarFill = 0xFF0000;
			}
			else{
				newEnemy.removeChild(healthBar);
			}
			healthBar.graphics.clear();
			healthBar.graphics.beginFill(healthBarFill, 1);
			healthBar.graphics.drawRect(-18, -40, 36*_enemyHealthPercentage, 8);
			healthBar.graphics.endFill();
			
			//when enemy dies
			if(_enemyHealthCurrent <= 0){
				
				if(SoundMusicBtns.soundOn){squish.play()}
				
				_volleyTimer.reset();
				_volleyTimer = null;
				
				//splat & self-removal
				var splat:AlienSplat = new AlienSplat();
				splat.x = newEnemy.x;
				splat.y = newEnemy.y;
				splat.scaleX = splat.scaleY = 1.1;
				this.parent.addChildAt(splat, this.parent.getChildIndex(RobotStart.levelBase)+1);
				RobotStart.splatArray.push(splat);
				splat.addEventListener(Event.REMOVED_FROM_STAGE, removeSplatTimers);
				
				splatTimer = new Timer(10000, 1);
				splatTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fadeSplat);
				splatTimer.start();
				
				function fadeSplat(t:TimerEvent){
					splatTimer.reset();
					splatTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, removeSplat);
					fadeOut = new Tween(splat, "alpha", Strong.easeOut, 1, 0, 1, true);
					fadeOut.FPS = 15;
					fadeOut.addEventListener(TweenEvent.MOTION_FINISH, removeSplat);
				}
				
				function removeSplat(e:TweenEvent){
					fadeOut.removeEventListener(TweenEvent.MOTION_FINISH, removeSplat);
					splat.removeEventListener(Event.REMOVED_FROM_STAGE, removeSplatTimers);
					RobotStart.splatArray.splice(RobotStart.splatArray.indexOf(splat), 1); 
					splat.parent.removeChild(splat);
				}
				
				function removeSplatTimers(e:Event){
					splatTimer.reset();
					splatTimer = null;
				}
				
				//item drop roll
				
				var dropRoll:Number = Math.random();
				
				if(dropRoll < 0.5 * newEnemy.enemyFactor){
					randomDrop = new DroppedItem(newEnemy.x, newEnemy.y, target, "coin")
					this.parent.addChildAt(randomDrop, this.parent.getChildIndex(RobotStart.splatArray[RobotStart.splatArray.length-1])+1);
					RobotStart.droppedItemArray.push(randomDrop);
				}
				else if((dropRoll >= 0.5 * newEnemy.enemyFactor) && (dropRoll < 0.65 * newEnemy.enemyFactor)){
					randomDrop = new DroppedItem(newEnemy.x, newEnemy.y, target, "health")
					this.parent.addChildAt(randomDrop, this.parent.getChildIndex(RobotStart.splatArray[RobotStart.splatArray.length-1])+1);
					RobotStart.droppedItemArray.push(randomDrop);
				}
				else if((dropRoll >= 0.65 * newEnemy.enemyFactor) && (dropRoll < 0.75 * newEnemy.enemyFactor)){
					randomDrop = new DroppedItem(newEnemy.x, newEnemy.y, target, "ammo")
					this.parent.addChildAt(randomDrop, this.parent.getChildIndex(RobotStart.splatArray[RobotStart.splatArray.length-1])+1);
					RobotStart.droppedItemArray.push(randomDrop);
				}
				
				
				
				//remove event listeners and display object, also sends custom event to remove object from parent and parent array list
				removeEventListener(Event.ENTER_FRAME, enemyAI);
				removeEventListener("enemyHit", takeDamage);
				removeChild(newEnemy);
				var enemyIndex:String = new String(RobotStart.enemyList.indexOf(this));
				this.parent.dispatchEvent(new DataEvent("enemyDied", false, false, enemyIndex));			
				
				//add score
				var addScore:int = new int();
				if(this.enemyType == "soldier"){
					addScore = Math.round((50 / RobotStart.difficultyFactor)/5)*5;
				}
				else if(this.enemyType == "elite"){
					addScore = Math.round((125 / RobotStart.difficultyFactor)/5)*5;
				}
				else if(this.enemyType == "juggernaut"){
					addScore = Math.round((300 / RobotStart.difficultyFactor)/5)*5;
				}
				else if(this.enemyType == "bomber"){
					addScore = Math.round((250 / RobotStart.difficultyFactor)/5)*5;
				}
				InterfaceElements.updateScore(addScore);
			}
		} //end takeDamage
		
		
		//bomber functions
		private function bombing(t:TimerEvent):void{
			dropBomb();
		}
		private function stopBombing(t:TimerEvent):void{
			bombTimer.stop();
			bombTimer.removeEventListener(TimerEvent.TIMER, bombing);
			bombTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, stopBombing);
			cellCenter();
			bomberMoving = true;
			bomberBombing = false;
		}
		private function dropBomb():void{
			
			if(target.playerHealthCurrent > 0){
				trace('bomb dropped');
				if(SoundMusicBtns.soundOn){explosion.play()}
				stage.addChild(new EnemyProjectile
								(stageRef, newEnemy.x, newEnemy.y, _projectileSpeed, "left", target, newEnemy.enemyType));
				stage.addChild(new EnemyProjectile
								(stageRef, newEnemy.x, newEnemy.y, _projectileSpeed, "right", target, newEnemy.enemyType));
				stage.addChild(new EnemyProjectile
								(stageRef, newEnemy.x, newEnemy.y, _projectileSpeed, "up", target, newEnemy.enemyType));
				stage.addChild(new EnemyProjectile
								(stageRef, newEnemy.x, newEnemy.y, _projectileSpeed, "down", target, newEnemy.enemyType));
				stage.addChild(new EnemyProjectile
								(stageRef, newEnemy.x, newEnemy.y, _projectileSpeed, "upRight", target, newEnemy.enemyType));
				stage.addChild(new EnemyProjectile
								(stageRef, newEnemy.x, newEnemy.y, _projectileSpeed, "upLeft", target, newEnemy.enemyType));
				stage.addChild(new EnemyProjectile
								(stageRef, newEnemy.x, newEnemy.y, _projectileSpeed, "downRight", target, newEnemy.enemyType));
				stage.addChild(new EnemyProjectile
								(stageRef, newEnemy.x, newEnemy.y, _projectileSpeed, "downLeft", target, newEnemy.enemyType));
			}
		}
		
		public function get enemyPosition():Point{
			enemyPos = new Point(newEnemy.x, newEnemy.y);
			return enemyPos;
		}

	} //end class
} //end package