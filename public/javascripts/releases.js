$(document).ready(function() {
    $('.edit_ebay_item').ajaxForm(function(data) {
        $('#ebay_item_' + this.url.split("/")[2]).remove();
    });
});