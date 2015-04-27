package com.bytespring.rbman.model 
{
 	import com.adobe.cairngorm.model.*;
 	import com.bytespring.rbman.control.MainController;
 	import com.bytespring.rbman.view.*;
 	import com.bytespring.rbman.vo.*;
 	
 	import flash.media.SoundChannel;
 	
 	import mx.collections.ArrayCollection;
 	import mx.core.SoundAsset;

 	[Bindable]
	public class ModelLocator implements com.adobe.cairngorm.model.ModelLocator {
	
	private static var modelLocator : com.bytespring.rbman.model.ModelLocator;
	
	// constants
	public static const appName:String = "RbMan";
	public static const version:String = '2.2';
	
	public static const STATE_LOGIN : String = "login";
	public static const STATE_MAINAPP : String = "mainApp";
	public static const STATE_MAIN_PANEL_BASE:String = "";
	public static const STATE_MAIN_PANEL_BUNDLE_DETAIL:String = "bundleDetail";
	public static const STATE_MAIN_PANEL_ADD_LOCALE:String = "addLocale";
	public static const STATE_MAIN_PANEL_DELETE_LOCALE:String = "deleteLocale";
	public static const STATE_MAIN_PANEL_IMPORT:String = "import";
	public static const STATE_MAIN_PANEL_EXPORT:String = "export";
	public static const STATE_ADD_BUNDLE:String = "ADD_BUNDLE";
	public static const STATE_EDIT_BUNDLE:String = "EDIT_BUNDLE";
	public static const STATE_DELETE_BUNDLE:String = "DELETE_BUNDLE";
	public static const STATE_ADD_KEY:String = "ADD_KEY";
	
	public static const nameRE:String = "^[A-Za-z0-9._-]+$";
	public static const locRE:String = "^[a-z]{2}_[A-Z]{2}$|^[a-z]{2}$";
    public static const encodings: Array = [ {label:"Java Properties (ISO 8859-1)", data:"ISO 8859-1"}, 
    	{label:"UTF-8", data:"UTF-8"} ];
	public static const pingInterval:Number = 1000 * 60 * 1; //milliseconds x seconds x minutes
	public static const pingEnabled:Boolean = true;
	public static const BASE_LOCALE:String = 'base';
	
	//variables
	public var login:Login;
	public var perms:Permissions;
	public var currentLocale:String;
	public var localeList:Array;
	public var bundleList:ArrayCollection;
	public var stats:StatsBean;
	public var messageArray:ArrayCollection;	
	public var bundle:BundleBean;
	public var baseBundle:BundleBean;
	
	// states
	public var bundleEditorState:String;
	public var mainPanelState:String = STATE_MAIN_PANEL_BASE;
	public var currentState : String = STATE_LOGIN;
	
   	public function ModelLocator() {
   		if ( com.bytespring.rbman.model.ModelLocator.modelLocator != null )
				throw new Error( "Only one ModelLocator instance should be instantiated" );
		init();			
   	}
	public static function getInstance() : com.bytespring.rbman.model.ModelLocator {
		if ( modelLocator == null )
		modelLocator = new com.bytespring.rbman.model.ModelLocator();
		return modelLocator;
	}
	public function init():void{
		login = new Login();
		perms = new Permissions();
		currentLocale = BASE_LOCALE;
		localeList = new Array();
		bundleList = new ArrayCollection();
		stats = new StatsBean();
		messageArray = new ArrayCollection();	
		bundle = new BundleBean();
		baseBundle = new BundleBean();
	}
	
	
	public function updateTranslatedKeys():void
	{
		var kb:KeyBean;
		var bkb:KeyBean;
		for(var i:int=0; i < bundle.keyAC.length; i++)
		{
			kb = bundle.keyAC[i];
			for(var j:int=0; j < baseBundle.keyAC.length; j++)
			{
				bkb = baseBundle.keyAC[j];
				if(kb.rbkey.toLowerCase() == bkb.rbkey.toLowerCase()){
					if(kb.rbvalue != bkb.rbvalue) {
						kb.translated = 1;
					}else{
						kb.translated = 0;
					}
				}
			}
		}
	}
	
	// ding
	[Embed(source="/../src/audio/Ding.mp3")]
    public var dingSound:Class;
    
    public function playSound(name:String):void{
    	if(name == 'ding'){
    		var snd:SoundAsset = new dingSound() as SoundAsset;
    		var sndChannel:SoundChannel = snd.play();
    	}
    }
	
	
	public var menubarString:String = '<menu>'+
		'<menuitem label="' + Util.getString('locale') + '">'+
		    '<menuitem label="' + Util.getString('locale.add') + '" data="' + MainController.EVENT_DSP_ADD_LOCALE +'" enabled="false"/>'+
		    '<menuitem label="' + Util.getString('locale.delete') + '" data="' + MainController.EVENT_DSP_DELETE_LOCALE +'" enabled="false"/>'+
		'</menuitem>'+
		'<menuitem label="' + Util.getString('bundle') + '">'+
		    '<menuitem label="' + Util.getString('bundle.add') + '" data="' + MainController.EVENT_ADD_BUNDLE +'"  enabled="false"/>'+
		    '<menuitem label="' + Util.getString('import.bundles') + '" data="' + MainController.EVENT_DSP_IMPORT +'" enabled="false"/>'+
		    '<menuitem label="' + Util.getString('export.bundles') + '" data="' + MainController.EVENT_DSP_EXPORT +'" enabled="false"/>'+
		'</menuitem>'+
		'</menu>';
	public var menubarXML:XML = new XML(menubarString);
	
	/*
	'<menuitem label="' + Util.getString('user') + '">'+
			'<menuitem label="' + Util.getString('logout') + '" data="' + MainController.EVENT_LOGOUT +'" enabled="true"/>'+
		'</menuitem>'+
	 */
	
	/*
	public var menuData:Array = [
	    {label: "MenuItem A", children: [
	         {label: "SubMenuItem A-1", enabled: false},
	         {label: "SubMenuItem A-2", type: "normal"}
	    ]},
	    {label: "MenuItem B", type: "check", toggled: true},
	    {label: "MenuItem C", type: "check", toggled: false},
	    {type: "separator"},
	    {label: "MenuItem D", children: [
	         {label: "SubMenuItem D-1", type: "radio", groupName: "g1"},
	       	 {label: "SubMenuItem D-2", type: "radio", groupName: "g1", toggled: true},
	         {label: "SubMenuItem D-3", type: "radio", groupName: "g1"}
	    ]}
	];
	*/

	}	
}

