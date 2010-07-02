$(document).ready(function() {
    var options = {
        url: "/releases.json",
        dataType: "json",
        success: function() {
            $('#new_release_errors').html('<p>Release Successfully Created</p>');
        },
        error: function(data) {
            $('#new_release_errors').html('<p>The Release Must be Unique</p>');
        }
    };
    $('#new_release').ajaxForm(options);
});