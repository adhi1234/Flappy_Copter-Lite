package org.summit.flappycopter 
{
	import flash.accessibility.ISearchableText;
	import flash.display3D.textures.RectangleTexture;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Juwal
	 */
	public class FlappyCopter extends Sprite 
	{
		[Embed(source = "../../../../assets/copterassets.png")]
		var CopterAssetsPng:Class;
		
		[Embed(source = "../../../../assets/copterassets.xml" , mimeType ="application/octet-stream")]
		var CopterAssetsXml:Class;
		
		//[Embed(source = "../../../../assets/journey.mp3")]
		//var GameMusic:Class;
		
		[Embed(source = "../../../../assets/crash.mp3")]
		var CrashSound:Class; 
		
		[Embed(source="../../../../assets/shield.mp3")]
		var PopSound:Class;
		
		var atlas:TextureAtlas;
		
		var copter:MovieClip;
		var bkg:Image;
		var bkg1:Image;
		var gravity:int = 1;
		var fallSpeed:Number = 0;
		var moveSpeed:int = 10;
		var hill:Image;
		var downHill:Image;
		
		var currentHill:Image;
		
		var isDead:Boolean = false;
		var go:Image;
		
		var popSound:Sound;
		var crashSound:Sound;
		
		public function FlappyCopter() 
		{
			super();
			
			atlas = new TextureAtlas(Texture.fromBitmap(new CopterAssetsPng()), XML(new CopterAssetsXml()));
			
			addBackground();
			addCopter();
			addHill();
			
			go = new Image(atlas.getTexture("gameover"));
			addChild(go);
			go.x = -1000;
			
			popSound = new PopSound();
			crashSound = new CrashSound();
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, gameLoop);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function addHill():void 
		{
			hill = new Image(atlas.getTexture("rockGrassUp"));
			addChild(hill);
			downHill = new Image(atlas.getTexture("rockGrassDown"));
			addChild(downHill);
			placeHill();
		}
		
		private function placeHill():void 
		{
			hill.y = 480 - 239;
			hill.x = 800 + Math.random() * 400;
			
			downHill.x = 800 + Math.random() * 400;
			
			if (Math.random()>0.4) {
				currentHill = hill;
			}else {
				currentHill = downHill;
			}
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this);
			if (touch && touch.phase==TouchPhase.BEGAN) {
				fallSpeed = -10;
				popSound.play();
			}
		}
		
		private function gameLoop(e:EnterFrameEvent):void 
		{
			if(!isDead){
				moveCopter();
				moveHill();
				moveBkg();
			
				checkCollision();
			}else {
				
				go.x = 200;
				go.y = 100;
			}
		}
		
		private function checkCollision():void 
		{
			var rect:Rectangle = copter.getBounds(this);
			var rect2:Rectangle = currentHill.getBounds(this);
			if (rect.intersects(rect2)) {
				gameOver();
			}
		}
		
		private function gameOver():void 
		{
			trace("game over");
			isDead = true;
			crashSound.play();
		}
		
		private function moveHill():void 
		{
			currentHill.x -= moveSpeed;
			if (currentHill.x<-108) {
				placeHill();
			}
			
		}
		
		private function moveCopter():void 
		{
			copter.y += fallSpeed;
			fallSpeed += gravity;
		}
		
		private function moveBkg():void 
		{
			bkg.x -= moveSpeed;
			bkg1.x -= moveSpeed;
			if (bkg.x<=-800) {
				resetPosition();
			}
		}
		
		private function addBackground():void 
		{
			bkg = new Image(atlas.getTexture("background"));
			addChild(bkg);
			bkg1 = new Image(atlas.getTexture("background"));
			addChild(bkg1);
			resetPosition();
		}
		
		private function resetPosition():void 
		{
			bkg.x = 0;
			bkg1.x = 800;
		}
		
		private function addCopter():void 
		{
			copter = new MovieClip(atlas.getTextures("planeRed"), 20);
			addChild(copter);
			copter.x = 300;
			copter.y = 200;
			Starling.juggler.add(copter);
		}
		
	}

}