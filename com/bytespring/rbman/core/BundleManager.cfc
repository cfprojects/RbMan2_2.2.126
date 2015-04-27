<cfcomponent name="bundleManager" output="false" 
	hint="I provide all the public functions for the bundle manager.">

<!--- setup the instance attributes --->
<cfscript>
	variables.my = StructNew();
	my.constants = "";
	my.utils = "";
	my.localeDAO = "";
	my.localeGateway = "";
	my.bundleDAO = "";
	my.bundleGateway = "";
	my.keyDAO = "";
	my.keyGateway = "";
	my.propertiesDAO = "";
</cfscript>

<cffunction name="Init" access="Public" returnType="bundleManager" output="false">
  <cfargument name="constants" required="true" type="com.bytespring.rbman.config.constants" />
	<cfargument name="utils" required="true" type="com.bytespring.rbman.common.utilities" />
	<cfscript>
		my.constants = arguments.constants;
		my.utils = arguments.utils;
		//my.localeDAO = createobject("component","localeDAO").init(my.constants);
		my.localeGateway = createobject("component","LocaleGateway").init(my.constants);
		my.keyDAO = createobject("component","KeyDAO").init(my.constants,my.utils);;
		my.keyGateway = createobject("component","KeyGateway").init(my.constants,my.utils);
		my.bundleDAO = createobject("component","BundleDAO").init(my.constants,my.utils,my.keyDAO,my.keyGateway);
		my.bundleGateway = createobject("component","BundleGateway").init(my.constants,my.utils);
		my.propertiesDAO = createobject("component","PropertiesDAO");
	</cfscript>
  <cfreturn this />
</cffunction>

<cffunction name="validateBundleBean" access="Public" returnType="com.bytespring.rbman.common.ValidationErrorCollection" output="false"
	hint="I validate a bundleBean.">
  <cfargument name="obj" required="true" type="BundleBean" />
	<cfscript>
		var errorCollection = createObject("component", "com.bytespring.rbman.common.ValidationErrorCollection").init();
		if (len(arguments.obj.getBundle_id())) {
			if (NOT isNumeric(arguments.obj.getBundle_id())) {
			errorCollection.addError("Bundle_id","Bundle_id is not numeric.");
			}
		}
		if (NOT len(trim(arguments.obj.getName()))) {
			errorCollection.addError("Name","Name is required.");
		}
		if (NOT len(trim(arguments.obj.getRbLoc()))) {
			errorCollection.addError("RbLoc","RbLoc is required.");
		}
		if (NOT len(trim(arguments.obj.getCreator()))) {
			errorCollection.addError("Creator","Creator is required.");
		}
		//if (NOT isDate(arguments.obj.getCreateDate())) {
			//errorCollection.addError("CreateDate","CreateDate is required.");
		//}
	</cfscript>
	
  <cfreturn errorCollection />
</cffunction>

<cffunction name="getLocaleList" output="false" access="public" returntype="array">
	<cfscript>
		var localeList = my.localeGateway.getLocaleList();
		var localeArray = arrayNew(1);
	</cfscript>

	<cfloop query="localeList">
		<cfset arrayAppend(localeArray,localeList.rbloc)/>
	</cfloop>

	<cfreturn localeArray />
</cffunction>

<cffunction name="getBundleList" output="false" access="public" returntype="query">
	<cfargument name="rbloc" type="string" required="true" />
	<cfscript>
		var bundleList = my.bundleGateway.getBundleList(arguments.rbloc);
		return bundleList;
	</cfscript>
</cffunction>

<cffunction name="getBundleByName" access="public" output="false" returntype="BundleBean">
	<cfargument name="name" type="string" required="true" />
	<cfargument name="rbloc" type="string" required="true" />
	<cfscript>
		var qIDs = my.BundleGateway.getBundleIDs(arguments.name,arguments.rbloc);
		var bundle = getBundleById(qIDs.bundle_id[1]);
		return bundle;
	</cfscript>
</cffunction>

<cffunction name="getBundleById" output="false" access="public" returntype="BundleBean">
	<cfargument name="id" required="true" type="numeric" />
	<cfscript>
		var bundleBean = createObject("component","BundleBean");
		my.bundleDAO.read(bundleBean,arguments.id);
	</cfscript>
	<cfreturn bundleBean />
</cffunction>

<cffunction name="bundleExists" access="public" output="false" returntype="boolean">
	<cfargument name="name" type="string" required="true" />
	<cfargument name="rbloc" type="string" required="true" />
	<cfscript>
		var qIDs = my.BundleGateway.getBundleIDs(arguments.name,arguments.rbloc);
		if(qIDs.recordcount GT 0){
			return true;
		}else{
			return false;
		}
	</cfscript>
