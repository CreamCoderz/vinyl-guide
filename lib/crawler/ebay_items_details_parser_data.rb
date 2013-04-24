module EbayItemsDetailsParserData

  DESCRIPTION = 'Description'
  ITEMID = 'ItemID'
  ENDTIME = 'EndTime'
  STARTTIME = 'StartTime'
  URL = 'ViewItemURLForNaturalSearch'
  IMAGE = 'GalleryURL'
  PICTURE = 'PictureURL'
  BIDCOUNT = 'BidCount'
  PRICE = 'ConvertedCurrentPrice'
  CURRENCY_ID = '@currencyID'
  SELLER = 'Seller'
  USERID = 'UserID'
  GETMULTIPLEITEMSRESPONSE = 'GetMultipleItemsResponse'
  ITEM = 'Item'
  TITLE = 'Title'
  ITEMSPECIFICS = 'ItemSpecifics'
  NAMEVALUELIST = 'NameValueList'
  RECORDSIZE = 'Record Size'
  GENRE = 'Genre'
  SUBGENRE = 'Sub-Genre'
  NAME = 'Name'
  VALUE = 'Value'
  CONDITION = 'Condition'
  SPEED = 'Speed'
  COUNTRY = 'Country'

  NODE_VALUE = '$'

  DEFAULT_STRATEGY = lambda{|node|CGI::unescapeHTML(node[NODE_VALUE]).gsub(/&apos;/, "'")}
  OPTIONAL_NODE_STRATEGY = lambda{|node| node ? CGI::unescapeHTML(node[NODE_VALUE]) : nil}
  INTEGER_STRATEGY = lambda{|node|DEFAULT_STRATEGY.call(node).to_i}
  FLOAT_STRATEGY = lambda{|node|DEFAULT_STRATEGY.call(node).to_f}
  DATE_STRATEGY = lambda{|node|DateUtil.utc_to_date(node[NODE_VALUE])}
  NULL_STRATEGY = lambda{|node|node}

  ITEMSSPECIFICS_STRATEGY = lambda do |item_specifics_node|
    parsed_specifics = {RECORDSIZE => nil, SUBGENRE => nil, CONDITION => nil, SPEED => nil, GENRE => nil}
    if item_specifics_node
      item_specifics = item_specifics_node[NAMEVALUELIST]
      item_specifics = ArrayUtil.arrayifiy(item_specifics)
      item_specifics.each do |item_specific|
        if parsed_specifics.key? item_specific[NAME][NODE_VALUE]
          parsed_specifics[item_specific[NAME][NODE_VALUE]] = item_specific[VALUE][NODE_VALUE]
        end
      end
    end
    parsed_specifics
  end

  PICTURE_STRATEGY = lambda do |picture_nodes|
    pictures = nil
    if picture_nodes
      picture_nodes = ArrayUtil.arrayifiy(picture_nodes)
      pictures = picture_nodes.map do |picture_node|
        picture_node[NODE_VALUE]
      end
    end
    pictures
  end

  VALUE_EXTRACTOR = {PICTURE => PICTURE_STRATEGY, ITEMSPECIFICS => ITEMSSPECIFICS_STRATEGY, ITEMID => INTEGER_STRATEGY,
          ENDTIME => DATE_STRATEGY, STARTTIME => DATE_STRATEGY, BIDCOUNT => INTEGER_STRATEGY, PRICE => FLOAT_STRATEGY,
          CURRENCY_ID => NULL_STRATEGY, IMAGE => OPTIONAL_NODE_STRATEGY, DESCRIPTION => OPTIONAL_NODE_STRATEGY}
  VALUE_EXTRACTOR.default = DEFAULT_STRATEGY

end