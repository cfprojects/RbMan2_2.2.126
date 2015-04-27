package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * The Cairngorm event broadcast to get the locale list
	 */
	public class DspImportEvent extends CairngormEvent 
	{
	
				
		/**
		 * The constructor
		 */
		public function DspImportEvent()
		{
			super(MainController.EVENT_DSP_IMPORT);
		}
	}
}