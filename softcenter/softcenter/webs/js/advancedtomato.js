// We use this for loadPage

function AdvancedTomato() {
    /* First handle page loading, hash change events and other most important tasks
     ************************************************************************************************/
    // Initial Page load, determine what to load
    if ( window.location.hash.match( /#/ ) ) { loadPage( window.location.hash ); } else { loadPage( '#/soft-center.asp' ); }
	
    // Bind "Hash Change" - Happens when hash in the "URL" changes (http://site.com/#hash-bind)
    $( window ).bind( 'hashchange', function() {
        // Prevent Mismatch on features page
        //( (location.hash.replace( '#', '#/' ) != '' ) ? loadPage( location.hash.replace( '#', '#/' ), true ) : '' );
        loadPage( location.hash, true )
   		//console.log("1212", location.hash.replace( '#', '#/' ))
        return false;

    } );
    // Handle Ajax Class Loading
    $( '.ajaxwrap' ).on( 'click', '.ajaxload', function( e ) {

        loadPage( $( this ).attr( 'href' ) );
        return false;

    } );
}

var ajax_retries = 1;
function loadPage( page, is_history ) {
	page = page.replace( '#', '/' );
	if (page.search('//') != -1){
		page = page.replace( '//', '/' );
	}	
	// console.log("page", page)
    // console.log("hash1", window.location.hash)
    if ( page == '//soft-center.asp' || page == '/' || page == null ) { page = '/soft-center.asp'; }
    // Some things that need to be done here =)
    if ( window.ajaxLoadingState ) { return false; } else { window.ajaxLoadingState = true; }

    // Since we use ajax, functions and timers stay in memory/cache. Here we undefine & stop them to prevent issues with other pages.
    if ( typeof( ref ) != 'undefined' ) {
        ref.destroy();
        ref = undefined;
        delete ref;
    }
    if ( typeof( wdog ) != 'undefined' ) { clearTimeout( wdog ); } // Delayed function that kills our refreshers!

    // Remove animation class from container, so we reset its anim count to 0
    $( '.container .ajaxwrap' ).removeClass( 'ajax-animation' );


    // Switch to JQUERY AJAX function call (doesn't capture errors allowing much easier debugging)
    $.ajax( { url: page, async: true, cache: false, timeout: 4000 } )
        .done( function( resp ) {

            var dom   = $( resp );
            var title = dom.filter( 'title' ).text();
            var html  = dom.filter( 'content' ).html();

            // Handle pages without title or content as normal (HTTP Redirect)
            if ( title == null || html == null ) {

                window.parent.location.href = page;
                return false;

            }

            // Set page title, current page title and animate page switch
            $( 'title' ).text( "LEDE " + title );
            $( 'h2.currentpage' ).text( title );
            $( '.container .ajaxwrap' ).html( html ).addClass( 'ajax-animation' );

            // Push History (First check if using IE9 or not)
            if ( history.pushState && is_history !== true ) {

                // IE9+ function that's awesome for AJAX stuff
                history.pushState(
                    {
                        "html"     : html,
                        "pageTitle": "LEDE " + title
                    },
                    "LEDE " + title, '#' + page
                );

            }

            // Go back to top
            $( '.container' ).scrollTop( 0 );
            
            // Reset loading state to false.
            window.ajaxLoadingState = false;
            if ( ajax_retries != 1 ) $( '.body-overwrite' ).remove();
            ajax_retries = 1;
   	    // console.log("hash2", window.location.hash)

        } )
        .fail( function( jqXHR, textStatus, errorThrown ) {

            console.log( jqXHR, errorThrown );

            // We retry few x before showing msg bellow (TBD)
            if ( ajax_retries <= 8 ) {

                // Write only if div doesn't already exist
                if ( $( 'body .body-overwrite' ).length == 0 ) {

                    $( 'body' ).append( '<div class="body-overwrite"><div class="body-overwrite-text text-center"><div class="spinner spinner-large"></div>' +
                                        '<br><br><b>连接丢失!</b><br>正在尝试重新连接...</div></div>' );

                }

                // Try again in 2500ms, when retries reach 3, show error instead
                setTimeout( function() {

                    // Count retries
                    ajax_retries++;

                    // Try again
                    window.ajaxLoadingState = false;
                    loadPage( page, is_history );

                }, 3000 );

                // Don't continue
                return;

            }

            // In case error is 0 it usually means 504, gateway timeout
            if ( jqXHR.status == 0 ) jqXHR.status = 504;

            $( 'h2.currentpage' ).text( jqXHR.status + ' 错误' );
            $( '.container .ajaxwrap' ).html( '<div class="box"><div class="heading">错误 - ' + jqXHR.status + '</div><div class="content">\
				<p>UI 无法与路由器通信!<br>这些问题通常发生在文件丢失,Web处理程序正忙或连接到路由器不可用时.</p>\
				<a href="/">刷新</a> 浏览器窗口可能会有帮助.</div></div>' ).addClass( 'ajax-animation' );

            // Loaded, clear state
            window.ajaxLoadingState = false;
            if ( ajax_retries != 1 ) $( '.body-overwrite' ).remove();

            // Remove Preloader
            $( '#nprogress' ).find( '.bar' ).css( { 'animation': 'none' } ).width( '100%' );
            setTimeout( function() { $( '#nprogress .bar' ).remove(); }, 250 );

        } );

}
