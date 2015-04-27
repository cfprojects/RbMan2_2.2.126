<cfcomponent output="false">

<cfscript>
	variables.my = StructNew();
	my.constants = "";
	my.utils = "";
	my.keyGateway = "";
	my.keyDAO = "";
</cfscript>

<cffunction name="Init" access="Public" returnType="bundleDAO" output="false">
  <cfargument name="constants" required="true" type="com.bytespring.rbman.config.Constants" />
	<cfargument name="utils" required="true" type="com.bytespring.rbman.common.Utilities" />
	<cfargument name="keyDAO" required="true" type="KeyDAO" />
	<cfargument name="keyGateway" required="true" type="KeyGateway" />
	
	<cfscript>
		my.constants = arguments.constants;
		my.utils = arguments.utils;
		my.keyDAO = arguments.keyDAO;
		my.keyGateway = arguments.keyGateway;
	</cfscript>
  <cfreturn this />
</cffunction>

<cffunction name="read" output="false" access="public" returntype="void">
	<cfargument name="obj" required="true" type="BundleBean">
	<cfargument name="id" required="true" type="numeric">
	<cfscript>
		var qRead="";
		var qKeyRead="";
		var keyArray = ArrayNew(1);
		var key = "";
	</cfscript>

	<cfquery name="qRead" datasource="#my.constants.getDSN()#">
		select 	bundle_id, name, rbloc, creator, createdate, editor, editdate
		from rb_bundle
		where bundle_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.id#" />
	</cfquery>

	<cfscript>
		if (qRead.recordcount GT 0) {
			arguments.obj.setbundle_id(qRead.bundle_id);
			arguments.obj.setname(qRead.name);
			arguments.obj.setrbloc(qRead.rbloc);
			arguments.obj.setcreator(qRead.creator);
			arguments.obj.setcreatedate(qRead.createdate);
			arguments.obj.seteditor(qRead.editor);
			arguments.obj.seteditdate(qRead.editdate);
		}
	</cfscript>
	<!---now get all the keys for this bundle --->
	<cfif qRead.recordcount EQ 1>
		<cfset qKeyRead = my.keyGateway.getAllByBundleId(qRead.bundle_id) />
		<cfloop query="qKeyRead">
			<cfscript>
				key = createObject("component", "KeyBean").init();
				key.setkey_id(qKeyRead.key_id);
				key.setbundle_id(qKeyRead.bundle_id);
				key.setrbkey(qKeyRead.rbkey);
				key.setrbvalue(qKeyRead.rbvalue);
				key.setcomments(qKeyRead.comments);
				key.settranslated(qKeyRead.translated);
				ArrayAppend(keyArray, key);
			</cfscript>
		</cfloop>
		<cfset arguments.obj.setKeyBeans(keyArray) />
	</cfif>
</cffunction>

<cffunction name="create" output="false" access="public" returntype="void">
	<cfargument name="bean" required="true" type="BundleBean">
	<cfscript>
		var qCreate="";
		var keyBeans="";
		var i="";
	</cfscript> >

	<cfif my.constants.getDBtype() IS "MSSQL">
		<cfquery name="qCreate" datasource="#my.constants.getDSN()#">
			SET NOCOUNT ON
			insert into rb_bundle
				(name, rbloc, creator, createdate)
			values (
				<cfqueryparam value="#arguments.bean.getname()#" cfsqltype="CF_SQL_VARCHAR" />,
				<cfqueryparam value="#arguments.bean.getrbloc()#" cfsqltype="CF_SQL_VARCHAR" />,
				<cfqueryparam value="#arguments.bean.getcreator()#" cfsqltype="CF_SQL_VARCHAR" />,
				<cfqueryparam value="#my.utils.getSQLDateTime()#" cfsqltype="CF_SQL_TIMESTAMP" />
			)
			SELECT scope_identity() AS newID
			SET NOCOUNT OFF
		</cfquery>
	</cfif>
	
	<cfif my.constants.getDBtype() IS "MYSQL">
		<cfquery name="qCreate" datasource="#my.constants.getDSN()#">
			insert into rb_bundle
				(name, rbloc, creator, createdate)
			values (
				<cfqueryparam value="#arguments.bean.getname()#" cfsqltype="CF_SQL_VARCHAR" />,
				<cfqueryparam value="#arguments.bean.getrbloc()#" cfsqltype="CF_SQL_VARCHAR" />,
				<cfqueryparam value="#arguments.bean.getcreator()#" cfsqltype="CF_SQL_VARCHAR" />,
				<cfqueryparam value="#my.utils.getSQLDateTime()#" cfsqltype="CF_SQL_TIMESTAMP" />
			)
		</cfquery>
		<cfquery name="qCreate" datasource="#my.constants.getDSN()#">
			SELECT LAST_INSERT_ID() AS newID
		</cfquery>
	</cfif>
	
	<cfscript>
		arguments.bean.setbundle_id(qCreate.newID);
		keyBeans = arguments.bean.getKeyBeans();
		
		for (i=1; i LTE ArrayLen(keyBeans); i=i+1)
		{
			keyBeans[i].setbundle_id(arguments.bean.getbundle_id());
			my.keyDao.create(keyBeans[i]);
		}
	</cfscript>
