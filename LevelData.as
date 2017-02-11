package  {
	import flash.display.*;
	import flash.utils.*;
	import flash.geom.*;
	
	public class LevelData extends Sprite{
		
		//MUSIC TRACKS
		
		public static var track1:Track1 = new Track1();
		public static var track2:Track2 = new Track2();
		public static var track3:Track3 = new Track3();
		public static var track4:Track4 = new Track4();
		public static var track5:Track5 = new Track5();
		public static var track6:Track6 = new Track6();
		public static var track7:Track7 = new Track7();
		public static var track8:Track8 = new Track8();
		
		//PUBLIC DATA ARRAYS
		
		public var levelBaseArray:Array = new Array();
		public var levelWallTopsArray:Array = new Array();
		public var playableAreaArray:Array = new Array();
		public var levelGridArray:Array = new Array();
		public var spawnTimersArray:Array = new Array();
		public var percentageArray:Array = new Array();
		public var waveCountArray:Array = new Array();
		public var spawnPointArray:Array = new Array();
		public var levelCardArray:Array = new Array();
		public var playerSpawnArray:Array = new Array();		
		public static var musicArray:Array = [track1, track2, track3, track4,
											  track5, track6, track7, track8];
		
		
		//PRIVATE LEVEL-SPECIFIC ITEMS
		
		//**************LEVEL 1**************
		
		private var base1:Level1Base = new Level1Base();
		private var tops1:Level1WallTops = new Level1WallTops();
		private var playable1:playableArea1 = new playableArea1();
		private var playerSpawn1:Point = new Point(140, 350);
		private var grid1:Array = 
		[
		[00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 00, 00, 00, 00, 00, 10, 10, 10, 10, 10, 10, 10, 00, 00, 00, 00, 00, 00, 00],
		[00, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 00, 00, 00, 00, 00, 00, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00]
		];
		private var spawnTimer1wave1:Timer = new Timer(3000, 6);
		private var spawnTimer1wave2:Timer = new Timer(3000, 8);
		private var spawnTimer1wave3:Timer = new Timer(2500, 9);
		private var spawnTimer1wave4:Timer = new Timer(2500, 10);
		private var spawnTimers1:Array = [spawnTimer1wave1, spawnTimer1wave2, spawnTimer1wave3, spawnTimer1wave4];
		
		//percentages represent chance of each enemy type spawning (order is: soldier, elite, juggernaut, bomber)
		private var per1wave1:Array = [100, 0, 0, 0];
		private var per1wave2:Array = [90, 10, 0, 0];
		private var per1wave3:Array = [85, 15, 0, 0];
		private var per1wave4:Array = [85, 15, 0, 0];
		private var percentages1:Array = [per1wave1, per1wave2, per1wave3, per1wave4];
		
		//spawn points
		private var lvl1gate1:Point = new Point(925,125);
		private var lvl1gate2:Point = new Point(925,325);
		private var lvl1gate3:Point = new Point(925,525);
		private var gates1:Array = [lvl1gate1, lvl1gate2, lvl1gate3];
		
		
		//**************LEVEL 2**************
		
		private var base2:Level2Base = new Level2Base();
		private var tops2:Level2WallTops = new Level2WallTops();
		private var playable2:playableArea2 = new playableArea2();
		private var playerSpawn2:Point = new Point(489, 313);
		private var grid2:Array = 
		[
		[00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 00, 00, 00, 00, 10, 10, 00, 00, 00, 00, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 00, 00, 00, 00, 10, 10, 00, 00, 00, 00, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00]
		];
		private var spawnTimer2wave1:Timer = new Timer(2000, 8);
		private var spawnTimer2wave2:Timer = new Timer(2000, 8);
		private var spawnTimer2wave3:Timer = new Timer(2500, 10);
		private var spawnTimer2wave4:Timer = new Timer(2500, 10);
		private var spawnTimer2wave5:Timer = new Timer(2500, 12);
		private var spawnTimers2:Array = [spawnTimer2wave1, spawnTimer2wave2, spawnTimer2wave3, spawnTimer2wave4, spawnTimer2wave5];
		
		//percentages represent chance of each enemy type spawning (order is: soldier, elite, juggernaut, bomber)
		private var per2wave1:Array = [90, 10, 0, 0];
		private var per2wave2:Array = [85, 15, 0, 0];
		private var per2wave3:Array = [80, 15, 5, 0];
		private var per2wave4:Array = [75, 15, 5, 0];
		private var per2wave5:Array = [70, 20, 5, 0];
		private var percentages2:Array = [per2wave1, per2wave2, per2wave3, per2wave4, per2wave5];
		
		//spawn points
		private var lvl2gate1:Point = new Point(925,275);
		private var lvl2gate2:Point = new Point(925,525);
		private var lvl2gate3:Point = new Point(75,275);
		private var gates2:Array = [lvl2gate1, lvl2gate2, lvl2gate3];
		
		//**************LEVEL 3**************
		
		private var base3:Level3Base = new Level3Base();
		private var tops3:Level3WallTops = new Level3WallTops();
		private var playable3:playableArea3 = new playableArea3();
		private var playerSpawn3:Point = new Point(350, 225);
		private var grid3:Array = 
		[
		[00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 00, 10, 10, 10, 10, 10, 10, 00, 10, 10, 10, 00, 00, 00, 10, 10, 00],
		[00, 10, 10, 00, 10, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 00, 10, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 00, 10, 10, 10, 10, 10, 10, 00, 10, 10, 10, 00, 10, 10, 10, 10, 00],
		[00, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 00],
		[00, 10, 10, 00, 10, 10, 00, 00, 00, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 00, 00, 00, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 00, 00, 00, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00]
		];
		private var spawnTimer3wave1:Timer = new Timer(2000, 10);
		private var spawnTimer3wave2:Timer = new Timer(2000, 10);
		private var spawnTimer3wave3:Timer = new Timer(2000, 12);
		private var spawnTimer3wave4:Timer = new Timer(2000, 12);
		private var spawnTimer3wave5:Timer = new Timer(2000, 14);
		private var spawnTimer3wave6:Timer = new Timer(2000, 14);
		private var spawnTimers3:Array = [spawnTimer3wave1, spawnTimer3wave2, spawnTimer3wave3, spawnTimer3wave4, spawnTimer3wave5, spawnTimer3wave6];
		
		//percentages represent chance of each enemy type spawning (order is: soldier, elite, juggernaut)
		private var per3wave1:Array = [80, 15, 5, 0];
		private var per3wave2:Array = [80, 10, 5, 5];
		private var per3wave3:Array = [70, 20, 5, 5];
		private var per3wave4:Array = [65, 20, 10, 5];
		private var per3wave5:Array = [65, 20, 10, 5];
		private var per3wave6:Array = [60, 25, 15, 0];
		private var percentages3:Array = [per3wave1, per3wave2, per3wave3, per3wave4, per3wave5, per3wave6];
		
		//spawn points
		private var lvl3gate1:Point = new Point(925,75);
		private var lvl3gate2:Point = new Point(925,575);
		private var lvl3gate3:Point = new Point(75,75);
		private var lvl3gate4:Point = new Point(75, 575);
		private var gates3:Array = [lvl3gate1, lvl3gate2, lvl3gate3, lvl3gate4];
		
		//**************LEVEL 4**************
		
		private var base4:Level4Base = new Level4Base();
		private var tops4:Level4WallTops = new Level4WallTops();
		private var playable4:playableArea4 = new playableArea4();
		private var playerSpawn4:Point = new Point(150, 150);
		private var grid4:Array = 
		[
		[00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 00, 00, 00, 00, 00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00, 00, 00, 00, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 00],
		[00, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 00, 10, 10, 10, 10, 10, 00],
		[00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00]
		];
		private var spawnTimer4wave1:Timer = new Timer(2000, 10);
		private var spawnTimer4wave2:Timer = new Timer(2000, 10);
		private var spawnTimer4wave3:Timer = new Timer(2000, 12);
		private var spawnTimer4wave4:Timer = new Timer(2000, 12);
		private var spawnTimer4wave5:Timer = new Timer(2000, 14);
		private var spawnTimer4wave6:Timer = new Timer(2000, 14);
		private var spawnTimer4wave7:Timer = new Timer(2000, 14);
		private var spawnTimer4wave8:Timer = new Timer(2000, 14);
		private var spawnTimers4:Array = [spawnTimer4wave1, spawnTimer4wave2, spawnTimer4wave3, spawnTimer4wave4, spawnTimer4wave5, spawnTimer4wave6, spawnTimer4wave7, spawnTimer4wave8];
		
		//percentages represent chance of each enemy type spawning (order is: soldier, elite, juggernaut, bomber)
		private var per4wave1:Array = [80, 15, 5, 0];
		private var per4wave2:Array = [80, 10, 5, 5];
		private var per4wave3:Array = [70, 20, 5, 5];
		private var per4wave4:Array = [65, 20, 10, 5];
		private var per4wave5:Array = [65, 20, 10, 5];
		private var per4wave6:Array = [60, 25, 15, 0];
		private var per4wave7:Array = [60, 25, 15, 0];
		private var per4wave8:Array = [60, 25, 15, 0];
		private var percentages4:Array = [per4wave1, per4wave2, per4wave3, per4wave4, per4wave5, per4wave6, per4wave7, per4wave8];
		
		//spawn points
		private var lvl4gate1:Point = new Point(775,75);
		private var lvl4gate2:Point = new Point(175,575);
		private var gates4:Array = [lvl4gate1, lvl4gate2];
		
		//CONSTRUCTOR
		public function LevelData(){
			
			levelBaseArray.push(base1, base2, base3, base4);
			levelWallTopsArray.push(tops1, tops2, tops3, tops4);
			playableAreaArray.push(playable1, playable2, playable3, playable4);
			levelGridArray.push(grid1, grid2, grid3, grid4);
			spawnTimersArray.push(spawnTimers1, spawnTimers2, spawnTimers3, spawnTimers4);
			percentageArray.push(percentages1, percentages2, percentages3, percentages4);
			waveCountArray.push(4, 5, 6, 8);
			spawnPointArray.push(gates1, gates2, gates3, gates4);
			levelCardArray.push("extvideo/level1card.flv", "extvideo/level2card.flv", "extvideo/level3card.flv", "extvideo/level4card.flv");
			playerSpawnArray.push(playerSpawn1, playerSpawn2, playerSpawn3, playerSpawn4);
		}
		
		//converts percentages from the percentages Array into String values that determine enemy type
		//called from RobotStart
		public function percentagizer(enemyTypes:Array):String{
			
			var seed:Number = Math.random()*100;
			
			var soldier:String = "soldier";
			var elite:String = "elite";
			var juggernaut:String = "juggernaut";
			var bomber:String = "bomber";
			
			if((seed >= 0) && (seed <= enemyTypes[0])){
				return soldier;
			}
			else if((seed > enemyTypes[0]) && (seed <= enemyTypes[0] + enemyTypes[1])){
				return elite;
			}
			else if((seed > enemyTypes[0] + enemyTypes[1]) && (seed <= enemyTypes[0] + enemyTypes[1] + enemyTypes[2])){
				return juggernaut;
			}
			else if((seed > enemyTypes[0] + enemyTypes[1] + enemyTypes[2]) && (seed <= enemyTypes[0] + enemyTypes[1] + enemyTypes[2] + enemyTypes[3])){
				return bomber;
			}
			else{
				return "error";
			}
		} //end percentagizer

	} //end class
	
} //end package