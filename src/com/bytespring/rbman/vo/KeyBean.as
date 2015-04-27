package com.bytespring.rbman.vo
{
	[RemoteClass(alias="com.bytespring.rbman.core.KeyBean")]
	[Bindable]
	public class KeyBean
	{

		public var key_id:Number = 0;
		public var bundle_id:Number = 0;
		public var rbkey:String = "";
		public var rbvalue:String = "";
		public var comments:String = "";
		public var translated:Number = 0;

	}
}