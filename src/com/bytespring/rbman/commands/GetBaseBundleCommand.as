package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.bytespring.rbman.business.GetBaseBundleDelegate;
	import com.bytespring.rbman.control.GetBaseBundleEvent;
	import com.bytespring.rbman.model.ModelLocator;
	import com.bytespring.rbman.vo.BundleBean;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class GetBaseBundleCommand implements ICommand, IResponder
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  
		public function execute( event : CairngormEvent ) : void
		{			
			var delegate : GetBaseBundleDelegate = new GetBaseBundleDelegate( this );
			var gbe:GetBaseBundleEvent = event as GetBaseBundleEvent;
			delegate.getBaseBundle(gbe.name);
		}
		
		public function result(event:Object):void
		{
			//set the base bundle
			model.baseBundle = event.result as BundleBean;
			model.updateTranslatedKeys();
		}
				
		public function fault(event:Object):void
		{
			Alert.show( ObjectUtil.toString(event.fault) );
		}
	}
}