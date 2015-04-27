package com.bytespring.rbman.model
{
	[Bindable]
	public class Message
	{
		public static const INFO:String = 'INFO';
		public static const ERROR:String = 'ERROR';
		
		public var text:String = '';
		public var type:String = '';

	}
}