package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * The Cairngorm event broadcast to get the locale list
	 */
	public class SetPermissionsEvent extends CairngormEvent 
	{
				
		/**
		 * The constructor
		 */
		public function SetPermissionsEvent()
		{
			super(MainController.EVENT_SET_PERMISSIONS);
		}
	}	
}