package com.bytespring.rbman.commands 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.bytespring.rbman.business.ExportBundlesDelegate;
	import com.bytespring.rbman.control.ExportBundlesEvent;
	import com.bytespring.rbman.model.ModelLocator;
	import com.bytespring.rbman.model.Util;
	import com.bytespring.utilities.*;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class ExportBundlesCommand extends DownloadListener implements ICommand, IResponder
	{
		private var model : ModelLocator = ModelLocator.getInstance();
	  	private var exportPath:String;
	  	
	  	
		public function execute( event : CairngormEvent ) : void
		{
			var delegate:ExportBundlesDelegate = new ExportBundlesDelegate( this );   
			var exportEvent:ExportBundlesEvent = ExportBundlesEvent( event );  
			delegate.exportBundles(exportEvent.bundleArray,exportEvent.encoding);
			this.progressBar = exportEvent.progressBar;    
		}
		
		public function result(event:Object):void
		{
			var result:Object = event.result as Object;
			this.fileName = String(result.FILENAME);
			this.url = String(result.EXPORTPATH);
			this.exportPath = String(result.EXPORTPATH);
			var fd:FileDownload = new FileDownload(this);
			fd.download();
		}
		
		public function fault(event:Object):void
		{
			Alert.show( ObjectUtil.toString(event.fault) );
		}
		
		public override function completeHandler(event:Event):void {
	    	super.completeHandler(event);
	    	
	    	var delegate:ExportBundlesDelegate = new ExportBundlesDelegate( this );
	    	delegate.exportFinished(this.exportPath);
	    	// set the state
	    	model.mainPanelState = '';
	    	// play a sound
			model.playSound('ding');
			// display a message
			Util.displayInfoMessage('bundle.export.ok');
	    }
    
	}
}