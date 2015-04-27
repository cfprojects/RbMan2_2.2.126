package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * The Cairngorm event broadcast to get the locale list
	 */
	public class LogoutEvent extends CairngormEvent 
	{
				
		/**
		 * The constructor
		 */
		public function LogoutEvent()
		{
			super(MainController.EVENT_LOGOUT);
		}
	}	
}