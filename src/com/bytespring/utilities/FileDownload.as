package com.bytespring.utilities
{
	import flash.events.*;
	import flash.net.FileReference;
  import flash.net.URLRequest;
  import mx.controls.ProgressBar;
  import mx.controls.Alert;
	
	public class FileDownload
	{
		private var downloadURL:URLRequest;
		private var file:FileReference;
    private var fileName:String;
    private var progressBar:ProgressBar;
    private var l:DownloadListener;
		
		public function FileDownload(listener:DownloadListener) {
	    l = listener;
    }
    
    public function download():void{
    	downloadURL = new URLRequest();
	    downloadURL.url = l.url + l.fileName;
	    file = new FileReference();
	    configureListeners(file);
	    file.download(downloadURL, l.fileName);
    }

    private function configureListeners(dispatcher:IEventDispatcher):void {
	    dispatcher.addEventListener(Event.CANCEL, l.cancelHandler);
	    dispatcher.addEventListener(Event.COMPLETE, l.completeHandler);
	    dispatcher.addEventListener(IOErrorEvent.IO_ERROR, l.ioErrorHandler);
	    dispatcher.addEventListener(Event.OPEN, l.openHandler);
	    dispatcher.addEventListener(ProgressEvent.PROGRESS, l.progressHandler);
	    dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, l.securityErrorHandler);
	    dispatcher.addEventListener(Event.SELECT, selectHandler);
    }

  	/*
  	*	For some bizare reason this function will not work if it's in the Download Listener.
  	*	This is a hack to get it working for now.
  	*/
    private function selectHandler(event:Event):void {
    	trace("selectHandler: " + event);
    }
	}
}