</cffunction>

<cffunction name="updateBundle" output="false" access="public" returntype="boolean">
	<cfargument name="bundleBean" required="true" type="BundleBean">
	<cfscript>
		var success = true;
		var keyBeans = "";
		var keysToDelete = ArrayNew(1);
		var newkeys = "";
		var oldkeys = "";
		var key = "";
		var i = "";
	</cfscript>

	<cftransaction isolation="read_committed">
		<cfscript>
			if(arguments.bundleBean.getrbloc() IS "base"){	
				keyBeans = arguments.bundleBean.getKeyBeans();
				// return all of the existing keys
				oldkeys = my.keyGateway.getExistingKeys(arguments.bundleBean.getbundle_id());
				newkeys = arguments.bundleBean.getValues();
				
				//globally delete any keys that have been removed from the keyBean array
				for (key IN oldkeys)
				{
					if (NOT structKeyExists(newkeys,key))
					{
						ArrayAppend(keysToDelete, key);
					}
				}
	
				// delete the keys
				if(arraylen(keysToDelete) GT 0){
					my.keyGateway.globallyDeleteKeys(keysToDelete,arguments.bundleBean.getName());
				}
				
				// create the new keys
				for (i=1; i LTE ArrayLen(keyBeans); i=i+1)
				{
					keyBeans[i].setRbkey(replace(keyBeans[i].getRbkey()," ","","all"));
					if(keyBeans[i].getKey_id() EQ 0 AND NOT structKeyExists(oldkeys,keyBeans[i].getRbkey())){
						keyBeans[i].setBundle_id(arguments.bundleBean.getBundle_id());
						globallyAddKey(keyBeans[i],arguments.bundleBean.getName());
					}
				}
			}
			// update the bundle
			success = my.bundleDAO.update(arguments.bundleBean);
			return success;
		</cfscript>
	</cftransaction>
</cffunction>

<cffunction name="globallyAddKey" access="public" output="false" returntype="void">
	<cfargument name="keyBean" type="keyBean" required="true" />
	<cfargument name="bundleName" type="string" required="true" />
	<cfscript>
		var qIDs = my.bundleGateway.getBundleIDs(arguments.bundleName);
		var tmpKeyBean = createObject("component","KeyBean");
	</cfscript>
	<cfloop query="qIDs">
		<cfscript>
			tmpKeyBean.setBundle_id(qIDs.bundle_id);
			tmpKeyBean.setrbkey(arguments.keyBean.getRbkey());
			tmpKeyBean.setrbvalue(arguments.keyBean.getRbValue());
			my.keyDAO.create(tmpKeyBean);
		</cfscript>
	</cfloop>
</cffunction>

<cffunction name="deleteAll" access="public" output="false" returntype="boolean">
	<cfargument name="bundleName" type="string" required="true" />
	<cfscript>
		var qIDS = "";
		var tmpBundle = "";
		var success = false;
	</cfscript>
	<cfset qIDS = my.bundleGateway.getBundleIds(bundleName) />
	<cfloop query="qIDS">
		<cfscript>
			tmpBundle = createobject("component","BundleBean");
			my.bundleDAO.read(tmpBundle,qIDS.bundle_id);
			my.bundleDAO.delete(tmpBundle);
			success = true;
		</cfscript>
	</cfloop>
	<cfreturn success />
</cffunction>

<cffunction name="addBundle" access="public" output="false" returntype="boolean">
	<cfargument name="bundleBean" type="BundleBean" required="true" />
	<cfscript>
		var localeList = my.localeGateway.getLocaleList();
		var i = "";
		var getID = my.bundleGateway.getBundleIds(arguments.bundleBean.getName());
		var success = false;
		if (getID.recordcount EQ 0) {
			for(i=1; i LTE localeList.recordcount; i=i+1){
				arguments.bundleBean.setRbLoc(localeList.rbloc[i]);
				my.bundleDAO.create(arguments.bundleBean);
			}
			success = true;
		}
		return success;
	</cfscript>
</cffunction>

<cffunction name="addLocale" access="public" output="false" returntype="boolean">
	<cfargument name="rbloc" type="string" required="true" />
	<cfscript>
		var bundleList = "";
		var success = false;
		var bundle = "";
		var i = "";
		var locRE = "^[a-z]{2}_[A-Z]{2}$|^[a-z]{2}$";
		
		if(NOT reFind(locRE ,arguments.rbloc)){
			return false;
		}
		if (NOT my.localeGateway.localeExists(arguments.rbloc)){
			//add the locale
			success = my.localeGateway.addLocale(arguments.rbloc);
			if(success){
				//get the base bundle list
				bundleList = getBundleList("base");
				//loop over the bundle list
				for(i=1; i LTE bundleList.recordcount; i=i+1){
					bundle = getBundleById(bundleList.bundle_id[i]);
					bundle.setRbLoc(arguments.rbloc);
					my.bundleDAO.create(bundle);
				}
			}
		}
		return success;
	</cfscript>
