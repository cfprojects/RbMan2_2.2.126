package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.bytespring.rbman.vo.User;
	
	/**
	 * The Cairngorm event broadcast when adding a new locale
	 */
	public class AddNewLocaleEvent extends CairngormEvent 
	{
		/**
		 * The login details for the user
		 */
		public var rbloc : String;
				
		/**
		 * The constructor, taking an rbloc
		 */
		public function AddNewLocaleEvent(loc:String) 
		{
			super( MainController.EVENT_ADD_NEW_LOCALE );
			this.rbloc = loc;
		}
	}	
}