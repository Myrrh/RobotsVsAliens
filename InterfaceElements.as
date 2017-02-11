package  {
	
	import flash.display.*;
	import flash.text.*;
	import flash.geom.*;
	import flash.filters.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.utils.*;
	import flash.events.*;
	
	public class InterfaceElements extends Sprite {
		
		// PUBLIC VARS
		
		public static var nextWaveCounter:int = 0;
		public static var credits:int = 0;
		public static var score:int = 0;
		public static var currentLevel:int = 1;
		public static var currentWave:int = 1;
		public static var primaryClip:int = 18;
		public static var secondaryClip:int = 5;
		public static var secondaryRes:int = RobotStart.sRes;
		public static var accClip:int = RobotStart.aClip;
		public static var accessoryRes:int = RobotStart.aRes;
		public static var currentPrimary:String = "p1";
		public static var currentSecondary:String = "s1";
		public static var currentAccessory:String = "";
		public static var purchasedArray:Array = [
												  true, false, false, false, //primary weapons
												  true, false, false, false, //secondary weapons
												  false, false, false, false, false, false, //accessories
												  false, false, false, false, false, false //upgrades
												 ];
		
		//data caching for level replay
		public static var cachedCredits:int = 0;
		public static var cachedScore:int = 0;
		public static var cachedPrimary:String = "p1";
		public static var cachedSecondary:String = "s1";
		public static var cachedAccessory:String = "";
		public static var cachedPurchases:Array = [
												  true, false, false, false, //primary weapons
												  true, false, false, false, //secondary weapons
												  false, false, false, false, false, false, //accessories
												  false, false, false, false, false, false //upgrades
												 ];
		public static var cachedSecRes:int = 5;
		public static var cachedAccClip:int = 3;
		public static var cachedAccRes:int = 0;
		public static var cachedPlayerHealthFactor:Number = 1;
		public static var cachedPlayerSpeedFactor:Number = 1;
		public static var cachedPlayerDmgReceivedFactor:Number = 1;
		
		// PRIVATE VARS
		
		//text fields
		private static var waveCount:TextField = new TextField();
		private static var credCount:TextField = new TextField();
		private static var scoreCount:TextField = new TextField();
		private static var levelCount:TextField = new TextField();
		
		//dynamic ammo containers
		private static var primaryAmmo:Sprite = new Sprite();
		private static var secondaryAmmo:Sprite = new Sprite();
		private static var accessoryAmmo:Sprite = new Sprite();
	
		//fonts
		private var neuro:Font = new Neuropol();
		private var moon:Font = new Moonmonkey();
		private var verdana:Font = new Verdana();
		
		//filters
		private var iGlow:GlowFilter = new GlowFilter(0xFFFFFF, 1, 5, 5, 2);
		private var reserveGlow:GlowFilter = new GlowFilter(0x000000, 1, 2, 2, 5, 3);
		private var waveGlow:GlowFilter = new GlowFilter(0xFFF100, 0.75, 10, 10, 2, 3);
		private var counterShadow:DropShadowFilter = new DropShadowFilter(1, 45, 0xFFFFFF, 0.75, 1, 1, 2, 3);
		private var waveShadow:DropShadowFilter = new DropShadowFilter(4, 45, 0x000000, 0.75, 4, 4, 1, 3);
		
		//text formats
		private var counterText:TextFormat = new TextFormat(verdana.fontName, 18, 0x000000, true, false, false);
		private var reserveText:TextFormat = new TextFormat(verdana.fontName, 18, 0xFFFFFF, true, false, false);
		private var interfaceText:TextFormat = new TextFormat(moon.fontName, 20, 0x000000, true, false, false);
		private var waveText:TextFormat = new TextFormat(neuro.fontName, 72, 0xFFFFFF, true, false, false);
		
		//text fields
		private var primaryFld:TextField = new TextField();
		private var primaryReserve:TextField = new TextField();
		private var secondaryFld:TextField = new TextField();
		private static var secondaryReserve:TextField = new TextField();
		private var accFld:TextField = new TextField();
		private static var accessoryReserve:TextField = new TextField();
		private var waveFld:TextField = new TextField();
		private var credFld:TextField = new TextField();
		private var scoreFld:TextField = new TextField();
		private var levelFld:TextField = new TextField();
		
		//misc
		private static var endLevelTimer:Timer;
		private var waveTxtTween:Tween;
		private var iBar:InterfaceBar;
		private var soundMusic:SoundMusicBtns;
		

		public function InterfaceElements() {
			
			iBar = new InterfaceBar();
			iBar.x = 0;
			iBar.y = 617;
			addChild(iBar);
			
			var randomTrack:int = Math.floor(Math.random()*LevelData.musicArray.length);
			soundMusic = new SoundMusicBtns(LevelData.musicArray[randomTrack]);
			addChild(soundMusic);
			
			//static text styling and placement
			primaryFld.embedFonts = true;
			primaryFld.defaultTextFormat = interfaceText;
			primaryFld.x = 30;
			primaryFld.y = 3;
			primaryFld.autoSize = TextFieldAutoSize.LEFT;
			primaryFld.multiline = false;
			primaryFld.text = "primary";
			primaryFld.selectable = false;
			primaryFld.filters = [iGlow];
			
			primaryReserve.embedFonts = true;
			primaryReserve.defaultTextFormat = reserveText;
			primaryReserve.x = primaryFld.width + primaryFld.x + 5;
			primaryReserve.y = primaryFld.y - 5;
			primaryReserve.autoSize = TextFieldAutoSize.LEFT;
			primaryReserve.multiline = false;
			primaryReserve.text = "x ∞";
			primaryReserve.selectable = false;
			primaryReserve.filters = [reserveGlow];
			
			secondaryFld.embedFonts = true;
			secondaryFld.defaultTextFormat = interfaceText;
			secondaryFld.x = 160;
			secondaryFld.y = 3;
			secondaryFld.autoSize = TextFieldAutoSize.LEFT;
			secondaryFld.multiline = false;
			secondaryFld.text = "secondary";
			secondaryFld.selectable = false;
			secondaryFld.filters = [iGlow];
			
			secondaryReserve.embedFonts = true;
			secondaryReserve.defaultTextFormat = reserveText;
			secondaryReserve.x = secondaryFld.width + secondaryFld.x + 5;
			secondaryReserve.y = secondaryFld.y - 3;
			secondaryReserve.autoSize = TextFieldAutoSize.LEFT;
			secondaryReserve.multiline = false;
			secondaryReserve.text = "x " + secondaryRes;
			secondaryReserve.selectable = false;
			secondaryReserve.filters = [reserveGlow];

			accFld.embedFonts = true;
			accFld.defaultTextFormat = interfaceText;
			accFld.x = 325;
			accFld.y = 3;
			accFld.autoSize = TextFieldAutoSize.LEFT;
			accFld.multiline = false;
			accFld.text = "accessories";
			accFld.selectable = false;
			accFld.filters = [iGlow];
			
			accessoryReserve.embedFonts = true;
			accessoryReserve.defaultTextFormat = reserveText;
			accessoryReserve.x = accFld.width + accFld.x + 5;
			accessoryReserve.y = accFld.y - 3;
			accessoryReserve.autoSize = TextFieldAutoSize.LEFT;
			accessoryReserve.multiline = false;
			accessoryReserve.text = "x " + accessoryRes;
			accessoryReserve.selectable = false;
			accessoryReserve.filters = [reserveGlow];

			waveFld.embedFonts = true;
			waveFld.defaultTextFormat = interfaceText;
			waveFld.x = 480;
			waveFld.y = 3;
			waveFld.autoSize = TextFieldAutoSize.LEFT;
			waveFld.multiline = false;
			waveFld.text = "next wave";
			waveFld.selectable = false;
			waveFld.filters = [iGlow];
			
			credFld.embedFonts = true;
			credFld.defaultTextFormat = interfaceText;
			credFld.x = 620;
			credFld.y = 3;
			credFld.autoSize = TextFieldAutoSize.LEFT;
			credFld.multiline = false;
			credFld.text = "credits";
			credFld.selectable = false;
			credFld.filters = [iGlow];
			
			scoreFld.embedFonts = true;
			scoreFld.defaultTextFormat = interfaceText;
			scoreFld.x = 760;
			scoreFld.y = 3;
			scoreFld.autoSize = TextFieldAutoSize.LEFT;
			scoreFld.multiline = false;
			scoreFld.text = "score";
			scoreFld.selectable = false;
			scoreFld.filters = [iGlow];
			
			levelFld.embedFonts = true;
			levelFld.defaultTextFormat = interfaceText;
			levelFld.x = 890;
			levelFld.y = 3;
			levelFld.autoSize = TextFieldAutoSize.LEFT;
			levelFld.multiline = false;
			levelFld.text = "level";
			levelFld.selectable = false;
			levelFld.filters = [iGlow];
			
			//dynamic visual counters
			primaryAmmo.x = primaryFld.x - 15;
			primaryAmmo.y = primaryFld.y + 22;
			
			secondaryAmmo.x = secondaryFld.x + 10;
			secondaryAmmo.y = secondaryFld.y + 28;
			
			accessoryAmmo.x = accFld.x + 10;
			accessoryAmmo.y = accFld.y + 28;

			//dynamic text counters

			waveCount.defaultTextFormat = counterText;
			waveCount.embedFonts = true;
			waveCount.x = waveFld.x;
			waveCount.y = waveFld.y + 16;
			waveCount.autoSize = TextFieldAutoSize.CENTER;
			waveCount.multiline = false;
			waveCount.text = String(nextWaveCounter);
			waveCount.selectable = false;
			waveCount.filters = [counterShadow];
			
			credCount.defaultTextFormat = counterText;
			credCount.embedFonts = true;
			credCount.width = 75;
			credCount.x = credFld.x;
			credCount.y = credFld.y + 16;
			credCount.autoSize = TextFieldAutoSize.RIGHT;
			credCount.multiline = false;
			credCount.text = "000000" + String(credits);
			credCount.selectable = false;
			credCount.filters = [counterShadow];
			
			scoreCount.defaultTextFormat = counterText;
			scoreCount.embedFonts = true;
			scoreCount.width = 75;
			scoreCount.x = scoreFld.x;
			scoreCount.y = scoreFld.y + 16;
			scoreCount.autoSize = TextFieldAutoSize.RIGHT;
			scoreCount.multiline = false;
			scoreCount.text = "000000" + String(score);
			scoreCount.selectable = false;
			scoreCount.filters = [counterShadow];
			
			levelCount.defaultTextFormat = counterText;
			levelCount.embedFonts = true;
			levelCount.x = levelFld.x + 10;
			levelCount.y = levelFld.y + 16;
			levelCount.autoSize = TextFieldAutoSize.LEFT;
			levelCount.multiline = false;
			levelCount.text = "0" + String(currentLevel);
			levelCount.selectable = false;
			levelCount.filters = [counterShadow];
			
			iBar.addChild(primaryFld);
			iBar.addChild(primaryReserve);
			iBar.addChild(primaryAmmo);
			iBar.addChild(secondaryFld);
			iBar.addChild(secondaryReserve);
			iBar.addChild(secondaryAmmo);
			iBar.addChild(waveFld);
			iBar.addChild(waveCount);
			iBar.addChild(accFld);
			iBar.addChild(accessoryReserve);
			iBar.addChild(accessoryAmmo);
			iBar.addChild(credFld);
			iBar.addChild(credCount);
			iBar.addChild(scoreFld);
			iBar.addChild(scoreCount);
			iBar.addChild(levelFld);
			iBar.addChild(levelCount);
			
			updateCredits(0);
			updateScore(0);
			updateLevel();
			updatePrimary();
			updateSecondary();
			updateAccessory();
			updateWave(30);

		} //end constructor

	public static function updatePrimary():void{
		
		primaryAmmo.graphics.clear();
		
		for(var i:int = 0; i < primaryClip; i++){
			primaryAmmo.graphics.lineStyle(2, 0x000000);
			primaryAmmo.graphics.beginFill(0xFFFFFF);
			primaryAmmo.graphics.drawRect(i*7, 0, 5, 13);
			primaryAmmo.graphics.endFill();
		}
	}
	
	public static function updateSecondary():void{
		
		for(var c:int = secondaryAmmo.numChildren; c > 0; c--){
			secondaryAmmo.removeChildAt(0);
		} 
		
		for(var i:int = 0; i < secondaryClip; i++){
			var missileIcon:Missile = new Missile();
			missileIcon.scaleX = missileIcon.scaleY = 0.7;
			missileIcon.x = 0 + i*30;
			missileIcon.y = 0;
			secondaryAmmo.addChild(missileIcon);
		}
		
		secondaryReserve.replaceText(0, secondaryReserve.length, "x " + secondaryRes);
	}
	
	public static function updateAccessory():void{
		
		for(var d:int = accessoryAmmo.numChildren; d > 0; d--){
			accessoryAmmo.removeChildAt(0);
		}
		
		var hasAccessory:Boolean = true;
		
		for(var i:int = 0; i < accClip; i++){
			var accIcon;
			switch(currentAccessory){
				case("a1"):
					accIcon = new Accessory1();
					accIcon.gotoAndStop(1);
					break;
				case("a2"):
					accIcon = new Accessory2();
					accIcon.gotoAndStop(1);
					break;
				case("a3"):
					accIcon = new Accessory3();
					accIcon.gotoAndStop(1);
					break;
				case("a4"):
					accIcon = new Accessory4();
					accIcon.gotoAndStop(1);
					break;
				case("a5"):
					accIcon = new Accessory5();
					accIcon.gotoAndStop(1);
					break;
				case("a6"):
					accIcon = new Accessory6();
					accIcon.gotoAndStop(1);
					break;
				default:
					hasAccessory = false;
					break;
			}
			if(hasAccessory){
				accIcon.scaleX = accIcon.scaleY = 0.5;
				accIcon.x = 0 + i*25;
				accIcon.y = 0;
				accessoryAmmo.addChild(accIcon);
			}
		}
		
		accessoryReserve.replaceText(0, accessoryReserve.length, "x " + accessoryRes);
	}

	public static function updateWave(wave:int):void{
		var zeroes:String = new String();
		nextWaveCounter = wave;
		
		if(String(nextWaveCounter).length < 2){
			for(var i:int = 0; i < 2-String(nextWaveCounter).length; i++){
				zeroes += "0";
			}
		}
		
		waveCount.replaceText(0, waveCount.length, (zeroes + String(nextWaveCounter)));
	}
	
	public function waveTxt():void{
		var waveFld:TextField = new TextField();
		waveFld.embedFonts = true;
		waveFld.defaultTextFormat = waveText;
		waveFld.autoSize = TextFieldAutoSize.LEFT;
		waveFld.multiline = false;
		waveFld.text = "WAVE " + String(currentWave);
		waveFld.selectable = false;
		waveFld.filters = [waveShadow, waveGlow];
		waveFld.x = stage.stageWidth * 0.5 - (waveFld.width * 0.5);
		waveFld.y = stage.stageHeight * 0.5 - (waveFld.height * 0.5);
		addChild(waveFld);
		
		waveTxtTween = new Tween(waveFld, "alpha", Strong.easeIn, 1, 0, 2, true);
		waveTxtTween.FPS = 15;
		
		waveTxtTween.addEventListener(TweenEvent.MOTION_FINISH, removeWaveTxt);
		
		function removeWaveTxt():void{
			waveTxtTween.removeEventListener(TweenEvent.MOTION_FINISH, removeWaveTxt);
			removeChild(waveFld);
			stage.focus = stage;
		}
	}
	
	public function levelCleared():void{
		levelClearedText();
		endLevelTimer = new Timer(5000, 1);
		endLevelTimer.addEventListener(TimerEvent.TIMER_COMPLETE, endLevel);
		endLevelTimer.start();
	}
	
	private function endLevel(t:TimerEvent):void{
		endLevelTimer.reset();
		endLevelTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, endLevel);
		endLevelTimer = null;
		this.parent.dispatchEvent(new Event("endLevel", false, false));
	}
	
	private function levelClearedText():void{
		var clearFld:TextField = new TextField();
		clearFld.embedFonts = true;
		clearFld.defaultTextFormat = waveText;
		clearFld.autoSize = TextFieldAutoSize.LEFT;
		clearFld.multiline = false;
		clearFld.text = "LEVEL CLEARED!";
		clearFld.selectable = false;
		clearFld.filters = [waveShadow, waveGlow];
		clearFld.x = stage.stageWidth * 0.5 - (clearFld.width * 0.5);
		clearFld.y = stage.stageHeight * 0.5 - (clearFld.height * 0.5);
		addChild(clearFld);
		
		waveTxtTween = new Tween(clearFld, "alpha", Strong.easeIn, 1, 0, 2, true);
		
		waveTxtTween.addEventListener(TweenEvent.MOTION_FINISH, removeClearTxt);
		
		function removeClearTxt():void{
			waveTxtTween.removeEventListener(TweenEvent.MOTION_FINISH, removeClearTxt);
			removeChild(clearFld);
			stage.focus = stage;
		}
	}
	
	public static function updateCredits(cred:int):void{
		var zeroes:String = new String();
		credits += cred;
		
		if(String(credits).length < 7){
			for(var i:int = 0; i < 7-String(credits).length; i++){
				zeroes += "0";
			}
		}
		
		credCount.replaceText(0, credCount.length, (zeroes + String(credits)));
	}
	
	public static function updateScore(sco:int):void{
		var zeroes:String = new String();
		score += sco;
		
		if(String(score).length < 7){
			for(var i:int = 0; i < 7-String(score).length; i++){
				zeroes += "0";
			}
		}
		
		scoreCount.replaceText(0, scoreCount.length, (zeroes + String(score)));
	}
	
	public static function updateLevel():void{
		var zeroes:String = new String();
		
		if(String(currentLevel).length < 2){
			for(var i:int; i < 2-String(currentLevel).length; i++){
				zeroes += "0";
			}
		}
		
		levelCount.replaceText(0, levelCount.length, (zeroes + String(currentLevel)));
	}
	
	} //end class
} //end package