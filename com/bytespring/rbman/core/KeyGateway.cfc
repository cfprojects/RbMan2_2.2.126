<cfcomponent name="keyGateway" output="false">

<cfscript>
	variables.my = StructNew();
	my.constants = "";
	my.utils = "";
</cfscript>

<cffunction name="Init" access="Public" returnType="keyGateway" output="false">
  <cfargument name="constants" required="true" type="com.bytespring.rbman.config.Constants" />
	<cfargument name="utils" required="true" type="com.bytespring.rbman.common.Utilities" />
	<cfscript>
		my.constants = arguments.constants;
		my.utils = arguments.utils;
	</cfscript>
  <cfreturn this />
</cffunction>

<cffunction name="getAllByBundleId" output="false" access="public" returntype="query">
	<cfargument name="bundle_id" required="false">
	<cfset var qRead="">

	<cfquery name="qRead" datasource="#my.constants.getDSN()#">
		select key_id, bundle_id, rbkey, rbvalue, comments, translated
		from rb_key
		where rb_key.bundle_id = <cfqueryparam value="#arguments.bundle_id#" cfsqltype="CF_SQL_INTEGER">
	</cfquery>
	<cfreturn qRead />
</cffunction>

<cffunction name="getExistingKeys" output="false" access="public" returntype="struct">
	<cfargument name="bundle_id" required="true" type="numeric">

	<cfset var qRead="">
	<cfset var keys = structNew() />

	<cfquery name="qRead" datasource="#my.constants.getDSN()#">
		select key_id, rbkey
		from rb_key
		where rb_key.bundle_id = <cfqueryparam value="#arguments.bundle_id#" cfsqltype="CF_SQL_INTEGER">
	</cfquery>
	
	<cfloop query="qRead">
		<cfset keys[qRead.rbkey] = qRead.key_id />
	</cfloop>

	<cfreturn keys />
</cffunction>

<cffunction name="globallyDeleteKeys" access="public" output="false" returntype="void">
	<cfargument name="keyArray" type="array" required="true" />
	<cfargument name="bundleName" type="string" required="true" />
	<cfscript>
		var qDelete = "";
		var i = "";
		var keyList = arrayToList(arguments.keyArray);
	</cfscript>
	
		<cfquery name="qDelete" datasource="#my.constants.getDSN()#">
			DELETE FROM rb_key
			WHERE bundle_id IN (
				select bundle_id 
				from rb_bundle 
				where name = <cfqueryparam value="#arguments.bundleName#">
			) 
			AND	rbkey IN (<cfqueryparam value="#keyList#" list="true">)
		</cfquery>
</cffunction>

<cffunction name="getKeyCount" output="false" access="public" returntype="query">
	<cfargument name="rbloc" required="true" type="string">

	<cfset var qRead="">

	<cfquery name="qRead" datasource="#my.constants.getDSN()#">
		select translated, Count(translated) as total
		from rb_key k
		inner join rb_bundle b
		on k.bundle_id = b.bundle_id
		where b.rbloc = <cfqueryparam value="#arguments.rbloc#" />
		group by translated
	</cfquery>

	<cfreturn qRead />
</cffunction>



</cfcomponent>