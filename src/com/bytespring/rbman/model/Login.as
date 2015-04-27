package com.bytespring.rbman.model
{
	import com.bytespring.rbman.vo.User;
	[Bindable]
	public class Login
	{
		public var user : User;
		public var statusMessage : String;
		public var isPending : Boolean;
		public var rememberLogin : Boolean;
	}
}