package  {
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	
	public class SoundMusicBtns extends MovieClip{
		
		public static var soundOn:Boolean = true;
		public static var musicOn:Boolean = true;
		
		private var music:MusicButton = new MusicButton();
		private var snd:MuteButton = new MuteButton();
		private var musicChannel:SoundChannel = new SoundChannel();
		private var musicPause:Number;
		private var thisTrack:Sound;

		public function SoundMusicBtns(track:Sound) {
			thisTrack = track;
			
			snd.x = 920.5;
			snd.y = 15;
			snd.buttonMode = true;
			
			music.x = 881.5;
			music.y = 15.5;
			music.buttonMode = true;
			
			snd.addEventListener(MouseEvent.CLICK, muteAll);
			music.addEventListener(MouseEvent.CLICK, muteMusic);
			this.addEventListener(Event.ADDED_TO_STAGE, startSound);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeSelf);
			
			addChild(snd);
			addChild(music);
			
			if(soundOn){
				snd.gotoAndStop(1);
			}
			else{
				snd.gotoAndStop(2);
			}
			
			if(musicOn){
				music.gotoAndStop(1);
			}
			else{
				music.gotoAndStop(2);
			}
		} //end constructor
		
		private function startSound(e:Event):void{
			
			musicPause = 0;
			if((soundOn) && (musicOn)){
				musicChannel = thisTrack.play(0);
				musicChannel.addEventListener(Event.SOUND_COMPLETE, loopSound);
			}
		}
		
		private function loopSound(e:Event):void{
			musicChannel.removeEventListener(Event.SOUND_COMPLETE, loopSound);
			musicChannel = thisTrack.play(0);
			musicChannel.addEventListener(Event.SOUND_COMPLETE, loopSound);
		}
		
		private function muteAll(e:MouseEvent):void{
			
			if(soundOn){
				snd.gotoAndStop(2);
				soundOn = false;
				musicPause = musicChannel.position;
				SoundMixer.stopAll();
			}
			else{
				snd.gotoAndStop(1);
				soundOn = true;
				
				if(musicOn){
					musicChannel = thisTrack.play(musicPause);
					musicChannel.addEventListener(Event.SOUND_COMPLETE, loopSound);
				}
				else{}
			}
		}
		
		private function muteMusic(e:MouseEvent):void{
			
			if(musicOn){
				music.gotoAndStop(2);
				musicOn = false;
				musicPause = musicChannel.position;
				musicChannel.addEventListener(Event.SOUND_COMPLETE, loopSound);
				musicChannel.stop();
			}
			else{
				
				music.gotoAndStop(1);
				musicOn = true;
				
				if(soundOn){
					musicChannel = thisTrack.play(musicPause);
				}
				else{}
			}
			
		}
		
		private function removeSelf(e:Event):void{
			SoundMixer.stopAll();
			snd.removeEventListener(MouseEvent.CLICK, muteAll);
			music.removeEventListener(MouseEvent.CLICK, muteMusic);
			removeEventListener(Event.ADDED_TO_STAGE, startSound);
			removeEventListener(Event.REMOVED_FROM_STAGE, removeSelf);
			removeChild(snd);
			removeChild(music);
		}
	} //end class
} //end package