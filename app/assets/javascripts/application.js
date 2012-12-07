//= require jquery
//= require jquery.selectboxes
//= require jquery.autocomplete
//= require jquery.form
//= require rails
//= require_tree .
//= require_self

function AutoCompleter(id, path, key, callback, linkTextBuilder) {

    //TODO: looks like jquery is setting the scope of 'this', so i had to inline the functions
    $("#" + id).autocomplete(path, {
        formatItem: function(item) {
            var link = item[key].link;
            var title;
            if (linkTextBuilder == undefined)
                title = item[key].title;
            else
                title = linkTextBuilder(item);
            return "<a href=\"" + link + "\">" + title + "</a>";

        },
        dataType: "json",
        parse: function(data) {
            return $.map(data[key + 's'], function(item) {
                return {
                    data: item,
                    value: item.title,
                    result: ""
                };
            });
        },
        cacheLength: 0,
        indicator: 'foo.jpg',
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
    var key = 'release';
    this.init = function(ebayItem, authenticityToken) {
        this.ebayItemId = ebayItem;
        this.authenticityToken = authenticityToken;
    };

    this.categorize = function(id) {
        $.post("/ebay_items/" + EbayItem.ebayItemId, {"_method": "put", "ebay_item[release_id]": id, "authenticity_token": EbayItem.authenticityToken},
                function() {
                    window.location.reload();
                });
    };

    this.linkTextBuilder = function(item) {
        var anchorText = [];
        this.pushIfNotEmpty(anchorText, item[key].artist);
        this.pushIfNotEmpty(anchorText, item[key].title);
        if (item[key]['label_entity'])
            this.pushIfNotEmpty(anchorText, item[key]['label_entity'].name);
        this.pushIfNotEmpty(anchorText, item[key].matrix_number);
        return anchorText.join(" - ")
    };

    this.pushIfNotEmpty = function(anchorText, value) {
        if ("" != value)
            anchorText.push(value);
    };

    return {init: this.init,
        categorize: this.categorize,
        linkTextBuilder :this.linkTextBuilder}
}();

$(document).ready(function() {
    $('#time-form').change(function() {
        this.submit();
    });
});
