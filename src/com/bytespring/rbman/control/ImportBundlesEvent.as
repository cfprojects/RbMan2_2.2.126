package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * The Cairngorm event broadcast to get the locale list
	 */
	public class ImportBundlesEvent extends CairngormEvent 
	{
		public var encoding:String;	
				
		/**
		 * The constructor
		 */
		public function ImportBundlesEvent(encoding:String)
		{
			super(MainController.EVENT_IMPORT);
			this.encoding = encoding;
		}
	}
}