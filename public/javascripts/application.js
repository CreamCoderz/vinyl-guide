function setClass(elm, className) {
    elm.setAttribute("class", className);
}

/* autocompletion */
$(document).ready(function() {
    AutoCompleter.init("query", "/search_api");
});

var AutoCompleter = function() {

    function init(id, url) {
        $("#" + id).autocomplete(url, {formatItem: formatItem, cacheLength: 0, max: 20});
        $("#" + id).result(resultItem);
    }

    function formatItem(item, item_pos, item_count, query) {
        return "<a href=\"" + item[1] + "\">" + item[0] + "</a>";
    }

    function resultItem(event, item) {
        location.href = "/" + item[1];
    }

    return {init: init};

}();

