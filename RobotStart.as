package {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.utils.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import fl.video.*;
	import flash.media.*;
	import flash.text.*;

	public class RobotStart extends Sprite {
		
		//PUBLIC VARS/CONSTANTS
		
		//defines the invisible grid overlay
		public static const CELL_SIZE:uint = 50;
		public static const MAP_ROWS:uint = 13;
		public static const MAP_COLUMNS:uint = 20;
		public static const STARTING_X = -4;
		public static const STARTING_Y = 0;

		//current player position and enemy list
		public static var playerPos:Point = new Point();
		public static var enemyList:Array = new Array();
		
		//playable area, grid, and base
		public static var playable;
		public static var levelGrid;
		public static var levelBase;
		
		//container arrays
		public static var splatArray:Array = new Array();
		public static var droppedItemArray:Array = new Array();
		
		//dmg factors and other upgradables
		public static var pDmgFactor:Number = 1;
		public static var sDmgFactor:Number = 1;
		public static var sSpdFactor:Number = 1;
		public static var sSplashFactor:Number = 1;
		public static var pHealthFactor:Number = 1;
		public static var sRes:int = 5;
		public static var aRes:int = 0;
		public static var aClip:int = 3;
		public static var guardian:Boolean = false;
		public static var speedFactor:Number = 1;
		public static var DmgReceivedFactor:Number = 1;
		public static var difficultyFactor:Number = 1;

		//PRIVATE VARS 
		
		//interface elements
		private var ui:InterfaceElements;

		//armory screen
		private var armory:ArmoryScreen;
		
		//enemy, PC
		private var alien:Enemy;
		private var robo:Player;
		private var playerSpawn:Point;
		private var roboDeath:RoboDeath;
		private var _currentPrimary;
		private var _currentSecondary;

		//next wave counter, spawn timer
		private var nextWave:int = 30;
		private var waveTimer:Timer;
		private var spawnTimer:Timer;

		//*important for accessing static level data including grid values, level backgrounds, playable areas, and wave spawn info
		private var levelData:LevelData = new LevelData();
		private var thisLevelIndex:int;
		private var levelcard:FLVPlayback;
		
		//sounds
		private var warp:Sound = new Warp();
		private var powerDown:Sound = new PowerDown();
		private var victory:Sound = new VictoryMusic();
		private var soundMusic:SoundMusicBtns;
		
		//death screen
		private var deathScreenTimer:Timer;
		private var fade:FadeToBlack;
		private var fadeTween:Tween;
		private var arcade:Font = new Arcade();
		private var deathTextFormat:TextFormat = new TextFormat(arcade.fontName, 48, 0xF45551, false, false, false,
																null, null, "center");
		private var deathText:TextField;
		private var deathTextGlow:GlowFilter = new GlowFilter(0xFFFFFF, .75, 6, 6, 2, 3);
		private var replayBtn:ReplayButton;
		
		//win screen
		private var win:WinScreen;
		private var winTextFormat:TextFormat = new TextFormat(arcade.fontName, 42, 0x000066);
		private var winTextField:TextField = new TextField();
		private var winTextGlow:GlowFilter = new GlowFilter(0xFFFFFF, 1, 8, 8, 2, 3);
		
		//3rd level special vars
		private var greenTween:Tween;
		private var greenTween2:Tween;
		private var thisTop;
		private var top1:block1 = new block1();
		private var top2:block2 = new block2();
		private var top3:block3 = new block3();
		private var top4:block4 = new block4();
		private var top5:block5 = new block5();
		private var greenTimer:Timer;

		//CONSTRUCTOR - instantiates armory screen & button listener
		public function RobotStart() {
			armory = new ArmoryScreen();
			addChild(armory);
			armory.addEventListener("armoryComplete", levelCard);
		}//end constructor
		
		private function levelCard(e:Event){
			armory.removeEventListener("armoryComplete", levelCard);
			removeChild(armory);
			thisLevelIndex = InterfaceElements.currentLevel-1;
			levelcard = new FLVPlayback;
			levelcard.width = 978;
			levelcard.height = 660;
			levelcard.source = levelData.levelCardArray[thisLevelIndex];
			addChild(levelcard);
			levelcard.addEventListener(MetadataEvent.CUE_POINT, beginLevel);
		}

		//instantiates new level, removes armory screen
		private function beginLevel(e:MetadataEvent):void {

			levelcard.removeEventListener(MetadataEvent.CUE_POINT, beginLevel);
			removeChild(levelcard);
			
			addEventListener("enemyDied", removeEnemy);
			addEventListener("playerDied", playerDeath);
			stage.addEventListener(Event.ENTER_FRAME, updatePos);
			
			//check for guardian angel upgrade
			if(InterfaceElements.purchasedArray[19]){
				guardian = true;
			}
			else{guardian = false}
			
			//add invisible stage boundaries + grid
			playable = levelData.playableAreaArray[thisLevelIndex];
			addChild(playable);
			levelGrid = levelData.levelGridArray[thisLevelIndex];
			
			playerSpawn = levelData.playerSpawnArray[thisLevelIndex];
			robo = new Player(playerSpawn.x, playerSpawn.y);

			levelBase = (levelData.levelBaseArray[thisLevelIndex]);
			addChild(levelBase);
			addChild(robo);
			addChild(levelData.levelWallTopsArray[thisLevelIndex]);
			
			//special conditional for 3rd level only (not quite working, tweens getting garbage-collected mid-tween
			if(thisLevelIndex == 2){
				
				top1.g0 = top1.gg = top2.g0 = top2.gg = top3.g0 = top3.gg = top4.g0 = top4.gg = top5.g0 = top5.gg = 0;
				top1.g1 = top2.g1 = top3.g1 = top4.g1 = top5.g1 = 200;
				
				top1.x = 146; top1.y = 150; addChild(top1);
				top2.x = 296; top2.y = 399.95; addChild(top2);
				top3.x = 496; top3.y = 99.95; addChild(top3);
				top4.x = 696; top4.y = 299.95; addChild(top4);
				top5.x = 696; top5.y = 149.95; addChild(top5);

				greenTimer = new Timer(Math.random()*4000 + 2000);
				greenTimer.start();
				greenTimer.addEventListener(TimerEvent.TIMER, greenify);

				
			} //end if for 3rd level
			
			ui = new InterfaceElements();
			addChild(ui);
			ui.waveTxt();

			//gives stage focus
			stage.stageFocusRect = false;
			stage.focus = stage;

			//timer for wave spawning
			spawnTimer = levelData.spawnTimersArray[thisLevelIndex]
													[InterfaceElements.currentWave-1];
			spawnTimer.reset();
			spawnTimer.start();
			spawnTimer.addEventListener(TimerEvent.TIMER, spawnEnemy);
			spawnTimer.addEventListener(TimerEvent.TIMER_COMPLETE, removeTimer);
			
			//timer 'til next wave
			waveTimer = new Timer(1000);
			waveTimer.start();
			waveTimer.addEventListener(TimerEvent.TIMER, updateWaveCounter);
			
			//listen for endLevel event dispatched from InterfaceElements class
			addEventListener("endLevel", endLevel);
			
			//set damage factors
			switch(InterfaceElements.currentPrimary){
				case("p1"):
					pDmgFactor = 1;
					break;
				case("p2"):
					pDmgFactor = 1.3;
					break;
				case("p3"):
					pDmgFactor = 1.6;
					break;
				case("p4"):
					pDmgFactor = 2;
					break;
			}
			
			switch(InterfaceElements.currentSecondary){
				case("s1"):
					sDmgFactor = 1;
					sSpdFactor = 1;
					sSplashFactor = 1;
					break;
				case("s2"):
					sDmgFactor = 1.2;
					sSpdFactor = 1.05;
					sSplashFactor = 1.1;
					break;
				case("s3"):
					sDmgFactor = 1.4;
					sSpdFactor = 1.1;
					sSplashFactor = 1.2;
					break;
				case("s4"):
					sDmgFactor = 1.8;
					sSpdFactor = 1.2;
					sSplashFactor = 1.5;
					break;
			}
			
			trace("Primary: " + InterfaceElements.currentPrimary + " " + pDmgFactor);
			trace("Secondary: " + InterfaceElements.currentSecondary + " " + sDmgFactor + " " + 
				  sSpdFactor + " " + sSplashFactor);
			trace("Player Health: " + robo.playerHealthCurrent);
			trace("Player Speed: " + robo.movementSpeed);
			trace("Player Dmg Received: " + DmgReceivedFactor);
			trace("Purchased Array: " + InterfaceElements.purchasedArray);
			trace("Cached Purchase Array: " + InterfaceElements.cachedPurchases);

		}//end beginLevel
		
		//greenify function for 3rd level
		private function greenify(t:TimerEvent):void{
					
			var topArray:Array = [top1, top2, top3, top4, top5];
			thisTop = topArray[Math.floor(Math.random()*5)];
			greenTween = new Tween(thisTop, "gg", Strong.easeIn, thisTop.g0, thisTop.g1, 30, false);
			greenTween.addEventListener(TweenEvent.MOTION_CHANGE, setColor);
			greenTween.addEventListener(TweenEvent.MOTION_FINISH, removeTween1);
			
			function setColor(e:TweenEvent):void{
				thisTop.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, thisTop.gg, 0, 0);
			}
			
			function removeTween1(e:TweenEvent):void{
				greenTween.removeEventListener(TweenEvent.MOTION_CHANGE, setColor);
				greenTween.removeEventListener(TweenEvent.MOTION_FINISH, removeTween1);
				greenTween2 = new Tween(thisTop, "gg", Strong.easeOut, thisTop.g1, thisTop.g0, 180, false);
				greenTween2.addEventListener(TweenEvent.MOTION_CHANGE, removeColor);
				greenTween2.addEventListener(TweenEvent.MOTION_FINISH, removeTween2);		
			}
			
			function removeColor(e:TweenEvent){
				thisTop.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, thisTop.gg, 0, 0);
			}
			
			function removeTween2(e:TweenEvent){
				greenTween2.removeEventListener(TweenEvent.MOTION_CHANGE, removeColor);
				greenTween2.removeEventListener(TweenEvent.MOTION_FINISH, removeTween2);
				greenTimer = new Timer(Math.random()*4000 + 2000);
			}
			
		} //end greenify
		
		//important for accessing data from the Player and Enemy classes
		public static function getPlayerPos():Point {
			return playerPos;
		}
		
		//updates player position every frame
		public function updatePos(e:Event):void {
			playerPos.x = robo.playerX;
			playerPos.y = robo.playerY;
		}
		
		//establishes spawn points, spawns enemies at random gates based on spawnTimer interval
		private function spawnEnemy(t:TimerEvent):void {
			var gateRandom:Point = levelData.spawnPointArray[thisLevelIndex]
			[Math.floor(Math.random() * levelData.spawnPointArray[thisLevelIndex].length)];
			
			var thisType:String = levelData.percentagizer(levelData.percentageArray[thisLevelIndex]
														  [InterfaceElements.currentWave-1]);
			trace(thisType + " spawned");
			trace(spawnTimer.currentCount, spawnTimer.delay, spawnTimer.repeatCount);
			
			alien = new Enemy(gateRandom.x, gateRandom.y, robo, thisType);
			addChildAt(alien, (getChildIndex(robo)));
			
			if(SoundMusicBtns.soundOn){warp.play()}
			enemyList.push(alien);

		} //end spawnEnemy
			
		private function removeTimer(t:TimerEvent):void{
			spawnTimer.reset();
			spawnTimer.removeEventListener(TimerEvent.TIMER, spawnEnemy);
			spawnTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, removeTimer);
		}

		public static function enemyTarget():Array{
			return enemyList;
		}
		
		//removes enemy from list when killed as well as the associated display object
		//the data event sends the index position for the enemy that was killed
		private function removeEnemy(e:DataEvent):void{
			var enemyArrayIndex:int = new int(e.data);
			removeChildAt(getChildIndex(enemyList[enemyArrayIndex]));
			enemyList.splice(enemyArrayIndex, 1);
		}
		
		//time until next wave
		private function updateWaveCounter(t:TimerEvent):void{
			
			if(nextWave >= 0){
				InterfaceElements.updateWave(nextWave);
				nextWave--; 
			}
			
			//start new wave
			else if((nextWave < 0) && (InterfaceElements.currentWave < levelData.waveCountArray[thisLevelIndex])){
				nextWave = 30;
				InterfaceElements.currentWave++;
				InterfaceElements.updateWave(nextWave);
				nextWave--;
				spawnTimer = levelData.spawnTimersArray[thisLevelIndex]
				[InterfaceElements.currentWave-1];
				spawnTimer.reset();
				spawnTimer.start();
				spawnTimer.addEventListener(TimerEvent.TIMER, spawnEnemy);
				spawnTimer.addEventListener(TimerEvent.TIMER_COMPLETE, removeTimer);
				ui.waveTxt();
			}
			
			//if final wave is over
			else{
				waveTimer.reset();
				waveTimer.removeEventListener(TimerEvent.TIMER, updateWaveCounter);
				stage.addEventListener(Event.ENTER_FRAME, levelClearCheck);
			}
			
		} //end updateWaveCounter
		
		private function levelClearCheck(e:Event):void{
			if(enemyList.length == 0){
				ui.levelCleared();
				stage.removeEventListener(Event.ENTER_FRAME, levelClearCheck);
			}
		}
		
		private function endLevel(e:Event):void{
			trace('level ended');

			//stop any running timers
			spawnTimer.reset();
			if(spawnTimer.hasEventListener(TimerEvent.TIMER)){
			   spawnTimer.removeEventListener(TimerEvent.TIMER, spawnEnemy)
			   }
			if(spawnTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)){
			   spawnTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, removeTimer);
			   }
			waveTimer.reset();
			if(waveTimer.hasEventListener(TimerEvent.TIMER)){
				waveTimer.removeEventListener(TimerEvent.TIMER, updateWaveCounter);  
				}
			if(InterfaceElements.currentLevel == 3){
				greenTimer.reset();
				greenTimer.removeEventListener(TimerEvent.TIMER, greenify);
			}
			waveTimer = null;
			spawnTimer = null;
			greenTimer = null;
			
			//remove all display objects from stage
			removeChild(playable);
			removeChild(levelBase);
			if(this.contains(robo)){removeChild(robo)}
			removeChild(levelData.levelWallTopsArray[thisLevelIndex]);
			removeChild(ui);
			
			trace("children before loop: " + this.numChildren);
			while(this.numChildren > 0){
				removeChildAt(0);
			}
			trace("children after loop: " + this.numChildren);
			
			//remove event listeners
			removeEventListener("enemyDied", removeEnemy);
			removeEventListener("endLevel", endLevel);
			removeEventListener("playerDied", playerDeath);
			stage.removeEventListener(Event.ENTER_FRAME, updatePos);

			//increment level counter, reset ammo, and cache variables so they may be recalled if level is restarted
			enemyList = [];
			splatArray = [];
			InterfaceElements.currentLevel++;
			InterfaceElements.currentWave = 1;
			InterfaceElements.primaryClip = 18;
			InterfaceElements.secondaryClip = 5;
			InterfaceElements.secondaryRes = sRes;
			InterfaceElements.accClip = aClip;
			InterfaceElements.accessoryRes = aRes;
			nextWave = 30;
			
			InterfaceElements.cachedCredits = InterfaceElements.credits;
			InterfaceElements.cachedScore = InterfaceElements.score;
			InterfaceElements.cachedPrimary = InterfaceElements.currentPrimary;
			InterfaceElements.cachedSecondary = InterfaceElements.currentSecondary;
			InterfaceElements.cachedAccessory = InterfaceElements.currentAccessory;
			InterfaceElements.cachedPurchases = InterfaceElements.purchasedArray;
			InterfaceElements.cachedSecRes = sRes;
			InterfaceElements.cachedAccClip = aClip;
			InterfaceElements.cachedAccRes = aRes;
			InterfaceElements.cachedPlayerHealthFactor = pHealthFactor;
			InterfaceElements.cachedPlayerDmgReceivedFactor = DmgReceivedFactor;
			InterfaceElements.cachedPlayerSpeedFactor = speedFactor;
			
			
			if(InterfaceElements.currentLevel < 5){
				//bring back armory screen
				armory = new ArmoryScreen();
				addChild(armory);
				armory.addEventListener("armoryComplete", levelCard);
			}
			else{
				win = new WinScreen();
				addChild(win);
				
				winTextField.defaultTextFormat = winTextFormat;
				winTextField.embedFonts = true;
				winTextField.x = 400;
				winTextField.y = 225;
				winTextField.selectable = false;
				winTextField.multiline = false;
				winTextField.autoSize = TextFieldAutoSize.CENTER;
				winTextField.filters = [winTextGlow];
				winTextField.text = String(InterfaceElements.score);
				addChild(winTextField);
				
				soundMusic = new SoundMusicBtns(victory);
				stage.addChild(soundMusic);
			}
		}
		
		private function playerDeath(e:DataEvent):void{
			
			//death animation
			_currentPrimary = robo.currentP;
			_currentSecondary = robo.currentS;
			if(SoundMusicBtns.soundOn){powerDown.play()}
			var deathPoint:Point = getPlayerPos();
			roboDeath = new RoboDeath();
			roboDeath.x = deathPoint.x;
			roboDeath.y = deathPoint.y;
			roboDeath.rotation = int(e.data);
			removeChild(robo);
			stage.addChild(roboDeath);
			_currentPrimary.x = 11.35;
			_currentPrimary.y = 18;
			_currentPrimary.scaleX = _currentPrimary.scaleY = 0.213;
			_currentSecondary.x = 11.35;
			_currentSecondary.y = -18;
			_currentSecondary.scaleX = _currentSecondary.scaleY = 0.2;
			roboDeath.addChildAt(_currentPrimary, (stage.getChildIndex(roboDeath)));
			roboDeath.addChildAt(_currentSecondary, (stage.getChildIndex(roboDeath)));

			//stop any running timers
			waveTimer.reset();
			spawnTimer.reset();
			if(spawnTimer.hasEventListener(TimerEvent.TIMER)){
			   spawnTimer.removeEventListener(TimerEvent.TIMER, spawnEnemy)
			   }
			if(spawnTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)){
			   spawnTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, removeTimer);
			   }
			if(waveTimer.hasEventListener(TimerEvent.TIMER)){
				waveTimer.removeEventListener(TimerEvent.TIMER, updateWaveCounter);  
				}
			if(thisLevelIndex == 2){
				greenTimer.reset();
				greenTimer.removeEventListener(TimerEvent.TIMER, greenify);
			}
			waveTimer = null;
			spawnTimer = null;
			greenTimer = null;
			
			deathScreenTimer = new Timer(3000, 1);
			deathScreenTimer.start();
			deathScreenTimer.addEventListener(TimerEvent.TIMER_COMPLETE, deathScreenFade);
		} //end playerDeath
		
		private function deathScreenFade(t:TimerEvent):void{
			deathScreenTimer.reset();
			deathScreenTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, deathScreenFade);
			deathScreenTimer = null;
			fade = new FadeToBlack;
			fade.alpha = 0;
			stage.addChild(fade);
			fadeTween = new Tween(fade, "alpha", Strong.easeOut, 0, 1, 1, true);
			fadeTween.FPS = 15;
			fadeTween.addEventListener(TweenEvent.MOTION_FINISH, deathScreen);
		}
		
		private function deathScreen(e:TweenEvent):void{
			fadeTween.removeEventListener(TweenEvent.MOTION_FINISH, deathScreen);
			deathText = new TextField();
			deathText.defaultTextFormat = deathTextFormat;
			deathText.embedFonts = true;
			deathText.autoSize = TextFieldAutoSize.CENTER;
			deathText.x = stage.stageWidth * 0.5;
			deathText.y = stage.stageHeight * 0.3;
			deathText.multiline = true;
			deathText.selectable = false;
			deathText.filters = [deathTextGlow];
			deathText.text = "YOU DIED.\n\nYOUR SCORE WAS:\n\n" + InterfaceElements.score;
			stage.addChild(deathText);
			
			replayBtn = new ReplayButton();
			replayBtn.gotoAndStop(1);
			replayBtn.x = stage.stageWidth * 0.5;
			replayBtn.y = deathText.y + deathText.height + 130;
			replayBtn.scaleX = replayBtn.scaleY = 0.9;
			replayBtn.buttonMode = true;
			stage.addChild(replayBtn);
			
			replayBtn.addEventListener(MouseEvent.ROLL_OVER, mouseOverReplay);
			replayBtn.addEventListener(MouseEvent.ROLL_OUT, mouseOutReplay);
			replayBtn.addEventListener(MouseEvent.CLICK, restartLevel);
		}
		
		private function mouseOverReplay(e:MouseEvent):void{replayBtn.gotoAndStop(2)}
		private function mouseOutReplay(e:MouseEvent):void{replayBtn.gotoAndStop(1)}
		
		private function restartLevel(e:MouseEvent = null):void{
			
			replayBtn.removeEventListener(MouseEvent.ROLL_OVER, mouseOverReplay);
			replayBtn.removeEventListener(MouseEvent.ROLL_OUT, mouseOutReplay);
			replayBtn.removeEventListener(MouseEvent.CLICK, restartLevel);
			
			//remove event listeners
			removeEventListener("enemyDied", removeEnemy);
			removeEventListener("endLevel", endLevel);
			removeEventListener("playerDied", playerDeath);
			stage.removeEventListener(Event.ENTER_FRAME, updatePos);
			
			//clear stage
			stage.removeChild(deathText);
			stage.removeChild(replayBtn);
			stage.removeChild(fade);
			stage.removeChild(roboDeath);
			
			trace("children before loop: " + this.numChildren);
			while(this.numChildren > 0){
				removeChildAt(0);
			}
			trace("children after loop: " + this.numChildren);
			
			//reset variables
			enemyList = [];
			splatArray = [];
			nextWave = 30;
			InterfaceElements.currentWave = 1;
			InterfaceElements.primaryClip = 18;
			InterfaceElements.secondaryClip = 5;
			InterfaceElements.secondaryRes = 5;
			InterfaceElements.credits = InterfaceElements.cachedCredits;
			InterfaceElements.score = InterfaceElements.cachedScore;
			InterfaceElements.currentPrimary = InterfaceElements.cachedPrimary;
			InterfaceElements.currentSecondary = InterfaceElements.cachedSecondary;
			InterfaceElements.currentAccessory = InterfaceElements.cachedAccessory;
			InterfaceElements.purchasedArray = InterfaceElements.cachedPurchases;
			InterfaceElements.secondaryRes = InterfaceElements.cachedSecRes;
			InterfaceElements.accClip = InterfaceElements.cachedAccClip;
			InterfaceElements.accessoryRes = InterfaceElements.cachedAccRes;
			pHealthFactor = InterfaceElements.cachedPlayerHealthFactor;
			DmgReceivedFactor = InterfaceElements.cachedPlayerDmgReceivedFactor;
			speedFactor = InterfaceElements.cachedPlayerSpeedFactor;
			
			//return armory
			armory = new ArmoryScreen();
			addChild(armory);
			armory.addEventListener("armoryComplete", levelCard);
		}
	
	}//end public class
}//end package