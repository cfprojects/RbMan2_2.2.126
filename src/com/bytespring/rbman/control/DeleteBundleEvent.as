package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * The Cairngorm event broadcast to get the locale list
	 */
	public class DeleteBundleEvent extends CairngormEvent 
	{
		
		/**
		 * The bundle name
		 */
		public var name:String;
				
		/**
		 * The constructor
		 */
		public function DeleteBundleEvent(name:String)
		{
			super(MainController.EVENT_DELETE_BUNDLE);
			this.name = name;
		}
	}	
}