package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.bytespring.rbman.business.GetLocaleStatsDelegate;
	import com.bytespring.rbman.model.ModelLocator;
	import com.bytespring.rbman.vo.StatsBean;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class GetLocaleStatsCommand implements ICommand, IResponder
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  
		public function execute( event : CairngormEvent ) : void
		{			
			var delegate : GetLocaleStatsDelegate = new GetLocaleStatsDelegate( this );
			delegate.getStats(model.currentLocale);
		}

		
		public function result(event:Object):void
		{
				model.stats = event.result as StatsBean;
				model.stats.totalBundles = model.bundleList.length;
		}
				
		public function fault(event:Object):void
		{
			Alert.show( ObjectUtil.toString(event.fault) );
		}
	}
}