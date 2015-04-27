package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.bytespring.rbman.business.CreateBundleDelegate;
	import com.bytespring.rbman.control.CreateBundleEvent;
	import com.bytespring.rbman.control.GetBundleListEvent;
	import com.bytespring.rbman.model.ModelLocator;
	import com.bytespring.rbman.model.Util;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class CreateBundleCommand implements ICommand, IResponder
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  
		public function execute( event : CairngormEvent ) : void
		{			
			var delegate : CreateBundleDelegate = new CreateBundleDelegate( this );
			var evt:CreateBundleEvent = event as CreateBundleEvent;
			delegate.createBundle(evt.bundle);
		}

		
		public function result(event:Object):void
		{
				var success:Boolean = Boolean(event.result);
				if(success) {
					//set the mainPanelVC state
					model.mainPanelState = ModelLocator.STATE_MAIN_PANEL_BASE;
					// reset state of the BundleDetail VC
					model.bundleEditorState = '';
					//success message
					Util.displayInfoMessage("bundle.added.ok");
					//refresh the bundle list
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
	}
}