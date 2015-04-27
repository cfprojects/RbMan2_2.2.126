package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.bytespring.rbman.business.DeleteLocaleDelegate;
	import com.bytespring.rbman.control.GetBundleListEvent;
	import com.bytespring.rbman.control.GetLocaleListEvent;
	import com.bytespring.rbman.model.ModelLocator;
	import com.bytespring.rbman.model.Util;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class DeleteCurrentLocaleCommand implements ICommand, IResponder
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  
		public function execute( event : CairngormEvent ) : void
		{			
			var delegate : DeleteLocaleDelegate = new DeleteLocaleDelegate( this );
			if(model.currentLocale != ModelLocator.BASE_LOCALE){
				delegate.deleteLocale(model.currentLocale);
			} else {
				showBaseError();
			}
		}

		
		public function result(event:Object):void
		{
				var success:Boolean = Boolean(event.result);
				if(success) {
					//set the mainPanelVC state
					model.mainPanelState = ModelLocator.STATE_MAIN_PANEL_BASE;
					//success message
					Util.displayInfoMessage("locale.delete.ok");
					//set the currentLocale back to base
					model.currentLocale = ModelLocator.BASE_LOCALE;
					//get the localeList
					var event1 : GetLocaleListEvent = new GetLocaleListEvent();
					CairngormEventDispatcher.getInstance().dispatchEvent(event1);
					//get the bundleList
					var event2 : GetBundleListEvent = new GetBundleListEvent(model.currentLocale);
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
		
		public function showBaseError():void
		{
			//set the mainPanelVC state
			model.mainPanelState = ModelLocator.STATE_MAIN_PANEL_BASE;
			//success message
			Util.displayErrorMessage("The base locale can not be deleted.");
		}
	}
}