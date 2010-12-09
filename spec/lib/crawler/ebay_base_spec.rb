require 'time'
require 'cgi'
require File.dirname(__FILE__) + "/../../../app/domain/ebayitemdata"
require File.dirname(__FILE__) + "/../../../app/domain/ebayitemdatabuilder"
require File.dirname(__FILE__) + "/../../../lib/dateutil"
require File.dirname(__FILE__) + "/ebay_base_data"
include EbayBaseData

module EbayBaseSpec

  # ---------------- FINDING -------------------------
  def self.generate_find_items_request(end_time_from, page_number, global_id='EBAY-US', sub_genre='Reggae%20%26%20Ska', app_id=NIL_API_KEY)
    "/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=#{app_id}&GLOBAL-ID=#{global_id}&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&categoryId=306&aspectFilter%280%29.aspectName=Genre&aspectFilter%280%29.aspectValueName=#{sub_genre}&itemFilter.name=EndTimeTo&itemFilter.value=#{DateUtil.date_to_utc(end_time_from)}&paginationInput.pageNumber=#{page_number}"
  end

  def self.generate_auction_item(auction_item)
    "<item>
            <itemId>#{auction_item[0]}</itemId>
            <title>BOB MARLEY &amp; THE WAILERS EXODUS 180 GRAM VINYL LP NEW</title>
            <globalId>EBAY-US</globalId>
            <primaryCategory>
                <categoryId>306</categoryId>
                <categoryName>Records</categoryName>
            </primaryCategory>
            <galleryURL>http://thumbs2.ebaystatic.com/pict/2505001942428080_1.jpg</galleryURL>
            <viewItemURL>
                http://cgi.ebay.com/BOB-MARLEY-THE-WAILERS-EXODUS-180-GRAM-VINYL-LP-NEW_W0QQitemZ250500194242QQcmdZViewItemQQptZMusic_on_Vinyl?hash=item3a52f99fc2
            </viewItemURL>
            <paymentMethod>PayPal</paymentMethod>
            <autoPay>false</autoPay>
            <postalCode>10707</postalCode>
            <location>Tuckahoe,NY,USA</location>
            <country>US</country>
            <shippingInfo>
                <shippingServiceCost currencyId=\"USD\">4.0</shippingServiceCost>
                <shippingType>Flat</shippingType>
                <shipToLocations>Worldwide</shipToLocations>
            </shippingInfo>
            <sellingStatus>
                <currentPrice currencyId=\"USD\">19.99</currentPrice>
                <convertedCurrentPrice currencyId=\"USD\">19.99</convertedCurrentPrice>
                <sellingState>Active</sellingState>
                <timeLeft>P27DT18H56M6S</timeLeft>
            </sellingStatus>
            <listingInfo>
                <bestOfferEnabled>false</bestOfferEnabled>
                <buyItNowAvailable>false</buyItNowAvailable>
                <startTime>2009-09-17T14:25:32.000Z</startTime>
                <endTime>#{DateUtil.date_to_utc(auction_item[1])}</endTime>
                <listingType>FixedPrice</listingType>
                <gift>false</gift>
            </listingInfo>
        </item>"
  end

  def self.generate_auctions_response_footer(current_page, total_pages)
    "</searchResult>
    <paginationOutput>
        <totalPages>#{total_pages}</totalPages>
        <totalEntries>763</totalEntries>
        <pageNumber>#{current_page}</pageNumber>
        <entriesPerPage>100</entriesPerPage>
    </paginationOutput>
    </findItemsAdvancedResponse>"
  end

  def self.generate_find_items_response(current_page, end_page)
    generate_complete_find_items_response(current_page, end_page,
            "#{generate_auction_item(FOUND_ITEM_1)}\n
            #{generate_auction_item(FOUND_ITEM_2)}\n
            #{generate_auction_item(FOUND_ITEM_3)}\n
            #{generate_auction_item(FOUND_ITEM_4)}\n
            #{generate_auction_item(FOUND_ITEM_5)}")
  end

  def self.generate_find_items_response_uk(current_page, end_page)
    generate_complete_find_items_response(current_page, end_page,
            "#{generate_auction_item(FOUND_ITEM_6)}\n
            #{generate_auction_item(FOUND_ITEM_7)}")
  end

  def self.generate_complete_find_items_response(current_page, end_page, body="")
    "#{AUCTIONS_RESPONSE_HEAD}\n
    #{body}\n
    #{generate_auctions_response_footer(current_page, end_page)}"
  end

  SAMPLE_FIND_ITEMS_RESPONSE = generate_find_items_response(1, 1)

  SINGLE_FIND_ITEMS_RESPONSE = AUCTIONS_RESPONSE_HEAD +
          generate_auction_item(FOUND_ITEM_1) +
          generate_auctions_response_footer(1, 1)

  # ---------------- DETAILS --------------------------

  def self.generate_multiple_items_request(item_ids, api_key=NIL_API_KEY)
    item_ids_converted = item_ids.join(",")
    "/shopping?version=517&appid=#{api_key}&callname=#{MULTIPLE_ITEMS_CALL}&IncludeSelector=#{MULTIPLE_ITEMS_SELECTORS}&ItemID=#{item_ids_converted}"
  end

  SAMPLE_GET_MULTIPLE_ITEMS_REQUEST = generate_multiple_items_request([TETRACK_ITEMID.to_s, GARNET_ITEMID.to_s])

  def self.generate_detail_item_xml_response(ebay_item_data)
    generate_all_detail_item_xml_response(ebay_item_data,
            "<ItemSpecifics>
     <NameValueList>
      <Name>Return policy details</Name>
      <Value>ANY ITEM MUST BE RETURNED WITHIN SEVEN WORKING DAYS UK.FOURTEEN DAYS;REST OF THE WORLD.PLEASE EMAIL ME THROUGH CONTACT SELLER TO CONFIRM.UPON RECEIPT YOU WILL BE FULLY REFUNDED AS STATED IN MY WRITE-UP.PLEASE READ. NOT BEFORE ITEM IS RETURNED.THIS GIVES YOU PLENTY OF TIME TO DECIDE WHETHER YOU ARE HAPPY OR NOT.I&apos;M SURE YOU WILL BE.AS I POST AS QUICKLY AS POSSIBLE,IT&apos;S ONLY FAIR FOR RETURN TO BE THE SAME.FAILER TO MEET THESE REQUIREMENTS.REFUND IS NULL AND VOID.IF NOT HAPPY WITH THIS.PLEASE DO NOT BID.</Value>
     </NameValueList>
     <NameValueList>
      <Name>Returns Accepted</Name>
      <Value>Returns Accepted</Value>
     </NameValueList>
     <NameValueList>
      <Name>Condition</Name>
      <Value>#{ebay_item_data.condition}</Value>
     </NameValueList>
     <NameValueList>
      <Name>Genre</Name>
      <Value>Reggae/Ska</Value>
     </NameValueList>
     <NameValueList>
      <Name>Record Size</Name>
      <Value>#{ebay_item_data.size}</Value>
     </NameValueList>
     <NameValueList>
      <Name>Speed</Name>
      <Value>#{ebay_item_data.speed}</Value>
     </NameValueList>
     <NameValueList>
      <Name>Sub-Genre</Name>
      <Value>#{ebay_item_data.subgenre}</Value>
     </NameValueList>
     <NameValueList>
      <Name>Compilation</Name>
      <Value></Value>
     </NameValueList>
    </ItemSpecifics>")
  end

  def self.generate_all_detail_item_xml_response(ebay_item_data, item_specifics='')
    gallery_node = ""
    picture_node = ""
    if ebay_item_data.galleryimg
      gallery_node = "<GalleryURL>#{ebay_item_data.galleryimg}</GalleryURL>"
    end
    if ebay_item_data.pictureimgs
      picture_node = ebay_item_data.pictureimgs.map{|picture_img| "<PictureURL>#{picture_img}</PictureURL>"}.join
    end
    "<Item>
    <BestOfferEnabled>false</BestOfferEnabled>
    #{
            if ebay_item_data.description
              "<Description>#{CGI.escapeHTML(ebay_item_data.description)}</Description>"
            end
    }
    <ItemID>#{ebay_item_data.itemid.to_s}</ItemID>
    <EndTime>#{DateUtil.date_to_utc(ebay_item_data.endtime)}</EndTime>
    <StartTime>#{DateUtil.date_to_utc(ebay_item_data.starttime)}</StartTime>
    <ViewItemURLForNaturalSearch>#{ebay_item_data.url}</ViewItemURLForNaturalSearch>
    <ListingType>Chinese</ListingType>
    <Location>Malmoe, -</Location>
    <PaymentMethods>PayPal</PaymentMethods>
    #{gallery_node}
    #{picture_node}
    <PrimaryCategoryID>306</PrimaryCategoryID>
    <PrimaryCategoryName>Music:Records</PrimaryCategoryName>
    <Quantity>1</Quantity>
    <Seller>
      <UserID>#{ebay_item_data.sellerid}</UserID>
      <FeedbackRatingStar>Red</FeedbackRatingStar>
      <FeedbackScore>3666</FeedbackScore>
      <PositiveFeedbackPercent>100.0</PositiveFeedbackPercent>
    </Seller>
    <BidCount>#{ebay_item_data.bidcount.to_s}</BidCount>
    <ConvertedCurrentPrice currencyID=\"#{ebay_item_data.currencytype}\">#{ebay_item_data.price.to_s}</ConvertedCurrentPrice>
    <CurrentPrice currencyID=\"#{ebay_item_data.currencytype}\">#{ebay_item_data.price.to_s}</CurrentPrice>
    <HighBidder>                
      <UserID>a***l</UserID>
      <FeedbackPrivate>false</FeedbackPrivate>
      <FeedbackRatingStar>Purple</FeedbackRatingStar>
      <FeedbackScore>509</FeedbackScore>
    </HighBidder>
    <ListingStatus>Completed</ListingStatus>
    <QuantitySold>1</QuantitySold>
    <ReserveMet>true</ReserveMet>
    <ShipToLocations>Worldwide</ShipToLocations>
    <Site>US</Site>
    <TimeLeft>PT0S</TimeLeft>
    <Title>#{ebay_item_data.title}</Title>
    <HitCount>193</HitCount>
    #{item_specifics}
    <Subtitle>SEE MY OTHER AUCTIONS for more M- roots &amp; dub 12\"s/7\"s!</Subtitle>
    <PrimaryCategoryIDPath>11233:306</PrimaryCategoryIDPath>
    <Storefront>
      <StoreURL>http://stores.ebay.com/id=0</StoreURL>
      <StoreName>
      </StoreName>
    </Storefront>
    <Country>#{ebay_item_data.country}</Country>
    <ReturnPolicy>
      <Refund>Money Back</Refund>
      <ReturnsWithin>14 Days</ReturnsWithin>
      <ReturnsAccepted>Returns Accepted</ReturnsAccepted>
      <ShippingCostPaidBy>Buyer</ShippingCostPaidBy>
    </ReturnPolicy>
    <MinimumToBid currencyID=\"USD\">410.0</MinimumToBid>
    <AutoPay>false</AutoPay>
    <PaymentAllowedSite>UK</PaymentAllowedSite>
    <PaymentAllowedSite>CanadaFrench</PaymentAllowedSite>
    <PaymentAllowedSite>Sweden</PaymentAllowedSite>
    <PaymentAllowedSite>Canada</PaymentAllowedSite>
    <PaymentAllowedSite>US</PaymentAllowedSite>
    <IntegratedMerchantCreditCardEnabled>false</IntegratedMerchantCreditCardEnabled>
    <HandlingTime>3</HandlingTime>
  </Item>"
  end

  TETRACK_ITEM_XML = generate_detail_item_xml_response(TETRACK_EBAY_ITEM)
  GARNET_ITEM_XML = generate_detail_item_xml_response(GARNET_EBAY_ITEM)

end