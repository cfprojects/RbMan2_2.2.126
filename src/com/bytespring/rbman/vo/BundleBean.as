package com.bytespring.rbman.vo
{
	import mx.collections.ArrayCollection;
	
	[RemoteClass(alias="com.bytespring.rbman.core.BundleBean")]
	[Bindable]
	public class BundleBean
	{
		
		public function BundleBean(){
			keyBeans = [];
		}
		
		public var bundle_id:Number;
		public var name:String;
		public var rbloc:String;
		public var creator:String;
		public var createdate:Date;
		public var editor:String;
		public var editdate:Date;
		private var _keyBeans:Array;
		
		[Transient]
		public var keyAC:ArrayCollection; // just for convenience 
		
		public function set keyBeans(keyBeans:Array):void{
			_keyBeans = keyBeans;
			keyAC = new ArrayCollection(keyBeans);
		}
		public function get keyBeans():Array{
			return _keyBeans;
		}

	}
}