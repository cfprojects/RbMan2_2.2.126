package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * The Cairngorm event broadcast to get the locale list
	 */
	public class DeleteLocaleEvent extends CairngormEvent 
	{
				
		/**
		 * The constructor
		 */
		public function DeleteLocaleEvent()
		{
			super(MainController.EVENT_DSP_DELETE_LOCALE);
		}
	}	
}