</cffunction>

<cffunction name="deleteLocale" access="public" output="false" returntype="boolean">
	<cfargument name="rbloc" type="string" required="true" />
	<cfscript>
		var success = false;
		if(arguments.rbloc IS NOT "base"){
			success = my.localeGateway.deleteLocale(arguments.rbloc);
		}
		return success;
	</cfscript>
</cffunction>

<cffunction name="getStats" access="public" output="false" returntype="StatsBean">
	<cfargument name="rbloc" type="string" required="true" />
	<cfscript>
		var statsBean = createobject("component","StatsBean");
		var stats = my.keyGateway.getKeyCount(arguments.rbloc);
	</cfscript>
	<cfloop query="stats">
		<cfif stats.translated>
			<cfset statsBean.setTotalKeys(stats.total) />
		<cfelse>
			<cfset statsBean.setTotalUKeys(stats.total) />
		</cfif>
	</cfloop>
	<cfreturn statsBean />
</cffunction>

<cffunction name="uploadFile" access="remote" output="false" returntype="void">
	<cfargument name="filefield" type="string" required="false" default="fileData" />
	<cfscript>
		var mfile = createObject("component","com.bytespring.rbman.common.ManagedFile");
		var ec = "";
		var filecheck = "";
		var bundleBean = "";
		
		//upload the file to the temp data dir
		my.utils.logString("uploading file to: " & my.constants.getTmpDataDir());
		my.utils.upload(mfile,arguments.filefield,my.constants.getTmpDataDir(),"application/octet-stream");
				
		if(right(mfile.getName(),11) IS NOT ".properties"){
			my.utils.deleteFile(my.constants.getTmpDataDir() & mfile.getName());
		}
	</cfscript>
</cffunction>

<cffunction name="importProperties" access="remote" output="false" returntype="boolean">
	<cfargument name="creator" type="string" required="true" hint="The name of the user importing the bundles." />
	<cfargument name="encoding" type="string" required="true" hint="utf-8,ISO 8859-1" />
	<cfscript>
		var today = DateFormat(Now(),"YYYY/MM/DD") & ""  & timeFormat(Now(),"HH:MM:SS");
		var mfile = createObject("component","com.bytespring.rbman.common.ManagedFile");
		var ec = "";
		var bundleBean = "";
		var fileList = "";
		var locRE = "_[a-z]{2}_[A-Z]{2}\.|_[a-z]{2}\.";
		var filename = "";
		var rbName = "";
		var rbLoc = "";
		var thisFind = "";
		var tmpArray = arrayNew(1);
		var tmpBean = "";
		var i = "";
		var success = true;
	</cfscript>
	<cfdirectory directory="#my.constants.getTmpDataDir()#" name="fileList" filter="*.properties" sort="name ASC" />
	<cfloop query="fileList">
		<cfscript>
			filename = fileList.name;
			// find the locale of the bundle
			thisFind = reFind(locRE,filename,1,true);
			if (thisFind.pos[1] GT 0) {
				rbLoc = mid(filename,thisFind.pos[1]+1,thisFind.len[1]-2);
				rbName = replace(filename,"_#rbLoc#","");
			} else {
				rbLoc = "base";
				rbName = filename;
			}
			// read the properties file
			bundleBean = my.propertiesDAO.read(rbName,rbLoc,my.constants.getTmpDataDir(),arguments.encoding);
			if(bundleBean.getRbLoc() IS "base"){
				if(arrayLen(tmpArray) EQ 0){
					arrayAppend(tmpArray,bundleBean);
				}else{
					arrayInsertAt(tmpArray,1,bundleBean);
				}
			}else{
				arrayAppend(tmpArray,bundleBean);
			}
			//deleteFile
			my.utils.deleteFile(my.constants.getTmpDataDir() & filename);
		</cfscript>
	</cfloop>
	<cfscript>
	// loop over the tmpArray
	for(i=1; i LTE arrayLen(tmpArray); i=i+1){
		if(success){
			bundleBean = tmpArray[i];
			// if bundle is base bundle
			if(bundleBean.getRbLoc() IS "base"){
				// if bundle exists
				if(bundleExists(bundleBean.getName(), bundleBean.getRbLoc())){
					// get bundle
					tmpBean = getBundleByName(bundleBean.getName(), bundleBean.getRbLoc());
					tmpBean.setValues(bundleBean.getValues());
					// update bundle
					success = updateBundle(tmpBean);
				}else{
					bundleBean.setCreator(arguments.creator);
					bundleBean.setCreateDate(today);
					success = addBundle(bundleBean);
				}
			}else{
				// if bundle exists
				if(bundleExists(bundleBean.getName(), bundleBean.getRbLoc())){
					// get bundle
					tmpBean = getBundleByName(bundleBean.getName(), bundleBean.getRbLoc());
					tmpBean.setValues(bundleBean.getValues());
					// update bundle
					success = updateBundle(tmpBean);
				}
			}
		}else{
			return success;
		}
	}			
	return success;	
	</cfscript>
