package com.bytespring.rbman.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.bytespring.rbman.vo.User;
	
	/**
	 * The Cairngorm event broadcast when the user attempts to log in
	 */
	public class LoginEvent extends CairngormEvent 
	{
		/**
		 * The login details for the user
		 */
		public var user : User;
				
		/**
		 * The constructor, taking a UserVO
		 */
		public function LoginEvent( user : User ) 
		{
			super( MainController.EVENT_LOGIN );
			this.user = user;
		}
	}	
}