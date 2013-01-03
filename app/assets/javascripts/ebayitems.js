$(document).ready(function () {
    var options = {
        url:"/releases.json",
        dataType:"json",
        success:function (responseText, statusText, xhr, elm) {
            window.location.reload();
        },
        error:function (responseText, statusText, xhr, elm) {
            console.log(responseText);
            $('.new_release_errors', elm).html('<p>The Release Already Exists</p>');
        }
    };

    //TODO: refactor to initialize with marionette.backbone

    $('.new_release').ajaxForm(options);

    $('.show-mapping-controls a.map').click(function (event) {
        $('#map-auction').toggleClass('hidden');
        event.preventDefault();
    });

    $('.show-mapping-controls a .help').click(function (event) {
        $('#help-steps').toggleClass('hidden');
        event.preventDefault();
    });

    $('ul.ebay-items li, .top-items .top-item').click(function (event) {
        if (!$(event.target).attr('href') && !$(event.target).attr('name') && !$(event.target).is('input')) {
            event.preventDefault();
            event.stopPropagation();
            window.location = $(event.target).closest('.record-item').data('link');
        }
    });

    $('.comment').click(function(event) {
        event.preventDefault();
        event.stopPropagation();
        $(event.target).closest('.record-item').find('.item-comments').first().toggle('fast');
    });

    //TODO: make this work
//    $('.search-header input[type=text]').focus();

});