<cfcomponent displayname="ValidationErrorCollection" output="false" hint="I am a collection of property validation errors">

<cffunction name="Init" returntype="ValidationErrorCollection" access="public" output="false" hint="I build a new ValidationErrorCollection.">
  <cfset variables.instance.errors = structNew() />
  <cfreturn this />
</cffunction>

<cffunction name="AddError" returntype="void" access="public" output="false" hint="I add to the Error collection.">
  <cfargument name="PropertyName" type="string" required="true" hint="I am the property in an error state.">
  <cfargument name="ErrorMessage" type="string" required="true" hint="I am a friendly error message.">
  <cfif not structKeyExists(variables.instance.errors, arguments.PropertyName)>
    <cfset variables.instance.errors[arguments.PropertyName] = arrayNew(1) />
  </cfif>
  
  <cfset arrayAppend(variables.instance.errors[arguments.PropertyName], arguments.ErrorMessage) />
</cffunction>

<cffunction name="RemoveError" returntype="void" access="public" output="false" hint="I remove an Error from the collection.">
  <cfargument name="PropertyName" type="string" required="true" hint="I am the property in an error state.">
  <cfset structDelete(variables.instance.errors,arguments.PropertyName) />
</cffunction>

<cffunction name="GetErrors" returntype="struct" access="public" output="false" hint="I get the Error collection.">
  <cfreturn variables.instance.Errors />
</cffunction>

<cffunction name="HasErrors" returntype="boolean" access="public" output="false" hint="I let you know if there are errors.">
  <cfargument name="PropertyName" type="string" required="false" default="" hint="You can check for errors on a specific property by passing me.">

  <cfif len(arguments.propertyName)>
    <cfif structKeyExists(variables.instance.errors,arguments.PropertyName)>
      <cfreturn true />
    <cfelse>
      <cfreturn false />
    </cfif>
  <cfelse>
    <cfif structCount(variables.instance.Errors) gt 0>
      <cfreturn true />
    <cfelse>
      <cfreturn false />
    </cfif>
  </cfif>
</cffunction>

<cffunction name="TotalErrors" returntype="numeric" access="public" output="false" hint="I let tell you how many errors.">
  <cfreturn structCount(variables.instance.Errors) />
</cffunction>

<cffunction name="Merge" returntype="void" access="public" output="false" hint="I merge another collection's errors into this one.">
  <cfargument name="Col" type="ValidationErrorCollection" required="true" hint="I am the collection to merge.">
  
  <cfset var i = "" />
  <cfset var j = "" />
  <cfset var err = col.getErrors() />
  
  <cfloop collection="#err#" item="i">
    <cfloop from="1" to="#arrayLen(err[i])#" index="j">
      <cfset addError(i, err[i][j]) />
    </cfloop>
  </cfloop>
</cffunction>

</cfcomponent>