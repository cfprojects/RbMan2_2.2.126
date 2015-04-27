package com.bytespring.rbman.model
{
	import mx.resources.ResourceManager;
	
	public class Util
	{
		public static function displayInfoMessage(msg:String):void{
			var message:Message = new Message;
	  		message.text = getString(msg);
	  		message.type = Message.INFO;
	  		ModelLocator.getInstance().messageArray.addItemAt(message,0);
		}
		
		public static function displayErrorMessage(msg:String):void{
			var message:Message = new Message;
	  		message.text = getString(msg);
	  		message.type = Message.ERROR;
	  		ModelLocator.getInstance().messageArray.addItemAt(message,0);
		}
		
		public static function getString(msg:String):String{
			var text:String = ResourceManager.getInstance().getString('resources',msg);
	  		if(text == null || text == ''){
	  			text = msg;
	  		}
	  		return text;
		}

	}
}