</cffunction>

<cffunction name="exportProperties" access="remote" output="false" returntype="struct">
	<cfargument name="bundleArray" type="array" required="true" hint="An array of base bundle names." />
	<cfargument name="encoding" type="string" required="true" hint="utf-8,ISO 8859-1" />
	<cfscript>
		var i = "";
		var j = "";
		var baLen = arrayLen(bundleArray);
		var bundleStruct = structNew();
		var laLen = "";
		var bundleName = "";
		var rbLoc = "";
		var zipFile = "";
		var bundle = "";
		var localeArray = "";
		var uuid = createUUID();
		var exportDir = my.constants.getTmpDataDir() & uuid & "/";
		var exportPath = my.constants.getTmpDataPath() & uuid & "/";
		var propArray = arrayNew(1);
		var propName = "";
		var result = structNew();
		
		try{
		// create the tmp directory
		my.utils.createDirectory(exportDir);
		//remove any duplicates from the array
		for(i=1; i lte baLen; i=i+1){
			bundleStruct[arguments.bundleArray[i]] = "";
		}
		
		// get the localeList
		localeArray = getLocaleList();
		laLen = arrayLen(localeArray);
		
		for(j=1; j lte laLen; j=j+1){
			rbLoc = localeArray[j];
			for(bundleName in bundleStruct){
				bundle = getBundleByName(bundleName,rbLoc);
				propName = my.propertiesDAO.write(bundle,exportDir,arguments.encoding);
				arrayAppend(propArray,propName);
			}
		}
		zipFile = createBundleArchive(propArray,exportDir);
		}catch(any ex){
			//my.utils.logObject(ex);
			my.utils.writedump(ex,my.constants.getTmpDataDir(),"ExportPropertiesException#uuid#");
		}
		// set the result
		result.EXPORTPATH = exportPath;
		result.FILENAME = zipFile;
		return result;
	</cfscript>
</cffunction>

<cffunction name="createBundleArchive" access="private" output="false" returntype="String">
	<cfargument name="fileArray" type="array" required="true" />
	<cfargument name="fileDir" type="string" required="true" />
	<cfscript>
		// Create a buffer for reading the files
		var buf = RepeatString(" ",1024).getBytes();
		var timestamp = dateformat(now(),"YYYYMMDD") & timeFormat(now(),"HHMMSS");
		var zipFileName = "rbFiles_" & timestamp & ".zip";
		var zipFilePath = arguments.fileDir & zipFileName;
		var fis     = CreateObject("java","java.io.FileInputStream");
		var fos    = CreateObject("java","java.io.FileOutputStream");
		var zipOS   = CreateObject("java","java.util.zip.ZipOutputStream");
		var zipEntry = "";
		var i = "";
		var len = ArrayLen(arguments.fileArray);
		var len2 = "";
		var propFile = "";
		
		try {
		// Create the ZIP file
		fos.init(zipFilePath);
		zipOS.init(fos);
		zipOS.setLevel(9);
		
		// Compress the files
		for (i=1; i LTE len; i=i+1) {
			propFile = arguments.fileDir & arguments.fileArray[i];
			fis.init(propFile);
			
			// Add ZIP entry to output stream.
			zipEntry = CreateObject("java","java.util.zip.ZipEntry");
			zipOS.putNextEntry(zipEntry.init(arguments.fileArray[i]));
			
			// Transfer bytes from the file to the ZIP file
			len2 = fis.read(buf);
			while (len2 GT 0) {
				zipOS.write(buf, 0, len2);
				len2 = fis.read(buf);
			}
			
			// Complete the entry
			zipOS.closeEntry();
			fis.close();
		}
		
		// Complete the ZIP file
		zipOS.close();
		} catch (any ex) {
			my.utils.logString(ex.message);
		}
		return zipFileName;
	</cfscript>
</cffunction>

</cfcomponent>

