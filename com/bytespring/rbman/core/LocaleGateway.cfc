<cfcomponent name="localeGateway" output="false" hint="I am the locale gateway.">
	
<cfscript>
	variables.my = StructNew();
	my.constants = "";
	my.utils = "";
</cfscript>
	
<cffunction name="Init" access="Public" returnType="localeGateway" output="false">
  <cfargument name="constants" required="true" type="com.bytespring.rbman.config.Constants" />
	<cfscript>
		my.constants = arguments.constants;
	</cfscript>
  <cfreturn this />
</cffunction>

<cffunction name="getLocaleList" output="false" access="public" returntype="query">
	<cfset var qRead="" />
	<cfquery name="qRead" datasource="#my.constants.getDSN()#">
		SELECT rbloc
		FROM rb_locale
	</cfquery>
	<cfreturn qRead />
</cffunction>

<cffunction name="localeExists" access="public" output="false" returntype="boolean">
	<cfargument name="rbloc" type="string" required="true" />
	<cfquery name="getLoc" datasource="#my.constants.getDSN()#">
		select rbloc
		from rb_locale
		where rbloc = <cfqueryparam value="#arguments.rbloc#" />
	</cfquery>
	<cfscript>
		if(getLoc.recordcount EQ 1){
			return true;
		}else{
			return false;
		}
	</cfscript>
</cffunction>

<cffunction name="addLocale" access="public" output="false" returntype="boolean"
	hint="I just add a locale to the locale table. All the bundles are added by the manager.">
	<cfargument name="rbloc" type="string" required="true" />
	<cfset var success = true />
	<cftry>
		<cfquery name="addLoc" datasource="#my.constants.getDSN()#">
			insert into rb_locale
			(
			rbloc
			)
			values
			(
			<cfqueryparam value="#arguments.rbloc#" />
			)
		</cfquery>
		<cfcatch type="database">
			<cfset success = false />
		</cfcatch>
	</cftry>
	<cfreturn success />
</cffunction>

<cffunction name="deleteLocale" access="public" output="false" returntype="boolean"
	hint="I delete a locale and all it's dependant bundles and keys." >
		<cfargument name="rbloc" type="string" required="true" />
		<cfset var success = true />
		<cfset var deleteLoc = "" />
		<cfquery name="deleteLoc" datasource="#my.constants.getDSN()#">
			delete from rb_locale
			where rbloc = <cfqueryparam value="#arguments.rbloc#" />
		</cfquery>
	<cfreturn success />
</cffunction>

</cfcomponent>
