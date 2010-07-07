$(document).ready(function() {
    var options = {
        url: "/releases.json",
        dataType: "json",
        success: function(responseText, statusText, xhr, elm) {
            $('.new_release_errors', elm).html('<p>Release Successfully Created</p>');
        },
        error: function(responseText, statusText, xhr, elm) {
            console.log(responseText);
            $('.new_release_errors', elm).html('<p>The Release Already Exists</p>');
        }
    };
    $('.new_release').ajaxForm(options);
});