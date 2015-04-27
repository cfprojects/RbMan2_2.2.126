package com.bytespring.utilities
{
	import mx.controls.ProgressBar;
	import flash.events.*;
	import flash.net.FileReference;
	import mx.controls.Alert;
	
	public class DownloadListener
	{
		public var progressBar:ProgressBar;
		public var fileName:String;
		public var url:String;
		
		public function cancelHandler(event:Event):void {
    	trace("cancelHandler: " + event);
    }

    public function completeHandler(event:Event):void {
    	progressBar.label = "Download Complete";
    	trace("completeHandler: " + event);
    }

    public function ioErrorHandler(event:IOErrorEvent):void {
    	Alert.show("ioErrorHandler: " + String(event));
    	trace("ioErrorHandler: " + event);
    }

    public function openHandler(event:Event):void {
    	trace("openHandler: " + event);
    }

    public function progressHandler(event:ProgressEvent):void {
    	//var file:FileReference = FileReference(event.target);
    	progressBar.setProgress(event.bytesLoaded,event.bytesTotal);
     	progressBar.label = "Downloading " + Math.round(event.bytesLoaded / 1024) + " kb of " + Math.round(event.bytesTotal / 1024) + " kb ";
    	//trace("progressHandler name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
    }

    public function securityErrorHandler(event:SecurityErrorEvent):void {
    	Alert.show("securityErrorHandler: " + String(event));
    	trace("securityErrorHandler: " + event);
    }

    public function selectHandler(event:Event):void {
    	trace("selectHandler:" + event);
    }
	}
}