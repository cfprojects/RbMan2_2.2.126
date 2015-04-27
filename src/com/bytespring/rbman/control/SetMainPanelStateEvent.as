package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * The Cairngorm event broadcast to get the locale list
	 */
	public class SetMainPanelStateEvent extends CairngormEvent 
	{
		
		public var state:String = '';		
		
		/**
		 * The constructor
		 */
		public function SetMainPanelStateEvent(state:String)
		{
			super(MainController.EVENT_SET_MAIN_PANEL_STATE);
			this.state = state;
		}
	}	
}