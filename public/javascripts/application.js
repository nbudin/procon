// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.fn.extend({
    eventDateShim: function(dateFieldId) {
	return this.bind('change', function(evt) {
	    d = new Date(new Number(this.value) * 1000);
	    $("#" + dateFieldId + '_1i').val(d.getUTCFullYear().toString());
	    $("#" + dateFieldId + '_2i').val((d.getUTCMonth() + 1).toString());
	    $("#" + dateFieldId + '_3i').val(d.getUTCDate().toString());
	});
    }
});