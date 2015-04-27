package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class GetBaseBundleEvent extends CairngormEvent 
	{
		public var name:String;
		
		public function GetBaseBundleEvent(name:String)
		{
			super(MainController.EVENT_GET_BASE_BUNDLE);
			this.name = name;
		}
	}	
}