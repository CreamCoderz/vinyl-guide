function setClass(elm, className) {
    elm.setAttribute("class", className);
}

function AutoCompleter(id, path) {

    //TODO: looks like query setting the scope for 'this', so i had to inline the functions
    $("#" + id).autocomplete(path, {
        formatItem: function(item) {
            return "<a href=\"" + item.release.link + "\">" + item.release.title + "</a>";
        },
        dataType: "json",
        parse: function(data) {
            return $.map(data, function(item) {
                return {
                    data: item,
                    value: item.title,
                    result: ""
                };
            });
        },
        cacheLength: 0,
        max: 20}).result(function (event, item) {
        location.href = "/" + item.id;
    });

}

