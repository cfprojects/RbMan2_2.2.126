package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.bytespring.rbman.business.DeleteBundleDelegate;
	import com.bytespring.rbman.control.DeleteBundleEvent;
	import com.bytespring.rbman.control.GetLocaleStatsEvent;
	import com.bytespring.rbman.model.ModelLocator;
	import com.bytespring.rbman.model.Util;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class DeleteBundleCommand implements ICommand, IResponder
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  	private var _name:String;
	  	
		public function execute( event : CairngormEvent ) : void
		{			
			var delegate : DeleteBundleDelegate = new DeleteBundleDelegate( this );
			var dbEvent:DeleteBundleEvent = event as DeleteBundleEvent;
			_name = dbEvent.name;
			delegate.deleteBundle(_name);
		}

		
		public function result(event:Object):void
		{
			var success:Boolean = Boolean(event.result);
			if(success) {
				//set the mainPanelVC state
				model.mainPanelState = ModelLocator.STATE_MAIN_PANEL_BASE;
				
				// remove the bundle from the current bundle list
				for(var i:int=0; i<model.bundleList.length; i++){
					if(model.bundleList[i].name == _name){
						model.bundleList.removeItemAt(i);
					}
				}
				
				//success message
				Util.displayInfoMessage("bundle.delete.ok");
				//update the stats
				var event1 : GetLocaleStatsEvent = new GetLocaleStatsEvent();
				CairngormEventDispatcher.getInstance().dispatchEvent(event1);
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