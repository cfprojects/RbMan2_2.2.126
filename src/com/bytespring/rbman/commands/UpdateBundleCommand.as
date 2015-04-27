package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.bytespring.rbman.business.UpdateBundleDelegate;
	import com.bytespring.rbman.control.GetLocaleStatsEvent;
	import com.bytespring.rbman.control.UpdateBundleEvent;
	import com.bytespring.rbman.model.ModelLocator;
	import com.bytespring.rbman.model.Util;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class UpdateBundleCommand implements ICommand, IResponder
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  
		public function execute( event : CairngormEvent ) : void
		{			
			var delegate : UpdateBundleDelegate = new UpdateBundleDelegate( this );
			var evt:UpdateBundleEvent = event as UpdateBundleEvent;
			model.updateTranslatedKeys();
			delegate.updateBundle(evt.bundle);
		}

		
		public function result(event:Object):void
		{
				var success:Boolean = Boolean(event.result);
				if(success) {
					//set the mainPanelVC state
					model.mainPanelState = ModelLocator.STATE_MAIN_PANEL_BASE;
					// set the editor state
					model.bundleEditorState = '';
					//success message
					Util.displayInfoMessage("The bundle was updated successfully.");
					//update the stats
					var event1 : GetLocaleStatsEvent = new GetLocaleStatsEvent();
					CairngormEventDispatcher.getInstance().dispatchEvent(event1);
				}else{
					//error message
					Util.displayErrorMessage("An error occurred.");
				}
		}
				
		public function fault(event:Object):void
		{
			Alert.show( ObjectUtil.toString(event.fault) );
		}
	}
}