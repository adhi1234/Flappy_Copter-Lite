package org.summit.flappycopter
{
	import flash.display.Sprite;
	import flash.events.Event;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Juwal
	 */
	public class Main extends Sprite 
	{
		
		var _starling:Starling;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			_starling = new Starling(FlappyCopter, stage);
			_starling.start();
		}
		
	}
	
}