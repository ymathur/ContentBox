<cfoutput>
<div id="cb-admin-bar">
	
	<span id="cb-admin-bar-actions">
		
		<cfif !isNull( args.oContent )>
			
			<cfif args.oContent.getContentType() == "Page">
			<span class="admin-bar-label">
				Layout: #args.oContent.getLayout()#
			</span>
			</cfif>

			<cfif args.oContent.getAllowComments()>
			<span class="admin-bar-label">
				Comments: #args.oContent.getNumberOfComments()#
			</span>
			</cfif>

			<span class="admin-bar-label">
				Hits: #args.oContent.getNumberOfHits()#
			</span>

			<cfif !args.oContent.getIsPublished()>
			<span class="admin-bar-label-red">
				Draft
			</span>
			</cfif>

			<cfif args.oContent.isPublishedInFuture()>
			<span class="admin-bar-label-red">
				Publishes on: #args.oContent.getDisplayPublishedDate()#
			</span>
			</cfif>

			<a href="#args.linkEdit#" class="button" target="_blank">
				&nbsp; Edit &nbsp;
			</a>

			<a href="#args.linkEdit###custom_fields" class="button" target="_blank">
				Custom Fields
			</a>

			<a href="#args.linkEdit###seo" class="button" target="_blank">
				SEO
			</a>

			<a href="#args.linkEdit###history" class="button" target="_blank">
				History
			</a>
		</cfif>

		<a href="#cb.linkAdmin()#" class="button" target="_blank">
			Admin
		</a>

	</span>

	<h4>
		#getModel( "Avatar@cb" )
		.renderAvatar( email=prc.oCurrentAuthor.getEmail(), size="30" )#
		ContentBox Admin Bar
	</h4>

	<cfif !isNull( args.oContent )>
	<p>
		By #args.oContent.getAuthorName()# on 
				#args.oContent.getActiveContent().getDisplayCreatedDate()#
	</p>
	</cfif>
	
</div>

<script>
setTimeout( insertAdminBar, 500 );
function insertAdminBar(){
	document.body.insertBefore( \
		document.getElementById( 'cb-admin-bar' ),
		document.body.firstChild 
	);
}
</script>

<style>
##cb-admin-bar{
	padding: 5px; 
	width:100%;
	height: 55px;
	top: 0; 
	left:0; 
	background: black; 
	color: white;
	text-align: center;
}
##cb-admin-bar-actions{
	float: right;
	margin-top: 10px;
	font-size: 12px;
}
##cb-admin-bar h4{
	float: left;
}
##cb-admin-bar p{
	font-size: 12px;
	margin-top: 18px;
}
##cb-admin-bar .admin-bar-label-red{
	background-color: red;
	padding: 3px;
	margin-right: 5px;
	border: 2px solid;
    border-radius: 20px;
}
##cb-admin-bar .admin-bar-label{
	background-color: ##3598db;
	padding: 3px;
	margin-right: 5px;
	border: 2px solid;
    border-radius: 20px;
}
##cb-admin-bar a.button {
    background-color: ##4CAF50;
    color: white;
    padding: 5px;
    margin: 0px 1px;
    font-size: 12px;
    border: none;
    cursor: pointer;
    border-radius: 20px;
}
##cb-admin-bar a.button:hover, ##cb-admin-bar a.button:focus {
    background-color: ##3e8e41;
    text-decoration: none;
}
</style>
</cfoutput>