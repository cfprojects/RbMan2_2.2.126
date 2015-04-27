<cfcomponent name="utilities" output="false" hint="I contain some basic utility functions.">
<cfprocessingdirective pageencoding="utf-8" />
<!--- setup the instance attributes --->
<cfscript>
	variables.my = StructNew();
	// email address regular expression
	my.basicEmailRE = "[\.\-\+_]*[A-Z0-9]+([\.\-\+_][A-Z0-9]*)*[\.\-\+_]*@[A-Z0-9]+([\.\-_][A-Z0-9]*)*\.([A-Z]){2,4}";
	//private var regex:String = "^[a-zA-Z_0-9-'\+~]+(\.[a-zA-Z_0-9-'\+~]+)*@([a-zA-Z_0-9-]+\.)+[a-zA-Z]{2,7}$";		
	// email address list ^eRE(,eRE)*$
	my.emailListRE = "^" & my.basicEmailRE & "(," & my.basicEmailRE & ")*$";
	// single email address ^eRE$
	my.emailRE = "^" & my.basicEmailRE & "$";
	// locale
	my.localeRE = "^[a-z]{2}_[A-Z]{2}$|^[a-z]{2}$";
	// windows filename
	//my.filenameRE = "[" & "'" & '"' & "##" & "/\\%&`@~!,:;=<>\+\*\?\[\]\^\$\(\)\{\}\|]";
	my.filenameRE = "[^A-Za-z._\-]";
	// html to plain text re's'
	my.htmlRE1= "<[^>]*>|&[^;]*;";
	my.htmlRE2 = "[\s]{2,}";
	
</cfscript>

<cffunction name="Init" access="Public" returnType="utilities" output="false" hint="I am the constructor.">
  <cfreturn this />
</cffunction>

<cffunction name="isEmail" access="public" returnType="boolean" output="true" 
						hint="I return true if the passed in string is a valid email address.">
  <cfargument name="email" required="true" type="string" />
	<cfset var result = false />
	<cfif reFindNoCase(my.emailRE,arguments.email)>
		<cfset result = true />
	</cfif>
  <cfreturn result />
</cffunction>

<cffunction name="isEmailList" access="public" returnType="boolean" output="false"
						hint="I return true if the passed in string is a list of valid email addresses. Note: An email list can contain only one element.">
  <cfargument name="emailList" required="true" type="string" />
	<cfset var result = false />
	<cfif reFindNoCase(my.emailListRE,arguments.emailList)>
		<cfset result = true />
	</cfif>
  <cfreturn result />
</cffunction>

<cffunction name="isLocale" access="public" returnType="boolean" output="false" 
						hint="I return true if the passed in string is a valid locale.">
  <cfargument name="locale" required="true" type="string" />
	<cfset var result = false />
	<cfif reFind(my.localeRE,arguments.locale)>
		<cfset result = true />
	</cfif>
  <cfreturn result />
</cffunction>

<cffunction name="getSQLDateTime" access="public" returnType="string" output="false" 
						hint="I return the current time formatted to be SQL friendly.">
	<cfset var thenow = DateFormat(Now(),"YYYY/MM/DD") & " " & TimeFormat(Now(),"HH:mm:ss") />
	
  <cfreturn thenow />
</cffunction>

<cffunction name="createLsName" access="Public" returnType="string" output="false" 
	hint="I create a locale specific name.">
	<cfargument name="firstname" required="true" type="string" />
	<cfargument name="lastname" required="true" type="string" />
	<cfargument name="locale" required="true" type="string" />
	<cfscript>
		var name = "";
	</cfscript>
	<cfif arguments.locale is "zh_CN">
		<cfset name = arguments.lastname & " " & arguments.firstname />
	<cfelse>
		<cfset name = arguments.firstname & " " & arguments.lastname />
	</cfif>
  <cfreturn name />
</cffunction>

