<cfcomponent output="false">

<cfscript>
variables.my = StructNew();
my.constants = "";
my.utils = "";
</cfscript>

<cffunction name="Init" access="Public" returnType="keyDAO" output="false">
 <cfargument name="constants" required="true" type="com.bytespring.rbman.config.Constants" />
	<cfargument name="utils" required="true" type="com.bytespring.rbman.common.Utilities" />
	<cfscript>
		my.constants = arguments.constants;
		my.utils = arguments.utils;
	</cfscript>
 <cfreturn this />
</cffunction>

<cffunction name="read" output="false" access="public" returntype="void">
	<cfargument name="obj" required="true" type="keyBean">
	<cfargument name="id" required="true" type="numeric">
	<cfset var qRead="">

	<cfquery name="qRead" datasource="#my.constants.getDSN()#">
		select 	key_id, bundle_id, rbkey, rbvalue, comments, translated
		from rb_key
		where key_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.id#" />
	</cfquery>

	<cfscript>
		if (qRead.recordcount GT 0) {
			arguments.obj.setkey_id(qRead.key_id);
			arguments.obj.setbundle_id(qRead.bundle_id);
			arguments.obj.setrbkey(qRead.rbkey);
			arguments.obj.setrbvalue(qRead.rbvalue);
			arguments.obj.setcomments(qRead.comments);
			arguments.obj.settranslated(qRead.translated);
		}
	</cfscript>
</cffunction>

<cffunction name="create" output="false" access="public" returntype="void">
	<cfargument name="bean" required="true" type="keyBean">
	<cfset var qCreate="">

	<cfif my.constants.getDBtype() IS "MSSQL">
		<cfquery name="qCreate" datasource="#my.constants.getDSN()#">
			SET NOCOUNT ON
			insert into rb_key
			(bundle_id, rbkey, rbvalue, comments, translated)
			values (
				<cfqueryparam value="#arguments.bean.getbundle_id()#" cfsqltype="CF_SQL_INTEGER" />,
				<cfqueryparam value="#arguments.bean.getrbkey()#" cfsqltype="CF_SQL_VARCHAR" />,
				<cfqueryparam value="#arguments.bean.getrbvalue()#" cfsqltype="CF_SQL_VARCHAR" />,
				<cfqueryparam value="#arguments.bean.getcomments()#" cfsqltype="CF_SQL_VARCHAR" />,
				<cfqueryparam value="#arguments.bean.gettranslated()#" cfsqltype="CF_SQL_INTEGER" />
			)
			SELECT scope_identity() AS newID
			SET NOCOUNT OFF
		</cfquery>
	</cfif>
	
	<cfif my.constants.getDBtype() IS "MYSQL">
		<cfquery name="qCreate" datasource="#my.constants.getDSN()#">
			insert into rb_key
			(bundle_id, rbkey, rbvalue, comments, translated)
			values (
				<cfqueryparam value="#arguments.bean.getbundle_id()#" cfsqltype="CF_SQL_INTEGER" />,
				<cfqueryparam value="#arguments.bean.getrbkey()#" cfsqltype="CF_SQL_VARCHAR" />,
				<cfqueryparam value="#arguments.bean.getrbvalue()#" cfsqltype="CF_SQL_VARCHAR" />,
				<cfqueryparam value="#arguments.bean.getcomments()#" cfsqltype="CF_SQL_VARCHAR" />,
				<cfqueryparam value="#arguments.bean.gettranslated()#" cfsqltype="CF_SQL_INTEGER" />
			)
		</cfquery>
		<cfquery name="qCreate" datasource="#my.constants.getDSN()#">
			SELECT LAST_INSERT_ID() AS newID
		</cfquery>
	</cfif>
	<cfset arguments.bean.setkey_id(qCreate.newID) />
</cffunction>

<cffunction name="update" output="false" access="public" returntype="boolean">
	<cfargument name="bean" required="true" type="keyBean">
	<cfset var qUpdate="">
	<cfset var success = false />
	
	<cfif my.constants.getDBtype() IS "MSSQL">
		<cfquery name="qUpdate" datasource="#my.constants.getDSN()#">
			SET NOCOUNT ON
			update rb_key
			set bundle_id = <cfqueryparam value="#arguments.bean.getbundle_id()#" cfsqltype="CF_SQL_INTEGER"  />,
				rbkey = <cfqueryparam value="#arguments.bean.getrbkey()#" cfsqltype="CF_SQL_VARCHAR" />,
				rbvalue = <cfqueryparam value="#arguments.bean.getrbvalue()#" cfsqltype="CF_SQL_VARCHAR" />,
				comments = <cfqueryparam value="#arguments.bean.getcomments()#" cfsqltype="CF_SQL_VARCHAR" />,
				translated = <cfqueryparam value="#arguments.bean.gettranslated()#" cfsqltype="CF_SQL_INTEGER"  />
			where key_id = <cfqueryparam value="#arguments.bean.getkey_id()#" cfsqltype="CF_SQL_INTEGER">
			SELECT @@ROWCOUNT AS numRows
			SET NOCOUNT OFF
		</cfquery>
		<cfif qUpdate.numRows GT 0>
			<cfset success = true />
		</cfif>
	</cfif>
	
	<cfif my.constants.getDBtype() IS "MYSQL">
		<cfquery name="qUpdate" datasource="#my.constants.getDSN()#">
			update rb_key
			set bundle_id = <cfqueryparam value="#arguments.bean.getbundle_id()#" cfsqltype="CF_SQL_INTEGER"  />,
				rbkey = <cfqueryparam value="#arguments.bean.getrbkey()#" cfsqltype="CF_SQL_VARCHAR" />,
				rbvalue = <cfqueryparam value="#arguments.bean.getrbvalue()#" cfsqltype="CF_SQL_VARCHAR" />,
				comments = <cfqueryparam value="#arguments.bean.getcomments()#" cfsqltype="CF_SQL_VARCHAR" />,
				translated = <cfqueryparam value="#arguments.bean.gettranslated()#" cfsqltype="CF_SQL_INTEGER"  />
			where key_id = <cfqueryparam value="#arguments.bean.getkey_id()#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>
		<cftry>
			<cfquery name="qUpdate" datasource="#my.constants.getDSN()#">
				SELECT ROW_COUNT() AS numRows
			</cfquery>
			<cfif qUpdate.numRows GT 0>
				<cfset success = true />
			</cfif>
			<cfcatch type="database">
				<!--- ROW_COUNT() not supported --->
				<cfset success = true />
			</cfcatch>
		</cftry>
	</cfif>
	
	<cfreturn success />
</cffunction>

<cffunction name="delete" output="false" access="public" returntype="void">
	<cfargument name="bean" required="true" type="keyBean">
	<cfset var qDelete="">
	<cfquery name="qDelete" datasource="#my.constants.getDSN()#" result="status">
		delete
		from rb_key
		where key_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.bean.getkey_id()#" />
	</cfquery>
</cffunction>


</cfcomponent>