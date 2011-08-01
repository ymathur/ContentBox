/**
* RSS Service for this application
*/
component singleton{

	// Dependecnies
	property name="settingService"		inject="id:settingService@bb";
	property name="entryService"		inject="id:entryService@bb";
	property name="commentService"		inject="id:commentService@bb";
	property name="feedGenerator" 		inject="coldbox:plugin:feedGenerator";
	property name="bbHelper"			inject="coldbox:myplugin:BBHelper@blogbox-ui";
	property name="log"					inject="logbox:logger:{this}";
	

	function init(){
		return this;
	}
	
	/**
	* Build RSS feeds for BlogBox, with added caching.
	*/
	function getRSS(boolean comments=false,category="",entrySlug=""){
		var rssFeed  = "";
		var cacheKey = "bb-feeds-";
		
		// Building comment feed or entry feed
		switch(arguments.comments){
			case true : { rssfeed = buildCommentFeed(argumentCollection=arguments); break;}
			default   : { rssfeed = buildEntryFeed(argumentCollection=arguments); break; }
		}
		
		return rssFeed;		
	}
	
	/**
	* Build entries feeds
	* @category The category to filter on if needed
	*/	
	function buildEntryFeed(category=""){
		var settings		= settingService.getAllSettings(asStruct=true);
		var entryResults 	= entryService.findPublishedEntries(category=arguments.category,max=settings.bb_paging_maxRSSEntries);
		var myArray 		= [];
		var feedStruct 		= {};
		var columnMap 		= {};
		var qEntries		= entityToQuery( entryResults.entries );
		
		// Create the column maps
		columnMap.title 		= "title";
		columnMap.description 	= "content";
		columnMap.pubDate 		= "publishedDate";
		columnMap.link 			= "link";
		columnMap.author		= "author";
		columnMap.category_tag	= "categories";
		
		// Add necessary columns to query
		QueryAddColumn(qEntries, "link", myArray);
		QueryAddColumn(qEntries, "linkComments", myArray);
		QueryAddColumn(qEntries, "author", myArray);
		QueryAddColumn(qEntries, "categories", myArray);
		
		// Attach permalinks
		for(var i = 1; i lte entryResults.count; i++){
			// build URL to entry
			qEntries.link[i] 			= bbHelper.linkEntryWithSlug( qEntries.slug );
			qEntries.author[i]			= "#entryResults.entries[i].getAuthor().getEmail()# (#entryResults.entries[i].getAuthorName()#)";
			qEntries.linkComments[i]	= bbHelper.linkComments( entryResults.entries[i] );
			qEntries.categories[i]		= entryResults.entries[i].getCategoriesList();
		}
		
		// Generate feed items
		feedStruct.title 		= bbHelper.siteName() & " RSS Feed by BlogBox";
		feedStruct.generator	= "BlogBox by ColdBox Platform";
		feedStruct.copyright	= "Ortus Solutions, Corp (www.ortussolutions.com)";
		feedStruct.description	= bbHelper.siteDescription();
		feedStruct.webmaster	= settings.bb_site_email;
		feedStruct.pubDate 		= now();
		feedStruct.lastbuilddate = now();
		feedStruct.link 		= bbHelper.linkHome();
		feedStruct.items 		= qEntries;
		
		return feedGenerator.createFeed(feedStruct,columnMap);
	}

	/**
	* Build comment feeds
	* @entrySlug The category to filter on if needed
	*/	
	function buildCommentFeed(entrySlug=""){
		var settings		= settingService.getAllSettings(asStruct=true);
		var commentResults 	= commentService.findApprovedComments(entryID=entryService.getIDBySlug(arguments.entrySlug),max=settings.bb_paging_maxRSSEntries);
		var myArray 		= [];
		var feedStruct 		= {};
		var columnMap 		= {};
		var qComments		= entityToQuery( commentResults.comments );
		
		// Create the column maps
		columnMap.title 		= "title";
		columnMap.description 	= "content";
		columnMap.pubDate 		= "createddate";
		columnMap.link 			= "link";
		columnMap.author		= "rssAuthor";
		columnMap.category_tag	= "categories";
		
		// Add necessary columns to query
		QueryAddColumn(qComments, "title", myArray);
		QueryAddColumn(qComments, "linkComments", myArray);
		QueryAddColumn(qComments, "rssAuthor", myArray);
		
		// Attach permalinks
		for(var i = 1; i lte commentResults.count; i++){
			// build URL to entry
			qComments.title[i] 			= "Comment (approved:#yesNoFormat(qComments.isApproved)#) by #qComments.author[i]# on #commentResults.comments[i].getEntry().getSlug()#";
			qComments.rssAuthor[i]		= "#qComments.authorEmail# (#qComments.author#)";
			qComments.linkComments[i]	= bbHelper.linkComment( commentResults.comments[i] );
		}
		
		// Generate feed items
		feedStruct.title 		= bbHelper.siteName() & " Comments RSS Feed by BlogBox";
		feedStruct.generator	= "BlogBox by ColdBox Platform";
		feedStruct.copyright	= "Ortus Solutions, Corp (www.ortussolutions.com)";
		feedStruct.description	= bbHelper.siteDescription();
		feedStruct.webmaster	= settings.bb_site_email;
		feedStruct.pubDate 		= now();
		feedStruct.lastbuilddate = now();
		feedStruct.link 		= bbHelper.linkHome();
		feedStruct.items 		= qComments;
		
		return feedGenerator.createFeed(feedStruct,columnMap);
	}

}