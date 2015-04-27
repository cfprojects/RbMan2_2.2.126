<cfcomponent name="appFacade" output="false" hint="I initialise the app and provide a facade to the components in the business model.">

<!--- setup the instance attributes --->

<cffunction name="Init" access="Public" returnType="appFacade" output="false"
	hint="I am the constructor.">
	<cfscript>
		var constants = createobject("component","com.bytespring.rbman.config.Constants");
		var utils = createObject("component","com.bytespring.rbman.common.Utilities");
		var args = "";
	</cfscript>
	
	<cflock scope="application" timeout="30" type="exclusive">
		<!--- init constants --->
		<cfset application.constants = constants />
		
		<!--- init utils --->
		<cfset application.utils = utils />
		
		<!--- init BundleManager --->
		<cfscript>
			args = structNew();
			args.constants = constants;
			args.utils = utils;
			application.bundleManager = createObject("component","com.bytespring.rbman.core.BundleManager").init(argumentCollection=args);
		</cfscript>
		
		<!--- init the UserManager --->
		<cfscript>
			args = structNew();
			args.constants = constants;
			args.utils = utils;
			application.userManager = createObject("component","com.bytespring.rbman.user.UserManager").init(argumentCollection=args);
		</cfscript>
	</cflock>
	
  <cfreturn this />
</cffunction>

<cffunction name="getConstants" access="public" returntype="com.bytespring.rbman.config.Constants" output="false">
	<cfreturn application.constants />
</cffunction>

<cffunction name="getUtils" access="public" returntype="com.bytespring.rbman.common.Utilities" output="false">
	<cfreturn application.utils />
</cffunction>

<cffunction name="getBundleManager" access="public" returntype="com.bytespring.rbman.core.BundleManager" output="false">
	<cfreturn application.bundleManager />
</cffunction>

<cffunction name="getUserManager" access="public" returntype="com.bytespring.rbman.user.UserManager" output="false">
	<cfreturn application.userManager />
</cffunction>

</cfcomponent>

