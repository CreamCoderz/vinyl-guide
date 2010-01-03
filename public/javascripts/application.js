function setClass(elm, className) {
    elm.setAttribute("class", className);
}

/* autocompletion */
$(document).ready(function() {
    AutoCompleter.init("q", "/search");
});

var AutoCompleter = function() {

    function init(id, url) {
        $("#" + id).autocomplete(url, {
            formatItem: formatItem,
            dataType: "json",
            parse: parseJson,
            cacheLength: 0,
            max: 20}).result(resultItem);
    }

    function parseJson(data) {
        return $.map(data, function(item) {
            return {
                data: item,
                value: item.title,
                result: ""
            };
        });
    }

    function formatItem(item, item_pos, item_count, query) {
        return "<a href=\"" + item.id + "\">" + item.title + "</a>";
    }

    function resultItem(event, item) {
        location.href = "/" + item.id;
    }

    return {init: init};

}();

