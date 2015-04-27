package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * The Cairngorm event broadcast to get the locale list
	 */
	public class DspExportEvent extends CairngormEvent 
	{
	
				
		/**
		 * The constructor
		 */
		public function DspExportEvent()
		{
			super(MainController.EVENT_DSP_EXPORT);
		}
	}
}