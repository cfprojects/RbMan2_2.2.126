package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.controls.ProgressBar;
	
	/**
	 * The Cairngorm event broadcast to get the locale list
	 */
	public class ExportBundlesEvent extends CairngormEvent 
	{
		
		/**
		 * The bundle array
		 */
		public var bundleArray:Array;
		public var encoding:String;
		public var progressBar:ProgressBar;
				
		/**
		 * The constructor
		 */
		public function ExportBundlesEvent(bundles:Array, encoding:String, prog:ProgressBar)
		{
			super(MainController.EVENT_EXPORT);
			this.bundleArray = bundles;
			this.encoding = encoding;
			this.progressBar = prog;
		}
	}	
}