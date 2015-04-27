<cfapplication  NAME="rbman2" 
   sessionMANAGEMENT="true" 
   setClientCookies="true"
		loginstorage="session"
	 clientmanagement="false" />
	 
<!--- <cfset url.init = true /> --->

<cflock type="exclusive" scope="application" timeout="30">
	<cfif NOT structKeyExists(application,"appFacade") OR structKeyExists(url,"init")>
		<cfset application.appFacade = createObject("component","com.bytespring.rbman.common.AppFacade").init() />
	</cfif>
</cflock>
<cflock type="readonly" scope="application" timeout="10">
	<cfset request.constants = application.appFacade.getConstants() />
	<cfset request.utils = application.appFacade.getUtils() />
	<cfset request.bundleManager = application.appFacade.getBundleManager() />
	<cfset request.userManager = application.appFacade.getUserManager() />
</cflock>
