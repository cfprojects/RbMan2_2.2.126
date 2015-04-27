package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.bytespring.rbman.business.GetLocaleListDelegate;
	import com.bytespring.rbman.model.ModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class GetLocaleListCommand implements ICommand, IResponder
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  
		public function execute( event : CairngormEvent ) : void
		{			
			var delegate : GetLocaleListDelegate = new GetLocaleListDelegate( this );
			delegate.getLocaleList();
		}

		
		public function result(event:Object):void
		{
				model.localeList = event.result as Array;
		}
				
		public function fault(event:Object):void
		{
			Alert.show( ObjectUtil.toString(event.fault) );
		}
	}
}