<cffunction name="upload" access="public" returntype="ValidationErrorCollection" output="false"
	hint="I upload a file to the tmp data directory and return the details in a managedFile object.">
	<cfargument name="mfile" type="managedFile" required="true" />
	<cfargument name="fieldname" type="string" required="true" />
	<cfargument name="path" type="string" required="true" />
	<cfargument name="mimelist" type="string" required="false" />
	<cfscript>
		var errorCollection = createObject("component", "ValidationErrorCollection").init();
		var result = "";
	</cfscript>
	<cftry>
		<cffile action="upload" accept="#arguments.mimelist#" filefield="#arguments.fieldName#"
						destination="#arguments.path#" nameconflict="overwrite" result="result" />
		<cfset mfile.setName(result.serverfile)>
		<cfset mfile.setPath(result.serverDirectory & "\" & result.serverfile)>
		<cfset mfile.setMIMEType(result.contentType & "/" & result.contentSubType)>
		<cfset mfile.setSize(result.fileSize)>
		<cfset mfile.setDateCreated(result.timecreated)>
		<cfcatch>
			<cfif reFindNoCase("MIME type.*not accepted",cfcatch.message)>
				<cfset errorCollection.addError("mimeType","The file was not an acceptable mime type.") />
			<cfelseif findNoCase("zero-length",cfcatch.detail)>
				<cfset errorCollection.addError("zeroLength","Saving empty (zero-length) files is prohibited.") />
			<cfelseif findNoCase("did not contain a file",cfcatch.message)>
				<cfset errorCollection.addError("noFile","No file was specified for the upload.") />
			<cfelse>
				<cfset errorCollection.addError("uploadError","An error occured trying to upload the file.") />
			</cfif>
		</cfcatch>
	</cftry>
	<cfreturn errorCollection>
</cffunction>

<cffunction name="pushContent" access="public" returntype="void" output="false"
	hint="I push a file up to the client based on the mime type of the file extention.">
	<cfargument name="mfile" type="managedFile" required="true" />
	<cfargument name="download" type="boolean" required="false" default="false" />
	<cfargument name="deleteFile" type="boolean" required="false" default="false" />	
	
	<cfset var fileName = replace(arguments.mfile.getName()," ","_","all") />
	<cfif NOT arguments.download AND len(arguments.mfile.getMimetype())>
		<cfheader name="Content-Disposition" value="inline; filename=#fileName#">
	<cfelse>
		<cfheader name="Content-Disposition" value="attachment; filename=#fileName#" />
	</cfif>
	<cfcontent type="#arguments.mfile.getMimetype()#" deletefile="#arguments.deleteFile#" file="#arguments.mfile.getPath()#">
</cffunction>

<cffunction name="filterFilename" access="public" returntype="string" output="false"
	hint="I remove any dodgy characters from a filename and replace any spaces with underscores.">
	<cfargument name="filename" type="string" required="true" />
	<cfscript>
	 var newfilename = replace(arguments.filename," ","_","all");
	 newfilename = reReplace(newfilename,my.filenameRE,"","all");
	</cfscript>
	<cfreturn newfilename /> 
</cffunction>

<cffunction name="HtmlToPlainText" access="public" returntype="string" output="false"
	hint="I convert html to plain text as best as possible. Could be improved.">
	<cfargument name="content" type="string" required="true" />
	<cfscript>
	 var newString = reReplace(arguments.content,my.htmlRE1,"","all");
	 newString = reReplace(newString,my.htmlRE2," ","all");
	 newString = trim(newString);
	</cfscript>
	<cfreturn newString /> 
</cffunction>

<cffunction name="throw" access="public" returntype="void" output="false" hint="I throw an exception">
	<cfargument name="type" type="string" required="true" />
	<cfargument name="message" type="string" required="true" />
	<cfthrow type="#arguments.type#" message="#arguments.message#" />
</cffunction>

<cffunction name="dump" access="public" returntype="void" output="true" hint="I dump something.">
	<cfargument name="object" type="any" required="true" />
	<cfargument name="abort" type="boolean" required="false" default="true" />
	<cfdump var="#object#" />
	<cfif arguments.abort>
		<cfdump var="... aborted">
		<cfabort/>
	</cfif>
	<cfabort />
</cffunction>

<cffunction name="writeDump" access="public" returntype="void" output="false">
	<cfargument name="object" type="any" required="true">
	<cfargument name="path" type="String" required="true">
	<cfargument name="filename" type="string" required="false" default="debugging_dump">
	<cfset var filecontent = ""/>
	<cfsavecontent variable="filecontent">
		<cfdump var="#arguments.object#">
	</cfsavecontent>
	<cffile action="write" file="#arguments.path##filename#.html" output="#filecontent#" charset="utf-8" />
</cffunction>

<cffunction name="isInstance" access="public" returntype="Boolean" output="false" hint="I emulate the java instanceOf operator for CF and Java objects.">
  <cfargument name="obj" type="any" required="true"/>
  <cfargument name="reqType" type="string" required="true" />
	<cfargument name="lang" type="string" required="true" default="cf" hint="java or cf" />
	<cfscript>
		var searchMd = "";
		var tmpClass = "";
	</cfscript>
	<cfswitch expression="#arguments.lang#">
		<cfcase value="cf">
			<cfset searchMd = getMetaData(obj) />
		  <cfif searchMd.name IS arguments.reqType >
		    <cfreturn true />
		  <cfelse>
		    <cfloop condition="#StructKeyExists(searchMd, "extends")#">
		       <cfset searchMd = searchMd.extends />
		       <cfif searchMd.name IS reqType>
		         <cfreturn true />
		       </cfif>
		    </cfloop>
		  </cfif>
		</cfcase>
		<cfcase value="java">
			<cfset tmpClass = obj.getClass() />
			<cfif tmpClass.getName() IS arguments.reqType>
				<cfreturn true />
			<cfelse>
				<cfloop condition="true">
					<cfset tmpClass = tmpClass.getSuperClass() />
					<cfif tmpClass.getName() IS reqType>
						<cfreturn true />
					</cfif>
					<cfif tmpclass.getName() IS "java.lang.Object">
						<cfbreak />
					</cfif>
				</cfloop>
			</cfif>
		</cfcase>
		<cfdefaultcase></cfdefaultcase>
	</cfswitch>
  <cfreturn false />
</cffunction>

<cffunction name="logString" access="public" returntype="void" output="false" hint="i log information">
	<cfargument name="text" type="string" required="true" hint="text to be logged" />
	<cfargument name="logfile" type="string" required="false" default="Debugging_Log" />
	<cfargument name="type" type="string" required="false" default="information" />
	<cfscript>
		if(NOT listFind("error,fatal information,information,warning",arguments.type)) 
		{
			arguments.type = "information";
		}
	</cfscript>
	<cflog file="#arguments.logfile#" type="#arguments.type#" text="#arguments.text#" />
</cffunction>
	
<cffunction name="logObject" access="public" returntype="void" output="false" hint="i print any object">
	<cfargument name="obj" type="any" required="true" />
	<cfargument name="logfile" type="string" required="false" default="Debugging_Log" />
	<cfargument name="type" type="string" required="false" default="information" />
	<cfscript>
		if(IsStruct(arguments.obj)) {
			logString("===STRUCT===",arguments.logfile,arguments.type);
			logStruct(arguments.obj,arguments.logfile,arguments.type);
		} else if(IsArray(arguments.obj)) {
			logString("===ARRAY===",arguments.logfile,arguments.type);
			logArray(arguments.obj,arguments.logfile,arguments.type);
		} else if(IsSimpleValue(arguments.obj)){
			logString("SIMPLE VALUE - > #arguments.obj#",arguments.logfile,arguments.type);
		} else {
			logString("COMPLEX-VALUE",arguments.logfile,arguments.type);
		}
	</cfscript>
</cffunction>

<cffunction name="logStruct" access="public" returntype="void" output="false" hint="i print all the keys in a struct">
	<cfargument name="theStruct" type="struct" required="true" hint="struct to be logged" />
	<cfargument name="logfile" type="string" required="false" default="Debugging_Log" />
	<cfargument name="type" type="string" required="false" default="information" />
	<cfscript>
		var key = "";
		var obj = "";
		for(key in arguments.theStruct) {
			obj = arguments.theStruct[key];
			if(IsSimpleValue(obj)) {
				logString("#key# -> #obj#",arguments.logfile,arguments.type);
			} else if(IsStruct(obj)) {
				logString("#key# -> STRUCT",arguments.logfile,arguments.type);
				logStruct(obj,arguments.logfile,arguments.type);
			} else if(IsArray(obj)) {
				logString("#key# -> ARRAY",arguments.logfile,arguments.type);
				logArray(obj,arguments.logfile,arguments.type);
			} else {
				logString("#key# -> COMPLEX-VALUE",arguments.logfile,arguments.type);
			}
		}
	</cfscript>
</cffunction>
	
<cffunction name="logArray" access="private" returntype="void" output="false" hint="i print all the objects in this array">
		<cfargument name="anArray" type="array" required="true" hint="array to be logged" />
		<cfargument name="logfile" type="string" required="false" default="Debugging_Log" />
		<cfargument name="type" type="string" required="false" default="information" />
		<cfscript>
			var obj = "";
			var i = "";
			for(i = 1; i LTE ArrayLen(arguments.anArray); i = i + 1) {
				obj = arguments.anArray[i];
				if(IsSimpleValue(obj)) {
					logString("Array[#i#]: #obj#",arguments.logfile,arguments.type);
				} else if(IsStruct(obj)) {
					logString("Array[#i#]: Struct",arguments.logfile,arguments.type);
					logStruct(obj,arguments.logfile,arguments.type);
				} else if(IsArray(obj)) {
					logString("Array[#i#]: Array",arguments.logfile,arguments.type);
					logArray(obj,arguments.logfile,arguments.type);
				} else {
					logString("Array[#i#]: -> COMPLEX-VALUE",arguments.logfile,arguments.type);
				}
			}
		</cfscript>
</cffunction>

<cffunction name="createDirectory" access="public" output="false" returntype="boolean">
	<cfargument name="directory" type="string" required="true" />
	<cfset success = true />
	<cftry>
		<cfif NOT directoryExists(arguments.directory)>
			<cfdirectory action="create" directory="#arguments.directory#" />
		</cfif>
		<cfcatch type="any">
			<cfset success = false />
		</cfcatch>
	</cftry>
	<cfreturn success />
</cffunction>

<cffunction name="deleteDirectory" access="public" output="false" returntype="void">
	<cfargument name="dir" type="string" required="true" />
	<cfif directoryExists(arguments.dir)>
		<cfdirectory action="delete" directory="#arguments.dir#" recurse="true" />
	</cfif>
</cffunction>

<cffunction name="deleteFile" access="public" output="false" returntype="void">
	<cfargument name="file" type="string" required="true" />
	<cfif fileExists(file)>
		<cffile action="delete" file="#file#" />
	</cfif>
</cffunction>

</cfcomponent>

