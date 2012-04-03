function Favorite(successData) {
    var data = successData;
    var beforeSubmitText = "";
    var form;

    this.submitFavorite = function (e) {
        e.preventDefault();
        e.stopPropagation();
        form = $(this);
        beforeSubmitText = form.find('input[type=submit]').attr('value');
        form.find('input[type=submit]').attr('value', '*Loading*');
        form.ajaxSubmit(formConfig);
    };

    this.submitSuccess = function (jsonData) {
        form.attr('action', jsonData.favorite[data.uriAction]);
        form.find('input[name=_method]').attr('value', data.httpMethod);
        form.find('input[type=submit]').attr('value', data.submitText);
        form.attr('class', data.submitClass);
    };

    this.submitError = function (jqXHR) {
        console.log(jqXHR.responseText);
        var errorData = $.parseJSON("" + jqXHR.responseText);
        alert(errorData.error);
        form.find('input[type=submit]').attr('value', beforeSubmitText);
        // refresh the page to resolve a bad state
        window.location = window.location
    };

    var formConfig = {
        dataType:'json',
        success:this.submitSuccess,
        error: this.submitError
    };
}

$(function () {
    var editFavorite = new Favorite({uriAction:'create_uri', httpMethod:'create', submitText:'+Favorite', submitClass:'new_favorite'});
    $('.edit_favorite').live('submit', editFavorite.submitFavorite);

    var createFavorite = new Favorite({uriAction:'delete_uri', httpMethod:'delete', submitText:'-Favorite', submitClass:'edit_favorite'});
    $('.new_favorite').live('submit', createFavorite.submitFavorite);
});