<cfcomponent name="bundleFacade" output="false"
	hint="I provide a remote facade to the bundle manager.">

<cfscript>
	variables.my = StructNew();
	my.constants = request.constants;
	my.bundleManager = request.bundleManager;
	my.userManager = request.userManager;
	my.utils = request.utils;
</cfscript>

<cffunction name="getLocaleList" output="false" access="public" returntype="array">
	<cfscript>
		var localeArray = "";
		authUser();
		localeArray = my.bundleManager.getLocaleList();
		return localeArray;
	</cfscript>
</cffunction>

<cffunction name="getBundleList" output="false" access="public" returntype="query">
	<cfargument name="rbloc" required="true" type="string" />
	<cfscript>
		var bundleList = "";
		authUser();
		bundleList = my.bundleManager.getBundleList(arguments.rbloc);
		return bundleList;
	</cfscript>
</cffunction>

<cffunction name="getBundleById" output="false" access="public" returntype="com.bytespring.rbman.core.BundleBean">
	<cfargument name="id" required="true" type="numeric" />
	<cfscript>
		var bundleBean = "";
		authUser();
		bundleBean = my.bundleManager.getBundleById(arguments.id);
		return bundleBean;
	</cfscript>
</cffunction>

<cffunction name="getBundleByName" output="false" access="public" returntype="com.bytespring.rbman.core.BundleBean">
	<cfargument name="name" required="true" type="string" />
	<cfargument name="rbloc" required="true" type="string" />
	<cfscript>
		var bundleBean = "";
		authUser();
		bundleBean = my.bundleManager.getBundleByName(arguments.name,arguments.rbloc);
		return bundleBean;
	</cfscript>
</cffunction>

<cffunction name="updateBundle" output="false" access="public" returntype="boolean">
	<cfargument name="bundleBean" required="true" type="com.bytespring.rbman.core.BundleBean" />
	<cfscript>
		var success = false;
		authUser();
		success = my.bundleManager.updateBundle(arguments.bundleBean);
		return success;
	</cfscript>
</cffunction>

<cffunction name="addBundle" output="false" access="public" returntype="boolean">
	<cfargument name="bundleBean" required="true" type="com.bytespring.rbman.core.BundleBean" />
	<cfscript>
		var success = false;
		authUser();
		success = my.bundleManager.addBundle(arguments.bundleBean);
		return success;
	</cfscript>
</cffunction>

<cffunction name="deleteBundle" output="false" access="public" returntype="boolean">
	<cfargument name="bundleName" required="true" type="string" />
	<cfscript>
		var success = "";
		authUser();
		success = my.bundleManager.deleteAll(arguments.bundleName);
		return success;
	</cfscript>
</cffunction>

<cffunction name="login" output="false" access="public" returntype="com.bytespring.rbman.user.User">
	<cfargument name="user" required="true" type="com.bytespring.rbman.user.User" />
	<cfscript>
		var success = my.userManager.authUser(arguments.user);
		request.utils.logString(arguments.user.getUsername() & " logged into rbman2 successfully: " & success);
	</cfscript>
	
	<cfif success>
		<cflogin>
			<cfloginuser name="#arguments.user.getUsername()#" 
				password="#arguments.user.getPassword()#" 
				roles="#arguments.user.getRole()#" />
		</cflogin>
	</cfif>
	<cfreturn arguments.user />
</cffunction>

<cffunction name="authUser" access="public" output="false" returntype="void">
	<cflogin>
		<cfthrow type="custom" message="You must login before you can access this area.">
	</cflogin>
</cffunction>

<cffunction name="logoutUser" access="public" returntype="void">
	<cflogout />
</cffunction>

<cffunction name="ping" access="public" returntype="boolean" hint="I am used to keep the session active.">
	<cfset authUser() />
	<cfreturn true />
</cffunction>

<cffunction name="addLocale" access="public" output="false" returntype="boolean">
	<cfargument name="rbloc" type="string" required="true" />
	<cfscript>
		var success = "";
		authUser();
		success = my.bundleManager.addLocale(arguments.rbloc);
		return success;
	</cfscript>
</cffunction>

<cffunction name="deleteLocale" access="public" output="false" returntype="boolean">
	<cfargument name="rbloc" type="string" required="true" />
	<cfscript>
		var success = "";
		authUser();
		success = my.bundleManager.deleteLocale(arguments.rbloc);
		return success;
	</cfscript>
</cffunction>

<cffunction name="getStats" access="public" output="false" returntype="com.bytespring.rbman.core.StatsBean">
	<cfargument name="rbloc" type="string" required="true" />
	<cfscript>
		var stats = "";
		authUser();		
		stats = my.bundleManager.getStats(arguments.rbloc);
		return stats;
	</cfscript>
</cffunction>

<cffunction name="uploadFile" access="remote" output="false" returntype="void"
	hint="accessed via http webservice request">
	<cfargument name="uploadPassword" type="string" required="true" />
	<cfargument name="filefield" type="string" required="false" default="fileData" />
	<cfscript>
		if(arguments.uploadPassword IS "xyz123lmn"){
			my.bundleManager.uploadFile(arguments.filefield);		
		}
	</cfscript>
</cffunction>

<cffunction name="importBundles" access="public" output="false" returntype="boolean">
	<cfargument name="username" type="string" required="true" />
	<cfargument name="encoding" type="string" required="true" hint="utf-8,ISO 8859-1" />
	<cfset var success = false />
	<cfsetting requesttimeout="999" />
	<cfscript>
		authUser();		
		try{
			success = my.bundleManager.importProperties(arguments.username,arguments.encoding);
		}catch(any ex){
			my.utils.writedump(ex,my.constants.getTmpDataDir(),"ImportBundleException#createUUID()#");
		}
		return success;
	</cfscript>
</cffunction>

<cffunction name="exportBundles" access="public" output="false" returntype="struct">
	<cfargument name="bundleArray" type="array" required="true" />
	<cfargument name="encoding" type="string" required="true" hint="utf-8,ISO 8859-1" />
	<cfset var result = structNew() />
	<cfsetting requesttimeout="120" />
	<cfscript>
		authUser();
		return my.bundleManager.exportProperties(arguments.bundleArray,arguments.encoding);
	</cfscript>
</cffunction>

<cffunction name="exportFinished" access="public" output="false" returntype="void">
	<cfargument name="exportPath" type="string" required="true" hint="The relative path from the domain root to be deleted." />
	<cfscript>
		my.utils.deleteDirectory(expandPath(exportPath));
	</cfscript>
</cffunction>

</cfcomponent>