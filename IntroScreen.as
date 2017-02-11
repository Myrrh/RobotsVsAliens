package 
{
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.events.*;
	import fl.video.*;
	import fl.video.MetadataEvent;
	import flash.net.*;
	import flash.media.*;
	import flash.text.*;
	import flash.filters.DropShadowFilter;

	public class IntroScreen extends Sprite
	{
		public static var robots:Boolean = false;
		public static var aliens:Boolean = false;
		
		private var introBG:Loader = new Loader();
		private var introBGRequest:URLRequest;
		private var introVideo:FLVPlayback;
		
		private var robotStart:RobotStart = new RobotStart();
		private var instructions:InstructionSheet = new InstructionSheet();
		
		//menu buttons
		private var menuBack:menuBackButton;
		private var cred:credButton;
		private var instr:instrButton;
		private var playgame:playgameButton;
		private var choose:chooseButton;
		private var playRobots:playRobotsButton;
		private var playAliens:playAliensButton;
		
		//difficulty select screen
		private var difficultySelectLoad:Loader = new Loader();
		private var difficultySelectReq:URLRequest;
		private var easy:EasyButton = new EasyButton();
		private var normal:NormalButton = new NormalButton();
		private var hard:HardButton = new HardButton();
		private var insane:InsaneButton = new InsaneButton();
		
		//sound
		private var operational:Sound = new Operational();
		private var channel:SoundChannel = new SoundChannel();
		private var introMusic:Sound = new IntroMusic();
		private var musicChannel:SoundChannel = new SoundChannel();
		private var soundMusic:SoundMusicBtns;
		
		//text
		private var neuropol:Font = new Neuropol();
		private var consoleFormat:TextFormat = new TextFormat(neuropol.fontName, 16, 0x00CC33);
		private var myCreditFormat:TextFormat = new TextFormat(neuropol.fontName, 28, 0x00CC33);
		private var myCreditField:TextField = new TextField();
		private var consoleField:TextField = new TextField();
		private var consoleFieldCol2:TextField = new TextField();
		private var consoleShadow:DropShadowFilter = 
			new DropShadowFilter(2, 45, 0x000000, 1, 3, 3, 2.5, 3);
		
		public function IntroScreen(){
			
			//intro background
			introBGRequest = new URLRequest("extvideo/rvaintrobg.swf");
			introBG.load(introBGRequest);
			addChild(introBG);

			//intro animation
			introVideo = new FLVPlayback();
			introVideo.width = 978;
			introVideo.height = 660;
			introVideo.source = "extvideo/rvaintro2.flv";
			addChild(introVideo);
			introVideo.addEventListener(MetadataEvent.CUE_POINT, menuButtons);
			
			musicChannel = introMusic.play(0, 999);
			
			//instantiates/positions intro screen buttons;
			function menuButtons(eventObject:Object):void{
				menuBack = new menuBackButton();
				menuBack.x = 669;
				menuBack.y = 540;
					
				if (eventObject.info.name == "introComplete")
				{
					introVideo.pause();
					cred = new credButton();
					instr = new instrButton();
					playgame = new playgameButton();
					cred.x = 636;
					cred.y = 376;
					instr.x = 344;
					instr.y = 376;
					playgame.x = 488;
					playgame.y = 485;
	
					cred.addEventListener(MouseEvent.CLICK, viewCredits);
					instr.addEventListener(MouseEvent.CLICK, viewInstructions);
					playgame.addEventListener(MouseEvent.CLICK, chooseSide);
	
					stage.addChild(cred);
					stage.addChild(instr);
					stage.addChild(playgame);
				}
				
				//side panels animate in, "choose your side" appears
				else if (eventObject.info.name == "sidesOpen")
				{
					introVideo.pause();
					choose = new chooseButton();
					choose.x = 409;
					choose.y = 257;
	
					playRobots = new playRobotsButton();
					playRobots.gotoAndStop(2);
					playRobots.buttonMode = true;
					playRobots.x = 130;
					playRobots.y = 260;
	
					playAliens = new playAliensButton();
					playAliens.gotoAndStop(2);
					playAliens.buttonMode = true;
					playAliens.x = 660;
					playAliens.y = 260;
	
					playRobots.addEventListener(MouseEvent.CLICK, startGame);
					playRobots.addEventListener(MouseEvent.ROLL_OVER, highlightThis);
					playRobots.addEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
					//playAliens.addEventListener(MouseEvent.CLICK, startGame);
					playAliens.addEventListener(MouseEvent.ROLL_OVER, highlightThis);
					playAliens.addEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
	
					stage.addChild(choose);
					stage.addChild(playRobots);
					stage.addChild(playAliens);
				}
				//starts the game after choosing a side
				else if (eventObject.info.name == "sidesClosed")
				{
					difficultySelectScreen();
				}
				
				//on pressing cred button
				function viewCredits(e:MouseEvent):void
				{
					cred.enabled = cred.visible = false;
					instr.enabled = instr.visible = false;
					playgame.enabled = playgame.visible = false;
					
					if (stage.contains(menuBack) == false)
					{
						menuBack.addEventListener(MouseEvent.CLICK, returnToMenu);
						stage.addChild(menuBack);
					}
					else
					{
						menuBack.enabled = menuBack.visible = true;
					}
					
					myCreditField.x = 200;
					myCreditField.y = 280;
					myCreditField.multiline = false;
					myCreditField.selectable = false;
					myCreditField.embedFonts = true;
					myCreditField.defaultTextFormat = myCreditFormat;
					myCreditField.autoSize = TextFieldAutoSize.LEFT;
					myCreditField.filters = [consoleShadow];
					myCreditField.text = "Game Design by Michael C. Trombley";
					
					consoleField.x = 200;
					consoleField.y = 315;
					consoleField.multiline = true;
					consoleField.selectable = false;
					consoleField.embedFonts = true;
					consoleField.defaultTextFormat = consoleFormat;
					consoleField.autoSize = TextFieldAutoSize.LEFT;
					consoleField.filters = [consoleShadow];
					consoleField.text = "MUSIC: " +
					"\n\nBertycoX - Boom Project (ver 2)" +
					"\nBertycoX - Sunny Day" +
					"\nBertycoX - The Signal" +
					"\nBertycoX - Utopia" +
					"\nCaleb Cuzner (Nijg) - BotsRevenge" +
					"\nDarkn - INTENSITY" +
					"\nKhuskan - Elevator Music" +
					"\nLibra - Free Will" +
					"\nLibra - Girlfriend Experience" +
					"\nLibra - Speed of Light" +
					"\nWill (Pushbar) - Victory";
					
					consoleFieldCol2.x = consoleField.x + consoleField.width + 10;
					consoleFieldCol2.y = 315;
					consoleFieldCol2.multiline = true;
					consoleFieldCol2.selectable = false;
					consoleFieldCol2.embedFonts = true;
					consoleFieldCol2.defaultTextFormat = consoleFormat;
					consoleFieldCol2.autoSize = TextFieldAutoSize.LEFT;
					consoleFieldCol2.filters = [consoleShadow];
					consoleFieldCol2.text = "MISC SFX:" +
					"\n\nFutureSoundFX" +
					"\nHell's Sound Guy" +
					"\nN. Thompson" +
					"\nPengo" +
					"\n\nFONTS: " +
					"\n\nArcade by Yuji Adachi" +
					"\nMoonmonkey by A. Robinson" +
					"\nNeuropol by Typodermic Fonts" +
					"\nUnZialish by Manfred Klein";
					
					addChild(myCreditField);
					addChild(consoleField);
					addChild(consoleFieldCol2);					
				}
	
				//on pressing instr button
				function viewInstructions(e:MouseEvent):void
				{
					cred.enabled = cred.visible = false;
					instr.enabled = instr.visible = false;
					playgame.enabled = playgame.visible = false;
					
					if (stage.contains(menuBack) == false)
					{
						menuBack.addEventListener(MouseEvent.CLICK, returnToMenu);
						stage.addChild(menuBack);
					}
					else
					{
						menuBack.enabled = menuBack.visible = true;
					}
					
					instructions.x = 200;
					instructions.y = 290;
					addChild(instructions);
				}
				
				//return to main screen from instructions or credits
				function returnToMenu():void
				{
					cred.enabled = cred.visible = true;
					instr.enabled = instr.visible = true;
					playgame.enabled = playgame.visible = true;
					menuBack.enabled = menuBack.visible = false;

					//clear panel
					myCreditField.text = ""; consoleField.text = ""; consoleFieldCol2.text = "";
					if(stage.contains(myCreditField)){removeChild(myCreditField)}
					if(stage.contains(consoleField)){removeChild(consoleField)}
					if(stage.contains(consoleFieldCol2)){removeChild(consoleFieldCol2)}
					if(stage.contains(instructions)){removeChild(instructions)}
				}
	
				//on pressing playgame button
				function chooseSide(e:MouseEvent):void
				{
					cred.removeEventListener(MouseEvent.CLICK, viewCredits);
					instr.removeEventListener(MouseEvent.CLICK, viewInstructions);
					playgame.removeEventListener(MouseEvent.CLICK, chooseSide);
					stage.removeChild(cred);
					stage.removeChild(instr);
					stage.removeChild(playgame);
					introVideo.play();
				}
	
				//on choosing a side
				function startGame(e:MouseEvent):void
				{
					playRobots.removeEventListener(MouseEvent.CLICK, startGame);
					playRobots.removeEventListener(MouseEvent.ROLL_OVER, highlightThis);
					playRobots.removeEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
					playAliens.removeEventListener(MouseEvent.CLICK, startGame);
					playAliens.removeEventListener(MouseEvent.ROLL_OVER, highlightThis);
					playAliens.removeEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
					
					if (e.currentTarget == playRobots)
					{
						musicChannel.stop();
						robots = true;
						channel = operational.play();
						channel.addEventListener(Event.SOUND_COMPLETE, begin);
						function begin(e:Event):void{
							channel.removeEventListener(Event.SOUND_COMPLETE, begin);
							stage.removeChild(playRobots);
							stage.removeChild(playAliens);
							stage.removeChild(choose);
							introVideo.play();
						}
					}
					if (e.currentTarget == playAliens)
					{
						//aliens = true;
					}
				} // end startGame function
				
			}// end menuButtons function
			
		}// end constructor
		
		private function difficultySelectScreen():void{
			removeChild(introBG);
			removeChild(introVideo);
			
			difficultySelectReq = new URLRequest("extvideo/difficultybg.swf");
			difficultySelectLoad.load(difficultySelectReq);
			addChild(difficultySelectLoad);
			addChild(easy); addChild(normal); addChild(hard); addChild(insane);
			
			soundMusic = new SoundMusicBtns(introMusic);
			stage.addChild(soundMusic);
			
			easy.x = normal.x = hard.x = insane.x = 277;
			easy.y = 154;
			normal.y = easy.y + 110;
			hard.y = normal.y + 110;
			insane.y = hard.y + 110;
			
			easy.name = "easy"; normal.name = "normal"; hard.name = "hard"; insane.name = "insane";
			easy.buttonMode = true; normal.buttonMode = true;
			hard.buttonMode = true; insane.buttonMode = true;
			easy.gotoAndStop(2); normal.gotoAndStop(2); hard.gotoAndStop(2); insane.gotoAndStop(2);
			
			easy.addEventListener(MouseEvent.CLICK, difficultySelected);
			easy.addEventListener(MouseEvent.ROLL_OVER, highlightThis);
			easy.addEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
			normal.addEventListener(MouseEvent.CLICK, difficultySelected);
			normal.addEventListener(MouseEvent.ROLL_OVER, highlightThis);
			normal.addEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
			hard.addEventListener(MouseEvent.CLICK, difficultySelected);
			hard.addEventListener(MouseEvent.ROLL_OVER, highlightThis);
			hard.addEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
			insane.addEventListener(MouseEvent.CLICK, difficultySelected);
			insane.addEventListener(MouseEvent.ROLL_OVER, highlightThis);
			insane.addEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
		}
		
		private function difficultySelected(e:MouseEvent):void{
			
			easy.removeEventListener(MouseEvent.CLICK, difficultySelected);
			easy.removeEventListener(MouseEvent.ROLL_OVER, highlightThis);
			easy.removeEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
			normal.removeEventListener(MouseEvent.CLICK, difficultySelected);
			normal.removeEventListener(MouseEvent.ROLL_OVER, highlightThis);
			normal.removeEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
			hard.removeEventListener(MouseEvent.CLICK, difficultySelected);
			hard.removeEventListener(MouseEvent.ROLL_OVER, highlightThis);
			hard.removeEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
			insane.removeEventListener(MouseEvent.CLICK, difficultySelected);
			insane.removeEventListener(MouseEvent.ROLL_OVER, highlightThis);
			insane.removeEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
			removeChild(easy); removeChild(normal); removeChild(hard); removeChild(insane);
			removeChild(difficultySelectLoad);
			stage.removeChild(soundMusic);
			
			switch(e.currentTarget.name){
				case("easy"):
					RobotStart.difficultyFactor = 1.5;
					break;
				case("normal"):
					RobotStart.difficultyFactor = 1;
					break;
				case("hard"):
					RobotStart.difficultyFactor = 0.8;
					break;
				case("insane"):
					RobotStart.difficultyFactor = 0.6;
					break;
			}
			
			trace(RobotStart.difficultyFactor);
			
			if(robots){
				playRobotsGame();
				}
			else if(aliens){
				playAliensGame();
				}
		} //end difficultySelected
		
		private function playRobotsGame():void{
			//trace('ROBOTS!');
			stage.addChild(robotStart);
		}

		private function playAliensGame():void{
			//trace('ALIENS!');
		}
		
		private function highlightThis(e:MouseEvent):void{
			e.target.gotoAndStop(1);
		}
		
		private function unhighlightThis(e:MouseEvent):void{
			e.target.gotoAndStop(2);
		}
		
	}// end class
}// end package