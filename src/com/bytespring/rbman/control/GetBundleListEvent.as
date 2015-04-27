package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.collections.ArrayCollection;
	
	public class GetBundleListEvent extends CairngormEvent 
	{
		public var bundleList : ArrayCollection;
		public var locale:String;
				
		public function GetBundleListEvent(locale:String)
		{
			super(MainController.EVENT_GET_BUNDLE_LIST);
			this.locale = locale;
		}
	}	
}