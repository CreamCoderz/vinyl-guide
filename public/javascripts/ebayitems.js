$(document).ready(function() {
    var options = {
        url: "/releases.json",
        dataType: "json",
        success: function(responseText, statusText, xhr, elm) {
           window.location.reload();
        },
        error: function(responseText, statusText, xhr, elm) {
            console.log(responseText);
            $('.new_release_errors', elm).html('<p>The Release Already Exists</p>');
        }
    };
    $('.new_release').ajaxForm(options);

    //TODO: this will display all the forms on a page
    $('.show-mapping-controls a').click(function(event) {
        $('.map-auction').show();
        event.preventDefault();
    });
});