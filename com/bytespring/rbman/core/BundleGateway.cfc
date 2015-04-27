<cfcomponent name="bundleGateway" output="false">

<cfscript>
	variables.my = StructNew();
	my.constants = "";
	my.utils = "";
</cfscript>

<cffunction name="Init" access="Public" returnType="BundleGateway" output="false">
  <cfargument name="constants" required="true" type="com.bytespring.rbman.config.Constants" />
	<cfargument name="utils" required="true" type="com.bytespring.rbman.common.Utilities" />
	<cfscript>
		my.constants = arguments.constants;
		my.utils = arguments.utils;
	</cfscript>
  <cfreturn this />
</cffunction>

<cffunction name="getBundleList" output="false" access="public" returntype="query">
	<cfargument name="rbloc" type="string" required="true" />
	<cfset var qRead="">

	<cfquery name="qRead" datasource="#my.constants.getDSN()#">
		SELECT    bundle_id, rbloc, name
		FROM      rb_bundle
		WHERE rbloc = <cfqueryparam value="#arguments.rbloc#">
		ORDER BY name
	</cfquery>

	<cfreturn qRead>
</cffunction>

<cffunction name="getBundleIds" output="false" access="public" returntype="query">
	<cfargument name="name" type="string" required="true" />
	<cfargument name="rbloc" type="string" required="false" />
	<cfset var qRead="" />

	<cfquery name="qRead" datasource="#my.constants.getDSN()#">
		SELECT    bundle_id
		FROM      rb_bundle
		WHERE name = <cfqueryparam value="#arguments.name#">
		<cfif structKeyExists(arguments,"rbloc")>
		AND rbloc = <cfqueryparam value="#arguments.rbloc#">
		</cfif>
	</cfquery>

	<cfreturn qRead />
</cffunction>




</cfcomponent>