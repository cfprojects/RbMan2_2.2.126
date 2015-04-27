package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * The Cairngorm event broadcast to get the locale list
	 */
	public class DeleteCurrentLocaleEvent extends CairngormEvent 
	{
				
		/**
		 * The constructor
		 */
		public function DeleteCurrentLocaleEvent()
		{
			super(MainController.EVENT_DELETE_CURRENT_LOCALE);
		}
	}	
}