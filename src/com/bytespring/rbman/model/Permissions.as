package com.bytespring.rbman.model
{
	[Bindable]
	public final class Permissions
	{
		public var switchLocale:Boolean = false;
		public var addLocale:Boolean = false;
		public var deleteLocale:Boolean = false;
		public var addBundle:Boolean = false;
		public var deleteBundle:Boolean = false;
		public var exportBundle:Boolean = false;
		public var importBundel:Boolean = false;
		public var editBundle:Boolean = true;
		public var addKey:Boolean = false;
		public var deleteKey:Boolean = false;
	}
}