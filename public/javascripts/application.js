function setClass(elm, className) {
    elm.setAttribute("class", className);
}

function AutoCompleter(id, path, key, callback) {

    //TODO: looks like jquery is setting the scope of 'this', so i had to inline the functions
    $("#" + id).autocomplete(path, {
        formatItem: function(item) {
            var link = item[key].link;
            var title = item[key].title;
            return "<a href=\"" + link + "\">" + title + "</a>";

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
        if (callback == undefined)
            location.href = item[key].link;
        else
            callback(item[key].id);
    });

}

var Release = function() {

    var releaseId;
    var authenticityToken;

    this.categorize = function(id) {
        $.post("/ebay_items/" + id, {"_method": "put", "ebay_item[release_id]": Release.releaseId, "authenticity_token": Release.authenticityToken},
                function(data) {
                    $(".ebay-items").prepend(data);
                });
    };

    this.init = function(releaseId, authenticityToken) {
        this.releaseId = releaseId;
        this.authenticityToken = authenticityToken;
    };

    return {init: this.init,
        categorize: this.categorize}
}();

var EbayItem = function() {
    this.init = function(ebayItem, authenticityToken) {
        this.ebayItemId = ebayItem;
        this.authenticityToken = authenticityToken;
    };

    this.categorize = function(id) {
        $.post("/ebay_items/" + EbayItem.ebayItemId, {"_method": "put", "ebay_item[release_id]": id, "authenticity_token": EbayItem.authenticityToken},
                function() {
                    window.location = "/releases/" + id;
                });
    };
    return {init: this.init,
        categorize: this.categorize}
}();
