<!---
Name             : propertiesDAO.cfc
Author           : JasonSheedy - jason@jmpj.net 
Created          : Dec 2006
Responsibilities : I contain the functions to read/write/delete bundle object from/to properties files.
Last Updated     : 
History          : Updated Nov 2008
--->
<cfcomponent displayname="propertiesDAO" output="false" hint="Java Properties Data Access Object">

	<cffunction name="init" access="public" output="false" returntype="propertiesDAO" hint="Constructor for this CFC">
		<cfreturn this />
	</cffunction>

	<cffunction name="write" access="public" output="false" returntype="string"	
		hint="WRITE: writes a bundle to properties file.">
		<!--- take bundle bean as argument --->
		<cfargument name="bundle" type="BundleBean" required="true" />
		<cfargument name="propertiesDir" type="string" required="true" />
		<cfargument name="encoding" type="string" required="true" hint="utf-8,ISO 8859-1" />
		
		<!--- initialise the vars --->
		<cfscript>
			var fos = createObject("java", "java.io.FileOutputStream");
			var prop = "";
			var pw = "";
			var osw = "";
			var rbValues = arguments.bundle.getValues();
			var rbName = arguments.bundle.getName();
			var ext = ".properties";
			var rbLocale = arguments.bundle.getRbLoc();
			var thisRBfile = "";
			var propName = "";
			var rbHeader = "Base Bundle: " & rbName & ext & " Locale: " & rbLocale;
			var key = "";
			var line = "";
			
			// set the file path
			if(rbLocale IS "base"){
				propName = rbName & ext;
			}else{
				propName = rbName & "_" & rbLocale & ext;
			}
			thisRBfile = arguments.propertiesDir & propName;
			if(arguments.encoding IS "utf-8"){
				osw = createObject("java","java.io.OutputStreamWriter");
				pw = createObject("java","java.io.PrintWriter");
				fos.init(thisRBfile);
				osw.init(fos, "UTF-8");
				pw.init(osw);
				for(key in rbValues){
					line = key & "=" & rbValues[key];
					pw.println(line);
				}
				pw.close();
				osw.close();
			}else{
				prop = createObject("java", "java.util.Properties");
				for(key IN rbValues){
					prop.setProperty(key,rbValues[key]);
				}
				fos.init(thisRBfile);
				prop.store(fos,rbHeader);
			}
			fos.close();
			return propName;
		</cfscript>
	</cffunction>

	<cffunction name="read" access="public" output="false" returntype="BundleBean"
		hint="READ: reads a properties file and populates the bundle bean.">
		<cfargument name="propName" required="true" type="string" hint="The base properties file name.">
		<cfargument name="rbLocale" required="false" type="string" default="base"/> 
		<cfargument name="propertiesDir" type="string" required="true" />
		<cfargument name="encoding" type="string" required="true" hint="utf-8,ISO 8859-1" />
		
		<cfscript>
			var bundle = createObject("component","BundleBean");
			var fis = CreateObject("java", "java.io.FileInputStream");
			var prop = "";
			var isr = "";
			var br = "";
			var keys = ""; // var to hold rb keys
			var KEY = "";
			var VALUE = "";
			var keyBean = "";
			var keyBeanArray = ArrayNew(1);
			var ext = ".properties";
			var name = left(arguments.propName,len(arguments.propName)-len(ext));
			var thisLang = listFirst(arguments.rbLocale,"_");
			var thisRBfile = arguments.propertiesDir & listFirst(arguments.propName,".") & "_" & arguments.rbLocale & ext;
			var line = "";
			//var utils = createobject('component','com.bytespring.rbman.common.Utilities'); 
			
			
			// try just the language	
			if (NOT fileExists(thisRBfile)){
				thisRBfile = arguments.propertiesDir & listFirst(arguments.propName,".") & "_" & thisLang & ext;
			}
			// still nothing? strip thisRBfile back to base rb
			if (NOT fileExists(thisRBfile)) {
				thisRBFile = arguments.propertiesDir & arguments.propName;
			}
			// final check, if this fails the file is not where it should be
			if (fileExists(thisRBFile)) { 
				// set the values in the bundle bean
				bundle.setName(name);
				bundle.setRbLoc(arguments.rbLocale);
				
				if(arguments.encoding IS "utf-8"){
					isr = createObject("java","java.io.InputStreamReader");
					
					fis.init(thisRBFile);	
					isr.init(fis,"UTF-8");
					prop = createObject("java", "java.util.PropertyResourceBundle");
					prop.init(isr);
					// get properties file & read the keys
					keys = prop.getKeys();
					while (keys.hasMoreElements()) {
						KEY = keys.nextElement();
						VALUE = prop.getObject(KEY);
						keyBean = createObject("component","KeyBean");
						keyBean.setRbKey(KEY);
						keyBean.setRbValue(VALUE);
						arrayAppend(keyBeanArray,keyBean);
					}
					isr.close();
					fis.close();
				}else{
					prop = createObject("java", "java.util.Properties");
					// get properties file & read the keys
					fis.init(thisRBFile);
					prop.load(fis);
					keys = prop.propertyNames();
					while (keys.hasMoreElements()) {
						KEY = keys.nextElement();
						VALUE = prop.getProperty(KEY);
						keyBean = createObject("component","KeyBean");
						keyBean.setRbKey(KEY);
						keyBean.setRbValue(VALUE);
						arrayAppend(keyBeanArray,keyBean);
					}	
				}
				
				bundle.setKeyBeans(keyBeanArray);
			}
			
			fis.close();
			
			return bundle;
		</cfscript>
	</cffunction> 


</cfcomponent>