package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.bytespring.rbman.model.ModelLocator;
	
	public class DspExportCommand implements ICommand
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  
		public function execute( event : CairngormEvent ) : void
		{			
			//set the mainPanelVC state
			model.mainPanelState = ModelLocator.STATE_MAIN_PANEL_EXPORT;
		}
	}
}