//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require thickbox
//= require_self
//= require_tree .

jQuery.fn.extend({
    eventDateShim: function(dateFieldId) {
	return this.bind('change', function(evt) {
	    d = new Date(new Number(this.value) * 1000);
	    $("#" + dateFieldId + '_1i').val(d.getFullYear().toString());
	    $("#" + dateFieldId + '_2i').val((d.getMonth() + 1).toString());
	    $("#" + dateFieldId + '_3i').val(d.getDate().toString());
	});
    }
});