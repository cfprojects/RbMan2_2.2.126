package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.bytespring.rbman.model.ModelLocator;
	
	public class SetPermissionsCommand implements ICommand
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  
		public function execute( event : CairngormEvent ) : void
		{			
			setPermissions();
		}
		
		private function setPermissions():void{
			if(model.login.user.role == 'admin'){
				model.perms.switchLocale = true;
				model.perms.addLocale = true;
				model.perms.deleteLocale = true;
				model.perms.addBundle = true;
				model.perms.deleteBundle = true;
				model.perms.exportBundle = true;
				model.perms.importBundel = true;
				model.perms.editBundle = true;
				model.perms.addKey = true;
				model.perms.deleteKey = true;
				//menu
				model.menubarXML.menuitem[0].menuitem[0].@enabled = true;
				model.menubarXML.menuitem[0].menuitem[1].@enabled = true;
				model.menubarXML.menuitem[1].menuitem[0].@enabled = true;
				model.menubarXML.menuitem[1].menuitem[1].@enabled = true;
				model.menubarXML.menuitem[1].menuitem[2].@enabled = true;
			}else{
				model.perms.switchLocale = false;
				model.perms.addLocale = false;
				model.perms.deleteLocale = false;
				model.perms.addBundle = false;
				model.perms.deleteBundle = false;
				model.perms.exportBundle = false;
				model.perms.importBundel = false;
				model.perms.editBundle = true;
				model.perms.addKey = false;
				model.perms.deleteKey = false;
				//menu
				model.menubarXML.menuitem[0].menuitem[0].@enabled = false;
				model.menubarXML.menuitem[0].menuitem[1].@enabled = false;
				model.menubarXML.menuitem[1].menuitem[0].@enabled = false;
				model.menubarXML.menuitem[1].menuitem[1].@enabled = false;
				model.menubarXML.menuitem[1].menuitem[2].@enabled = false;
			}
		}
		
		
	}
}