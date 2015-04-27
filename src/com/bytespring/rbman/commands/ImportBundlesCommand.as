package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.bytespring.rbman.business.ImportBundlesDelegate;
	import com.bytespring.rbman.control.*;
	import com.bytespring.rbman.model.ModelLocator;
	import com.bytespring.rbman.model.Util;
	
	import flash.media.SoundChannel;
	
	import mx.controls.Alert;
	import mx.core.SoundAsset;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class ImportBundlesCommand implements ICommand, IResponder
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  
		public function execute( event : CairngormEvent ) : void
		{			
			var delegate : ImportBundlesDelegate = new ImportBundlesDelegate( this );
			var iEvent:ImportBundlesEvent = event as ImportBundlesEvent;
			delegate.importBundles(model.login.user.username,iEvent.encoding);
		}

		
		public function result(event:Object):void
		{
				var success:Boolean = Boolean(event.result);
				if(success) {
					//set the mainPanelVC state
					model.mainPanelState = ModelLocator.STATE_MAIN_PANEL_BASE;
					//success message
					Util.displayInfoMessage("bundle.import.ok");
					//get the bundleList
					var event2 : GetBundleListEvent = new GetBundleListEvent(model.currentLocale);
					CairngormEventDispatcher.getInstance().dispatchEvent(event2);
					// play a sound
					model.playSound('ding');
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