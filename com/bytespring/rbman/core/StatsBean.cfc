<cfcomponent output="false" alias="com.bytespring.rbman.core.StatsBean">
	<cfproperty name="totalBundles" type="numeric" default="0">
	<cfproperty name="totalKeys" type="numeric" default="0">
	<cfproperty name="totalUKeys" type="numeric" default="0">

	<cfscript>
		//Initialize the CFC with the default properties values.
		variables.totalBundles = 0;
		variables.totalKeys = 0;
		variables.totalUKeys = 0;
	</cfscript>

	<cffunction name="init" output="false" returntype="Stats">
		<cfreturn this>
	</cffunction>
	<cffunction name="getTotalBundles" output="false" access="public" returntype="any">
		<cfreturn variables.TotalBundles>
	</cffunction>

	<cffunction name="setTotalBundles" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfif (IsNumeric(arguments.val)) OR (arguments.val EQ "")>
			<cfset variables.TotalBundles = arguments.val>
		<cfelse>
			<cfthrow message="'#arguments.val#' is not a valid numeric"/>
		</cfif>
	</cffunction>

	<cffunction name="getTotalKeys" output="false" access="public" returntype="any">
		<cfreturn variables.TotalKeys>
	</cffunction>

	<cffunction name="setTotalKeys" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfif (IsNumeric(arguments.val)) OR (arguments.val EQ "")>
			<cfset variables.TotalKeys = arguments.val>
		<cfelse>
			<cfthrow message="'#arguments.val#' is not a valid numeric"/>
		</cfif>
	</cffunction>

	<cffunction name="getTotalUKeys" output="false" access="public" returntype="any">
		<cfreturn variables.TotalUKeys>
	</cffunction>

	<cffunction name="setTotalUKeys" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfif (IsNumeric(arguments.val)) OR (arguments.val EQ "")>
			<cfset variables.TotalUKeys = arguments.val>
		<cfelse>
			<cfthrow message="'#arguments.val#' is not a valid numeric"/>
		</cfif>
	</cffunction>



</cfcomponent>