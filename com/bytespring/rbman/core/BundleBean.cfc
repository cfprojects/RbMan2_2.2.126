<cfcomponent output="false" alias="com.bytespring.rbman.core.BundleBean">

	<cfproperty name="bundle_id" type="numeric" default="0">
	<cfproperty name="name" type="string" default="">
	<cfproperty name="rbloc" type="string" default="">
	<cfproperty name="creator" type="string" default="">
	<cfproperty name="createdate" type="date" default="">
	<cfproperty name="editor" type="string" default="">
	<cfproperty name="editdate" type="date" default="">
	<cfproperty name="keyBeans" type="keyBean[]">

	<cfscript>
		//Initialize the CFC with the default properties values.
		variables.bundle_id = 0;
		variables.name = "";
		variables.rbloc = "";
		variables.creator = "";
		variables.createdate = "";
		variables.editor = "";
		variables.editdate = "";
		variables.keyBeans = ArrayNew(1);
	</cfscript>

	<cffunction name="init" output="false" returntype="BundleBean">
		<cfreturn this>
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

	<cffunction name="getName" output="false" access="public" returntype="any">
		<cfreturn variables.Name>
	</cffunction>

	<cffunction name="setName" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Name = arguments.val>
	</cffunction>

	<cffunction name="getRbloc" output="false" access="public" returntype="any">
		<cfreturn variables.Rbloc>
	</cffunction>

	<cffunction name="setRbloc" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Rbloc = arguments.val>
	</cffunction>

	<cffunction name="getCreator" output="false" access="public" returntype="any">
		<cfreturn variables.Creator>
	</cffunction>

	<cffunction name="setCreator" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Creator = arguments.val>
	</cffunction>

	<cffunction name="getCreatedate" output="false" access="public" returntype="any">
		<cfreturn variables.Createdate>
	</cffunction>

	<cffunction name="setCreatedate" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfif (IsDate(arguments.val)) OR (arguments.val EQ "")>
			<cfset variables.Createdate = arguments.val>
		<cfelse>
			<cfthrow message="'#arguments.val#' is not a valid date"/>
		</cfif>
	</cffunction>

	<cffunction name="getEditor" output="false" access="public" returntype="any">
		<cfreturn variables.Editor>
	</cffunction>

	<cffunction name="setEditor" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Editor = arguments.val>
	</cffunction>

	<cffunction name="getEditdate" output="false" access="public" returntype="any">
		<cfreturn variables.Editdate>
	</cffunction>

	<cffunction name="setEditdate" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfif (IsDate(arguments.val)) OR (arguments.val EQ "")>
			<cfset variables.Editdate = arguments.val>
		<cfelse>
			<cfthrow message="'#arguments.val#' is not a valid date"/>
		</cfif>
	</cffunction>

	<cffunction name="getKeyBeans" output="false" access="public" returntype="keyBean[]">
		<cfreturn variables.KeyBeans>
	</cffunction>
	<cffunction name="setKeyBeans" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.KeyBeans = arguments.val>
	</cffunction>
	
	<!---utility functions --->
	<cffunction name="getValues" output="false" access="public" returntype="struct">
		<cfscript>
			var i = "";
			var keys = structNew();
			var keyBeans = getKeyBeans();
			var k = "";
			var v = "";
			for(i=1; i lte arrayLen(keyBeans); i=i+1) {
				k = keyBeans[i].getRbKey();
				v = keyBeans[i].getRbValue();
				keys[k] = v; 
			}
			return keys;
		</cfscript>
	</cffunction>
	
	<cffunction name="setValues" output="false" access="public" returntype="void">
		<cfargument name="values" required="true" type="struct">
		<cfscript>
			var i = "";
			var keys = structNew();
			var keyBeans = getKeyBeans();
			var k1 = "";
			var k2 = "";
			var len = "";
			var keyBean = "";
			var keyExists = "";
			
			// first update/delete the existing keys
			len = arrayLen(keyBeans);
			for(i=len; i GT 0; i=i-1) {
				k2 = keyBeans[i].getRbKey();
				if(structKeyExists(arguments.values,k2)){
					keyBeans[i].setRbValue(arguments.values[k2]);		
				}else{
					arrayDeleteAt(keyBeans,i);
				}
			}
			
			// now add any new keys
			for(k1 IN arguments.values) {
				keyExists = false;
				// update/delete the existing keys
				len = arrayLen(keyBeans);
				for(i=len; i GT 0; i=i-1) {
					k2 = keyBeans[i].getRbKey();
					if(k1 IS k2){
						keyExists = true;
						break;
					}
				}
				// add the key if it does not exist
				if(NOT keyExists){
					keyBean = createObject("component","KeyBean");
					keyBean.setRbKey(k1);
					keyBean.setRbValue(arguments.values[k1]);
					arrayAppend(keyBeans,keyBean);
				}
			}
			setKeyBeans(keyBeans);
		</cfscript>
	</cffunction>
	
	

	<cffunction name="getKeyValue" access="public" output="false" returntype="string">
		<cfargument name="key" required="true" type="string">
		<cfscript>
			var value = "";
			var keys = getValues();
			if (structKeyExists(keys,arguments.key)) {
				value = keys[key];
			}
			return value;
		</cfscript>
	</cffunction>
	
	<cffunction name="keyExists" access="public" output="false" returntype="boolean">
		<cfargument name="key" type="string" required="true" />
		<cfscript>
			if (len(trim(getKey(arguments.key)))) {
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>
	
</cfcomponent>