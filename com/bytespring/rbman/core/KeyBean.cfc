<cfcomponent output="false" alias="com.bytespring.rbman.core.KeyBean">

	<cfproperty name="key_id" type="numeric" default="0">
	<cfproperty name="bundle_id" type="numeric" default="0">
	<cfproperty name="rbkey" type="string" default="">
	<cfproperty name="rbvalue" type="string" default="">
	<cfproperty name="comments" type="string" default="">
	<cfproperty name="translated" type="numeric" default="0">

	<cfscript>
		//Initialize the CFC with the default properties values.
		variables.key_id = 0;
		variables.bundle_id = 0;
		variables.rbkey = "";
		variables.rbvalue = "";
		variables.comments = "";
		variables.translated = 0;
	</cfscript>

	<cffunction name="init" output="false" returntype="keyBean">
		<cfreturn this>
	</cffunction>
	<cffunction name="getKey_id" output="false" access="public" returntype="any">
		<cfreturn variables.Key_id>
	</cffunction>

	<cffunction name="setKey_id" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfif (IsNumeric(arguments.val)) OR (arguments.val EQ "")>
			<cfset variables.Key_id = arguments.val>
		<cfelse>
			<cfthrow message="'#arguments.val#' is not a valid numeric"/>
		</cfif>
	</cffunction>

	<cffunction name="getBundle_id" output="false" access="public" returntype="any">
		<cfreturn variables.Bundle_id>
	</cffunction>

	<cffunction name="setBundle_id" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfif (IsNumeric(arguments.val)) OR (arguments.val EQ "")>
			<cfset variables.Bundle_id = arguments.val>
		<cfelse>
			<cfthrow message="'#arguments.val#' is not a valid numeric"/>
		</cfif>
	</cffunction>

	<cffunction name="getRbkey" output="false" access="public" returntype="any">
		<cfreturn variables.Rbkey>
	</cffunction>

	<cffunction name="setRbkey" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Rbkey = arguments.val>
	</cffunction>

	<cffunction name="getRbvalue" output="false" access="public" returntype="any">
		<cfreturn variables.Rbvalue>
	</cffunction>

	<cffunction name="setRbvalue" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Rbvalue = arguments.val>
	</cffunction>

	<cffunction name="getComments" output="false" access="public" returntype="any">
		<cfreturn variables.Comments>
	</cffunction>

	<cffunction name="setComments" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Comments = arguments.val>
	</cffunction>

	<cffunction name="getTranslated" output="false" access="public" returntype="any">
		<cfreturn variables.Translated>
	</cffunction>

	<cffunction name="setTranslated" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfif (IsNumeric(arguments.val)) OR (arguments.val EQ "")>
			<cfset variables.Translated = arguments.val>
		<cfelse>
			<cfthrow message="'#arguments.val#' is not a valid numeric"/>
		</cfif>
	</cffunction>



</cfcomponent>