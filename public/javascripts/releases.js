$(document).ready(function() {
    $('.edit_ebay_item').ajaxForm(function(data) {
        $('#ebay_item_' + this.url.split("/")[2]).remove();
    });
});

$(document).ready(function() {
    var labelSelector = $("#label_selector");
    labelSelector.addOption({"js_new_label":'Enter a new label...'}, false);
    labelSelector.change(function() {
        if ("js_new_label" == $(this).val()) {
            var newOption = prompt("Please enter a new label name:", "");
            $("#label_selector").addOption(newOption, newOption);
            labelSelector.select(newOption);
        }
    });
});