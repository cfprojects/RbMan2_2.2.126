package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * The Cairngorm event broadcast to get the locale list
	 */
	public class AddLocaleEvent extends CairngormEvent 
	{
				
		/**
		 * The constructor
		 */
		public function AddLocaleEvent()
		{
			super(MainController.EVENT_DSP_ADD_LOCALE);
		}
	}	
}