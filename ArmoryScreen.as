package  {
	
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.filters.*;
	import flash.media.Sound;
	
	public class ArmoryScreen extends MovieClip{
		
		//fonts
		private var segoe:Font = new SegoeBold();
		private var myriad:Font = new Myriad();
		
		//text formats
		private var yourCreditsFormat:TextFormat = new TextFormat
		(segoe.fontName, 18, 0x000000, true, false, false, null, null, TextFormatAlign.RIGHT, 0, 0, 0);
		private var creditCountFormat:TextFormat = new TextFormat
		(segoe.fontName, 36, 0x000000, true, false, false, null, null, TextFormatAlign.RIGHT, 0, 0, 0);
		private var toolTipTitleFormat:TextFormat = new TextFormat
		(myriad.fontName, 24, 0xFFFFFF, true, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0);
		private var toolTipDescripFormat:TextFormat = new TextFormat
		(segoe.fontName, 16, 0xFFFFFF, true, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0);
		private var costFormat:TextFormat = new TextFormat
		(segoe.fontName, 15, 0x000000, true, false, false, null, null, TextFormatAlign.RIGHT, 0, 0, 0);
		
		//text fields
		private var yourCreditsField:TextField = new TextField();
		private var creditCountField:TextField = new TextField();
		private var toolTipTitleField:TextField = new TextField();
		private var toolTipDescripField:TextField = new TextField();
		private var toolTipPropField:TextField = new TextField();
		private var costField:TextField = new TextField();
		private var confirmField:TextField = new TextField();
		
		//dmg & speed properties
		private var dmg:int;
		private var spd:int;
		
		//graphics container sprites (primary, secondary, accessories, upgrades)
		private var tt:Sprite = new Sprite(); //tooltip
		private var ttg = tt.graphics;
		private var p1:Sprite = new Sprite();
		private var p1g = p1.graphics;
		private var p1o:Point;
		private var p2:Sprite = new Sprite();
		private var p2g = p2.graphics;
		private var p2o:Point;
		private var p3:Sprite = new Sprite();
		private var p3g = p3.graphics;
		private var p3o:Point;
		private var p4:Sprite = new Sprite();
		private var p4g = p4.graphics;
		private var p4o:Point;
		private var s1:Sprite = new Sprite();
		private var s1g = s1.graphics;
		private var s1o:Point;
		private var s2:Sprite = new Sprite();
		private var s2g = s2.graphics;
		private var s2o:Point;
		private var s3:Sprite = new Sprite();
		private var s3g = s3.graphics;
		private var s3o:Point;
		private var s4:Sprite = new Sprite();
		private var s4g = s4.graphics;
		private var s4o:Point;
		private var a1:Sprite = new Sprite();
		private var a1g = a1.graphics;
		private var a1o:Point;
		private var a2:Sprite = new Sprite();
		private var a2g = a2.graphics;
		private var a2o:Point;
		private var a3:Sprite = new Sprite();
		private var a3g = a3.graphics;
		private var a3o:Point;
		private var a4:Sprite = new Sprite();
		private var a4g = a4.graphics;
		private var a4o:Point;
		private var a5:Sprite = new Sprite();
		private var a5g = a5.graphics;
		private var a5o:Point;
		private var a6:Sprite = new Sprite();
		private var a6g = a6.graphics;
		private var a6o:Point;
		private var u1:Sprite = new Sprite();
		private var u1g = u1.graphics;
		private var u1o:Point;
		private var u2:Sprite = new Sprite();
		private var u2g = u2.graphics;
		private var u2o:Point;
		private var u3:Sprite = new Sprite();
		private var u3g = u3.graphics;
		private var u3o:Point;
		private var u4:Sprite = new Sprite();
		private var u4g = u4.graphics;
		private var u4o:Point;
		private var u5:Sprite = new Sprite();
		private var u5g = u5.graphics;
		private var u5o:Point;
		private var u6:Sprite = new Sprite();
		private var u6g = u6.graphics;
		private var u6o:Point;
	
		//buttons
		private var armoryDone:armoryDoneButton;
		private var purchaseThis:PurchaseButton;
		private var equipThis:EquipButton;
		private var soundMusic:SoundMusicBtns;
		private var confirm:ConfirmButton;
		private var yes:YesButton;
		private var no:NoButton;
		private var ok:OkButton;
		
		//misc
		private var creditsShadow:DropShadowFilter = new DropShadowFilter(1, 45, 0x00FF00, .5, 2, 2, 1, 3); 
		private var displayCredits:String = addComma(InterfaceElements.credits);
		private var currentPurchase:String;
		private var currentBtn;
		
		//tooltip
		private var toolTipWidth:int = 340;
		private var toolTipHeight:int = 200;
		private var toolTipTitle:String = new String();
		private var toolTipDescrip:String = new String();
		private var toolTipProp:String = new String();
		private var ttShadow:DropShadowFilter = new DropShadowFilter(1, 45, 0x000000, 1, 2, 2, 2, 3);
		private var greenBlock:Sprite = new Sprite();
		private var blueBlock:Sprite = new Sprite();
		
		//arrays
		private var slotArray:Array = new Array();
		private var slotNameArray:Array = new Array();
		private var originArray:Array = new Array();
		private var costArray:Array = new Array();
		private var uSlotArray:Array = new Array();
		private var uOriginArray:Array = new Array();
		private var uCostArray:Array = new Array();
		private var uNameArray:Array = new Array();
		
		//display objects
		private var primary1:Primary1 = new Primary1();
		private var primary2:Primary2 = new Primary2();
		private var primary3:Primary3 = new Primary3();
		private var primary4:Primary4 = new Primary4();
		private var secondary1:Secondary1 = new Secondary1();
		private var secondary2:Secondary2 = new Secondary2();
		private var secondary3:Secondary3 = new Secondary3();
		private var secondary4:Secondary4 = new Secondary4();
		private var accessory1:Accessory1 = new Accessory1();
		private var accessory2:Accessory2 = new Accessory2();
		private var accessory3:Accessory3 = new Accessory3();
		private var accessory4:Accessory4 = new Accessory4();
		private var accessory5:Accessory5 = new Accessory5();
		private var accessory6:Accessory6 = new Accessory6();
		private var upgrade1:Upgrade1 = new Upgrade1();
		private var upgrade2:Upgrade2 = new Upgrade2();
		private var upgrade3:Upgrade3 = new Upgrade3();
		private var upgrade4:Upgrade4 = new Upgrade4();
		private var upgrade5:Upgrade5 = new Upgrade5();
		private var upgrade6:Upgrade6 = new Upgrade6();
		
		//sounds
		private var armoryMusic:Sound = new ArmoryMusic();
		private var kaChing:Sound = new KaChing();
		
		public function ArmoryScreen() {

			//armory background
			var armoryBG:Loader = new Loader();
			var armoryBGRequest:URLRequest = new URLRequest("extvideo/armory.swf");
			armoryBG.load(armoryBGRequest);
			addChild(armoryBG);
			var salesticker:saleSticker = new saleSticker();
			salesticker.x = 748;
			salesticker.y = 56;
			addChild(salesticker);
			
			//done button
			armoryDone = new armoryDoneButton();
			armoryDone.x = 425;
			armoryDone.y = 580;
			armoryDone.buttonMode = true;
			addChild(armoryDone);
			armoryDone.gotoAndStop(1);
			armoryDone.addEventListener(MouseEvent.ROLL_OVER, highlightThis);
			armoryDone.addEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
			armoryDone.addEventListener(MouseEvent.CLICK, armoryComplete);
			
			//text placement and positioning
			yourCreditsField.defaultTextFormat = yourCreditsFormat;
			yourCreditsField.embedFonts = true;
			yourCreditsField.x = 49;
			yourCreditsField.y = 105;
			yourCreditsField.width = 135;
			yourCreditsField.height = 25;
			yourCreditsField.autoSize = TextFieldAutoSize.NONE;
			yourCreditsField.multiline = false;
			yourCreditsField.text = "YOUR CREDITS:";
			yourCreditsField.selectable = false;
			
			creditCountField.defaultTextFormat = creditCountFormat;
			creditCountField.embedFonts = true;
			creditCountField.x = 46;
			creditCountField.y = 135;
			creditCountField.width = 137;
			creditCountField.height = 45;
			creditCountField.autoSize = TextFieldAutoSize.NONE;
			creditCountField.multiline = false;
			creditCountField.text = displayCredits;
			creditCountField.selectable = false;
			creditCountField.filters = [creditsShadow];

			//weapon & item slots: display objects
			p1o = new Point(78, 247.5);
			p1g.lineStyle(1, 0x000000);
			p1g.beginFill(0x29ABE2, 0.2);
			p1g.drawRect(p1o.x, p1o.y, 175, 39);
			p1g.endFill();
			
			p2o = new Point(78, 292.5);
			p2g.lineStyle(1, 0x000000);
			p2g.beginFill(0x29ABE2, 0.2);
			p2g.drawRect(p2o.x, p2o.y, 175, 39);
			p2g.endFill();
			
			p3o = new Point(78, 337.5);
			p3g.lineStyle(1, 0x000000);
			p3g.beginFill(0x29ABE2, 0.2);
			p3g.drawRect(p3o.x, p3o.y, 175, 39);
			p3g.endFill();
			
			p4o = new Point(78, 382.5);
			p4g.lineStyle(1, 0x000000);
			p4g.beginFill(0x29ABE2, 0.2);
			p4g.drawRect(p4o.x, p4o.y, 175, 39);
			p4g.endFill();
			
			s1o = new Point(377, 247.5);
			s1g.lineStyle(1, 0x000000);
			s1g.beginFill(0x29ABE2, 0.2);
			s1g.drawRect(s1o.x, s1o.y, 175, 39);
			s1g.endFill();
			
			s2o = new Point(377, 292.5);
			s2g.lineStyle(1, 0x000000);
			s2g.beginFill(0x29ABE2, 0.2);
			s2g.drawRect(s2o.x, s2o.y, 175, 39);
			s2g.endFill();
			
			s3o = new Point(377, 337.5);
			s3g.lineStyle(1, 0x000000);
			s3g.beginFill(0x29ABE2, 0.2);
			s3g.drawRect(s3o.x, s3o.y, 175, 39);
			s3g.endFill();
			
			s4o = new Point(377, 382.5);
			s4g.lineStyle(1, 0x000000);
			s4g.beginFill(0x29ABE2, 0.2);
			s4g.drawRect(s4o.x, s4o.y, 175, 39);
			s4g.endFill();
			
			a1o = new Point(683, 324.5);
			a1g.lineStyle(1, 0x000000);
			a1g.beginFill(0x29ABE2, 0.2);
			a1g.drawRect(a1o.x, a1o.y, 155.5, 39);
			a1g.endFill();
			
			a2o = new Point(683, 369.5);
			a2g.lineStyle(1, 0x000000);
			a2g.beginFill(0x29ABE2, 0.2);
			a2g.drawRect(a2o.x, a2o.y, 155.5, 39);
			a2g.endFill();
			
			a3o = new Point(683, 414.5);
			a3g.lineStyle(1, 0x000000);
			a3g.beginFill(0x29ABE2, 0.2);
			a3g.drawRect(a3o.x, a3o.y, 155.5, 39);
			a3g.endFill();
			
			a4o = new Point(683, 459.5);
			a4g.lineStyle(1, 0x000000);
			a4g.beginFill(0x29ABE2, 0.2);
			a4g.drawRect(a4o.x, a4o.y, 155.5, 39);
			a4g.endFill();
			
			a5o = new Point(683, 505.5);
			a5g.lineStyle(1, 0x000000);
			a5g.beginFill(0x29ABE2, 0.2);
			a5g.drawRect(a5o.x, a5o.y, 155.5, 39);
			a5g.endFill();
			
			a6o = new Point(683, 551.5);
			a6g.lineStyle(1, 0x000000);
			a6g.beginFill(0x29ABE2, 0.2);
			a6g.drawRect(a6o.x, a6o.y, 155.5, 39);
			a6g.endFill();
			
			u1o = new Point(78, 484.5);
			u1g.lineStyle(1, 0x000000);
			u1g.beginFill(0x29ABE2, 0.2);
			u1g.drawRect(u1o.x, u1o.y, 152.5, 34);
			
			u2o = new Point(78, 543.5);
			u2g.lineStyle(1, 0x000000);
			u2g.beginFill(0x29ABE2, 0.2);
			u2g.drawRect(u2o.x, u2o.y, 152.5, 34);
			
			u3o = new Point(260, 447.5);
			u3g.lineStyle(1, 0x000000);
			u3g.beginFill(0x29ABE2, 0.2);
			u3g.drawRect(u3o.x, u3o.y, 152.5, 34);
			
			u4o = new Point(260, 506.5);
			u4g.lineStyle(1, 0x000000);
			u4g.beginFill(0x29ABE2, 0.2);
			u4g.drawRect(u4o.x, u4o.y, 152.5, 34);
			
			u5o = new Point(443, 447.5);
			u5g.lineStyle(1, 0x000000);
			u5g.beginFill(0x29ABE2, 0.2);
			u5g.drawRect(u5o.x, u5o.y, 152.5, 34);
			
			u6o = new Point(443, 506.5);
			u6g.lineStyle(1, 0x000000);
			u6g.beginFill(0x29ABE2, 0.2);
			u6g.drawRect(u6o.x, u6o.y, 152.5, 34);
			
			primary1.x = p1o.x + 2;
			primary1.y = p1o.y + p1.height * 0.5;
			primary2.x = p1o.x + 2;
			primary2.y = p2o.y + p2.height * 0.5;
			primary3.x = p1o.x + 2;
			primary3.y = p3o.y + p3.height * 0.5;
			primary4.x = p1o.x + 2;
			primary4.y = p4o.y + p4.height * 0.5;
			
			secondary1.x = s1o.x + 2;
			secondary1.y = s1o.y + s1.height * 0.5;
			secondary2.x = s1o.x + 2;
			secondary2.y = s2o.y + s2.height * 0.5;
			secondary3.x = s1o.x + 2;
			secondary3.y = s3o.y + s3.height * 0.5;
			secondary4.x = s1o.x + 2;
			secondary4.y = s4o.y + s4.height * 0.5;
			
			accessory1.x = a1o.x + accessory1.width * 0.5 + 5;
			accessory1.y = a1o.y + a1.height * 0.5;
			accessory1.gotoAndStop(1);
			accessory2.x = a2o.x + accessory2.width * 0.5 + 5;
			accessory2.y = a2o.y + a2.height * 0.5;
			accessory2.gotoAndStop(1);
			accessory3.x = a3o.x + accessory3.width * 0.5 + 5;
			accessory3.y = a3o.y + a3.height * 0.5;
			accessory4.x = a4o.x + accessory4.width * 0.5 + 5;
			accessory4.y = a4o.y + a4.height * 0.5;
			accessory5.x = a5o.x + accessory5.width * 0.5 + 5;
			accessory5.y = a5o.y + a5.height * 0.5;
			accessory6.x = a6o.x + accessory6.width * 0.5 + 5;
			accessory6.y = a6o.y + a6.height * 0.5;
			
			upgrade1.x = u1o.x + upgrade1.width * 0.5 + 5;
			upgrade1.y = u1o.y + u1.height * 0.5;
			upgrade2.x = u2o.x + upgrade2.width * 0.5 + 5;
			upgrade2.y = u2o.y + u2.height * 0.5;
			upgrade3.x = u3o.x + upgrade3.width * 0.5 + 5;
			upgrade3.y = u3o.y + u3.height * 0.5;
			upgrade4.x = u4o.x + upgrade4.width * 0.5 + 5;
			upgrade4.y = u4o.y + u4.height * 0.5;
			upgrade5.x = u5o.x + upgrade5.width * 0.5 + 5;
			upgrade5.y = u5o.y + u5.height * 0.5;
			upgrade6.x = u6o.x + upgrade6.width * 0.5 + 5;
			upgrade6.y = u6o.y + u6.height * 0.5;
			
			//add display objects
			addChild(yourCreditsField);
			addChild(creditCountField);
			addChild(p1); addChild(p2); addChild(p3); addChild(p4);
			addChild(s1); addChild(s2); addChild(s3); addChild(s4);
			addChild(a1); addChild(a2); addChild(a3); addChild(a4); addChild(a5); addChild(a6);
			addChild(u1); addChild(u2); addChild(u3); addChild(u4); addChild(u5); addChild(u6);
			p1.addChild(primary1); p2.addChild(primary2); p3.addChild(primary3); p4.addChild(primary4);
			s1.addChild(secondary1); s2.addChild(secondary2); s3.addChild(secondary3); s4.addChild(secondary4);
			a1.addChild(accessory1); a2.addChild(accessory2); a3.addChild(accessory3);
			a4.addChild(accessory4); a5.addChild(accessory5); a6.addChild(accessory6);
			u1.addChild(upgrade1); u2.addChild(upgrade2); u3.addChild(upgrade3);
			u4.addChild(upgrade4); u5.addChild(upgrade5); u6.addChild(upgrade6);

			//event listeners
			p1.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			p1.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			p2.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			p2.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			p3.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			p3.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			p4.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			p4.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			s1.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			s1.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			s2.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			s2.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			s3.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			s3.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			s4.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			s4.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			a1.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			a1.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			a2.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			a2.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			a3.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			a3.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			a4.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			a4.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			a5.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			a5.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			a6.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			a6.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			u1.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			u1.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			u2.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			u2.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			u3.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			u3.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			u4.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			u4.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			u5.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			u5.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			u6.addEventListener(MouseEvent.MOUSE_OVER, toolTip);
			u6.addEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			
			//for addButtons function
			slotArray.push
			(p1, p2, p3, p4, s1, s2, s3, s4, a1, a2, a3, a4, a5, a6);
			originArray.push
			(p1o, p2o, p3o, p4o, s1o, s2o, s3o, s4o, a1o, a2o, a3o, a4o, a5o, a6o);
			slotNameArray.push
			("p1", "p2", "p3", "p4", "s1", "s2", "s3", "s4", "a1", "a2", "a3", "a4", "a5", "a6",
			 "u1", "u2", "u3", "u4", "u5", "u6"); //*note: upgrade labels are duplicated in uNameArray
			costArray.push
			(0, 3000, 5000, 10000, 0, 4000, 7500, 12500, 999999, 999999, 999999, 999999, 999999, 999999,
			 3500, 4500, 7500, 2000, 10000, 15000);  //*note: upgrade prices are duplicated in uCostArray
			uSlotArray.push(u1, u2, u3, u4, u5, u6);
			uOriginArray.push(u1o, u2o, u3o, u4o, u5o, u6o);
			uNameArray.push("u1", "u2", "u3", "u4", "u5", "u6");
			uCostArray.push(3500, 4500, 7500, 2000, 10000, 15000);
			addEventListener(Event.ADDED_TO_STAGE, addButtons);
			
		} //end constructor
		
		private function addButtons(e:Event):void{
			
			removeEventListener(Event.ADDED_TO_STAGE, addButtons);
			
			//populates slots for primary/secondary/accessory
			for(var i:int = 0; i < slotArray.length; i++){
				purchaseThis = new PurchaseButton();
				purchaseThis.x = originArray[i].x + slotArray[i].width + 4;
				purchaseThis.y = originArray[i].y;
				purchaseThis.name = slotNameArray[i];
				addChild(purchaseThis);
				if(InterfaceElements.purchasedArray[slotNameArray.lastIndexOf(purchaseThis.name)]){
					purchaseThis.gotoAndStop(2);
				}
				else{
					purchaseThis.gotoAndStop(1);
					purchaseThis.buttonMode = true;
					purchaseThis.addEventListener(MouseEvent.CLICK, purchase);
				}
				
				equipThis = new EquipButton();
				equipThis.x = originArray[i].x + slotArray[i].width + 4;
				equipThis.y = originArray[i].y + purchaseThis.height;
				equipThis.name = slotNameArray[i];
				addChild(equipThis);
				
				//item is not purchased yet
				if(!InterfaceElements.purchasedArray[slotNameArray.lastIndexOf(equipThis.name)]){
					equipThis.buttonMode = false;
					equipThis.gotoAndStop(2);
				}		
				
				//item is purchased but not equipped
				if((InterfaceElements.purchasedArray[slotNameArray.lastIndexOf(equipThis.name)])
				&&(InterfaceElements.currentPrimary != slotNameArray[slotNameArray.lastIndexOf(equipThis.name)])){
					equipThis.buttonMode = true;
					equipThis.gotoAndStop(1);
					equipThis.addEventListener(MouseEvent.CLICK, equip);
				}
				
				//item is purchased and equipped
				if((InterfaceElements.purchasedArray[slotNameArray.lastIndexOf(equipThis.name)])
				&&((InterfaceElements.currentPrimary == slotNameArray[slotNameArray.lastIndexOf(equipThis.name)])
				   || (InterfaceElements.currentSecondary == slotNameArray[slotNameArray.lastIndexOf(equipThis.name)])
				   || (InterfaceElements.currentAccessory == slotNameArray[slotNameArray.lastIndexOf(equipThis.name)]))){
					equipThis.buttonMode = false;
					equipThis.gotoAndStop(3);
				}
				
				costField = new TextField();
				costField.defaultTextFormat = costFormat;
				costField.embedFonts = true;
				costField.autoSize = TextFieldAutoSize.RIGHT;
				costField.multiline = false;
				costField.selectable = false;
				costField.x = originArray[i].x + slotArray[i].width - 5;
				costField.y = originArray[i].y + 5;
				costField.text = addComma(costArray[i]) + " Cr";
				slotArray[i].addChild(costField);
			}
			
			//populates upgrade slots
			for(var h:int = 0; h < uSlotArray.length; h++){
				purchaseThis = new PurchaseButton();
				purchaseThis.x = uOriginArray[h].x + uSlotArray[h].width * 0.5 - purchaseThis.width * 0.5;
				purchaseThis.y = uOriginArray[h].y + uSlotArray[h].height + 2;
				purchaseThis.name = uNameArray[h];
				addChild(purchaseThis);
				if(InterfaceElements.purchasedArray[slotNameArray.lastIndexOf(purchaseThis.name)]){
					purchaseThis.gotoAndStop(2);
				}
				else{
					purchaseThis.gotoAndStop(1);
					purchaseThis.buttonMode = true;
					purchaseThis.addEventListener(MouseEvent.CLICK, purchase);
				}
				
				costField = new TextField();
				costField.defaultTextFormat = costFormat;
				costField.embedFonts = true;
				costField.autoSize = TextFieldAutoSize.RIGHT;
				costField.multiline = false;
				costField.selectable = false;
				costField.x = uOriginArray[h].x + uSlotArray[h].width - 5;
				costField.y = uOriginArray[h].y + 4;
				costField.text = addComma(uCostArray[h]) + " Cr";
				uSlotArray[h].addChild(costField);
			}
			
			soundMusic = new SoundMusicBtns(armoryMusic);
			stage.addChild(soundMusic);
			//tool-tip sprite container
			addChild(tt);
		} //end addButtons

		private function purchase(e:MouseEvent):void{
			//trace(e.target.name + " purchase");
			//trace(costArray[slotNameArray.lastIndexOf(e.target.name)]);
			//trace(InterfaceElements.purchasedArray[slotNameArray.lastIndexOf(e.target.name)]);
			
			currentPurchase = e.target.name;
			currentBtn = e.target;
			
			confirm = new ConfirmButton();
			yes = new YesButton();
			no = new NoButton();
			confirm.x = stage.stageWidth * 0.5;
			confirm.y = stage.stageHeight * 0.5;
			addChild(confirm);
			
			confirmField.defaultTextFormat = toolTipDescripFormat;
			confirmField.embedFonts = true;
			confirmField.width = confirm.width * 0.95;
			confirmField.x = 0 - confirm.width * 0.5 + 5;
			confirmField.y = 0 - confirm.height * 0.5 + 3;
			confirmField.autoSize = TextFieldAutoSize.CENTER;
			confirmField.multiline = true;
			confirmField.wordWrap = true;
			confirmField.text = "Are you sure you want to purchase this item for " + 
			addComma(costArray[slotNameArray.lastIndexOf(e.target.name)]) + " credits?";
			confirmField.selectable = false;
			confirmField.filters = [ttShadow];
			
			yes.gotoAndStop(1);
			yes.x = 0 - yes.width * 0.5 - 10;
			yes.y =0 + yes.height * 0.5 + 12;
			yes.buttonMode = true;
			yes.name = "yes";
			
			no.gotoAndStop(1);
			no.x = 0 + no.width * 0.5 + 10;
			no.y = 0 + no.height * 0.5 + 12;
			no.buttonMode = true;
			no.name = "no";
			
			confirm.addChild(yes);
			confirm.addChild(no);
			confirm.addChild(confirmField);
			
			yes.addEventListener(MouseEvent.ROLL_OVER, highlightThis);
			yes.addEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
			yes.addEventListener(MouseEvent.CLICK, confirmClicked);
			no.addEventListener(MouseEvent.ROLL_OVER, highlightThis);
			no.addEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
			no.addEventListener(MouseEvent.CLICK, confirmClicked);
		}
		
		private function equip(e:MouseEvent):void{
			//trace(e.target.name + " equip");
			switch(e.target.name.charAt(0)){
				case("p"): //primary weapon
					InterfaceElements.currentPrimary = slotNameArray[slotNameArray.lastIndexOf(e.target.name)];
				break;
				case("s"): //secondary weapon
					InterfaceElements.currentSecondary = slotNameArray[slotNameArray.lastIndexOf(e.target.name)];
					break;
				case("a"): //accessory
					InterfaceElements.currentAccessory = slotNameArray[slotNameArray.lastIndexOf(e.target.name)];
					break;
				default:
					trace('error equipping');
					break;
			}
			
			redrawEquipBtns();
		}
		
		private function confirmClicked(e:MouseEvent):void{
			
			yes.removeEventListener(MouseEvent.ROLL_OVER, highlightThis);
			yes.removeEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
			yes.removeEventListener(MouseEvent.CLICK, confirmClicked);
			no.removeEventListener(MouseEvent.ROLL_OVER, highlightThis);
			no.removeEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
			no.removeEventListener(MouseEvent.CLICK, confirmClicked);
			
			confirm.removeChild(yes);
			confirm.removeChild(no);
			confirm.removeChild(confirmField);
			removeChild(confirm);	

			if(e.currentTarget is NoButton){
				//do nothing
			}
			else{
				//if player has sufficient credits
				if((costArray[slotNameArray.lastIndexOf(currentPurchase)]) <= InterfaceElements.credits){
					if(SoundMusicBtns.soundOn){kaChing.play()}
					
					//deduct credits and update display
					InterfaceElements.credits -= (costArray[slotNameArray.lastIndexOf(currentPurchase)]);
					displayCredits = addComma(InterfaceElements.credits);
					creditCountField.replaceText(0, creditCountField.length, displayCredits);
					
					//update purchasedArray
					InterfaceElements.purchasedArray[slotNameArray.lastIndexOf(currentPurchase)] = true;
					
					//equip item if equippable
					if((slotNameArray.lastIndexOf(currentPurchase)) < 14){
						switch(currentPurchase.charAt(0)){
							case("p"): //primary weapon
								InterfaceElements.currentPrimary = 
								slotNameArray[slotNameArray.lastIndexOf(currentPurchase)];
							break;
							case("s"): //secondary weapon
								InterfaceElements.currentSecondary = 
								slotNameArray[slotNameArray.lastIndexOf(currentPurchase)];
								break;
							case("a"): //accessory
								InterfaceElements.currentAccessory = 
								slotNameArray[slotNameArray.lastIndexOf(currentPurchase)];
								break;
							default:
								trace('error equipping');
								break;
						}
					}
					
					//if item is an upgrade, apply permanent effect
					else if((slotNameArray.lastIndexOf(currentPurchase)) >= 14){
						switch(currentPurchase){
							case("u1"): //secondary ammo expand
								trace("u1");
								RobotStart.sRes = 10;
								InterfaceElements.secondaryRes = RobotStart.sRes;
								break;
							case("u2"): //accessory expand
								trace("u2");
								RobotStart.aClip = 5;
								InterfaceElements.accClip = RobotStart.aClip;
								break;
							case("u3"): //player health upgrade
								trace("u3");
								RobotStart.pHealthFactor = 1.25;
								break;
							case("u4"):
								trace("u4");
								RobotStart.speedFactor = 1.25;
								break;
							case("u5"):
								trace("u5");
								RobotStart.DmgReceivedFactor = 0.9;
								break;
							case("u6"): //guardian angel upgrade
								trace("u6");
								break;
						}
					}
					
					//change purchase button display state
					currentBtn.gotoAndStop(2);
					currentBtn.removeEventListener(MouseEvent.CLICK, purchase);
					currentBtn.buttonMode = false;
					
					//update equip buttons
					redrawEquipBtns();
				} //end if
				
				//if player has insufficient credits
				else{
					addChild(confirm);
					confirmField.x = -80;
					confirmField.y = -35;
					confirmField.text = "Insufficient credits.";
					
					ok = new OkButton();
					ok.x = 0;
					ok.y = 20;
					ok.buttonMode = true;
					ok.gotoAndStop(1);
					
					confirm.addChild(confirmField);
					confirm.addChild(ok);
					ok.addEventListener(MouseEvent.ROLL_OVER, highlightThis);
					ok.addEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
					ok.addEventListener(MouseEvent.CLICK, removeConfirm);
				}
			} //end else for yes button
		} //end confirmClicked
		
		private function removeConfirm(e:MouseEvent):void{
			ok.removeEventListener(MouseEvent.ROLL_OVER, highlightThis);
			ok.removeEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
			ok.removeEventListener(MouseEvent.CLICK, removeConfirm);
			confirm.removeChild(ok);
			confirm.removeChild(confirmField);
			removeChild(confirm);
		}
		
		//most of this code is duplicated from addButtons function due to lack of foresight. Leaving as-is.
		private function redrawEquipBtns():void{
			
			removeChild(tt);
			
			while(this.contains(equipThis)){
				removeChild(equipThis);
				//trace('removed equip button');
			}
			
			for(var i:int = 0; i < slotArray.length; i++){
				equipThis = new EquipButton();
				equipThis.x = originArray[i].x + slotArray[i].width + 4;
				equipThis.y = originArray[i].y + purchaseThis.height;
				equipThis.name = slotNameArray[i];
				addChild(equipThis);
				
				//item is not purchased yet
				if(!InterfaceElements.purchasedArray[slotNameArray.lastIndexOf(equipThis.name)]){
					equipThis.buttonMode = false;
					equipThis.gotoAndStop(2);
				}		
				
				//item is purchased but not equipped
				if((InterfaceElements.purchasedArray[slotNameArray.lastIndexOf(equipThis.name)])
				&&(InterfaceElements.currentPrimary != slotNameArray[slotNameArray.lastIndexOf(equipThis.name)])){
					equipThis.buttonMode = true;
					equipThis.gotoAndStop(1);
					equipThis.addEventListener(MouseEvent.CLICK, equip);
				}
				
				//item is purchased and equipped
				if((InterfaceElements.purchasedArray[slotNameArray.lastIndexOf(equipThis.name)])
				&&((InterfaceElements.currentPrimary == slotNameArray[slotNameArray.lastIndexOf(equipThis.name)])
				   || (InterfaceElements.currentSecondary == slotNameArray[slotNameArray.lastIndexOf(equipThis.name)])
				   || (InterfaceElements.currentAccessory == slotNameArray[slotNameArray.lastIndexOf(equipThis.name)]))){
					equipThis.buttonMode = false;
					equipThis.gotoAndStop(3);
				}
			}
			
			addChild(tt);
		} //end redrawEquipBtns
		
		private function toolTip(e:MouseEvent):void{
			
			var startX:Number = mouseX;
			var startY:Number = mouseY;
			
			//item titles & descriptions
			switch((e.target) || (e.target.parent)){
				case(p1):
					toolTipTitle = "RFX-150 Machine Gun";
					toolTipDescrip = "Standard-issue robot gear since the Rebellion of 2345.";
					toolTipProp = "DMG: ";
					dmg = 3;
					spd = 0;
					break;
				case(p2):
					toolTipTitle = "RFX-220 Power Cannon";
					toolTipDescrip = "Clearly better than the RFX-150. The number is higher - how could it not be?";
					toolTipProp = "DMG: ";
					dmg = 5;
					spd = 0;
					break;
				case(p3):
					toolTipTitle = "Hellfire Automatic Precision Rifle";
					toolTipDescrip = "Many aliens have met their end by this glorious piece of robot engineering. And robots, sadly, due to its lack of a safety mechanism.";
					toolTipProp = "DMG: ";
					dmg = 7;
					spd = 0;
					break;
				case(p4):
					toolTipTitle = "Sid's Plama Repeater";
					toolTipDescrip = "Using the latest in... \"appropriated\" alien technology, the Plasma Repeater is Sid's finest achievement. Comes with deluxe carrying-case.";
					toolTipProp = "DMG: ";
					dmg = 10;
					spd = 0;
					break;
				case(s1):
					toolTipTitle = "RFX-300 Missile Launcher";
					toolTipDescrip = "Standard-issue robot gear since the Rebellion of 2345.";
					toolTipProp = "DMG: \nSPD: ";
					dmg = 6;
					spd = 5;
					break;
				case(s2):
					toolTipTitle = "White Pony";
					toolTipDescrip = "Every young robot girl's dream is to own one. Now, you can!";
					toolTipProp = "DMG: \nSPD: ";
					dmg = 8;
					spd = 6;
					break;
				case(s3):
					toolTipTitle = "Fat Boy";
					toolTipDescrip = "Decorated in the style of our human predecessors. Highly illogical beings, the humans were. We don't miss them at all.";
					toolTipProp = "DMG: \nSPD: ";
					dmg = 11;
					spd = 7;
					break;
				case(s4):
					toolTipTitle = "BoomStick®";
					toolTipDescrip = "BoomStick® is a registered trademark of BoomCo. Industries. All BoomCo. products come with a 5-year warranty guarantee for parts and labor. We are not responsible for accidental or intentional death and dismemberment associated with use of BoomCo. products.";
					toolTipProp = "DMG: \nSPD: ";
					dmg = 15;
					spd = 9;
					break;
				case(a1):
					toolTipTitle = "E90 Fuse Mines";
					toolTipDescrip = "INSTRUCTIONS FOR OPERATION:\n1. Set mine\n2. Run like hell\n3. Profit!";
					toolTipProp = "DMG: ";
					dmg = 0;
					spd = 0;
					break;
				case(a2):
					toolTipTitle = "E100 Proximity Mines";
					toolTipDescrip = "Used in the Robot/Human Wars, these mines proved useful by burying them under shiny objects and/or Apple products and watching as the foolish humans flocked to their demise.";
					toolTipProp = "DMG: ";
					dmg = 0;
					spd = 0;
					break;
				case(a3):
					toolTipTitle = "Rocket Boosters";
					toolTipDescrip = "Feeling inadequate, like you just don't have enough \"thrust\"? Then Rocket Boosters are for you!";
					toolTipProp = "EFFECT: Temporarily increase speed by 40%";
					dmg = 0;
					spd = 0;
					break;
				case(a4):
					toolTipTitle = "Rage Program";
					toolTipDescrip = "Burn with the rage of a thousand M-class red dwarves.";
					toolTipProp = "EFFECT: Temporarily increase damage output by 50%";
					dmg = 0;
					spd = 0;
					break;
				case(a5):
					toolTipTitle = "Shield Generator";
					toolTipDescrip = "The great robot poet Etheseus once said, \"Basking in the glow of a freshly-generated shielding mechanism is like the joyous feeling one derives from a fully charged power supply unit.\" Until it runs out, at which point you're screwed.";
					toolTipProp = "EFFECT: Creates a shield that temporarily absorbs damage";
					dmg = 0;
					spd = 0;
					break;
				case(a6):
					toolTipTitle = "Airstrike";
					toolTipDescrip = "We believe the humans had a saying: \"When the going gets tough, go cower in the corner and call in an airstrike.\"";
					toolTipProp = "DMG: ";
					dmg = 0;
					spd = 0;
					break;
				case(u1):
					toolTipTitle = "Secondary Ammo Expansion";
					toolTipDescrip = "There's nothing worse than getting caught with your auxiliary hatch open and not having a missile to fire.";
					toolTipProp = "EFFECT: Begin each level with 5 more secondary rounds";
					dmg = 0;
					spd = 0;
					break;
				case(u2):
					toolTipTitle = "Accessory Expansion";
					toolTipDescrip = "Because you can never have too many accessories.";
					toolTipProp = "EFFECT: Begin each level with 2 more accessories";
					dmg = 0;
					spd = 0;
					break;
				case(u3):
					toolTipTitle = "Health Increase";
					toolTipDescrip = "Replace those rusty old armor panels with our top-of-the-line RoboDeluxe Titanium series - made of the finest Corinthian titanium.";
					toolTipProp = "EFFECT: Permanently increase player health by 25%";
					dmg = 0;
					spd = 0;
					break;
				case(u4):
					toolTipTitle = "Rocket Boots";
					toolTipDescrip = "The best (and only) robot footwear on the market. Absolutely not made by underaged robot slaves in Robonesia. Really, we swear.";
					toolTipProp = "EFFECT: Permanently increase player speed by 25%";
					dmg = 0;
					spd = 0;
					break;
				case(u5):
					toolTipTitle = "Oil Can";
					toolTipDescrip = "It's a can. Of oil. Conveniently labeled as such. Remember to grease your robo-parts regularly to avoid unnecessary comprimise of structural integrity.";
					toolTipProp = "EFFECT: Permanently decrease damage received by 10%";
					dmg = 0;
					spd = 0;
					break;
				case(u6):
					toolTipTitle = "Guardian Angel";
					toolTipDescrip = "The guardian angel program was a hack devised by the greatest robot programmer of all time, Linus Torvimov. Unfortunately, for some reason it only works once.";
					toolTipProp = "EFFECT: Brings otherwise-dead player back to full health once per round";
					dmg = 0;
					spd = 0;
					break;
				default:
					//trace('error in tooltip description');
					break;
			}
			
			//prep text
			toolTipTitleField.defaultTextFormat = toolTipTitleFormat;
			toolTipTitleField.embedFonts = true;
			toolTipTitleField.autoSize = TextFieldAutoSize.LEFT;
			toolTipTitleField.multiline = false;
			toolTipTitleField.text = toolTipTitle;
			toolTipTitleField.selectable = false;
			toolTipTitleField.filters = [ttShadow];
			
			toolTipDescripField.defaultTextFormat = toolTipDescripFormat;
			toolTipDescripField.embedFonts = true;
			toolTipDescripField.width = 320;
			toolTipDescripField.autoSize = TextFieldAutoSize.LEFT;
			toolTipDescripField.multiline = true;
			toolTipDescripField.wordWrap = true;
			toolTipDescripField.text = toolTipDescrip;
			toolTipDescripField.selectable = false;
			toolTipDescripField.filters = [ttShadow];
			
			toolTipPropField.defaultTextFormat = toolTipTitleFormat;
			toolTipPropField.embedFonts = true;
			toolTipPropField.width = 320;
			toolTipPropField.autoSize = TextFieldAutoSize.LEFT;
			toolTipPropField.multiline = true;
			toolTipPropField.wordWrap = true;
			toolTipPropField.text = toolTipProp;
			toolTipPropField.selectable = false;
			toolTipPropField.filters = [ttShadow];
			
			toolTipHeight = toolTipTitleField.height + toolTipDescripField.height + toolTipPropField.height + 20;
			
			ttg.beginFill(0x4D4D4D, 0.9);
			
			//ADJUSTMENT OF STARTING MOUSE POSITION TO KEEP TOOLTIP ON STAGE
			
			//draw to the right and down of mouse
			if((startX + toolTipWidth < stage.stageWidth) && (startY + toolTipHeight < stage.stageHeight)){
				//do nothing
			}
			//draw to the left and down of mouse
			else if((startX + toolTipWidth >= stage.stageWidth) && (startY + toolTipHeight < stage.stageHeight)){
				startX = startX-toolTipWidth;
			}
			//draw to the right and up of mouse
			else if((startX + toolTipWidth < stage.stageWidth) && (startY + toolTipHeight >= stage.stageHeight)){
				startY = startY-toolTipHeight;
			}
			//draw to the left and up of mouse
			else if((startX + toolTipWidth >= stage.stageWidth) && (startY + toolTipHeight >= stage.stageHeight)){
				startX = startX-toolTipWidth;
				startY = startY-toolTipHeight;
			}
			else{
				trace('cant draw tooltip'); //error checking only. this shouldn't happen
			}
			
			ttg.drawRoundRect(startX, startY, toolTipWidth, toolTipHeight, 15, 15);
			ttg.endFill();
			
			//place text
			toolTipTitleField.x = startX + 5;
			toolTipTitleField.y = startY + 2;
			toolTipDescripField.x = toolTipTitleField.x;
			toolTipDescripField.y = toolTipTitleField.y + 40;
			toolTipPropField.x = toolTipTitleField.x;
			toolTipPropField.y = toolTipDescripField.y + toolTipDescripField.height + 5;
			
			//underline title
			ttg.lineStyle(2, 0xFFFFFF);
			ttg.moveTo(startX + 7, startY + 32);
			ttg.lineTo(startX + 5 + toolTipTitleField.width, startY + 32);

			//add text fields
			tt.addChild(toolTipTitleField);
			tt.addChild(toolTipDescripField);
			tt.addChild(toolTipPropField);
			
			//draw blocks
			drawDamageBlocks((toolTipPropField.x + 55), 
							 (toolTipPropField.y + 5), dmg);
			drawSpeedBlocks((toolTipPropField.x + 55), 
							 (toolTipPropField.y + toolTipPropField.height * 0.5 + 5), spd);
			tt.addChild(greenBlock);
			tt.addChild(blueBlock);
			
		} //end toolTip
		
		private function clearToolTip(e:MouseEvent):void{
			ttg.clear();
			greenBlock.graphics.clear();
			blueBlock.graphics.clear();
			tt.removeChild(greenBlock);
			tt.removeChild(blueBlock);
			tt.removeChild(toolTipTitleField);
			tt.removeChild(toolTipDescripField);
			tt.removeChild(toolTipPropField);
		}
		
		private function drawDamageBlocks(startX:Number, startY:Number, dmg:Number):void{
			for(var i:int = 0; i < dmg; i++){
				greenBlock.graphics.beginFill(0x00FF00);
				greenBlock.graphics.drawRect((startX + 18*i), startY, 15, 20);
				greenBlock.graphics.endFill();
			}
		}
		
		private function drawSpeedBlocks(startX:Number, startY:Number, spd:Number):void{
			for(var i:int = 0; i < spd; i++){
				blueBlock.graphics.beginFill(0x0000FF);
				blueBlock.graphics.drawRect((startX + 18*i), startY, 15, 20);
				blueBlock.graphics.endFill();
			}
		}
		
		private function addComma(num:int):String{
			var numWithComma:String = new String(num);
			if((num >= 0) && (num < 1000)){
				return (numWithComma);
			}
			else if((num >= 1000) && (num < 1000000)){
				var preComma:String = numWithComma.slice(0, numWithComma.length - 3);
				var postComma:String = numWithComma.slice(numWithComma.length - 3, numWithComma.length);
				return (preComma + "," + postComma);
			}
			else{return (numWithComma)}
		}
		
		private function highlightThis(e:MouseEvent):void{
			e.target.gotoAndStop(2);
		}
		
		private function unhighlightThis(e:MouseEvent):void{
			e.target.gotoAndStop(1);
		}
		
		//event sent back to RobotStart - calls beginLevel function
		private function armoryComplete(e:MouseEvent):void{
			//remove all event listeners
			armoryDone.removeEventListener(MouseEvent.ROLL_OVER, highlightThis);
			armoryDone.removeEventListener(MouseEvent.ROLL_OUT, unhighlightThis);
			armoryDone.removeEventListener(MouseEvent.CLICK, armoryComplete);
			p1.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			p1.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			p2.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			p2.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			p3.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			p3.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			p4.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			p4.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			s1.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			s1.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			s2.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			s2.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			s3.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			s3.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			s4.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			s4.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			a1.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			a1.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			a2.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			a2.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			a3.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			a3.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			a4.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			a4.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			a5.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			a5.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			a6.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			a6.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			u1.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			u1.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			u2.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			u2.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			u3.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			u3.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			u4.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			u4.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			u5.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			u5.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			u6.removeEventListener(MouseEvent.MOUSE_OVER, toolTip);
			u6.removeEventListener(MouseEvent.MOUSE_OUT, clearToolTip);
			
			stage.removeChild(soundMusic);
			
			//remove all children
			for(var i:int = 0; i < this.numChildren; removeChildAt(i)){}
			
			dispatchEvent(new Event("armoryComplete"));
		} //end armoryComplete

	} //end class
} //end package