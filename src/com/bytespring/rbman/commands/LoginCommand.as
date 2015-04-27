package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.bytespring.rbman.business.LoginDelegate;
	import com.bytespring.rbman.control.LoginEvent;
	import com.bytespring.rbman.model.ModelLocator;
	import com.bytespring.rbman.vo.User;
	
	import flash.net.SharedObject;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class LoginCommand implements ICommand, IResponder
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  	private var lso:SharedObject;
	  
		public function execute( event : CairngormEvent ) : void
		{
			model.login.isPending = true;
			
			var delegate : LoginDelegate = new LoginDelegate( this );   
			var loginEvent : LoginEvent = LoginEvent( event );  
			delegate.login( loginEvent.user );	      
		}
		
		public function result(event:Object):void
			{
			model.login.user = User( event.result );
			this.lso = SharedObject.getLocal("auth");
			
			if(model.login.user.rbloc != '' 
				&& (model.login.user.role == 'standard' || model.login.user.role == 'admin')) {
		    	model.login.isPending = false;
		    	//persist the login details in SO
		    	if( model.login.rememberLogin ) {
		        	this.lso.data['username'] = model.login.user.username;
		        	this.lso.data['password'] = model.login.user.password;	
		    	}else{
		        	this.lso.data['username'] = null;
		        	this.lso.data['password'] = null;		
		    	}
		    	//set the current locale
		    	model.currentLocale = model.login.user.rbloc;
		    	//set the state
		    	model.currentState = ModelLocator.STATE_MAINAPP;            	
			}else{
				// login didn't work. show message
				model.login.isPending = true;
				model.login.statusMessage = ResourceManager.getInstance().getString('resources','login.error');
			}
		}
				
		public function fault(event:Object):void
		{
			model.login.statusMessage = ResourceManager.getInstance().getString('resources','login.server.error');
			model.login.isPending = true;
			//Alert.show( ObjectUtil.toString(event.fault) );
		}
		
		
	}
}