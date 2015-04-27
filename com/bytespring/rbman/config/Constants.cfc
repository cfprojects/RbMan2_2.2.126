<cfcomponent output="false" name="constants" hint="I contain all the constants for the app.">

<!--- set constants --->
<cfscript>
	variables.DSN="rbman2"; //Insert your datasource name here
	variables.DBtype="MYSQL"; //MYSQL,MSSQL
	variables.TmpDataDir = ExpandPath('/tmp_data/');
	variables.TmpDataPath = '/tmp_data/';
	
	
	//Add users here.
	variables.users = ArrayNew(1);
	variables.newUser = StructNew();
	variables.newUser.username="Admin";
	variables.newUser.password="Password1";
	variables.newUser.role="admin"; //admin,standard
	variables.newUser.rbloc="base"; // the users locale
	arrayAppend(variables.users,variables.newUser);
	variables.newUser = StructNew();
	variables.newUser.username="Standard";
	variables.newUser.password="Password1";
	variables.newUser.role="standard";
	variables.newUser.rbloc="zh_CN";
	arrayAppend(variables.users,variables.newUser);
	variables.newUser = "";
</cfscript>

<cffunction name="Init" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="setDSN" output="false">
	<cfargument name="value" type="string" required="true" />
	<cfset variables.DSN = arguments.value />
</cffunction>
<cffunction name="getDSN" output="false">
	<cfreturn variables.DSN />
</cffunction>

<cffunction name="setDBtype" output="false">
	<cfargument name="value" type="string" required="true" />
	<cfset variables.DBtype = arguments.value />
</cffunction>
<cffunction name="getDBtype" output="false">
	<cfreturn variables.DBtype />
</cffunction>

<cffunction name="setTmpDataDir" output="false">
	<cfargument name="value" type="string" required="true" />
	<cfset variables.TmpDataDir = arguments.value />
</cffunction>
<cffunction name="getTmpDataDir" output="false">
	<cfreturn variables.TmpDataDir />
</cffunction>

<cffunction name="setTmpDataPath" output="false">
	<cfargument name="value" type="string" required="true" />
	<cfset variables.TmpDataPath = arguments.value />
</cffunction>
<cffunction name="getTmpDataPath" output="false">
	<cfreturn variables.TmpDataPath />
</cffunction>

<cffunction name="setUsers" output="false">
	<cfargument name="value" type="struct" required="true" />
	<cfset variables.users = arguments.value />
</cffunction>
<cffunction name="getUsers" output="false">
	<cfreturn variables.users />
</cffunction>

</cfcomponent>