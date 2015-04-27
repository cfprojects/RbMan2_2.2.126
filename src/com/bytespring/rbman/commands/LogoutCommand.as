package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.bytespring.rbman.model.ModelLocator;
	
	public class LogoutCommand implements ICommand
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  
		public function execute( event : CairngormEvent ) : void
		{			
			model.mainPanelState = '';
			model.currentState = ModelLocator.STATE_LOGIN;
			model.init();
		}
		
	}
}