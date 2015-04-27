package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.bytespring.rbman.vo.BundleBean;
	
	public class CreateBundleEvent extends CairngormEvent 
	{
		public var bundle:BundleBean;
				
		public function CreateBundleEvent(bundle:BundleBean)
		{
			super(MainController.EVENT_CREATE_BUNDLE);
			this.bundle = bundle;
		}
	}	
}