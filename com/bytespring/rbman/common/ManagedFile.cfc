<cfcomponent name="managedFile" output="false" hint="I am a managed file bean.">

<!--- setup the instance attributes --->
<cfscript>
	variables.my = StructNew();
	my.Name = "";
	my.Path = "";
	my.Mimetype = "";
	my.Size = "";
	my.DateCreated = "";
</cfscript>

<cffunction name="Init" access="Public" returnType="managedFile" output="false"
	hint="I am the constructor.">
  <cfreturn this />
</cffunction>

<cffunction name="getAll" access="public" returntype="struct" output="false">
	<cfreturn variables.my />
</cffunction>

<cffunction name="setName" access="public" output="false">
	<cfargument name="Name" type="string" required="true" />
	<cfset my.Name = arguments.Name />
</cffunction>
<cffunction name="getName" access="public" returntype="string" output="false">
	<cfreturn my.Name />
</cffunction>

<cffunction name="setPath" access="public" output="false">
	<cfargument name="Path" type="string" required="true" />
	<cfset my.Path = arguments.Path />
</cffunction>
<cffunction name="getPath" access="public" returntype="string" output="false">
	<cfreturn my.Path />
</cffunction>

<cffunction name="setMimetype" access="public" output="false">
	<cfargument name="Mimetype" type="string" required="true" />
	<cfset my.Mimetype = arguments.Mimetype />
</cffunction>
<cffunction name="getMimetype" access="public" returntype="string" output="false">
	<cfreturn my.Mimetype />
</cffunction>

<cffunction name="setSize" access="public" output="false">
	<cfargument name="Size" type="string" required="true" />
	<cfset my.Size = arguments.Size />
</cffunction>
<cffunction name="getSize" access="public" returntype="string" output="false">
	<cfreturn my.Size />
</cffunction>

<cffunction name="setDateCreated" access="public" output="false">
	<cfargument name="DateCreated" type="string" required="true" />
	<cfset my.DateCreated = arguments.DateCreated />
</cffunction>
<cffunction name="getDateCreated" access="public" returntype="string" output="false">
	<cfreturn my.DateCreated />
</cffunction>

</cfcomponent>

