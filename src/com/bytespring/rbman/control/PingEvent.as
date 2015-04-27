package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * The Cairngorm event
	 */
	public class PingEvent extends CairngormEvent 
	{
				
		/**
		 * The constructor
		 */
		public function PingEvent()
		{
			super(MainController.EVENT_PING);
		}
	}	
}