</cffunction>

<cffunction name="update" output="false" access="public" returntype="boolean">
	<cfargument name="bean" required="true" type="BundleBean">
	<cfscript>
		var qUpdate="";
		var success=false;
		var keyBeans="";
		var i = "";
	</cfscript>

	<cfif my.constants.getDBtype() IS "MSSQL">
		<cfquery name="qUpdate" datasource="#my.constants.getDSN()#">
			SET NOCOUNT ON
			update rb_bundle
			set name = <cfqueryparam value="#arguments.bean.getname()#" cfsqltype="CF_SQL_VARCHAR" />,
				rbloc = <cfqueryparam value="#arguments.bean.getrbloc()#" cfsqltype="CF_SQL_VARCHAR" />,
				editor = <cfqueryparam value="#arguments.bean.geteditor()#" cfsqltype="CF_SQL_VARCHAR" />,
				editdate = <cfqueryparam value="#my.utils.getSQLDateTime()#" cfsqltype="CF_SQL_TIMESTAMP" />
			where bundle_id = <cfqueryparam value="#arguments.bean.getbundle_id()#" cfsqltype="CF_SQL_INTEGER">
			SELECT @@ROWCOUNT AS numRows
			SET NOCOUNT OFF
		</cfquery>
		<cfif qUpdate.numRows GT 0>
			<cfset success = true />
		</cfif>
	</cfif>
	
	<cfif my.constants.getDBtype() IS "MYSQL">
		<cfquery name="qUpdate" datasource="#my.constants.getDSN()#">
			update rb_bundle
			set name = <cfqueryparam value="#arguments.bean.getname()#" cfsqltype="CF_SQL_VARCHAR" />,
				rbloc = <cfqueryparam value="#arguments.bean.getrbloc()#" cfsqltype="CF_SQL_VARCHAR" />,
				editor = <cfqueryparam value="#arguments.bean.geteditor()#" cfsqltype="CF_SQL_VARCHAR" />,
				editdate = <cfqueryparam value="#my.utils.getSQLDateTime()#" cfsqltype="CF_SQL_TIMESTAMP" />
			where bundle_id = <cfqueryparam value="#arguments.bean.getbundle_id()#" cfsqltype="CF_SQL_INTEGER">
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
	
	<cfif success>
		<cfscript>
			// update all the existing keys
			keyBeans = arguments.bean.getKeyBeans();
			for (i = 1; i LTE ArrayLen(keyBeans); i = i + 1)
			{
				if(keyBeans[i].getKey_id() GT 0){
					my.keyDAO.update(keyBeans[i]);
				}
			}
		</cfscript>
	</cfif>
	<cfreturn success />
</cffunction>

<cffunction name="delete" output="false" access="public" returntype="void">
	<cfargument name="bean" required="true" type="BundleBean">
	<cfscript>
		var qDelete="";
		var keyBeans = arguments.bean.getKeyBeans();
		var i = "";	
	</cfscript>
	<cftransaction isolation="read_committed">
		<cfscript>
			for (i=1; i LTE ArrayLen(keyBeans); i=i+1)
			{
				my.keyDao.delete(keyBeans[i]);
			}
		</cfscript>

		<cfquery name="qDelete" datasource="#my.constants.getDSN()#" result="status">
			delete
			from rb_bundle
			where bundle_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.bean.getbundle_id()#" />
		</cfquery>
	</cftransaction>

</cffunction>


</cfcomponent>