<cfcomponent output="false" alias="com.bytespring.rbman.user.User">
	<!---
		 These are properties that are exposed by this CFC object.
		 These property definitions are used when calling this CFC as a web services, 
		 passed back to a flash movie, or when generating documentation

		 NOTE: these cfproperty tags do not set any default property values.
	--->
	<cfproperty name="username" type="string" default="">
	<cfproperty name="password" type="string" default="">
	<cfproperty name="role" type="string" default="">
	<cfproperty name="rbloc" type="string" default="">

	<cfscript>
		//Initialize the CFC with the default properties values.
		variables.username = "";
		variables.password = "";
		variables.role = ""; //admin,standard
		variables.rbloc = "";
	</cfscript>

	<cffunction name="init" output="false" returntype="User">
		<cfreturn this>
	</cffunction>
	<cffunction name="getUsername" output="false" access="public" returntype="any">
		<cfreturn variables.Username>
	</cffunction>

	<cffunction name="setUsername" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Username = arguments.val>
	</cffunction>

	<cffunction name="getPassword" output="false" access="public" returntype="any">
		<cfreturn variables.Password>
	</cffunction>

	<cffunction name="setPassword" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Password = arguments.val>
	</cffunction>

	<cffunction name="getRole" output="false" access="public" returntype="any">
		<cfreturn variables.Role>
	</cffunction>

	<cffunction name="setRole" output="false" access="public" returntype="void">
		<cfargument name="val" required="true" hint="admin,standard">
		<cfset variables.Role = arguments.val>
	</cffunction>

	<cffunction name="getRbloc" output="false" access="public" returntype="any">
		<cfreturn variables.Rbloc>
	</cffunction>

	<cffunction name="setRbloc" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Rbloc = arguments.val>
	</cffunction>



</cfcomponent>