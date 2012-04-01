$(function () {
    $('.edit_favorite').live('submit', function (e) {
        e.preventDefault();
        e.stopPropagation();
        var form = $(this);
        form.append("<input type='hidden' name='format' value='json'/>");
        form.find('input[type=submit]').attr('value', '*Loading*');
        form.ajaxSubmit(function (data) {
            form.attr('action', data.favorite.create_uri);
            form.find('input[name=_method]').attr('value', 'create');
            form.find('input[type=submit]').attr('value', '+Favorite');
            form.attr('class', 'new_favorite');
        });
    });

    $('.new_favorite').live('submit', function (e) {
        e.preventDefault();
        e.stopPropagation();
        var form = $(this);
        form.append("<input type='hidden' name='format' value='json'/>");
        form.find('input[type=submit]').attr('value', '*Loading*');
        form.ajaxSubmit(function (data) {
            form.attr('action', data.favorite.delete_uri);
            form.find('input[name=_method]').attr('value', 'delete');
            form.find('input[type=submit]').attr('value', '-Favorite');
            form.attr('class', 'edit_favorite');
        });
    })

});