package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * The Cairngorm event broadcast to get the locale list
	 */
	public class AddBundleEvent extends CairngormEvent 
	{
				
		/**
		 * The constructor
		 */
		public function AddBundleEvent()
		{
			super(MainController.EVENT_ADD_BUNDLE);
		}
	}	
}