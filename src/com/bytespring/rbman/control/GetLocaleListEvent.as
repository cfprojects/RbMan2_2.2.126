package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * The Cairngorm event broadcast to get the locale list
	 */
	public class GetLocaleListEvent extends CairngormEvent 
	{
		/**
		 * The locale list
		 */
		public var localeList : Array;
				
		/**
		 * The constructor
		 */
		public function GetLocaleListEvent() 
		{
			super( MainController.EVENT_GET_LOCALE_LIST );
		}
	}	
}