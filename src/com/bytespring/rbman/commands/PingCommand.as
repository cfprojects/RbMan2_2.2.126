package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.bytespring.rbman.business.PingDelegate;
	import com.bytespring.rbman.control.PingEvent;
	import com.bytespring.rbman.model.ModelLocator;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class PingCommand implements ICommand, IResponder
	{
		private var model : ModelLocator = ModelLocator.getInstance();
		private var pingTimer:Timer;
	  
		public function execute( event : CairngormEvent ) : void
		{			
			var delegate : PingDelegate = new PingDelegate( this );
			delegate.ping();
		}

		
		public function result(event:Object):void
		{
				var success:Boolean = Boolean(event.result);
				if(ModelLocator.pingEnabled && success){
					// create a timer to ping the server again
					pingTimer = new Timer(ModelLocator.pingInterval,1);
					pingTimer.addEventListener(TimerEvent.TIMER_COMPLETE,PingMe);
					pingTimer.start();
				}
		}
				
		public function fault(event:Object):void
		{
			Alert.show( ObjectUtil.toString(event.fault) );
		}
		
		private function PingMe(event:TimerEvent):void{
			//ping the server
			var ping : PingEvent = new PingEvent();
			CairngormEventDispatcher.getInstance().dispatchEvent(ping);
		};
	}
}