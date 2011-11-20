//
// Common Site Tools
//
jQuery.extend(jQuery, {
    blank : function(string) { return !$.present(string); },
    present : function(string) { return $.trim(string).length>0; },

    // HTML Encode -- trying to keep it similar to rail's h()
    h : function(string) {
        return $(document.createElement('span')).text(string).html();
    },

    preserve_newlines : function(string) {
        return $.h(string).replace(/\n/gi, '<br />');
    },

    // Take what we think is a function, check to make sure it is and call it
    // if we can returning the functions return value or false otherwise
    call_fn : function(fn, args) {
        if ( jQuery.isFunction(fn) ) return fn(args);
    }

});
