/**
* Manage ForgeBox
*/
component extends="baseHandler"{

	// Dependencies
	property name="forgebox" 			inject="forgebox@forgeboxsdk";
	property name="forgeboxInstaller" 	inject="forgeboxInstaller@cb";
	property name="markdown"			inject="Processor@cbmarkdown";

	/**
	* Display ForgeBox entries
	*/
	function index( event, rc, prc ){
		// order by
		event.paramValue( "orderBy", "POPULAR" );
		event.paramValue( "startrow", "0" );

		// exit Handlers
		prc.xeh 				= "#prc.cbAdminEntryPoint#.layouts.remove";
		prc.xehForgeBoxInstall  = "#prc.cbAdminEntryPoint#.forgebox.install";
		prc.xehForgeBox			= "#prc.cbAdminEntryPoint#.forgebox.index";
		prc.markdown 			= variables.markdown;

		// get entries
		try{
			prc.entries = forgebox.getEntries( orderBy=forgebox.ORDER[ rc.orderBy ], typeSlug=rc.typeslug, startrow=rc.startrow );
			prc.errors = false;
		} catch( Any e ) {
			prc.errors = true;
			log.error( "Error retrieving from ForgeBox: #e.message# #e.detail#",e);
			cbMessagebox.error( "Error retrieving to ForgeBox: #e.message# #e.detail#" );
		}

		// Entries title
		switch( rc.orderBy ){
			case "new" 		: { prc.entriesTitle = "Cool New Stuff!"; break; }
			case "recent" 	: { prc.entriesTitle = "Recently Updated!"; break; }
			default 		: { prc.entriesTitle = "Most Popular!"; }
		}
		// view
		event.setView( view="forgebox/index", layout="ajax" );
	}

	/**
	* Install an item from ForgeBox
	*/
	function install( event, rc, prc ){
		rc.downloadURL 	= urldecode( rc.downloadURL );
		rc.returnURL 	= urldecode( rc.returnURL );
		switch ( rc.installDir ) {
			case "modules":
				rc.installDir = getInstance( "moduleService@cb" ).getCustomModulesPath();
				break;
			case "themes":
				rc.installDir = getInstance( "themeService@cb" ).getCustomThemesPath();
				break;
			case "widgets":
				rc.installDir = getInstance( "widgetService@cb" ).getCustomWidgetsPath();
				break;
		}

		// get entries
		var results = forgeboxInstaller.install( rc.downloadURL, rc.installDir );
		if( results.error ){
			log.error( "Error installing from ForgeBox: #results.logInfo#",results.logInfo);
			cbMessagebox.error( "Error installing from ForgeBox: #results.logInfo#" );
		} else {
			cbMessagebox.info( "Entry installed from ForgeBox!" );
		}

		// flash results
		flash.put( "forgeboxInstallLog", results.logInfo );
		
		// return to caller
		relocate( URL=rc.returnURL );
	}
}