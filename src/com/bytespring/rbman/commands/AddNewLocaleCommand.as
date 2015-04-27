package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.bytespring.rbman.business.AddLocaleDelegate;
	import com.bytespring.rbman.control.AddNewLocaleEvent;
	import com.bytespring.rbman.control.GetBundleListEvent;
	import com.bytespring.rbman.control.GetLocaleListEvent;
	import com.bytespring.rbman.model.ModelLocator;
	import com.bytespring.rbman.model.Util;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class AddNewLocaleCommand implements ICommand, IResponder
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  private var rbloc:String;
	  
		public function execute( event : CairngormEvent ) : void
		{			
			var delegate : AddLocaleDelegate = new AddLocaleDelegate( this );
			var evt:AddNewLocaleEvent = event as AddNewLocaleEvent;
			rbloc = evt.rbloc;
			delegate.addLocale(rbloc);
		}

		
		public function result(event:Object):void
		{
				var success:Boolean = Boolean(event.result);
				if(success) {
					//set the mainPanelVC state
					model.mainPanelState = ModelLocator.STATE_MAIN_PANEL_BASE;
					//success message
					Util.displayInfoMessage("locale.added.ok");
					//set the currentLocale
					model.currentLocale = rbloc;
					//get the localeList
					var event1 : GetLocaleListEvent = new GetLocaleListEvent();
					CairngormEventDispatcher.getInstance().dispatchEvent(event1);
					//get the bundleList
					var event2 : GetBundleListEvent = new GetBundleListEvent(rbloc);
					CairngormEventDispatcher.getInstance().dispatchEvent(event2);
				}else{
					//error message
					Util.displayErrorMessage("generic.error");
				}
		}
				
		public function fault(event:Object):void
		{
			Alert.show( ObjectUtil.toString(event.fault) );
		}
	}
}