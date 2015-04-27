package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.bytespring.rbman.business.GetBundleListDelegate;
	import com.bytespring.rbman.control.*;
	import com.bytespring.rbman.model.ModelLocator;
	import com.bytespring.rbman.model.Util;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class GetBundleListCommand implements ICommand, IResponder
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  
		public function execute( event : CairngormEvent ) : void
		{			
			var delegate : GetBundleListDelegate = new GetBundleListDelegate( this );
			var evt:GetBundleListEvent = event as GetBundleListEvent;
			model.currentLocale = evt.locale;
			
			delegate.getBundleList(evt.locale);
		}

		
		public function result(event:Object):void
		{
			//set the bundleList in the modelLocator
			model.bundleList = event.result as ArrayCollection;
			//reset the mainPanelVC
			model.mainPanelState = ModelLocator.STATE_MAIN_PANEL_BASE;
			//display a welcome message
			var msg:String = ResourceManager.getInstance().getString('resources','bundle.list.loaded',[model.currentLocale]);
			Util.displayInfoMessage(msg);
			//update the stats
			var event1 : GetLocaleStatsEvent = new GetLocaleStatsEvent();
			CairngormEventDispatcher.getInstance().dispatchEvent(event1);
			//set the users permissions
    		var event2 : SetPermissionsEvent = new SetPermissionsEvent();
			CairngormEventDispatcher.getInstance().dispatchEvent(event2);
		}
				
		public function fault(event:Object):void
		{
			Alert.show( ObjectUtil.toString(event.fault) );
		}
	}
}