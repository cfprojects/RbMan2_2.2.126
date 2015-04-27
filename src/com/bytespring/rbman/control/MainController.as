package com.bytespring.rbman.control
{
	import com.adobe.cairngorm.control.FrontController;
	import com.bytespring.rbman.commands.*;
	
	public class MainController extends FrontController
	{
		
		public static const EVENT_LOGIN : String = "login";
		public static const EVENT_LOGOUT : String = "logout";
		public static const EVENT_SET_PERMISSIONS : String = "setPermissions";
		public static const EVENT_GET_LOCALE_LIST : String = "getLocaleList";
		public static const EVENT_GET_BUNDLE_LIST : String = "getBundleList";
		public static const EVENT_GET_BUNDLE : String = "getBundle";
		public static const EVENT_GET_BASE_BUNDLE : String = "getBaseBundle";
		public static const EVENT_UPDATE_BUNDLE : String = "updateBundle";
		public static const EVENT_DELETE_BUNDLE : String = "deleteBundle";
		public static const EVENT_ADD_BUNDLE : String = "addBundle";
		public static const EVENT_CREATE_BUNDLE : String = "createBundle";
		public static const EVENT_DSP_DELETE_LOCALE : String = "deleteLocale";
		public static const EVENT_DELETE_CURRENT_LOCALE : String = "deleteCurrentLocale";
		public static const EVENT_SET_MAIN_PANEL_STATE : String = "setMainPanelState";
		public static const EVENT_DSP_ADD_LOCALE : String = "addLocale";
		public static const EVENT_ADD_NEW_LOCALE : String = "addNewLocale";
		public static const EVENT_GET_LOCALE_STATS : String = "getLocaleStats";
		public static const EVENT_DSP_IMPORT : String = "dspImport";
		public static const EVENT_IMPORT : String = "Import";
		public static const EVENT_DSP_EXPORT : String = "dspExport";
		public static const EVENT_EXPORT : String = "Export";
		public static const EVENT_PING : String = "Ping";
		
		public function MainController()
		{
			addCommand( MainController.EVENT_LOGIN, LoginCommand );
			addCommand( MainController.EVENT_LOGOUT, LogoutCommand );
			addCommand( MainController.EVENT_SET_PERMISSIONS, SetPermissionsCommand );
			addCommand( MainController.EVENT_GET_LOCALE_LIST, GetLocaleListCommand );
			addCommand( MainController.EVENT_GET_BUNDLE_LIST, GetBundleListCommand );
			addCommand( MainController.EVENT_GET_BUNDLE, GetBundleCommand );
			addCommand( MainController.EVENT_UPDATE_BUNDLE, UpdateBundleCommand );
			addCommand( MainController.EVENT_DELETE_BUNDLE, DeleteBundleCommand );
			addCommand( MainController.EVENT_ADD_BUNDLE, AddBundleCommand );
			addCommand( MainController.EVENT_CREATE_BUNDLE, CreateBundleCommand );
			addCommand( MainController.EVENT_DSP_DELETE_LOCALE, DeleteLocaleCommand );
			addCommand( MainController.EVENT_DELETE_CURRENT_LOCALE, DeleteCurrentLocaleCommand );
			addCommand( MainController.EVENT_SET_MAIN_PANEL_STATE, SetMainPanelStateCommand );
			addCommand( MainController.EVENT_DSP_ADD_LOCALE, AddLocaleCommand );
			addCommand( MainController.EVENT_ADD_NEW_LOCALE, AddNewLocaleCommand );
			addCommand( MainController.EVENT_GET_LOCALE_STATS, GetLocaleStatsCommand );
			addCommand( MainController.EVENT_DSP_IMPORT, DspImportCommand );
			addCommand( MainController.EVENT_IMPORT, ImportBundlesCommand );
			addCommand( MainController.EVENT_DSP_EXPORT, DspExportCommand );
			addCommand( MainController.EVENT_EXPORT, ExportBundlesCommand );
			addCommand( MainController.EVENT_PING, PingCommand );
			addCommand(EVENT_GET_BASE_BUNDLE, GetBaseBundleCommand);
		}
	}
}