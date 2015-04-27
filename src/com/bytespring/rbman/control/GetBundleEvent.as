package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class GetBundleEvent extends CairngormEvent 
	{
		public var bundle_id : Number;
		
		public function GetBundleEvent(id:Number)
		{
			super(MainController.EVENT_GET_BUNDLE);
			this.bundle_id = id;
		}
	}	
}