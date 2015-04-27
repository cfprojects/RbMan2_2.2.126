package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.collections.ArrayCollection;
	
	/**
	 * The Cairngorm event broadcast to get the locale list
	 */
	public class GetLocaleStatsEvent extends CairngormEvent 
	{
	
				
		/**
		 * The constructor
		 */
		public function GetLocaleStatsEvent()
		{
			super(MainController.EVENT_GET_LOCALE_STATS);
		}
	}	
}