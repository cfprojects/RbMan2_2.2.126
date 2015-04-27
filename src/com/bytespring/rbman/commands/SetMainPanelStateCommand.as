package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.bytespring.rbman.control.SetMainPanelStateEvent;
	import com.bytespring.rbman.model.ModelLocator;
	
	public class SetMainPanelStateCommand implements ICommand
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  
		public function execute( event : CairngormEvent ) : void
		{			
			var SMPSevent:SetMainPanelStateEvent = event as SetMainPanelStateEvent;
			//set the mainPanelVC state
			model.mainPanelState = SMPSevent.state;
		}
	}
}