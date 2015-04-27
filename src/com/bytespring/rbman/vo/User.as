package com.bytespring.rbman.vo
{
  	[Bindable]
  	[RemoteClass(alias="com.bytespring.rbman.user.User")]
	public class User
	{
		public var username : String;
		public var password : String;
		public var role:String = ""; //admin,standard
		public var rbloc:String = "";
	}
	
}
