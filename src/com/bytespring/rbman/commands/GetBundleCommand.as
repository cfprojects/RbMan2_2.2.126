package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.bytespring.rbman.business.GetBundleDelegate;
	import com.bytespring.rbman.control.GetBaseBundleEvent;
	import com.bytespring.rbman.control.GetBundleEvent;
	import com.bytespring.rbman.model.ModelLocator;
	import com.bytespring.rbman.vo.BundleBean;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class GetBundleCommand implements ICommand, IResponder
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  
		public function execute( event : CairngormEvent ) : void
		{			
			var delegate : GetBundleDelegate = new GetBundleDelegate( this );
			var gbe:GetBundleEvent = event as GetBundleEvent;
			delegate.getBundleById(gbe.bundle_id);
		}
		
		public function result(event:Object):void
		{
			//set the mainPanelVC state
			model.mainPanelState = ModelLocator.STATE_MAIN_PANEL_BUNDLE_DETAIL;
			//get the bundle
			model.bundle = event.result as BundleBean;
			
			/* temp code for debugging */
			/*
			Util.displayInfoMessage('bundle loaded with key array len: ' + model.bundle.keyBeans.length);
			
			for each(var key:KeyBean in model.bundle.keyAC){
				Util.displayInfoMessage('key added: ' + key.rbkey);
			}
			*/
			
			//get the base bundle
			if(model.bundle.rbloc == ModelLocator.BASE_LOCALE){
				model.baseBundle = model.bundle;
			}else{
				CairngormEventDispatcher.getInstance().dispatchEvent(new GetBaseBundleEvent(model.bundle.name));
			}
			// set the editor state
			model.bundleEditorState = ModelLocator.STATE_EDIT_BUNDLE;
		}
				
		public function fault(event:Object):void
		{
			Alert.show( ObjectUtil.toString(event.fault) );
		}
	}
}