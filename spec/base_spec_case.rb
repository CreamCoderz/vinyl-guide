require 'ActiveSupport'
require 'time'

module BaseSpecCase

  SAMPLE_FIND_ITEMS_REQUEST = 'http://open.api.ebay.com/shopping?version=517&appid=WillSulz-7420-475d-9a40-2fb8b491a6fd&callname=FindItemsAdvanced&CategoryID=306&DescriptionSearch=true&EndTimeFrom=2009-07-09T01:00:00.000Z&EndTimeTo=2009-07-10T01:00:00.000Z&MaxEntries=100&PageNumber=1&QueryKeywords=reggae'

  item_1_endtime_utc = '2009-07-03T23:42:25.000Z'
  item_2_endtime_utc = '2009-07-03T23:46:05.000Z'
  item_3_endtime_utc = '2009-07-03T23:48:32.000Z'
  item_4_endtime_utc = '2009-07-03T23:48:32.000Z'
  item_5_endtime_utc = '2009-07-03T23:49:57.000Z'
  
  FOUND_ITEM_1 = [120440899019, Time.iso8601(item_1_endtime_utc).to_date]
  FOUND_ITEM_2 = [260436558510, Time.iso8601(item_2_endtime_utc).to_date]
  FOUND_ITEM_3 = [300325824658, Time.iso8601(item_3_endtime_utc).to_date]
  FOUND_ITEM_4 = [300325824769, Time.iso8601(item_4_endtime_utc).to_date]
  FOUND_ITEM_5 = [300325824946, Time.iso8601(item_5_endtime_utc).to_date]

  FOUND_ITEMS = [FOUND_ITEM_1, FOUND_ITEM_2]

  SAMPLE_FIND_ITEMS_RESPONSE = '<?xml version="1.0" encoding="UTF-8"?>
<FindItemsAdvancedResponse xmlns="urn:ebay:apis:eBLBaseComponents">
  <Timestamp>2009-07-03T23:42:05.299Z</Timestamp>
  <Ack>Success</Ack>
  <Build>e623__Bundled_9520957_R1</Build>
  <Version>623</Version>
  <CorrelationID>the message</CorrelationID>
  <SearchResult>
    <ItemArray>
      <Item>
        <ItemID>' + FOUND_ITEM_1[0].to_s + '</ItemID>
        <EndTime>' + item_1_endtime_utc + '</EndTime>
        <ViewItemURLForNaturalSearch>' + 'http://cgi.ebay.com/THIRD-WORLD-TALK-TO-ME-12-79-reggae-disco-HEAR_W0QQitemZ120440899019QQcategoryZ306QQcmdZViewItem' + '</ViewItemURLForNaturalSearch>
        <ListingType>Chinese</ListingType>
        <GalleryURL>' + 'http://thumbs3.ebaystatic.com/pict/1204408990198080_1.jpg' + '</GalleryURL>
        <PrimaryCategoryID>306</PrimaryCategoryID>
        <PrimaryCategoryName>Music:Records</PrimaryCategoryName>
        <BidCount>' + '2' + '</BidCount>
        <ConvertedCurrentPrice currencyID="USD">14.48</ConvertedCurrentPrice>
        <ListingStatus>Active</ListingStatus>
        <TimeLeft>PT20S</TimeLeft>
        <Title>THIRD WORLD - TALK TO ME 12"! \'79 reggae disco HEAR</Title>
        <ShippingCostSummary>
          <ShippingServiceCost currencyID="USD">3.99</ShippingServiceCost>
          <ShippingType>Flat</ShippingType>
        </ShippingCostSummary>
      </Item>
      <Item>
        <ItemID>' + FOUND_ITEM_2[0].to_s + '</ItemID>
        <EndTime>' + item_2_endtime_utc + '</EndTime>
        <ViewItemURLForNaturalSearch>http://cgi.ebay.com/BOUNTY-KILLER-NO-ARGUMENT-Reggae-45_W0QQitemZ260436558510QQcategoryZ306QQcmdZViewItem</ViewItemURLForNaturalSearch>
        <ListingType>Chinese</ListingType>
        <GalleryURL>http://thumbs1.ebaystatic.com/pict/2604365585108080_1.jpg</GalleryURL>
        <PrimaryCategoryID>306</PrimaryCategoryID>
        <PrimaryCategoryName>Music:Records</PrimaryCategoryName>
        <BidCount>1</BidCount>
        <ConvertedCurrentPrice currencyID="USD">0.99</ConvertedCurrentPrice>
        <ListingStatus>Active</ListingStatus>
        <TimeLeft>PT4M</TimeLeft>
        <Title>BOUNTY KILLER-NO ARGUMENT/Reggae 45</Title>
        <ShippingCostSummary>
          <ShippingServiceCost currencyID="USD">4.0</ShippingServiceCost>
          <ShippingType>FlatDomesticCalculatedInternational</ShippingType>
        </ShippingCostSummary>
      </Item>
      <Item>
        <ItemID>' + FOUND_ITEM_3[0].to_s + '</ItemID>
        <EndTime>' + item_3_endtime_utc + '</EndTime>
        <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Alton-Ellis-Deliver-Us-Rock-Steady-45-Single_W0QQitemZ300325824658QQcategoryZ306QQcmdZViewItem</ViewItemURLForNaturalSearch>
        <ListingType>Chinese</ListingType>
        <GalleryURL>http://thumbs2.ebaystatic.com/pict/3003258246588080_1.jpg</GalleryURL>
        <PrimaryCategoryID>306</PrimaryCategoryID>
        <PrimaryCategoryName>Music:Records</PrimaryCategoryName>
        <BidCount>0</BidCount>
        <ConvertedCurrentPrice currencyID="USD">15.99</ConvertedCurrentPrice>
        <ListingStatus>Active</ListingStatus>
        <TimeLeft>PT5M33S</TimeLeft>
        <Title>Alton Ellis: Deliver Us - Rock Steady 45 Single</Title>
        <ShippingCostSummary>
          <ShippingServiceCost currencyID="USD">4.0</ShippingServiceCost>
          <ShippingType>FlatDomesticCalculatedInternational</ShippingType>
        </ShippingCostSummary>
      </Item>
      <Item>
        <ItemID>' + FOUND_ITEM_4[0].to_s + '</ItemID>
        <EndTime>' + item_4_endtime_utc + '</EndTime>
        <ViewItemURLForNaturalSearch>http://cgi.ebay.com/John-Holt-Time-and-the-River-Reggae-45-Single_W0QQitemZ300325824769QQcategoryZ306QQcmdZViewItem</ViewItemURLForNaturalSearch>
        <ListingType>Chinese</ListingType>
        <GalleryURL>http://thumbs2.ebaystatic.com/pict/3003258247698080_1.jpg</GalleryURL>
        <PrimaryCategoryID>306</PrimaryCategoryID>
        <PrimaryCategoryName>Music:Records</PrimaryCategoryName>
        <BidCount>0</BidCount>
        <ConvertedCurrentPrice currencyID="USD">12.99</ConvertedCurrentPrice>
        <ListingStatus>Active</ListingStatus>
        <TimeLeft>PT6M27S</TimeLeft>
        <Title>John Holt- Time and the River -Reggae 45 Single</Title>
        <ShippingCostSummary>
          <ShippingServiceCost currencyID="USD">4.0</ShippingServiceCost>
          <ShippingType>FlatDomesticCalculatedInternational</ShippingType>
        </ShippingCostSummary>
      </Item>
      <Item>
        <ItemID>' + FOUND_ITEM_5[0].to_s + '</ItemID>
        <EndTime>' + item_5_endtime_utc + '</EndTime>
        <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Stranger-Patsy-When-You-Call-My-Name-Ska-45-Single_W0QQitemZ300325824946QQcategoryZ306QQcmdZViewItem</ViewItemURLForNaturalSearch>
        <ListingType>Chinese</ListingType>
        <GalleryURL>http://thumbs2.ebaystatic.com/pict/3003258249468080_1.jpg</GalleryURL>
        <PrimaryCategoryID>306</PrimaryCategoryID>
        <PrimaryCategoryName>Music:Records</PrimaryCategoryName>
        <BidCount>0</BidCount>
        <ConvertedCurrentPrice currencyID="USD">15.99</ConvertedCurrentPrice>
        <ListingStatus>Active</ListingStatus>
        <TimeLeft>PT7M52S</TimeLeft>
        <Title>Stranger &amp; Patsy: When You Call My Name - Ska 45 Single</Title>
        <ShippingCostSummary>
          <ShippingServiceCost currencyID="USD">4.0</ShippingServiceCost>
          <ShippingType>FlatDomesticCalculatedInternational</ShippingType>
        </ShippingCostSummary>
      </Item>
    </ItemArray>
  </SearchResult>
  <PageNumber>1</PageNumber>
  <TotalPages>6</TotalPages>
  <TotalItems>29</TotalItems>
  <ItemSearchURL>http://search-desc.ebay.com/ws/search/SaleSearch?fts=2&amp;DemandData=1&amp;dfe=20090604&amp;dff=1&amp;dfs=20090603&amp;dfte=2&amp;dfts=2&amp;fsop=32&amp;sacat=306&amp;satitle=reggae</ItemSearchURL>
</FindItemsAdvancedResponse>'

  TETRACK_ITEMID = 330340439690
  GARNET_ITEMID = 140329666820
  MULTIPLE_ITEMS_CALL = 'GetMultipleItems'
  MULTIPLE_ITEMS_SELECTORS = 'Details,TextDescription'
  SAMPLE_GET_MULTIPLE_ITEMS_REQUEST = '/shopping?version=517&appid=WillSulz-7420-475d-9a40-2fb8b491a6fd&callname=' + MULTIPLE_ITEMS_CALL + '&IncludeSelector=' + MULTIPLE_ITEMS_SELECTORS + '&ItemID=' + TETRACK_ITEMID.to_s + ',' + GARNET_ITEMID.to_s

  TETRACK_DESCRIPTION = 'A1: TETRACK - Let\'s Get Together A2: PABLO ALL STARS - Black Ants Lane Dub B1: JACOB MILLER - Each One Teach One B2: PABLO ALL STARS - Matthew Lane Dub [ROCKERS, JAMAICA] Incredible M- condition copy of this ULTRA RARE and legendary original jamaican Rockers 12". The vocal tracks by Jacob Miller and Tetrack (a version of the Johnny &amp; The Attractions rocksteady classic) are both amazing and so are the two dubs that I have put last in the soundclip below. Listen to this if you don\'t know it! A superb 12" in absolutely AMAZING condition. A-side matrix: A Pabblo 214A B-side matrix: A Pabblo 214B Vinyl condition: M- SOUNDCLIP! Double-click on the "play" button above to listen to SOUND CLIPS of both sides! If the player above doesn\'t work, click HERE to listen to the MP3. Don"t forget to check out my other auctions this week. AIR-MAIL POSTAGE COSTS: 45s: 1-3 45s: $4 to Sweden, $6.50 to Europe, $8 to rest of the world. 4-8 45s: $6 to Sweden, $12 to Europe, $13.50 to rest of the world. 12"s/LPs: 1 LP/12": $6 to Sweden, $13 to Europe, $14 to rest of the world. 2-3 LP/12"s: $8 to Sweden, $21 to Europe, $25 to rest of the world. 4-7 LP/12"s: $11 to Sweden, $32 to Europe, $39 to rest of the world. INSURED/REGISTRRED SHIPPING is available and costs $13 on top of the postage fee quoted above. I know that"s very expensive, but that"s the swedish postal system for you... IMPORTANT! Payment shall be recieved within 10 days. If you can"t pay within that time frame, either contact me so that I know when/if you intend to pay, or DON"T BID if you can"t come up with the money within 10 days after the auction end. PLEASE NOTE! In the unlikely event that it might happen, I can not be held responsible for packages going missing unless you"ve asked to have them sent with insured/registered shipping. Payment is accepted via PayPal. Thanks for looking and good luck bidding!'
  TETRACK_ENDTIME = '2009-07-01T13:34:08.000Z'
  TETRACK_STARTTIME = '2009-06-26T13:34:08.000Z'
  TETRACK_URL = 'http://cgi.ebay.com/TETRACK-Lets-Get-Together-JACOB-MILLER-rare-DUB-ROOTS_W0QQitemZ330340439690QQcategoryZ306QQcmdZViewItem'
  TETRACK_GALLERY_IMG = 'http://thumbs3.ebaystatic.com/pict/3303404396908080_2.jpg'
  TETRACK_BIDCOUNT = 7
  TETRACK_PRICE = 405.0
  TETRACK_SELLERID = 'pushkings'

  GARNET_DESCRIPTION = '45 RPM. Garnet Silk--Babylon Be Still/Version. Johnny Osbourne--Play Play Girl. Byron Lee &amp; The Dragonaires--Spring Garden on Fire/Instrumental. Gregory Isaacs--Hard Drugs/Version.. Records between VG+ to VG++. Not Mint. Great Records to add to your collection. Thanks for looking. Please see my other auctions for more great items. Happy Bidding!!'
  GARNET_ENDTIME = '2009-07-03T22:02:53.000Z'
  GARNET_STARTTIME = '2009-06-26T22:02:53.000Z'
  GARNET_URL = 'http://cgi.ebay.com/4-45-RPM-Reggae-Garnet-Silk-Johnny-Osbourne-etc_W0QQitemZ140329666820QQcategoryZ306QQcmdZViewItem'
  GARNET_GALLERY_IMG = 'http://thumbs3.ebaystatic.com/pict/1403296668208080_1.jpg'
  GARNET_BIDCOUNT = 1
  GARNET_PRICE = 5.0
  GARNET_SELLERID = 'ronsuniquerecords'


  TETRACK_ITEM_XML = '<Item>
    <BestOfferEnabled>false</BestOfferEnabled>
    <Description>' + TETRACK_DESCRIPTION + '</Description>
    <ItemID>'+ TETRACK_ITEMID.to_s + '</ItemID>
    <EndTime>'+ TETRACK_ENDTIME + '</EndTime>
    <StartTime>'+ TETRACK_STARTTIME + '</StartTime>
    <ViewItemURLForNaturalSearch>' + TETRACK_URL + '</ViewItemURLForNaturalSearch>
    <ListingType>Chinese</ListingType>
    <Location>Malmoe, -</Location>
    <PaymentMethods>PayPal</PaymentMethods>
    <GalleryURL>' + TETRACK_GALLERY_IMG + '</GalleryURL>
    <PictureURL>http://www.shingaling.com/ebay0906b/jacobmiller-b.jpg</PictureURL>
    <PrimaryCategoryID>306</PrimaryCategoryID>
    <PrimaryCategoryName>Music:Records</PrimaryCategoryName>
    <Quantity>1</Quantity>
    <Seller>
      <UserID>' + TETRACK_SELLERID + '</UserID>
      <FeedbackRatingStar>Red</FeedbackRatingStar>
      <FeedbackScore>3666</FeedbackScore>
      <PositiveFeedbackPercent>100.0</PositiveFeedbackPercent>
    </Seller>
    <BidCount>' + TETRACK_BIDCOUNT.to_s + '</BidCount>
    <ConvertedCurrentPrice currencyID="USD">405.0</ConvertedCurrentPrice>
    <CurrentPrice currencyID="USD">' + TETRACK_PRICE.to_s + '</CurrentPrice>
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
    <Title>TETRACK Let"s Get Together JACOB MILLER rare DUB ROOTS</Title>
    <HitCount>193</HitCount>
    <Subtitle>SEE MY OTHER AUCTIONS for more M- roots &amp; dub 12"s/7"s!</Subtitle>
    <PrimaryCategoryIDPath>11233:306</PrimaryCategoryIDPath>
    <Storefront>
      <StoreURL>http://stores.ebay.com/id=0</StoreURL>
      <StoreName>
      </StoreName>
    </Storefront>
    <Country>SE</Country>
    <ReturnPolicy>
      <Refund>Money Back</Refund>
      <ReturnsWithin>14 Days</ReturnsWithin>
      <ReturnsAccepted>Returns Accepted</ReturnsAccepted>
      <ShippingCostPaidBy>Buyer</ShippingCostPaidBy>
    </ReturnPolicy>
    <MinimumToBid currencyID="USD">410.0</MinimumToBid>
    <AutoPay>false</AutoPay>
    <PaymentAllowedSite>UK</PaymentAllowedSite>
    <PaymentAllowedSite>CanadaFrench</PaymentAllowedSite>
    <PaymentAllowedSite>Sweden</PaymentAllowedSite>
    <PaymentAllowedSite>Canada</PaymentAllowedSite>
    <PaymentAllowedSite>US</PaymentAllowedSite>
    <IntegratedMerchantCreditCardEnabled>false</IntegratedMerchantCreditCardEnabled>
    <HandlingTime>3</HandlingTime>
  </Item>'

  GARNET_ITEM_XML = '<Item>
    <BestOfferEnabled>false</BestOfferEnabled>
    <Description>' + GARNET_DESCRIPTION + '</Description>
    <ItemID>' + GARNET_ITEMID.to_s + '</ItemID>
    <EndTime>' + GARNET_ENDTIME + '</EndTime>
    <StartTime>' + GARNET_STARTTIME + '</StartTime>
    <ViewItemURLForNaturalSearch>' + GARNET_URL + '</ViewItemURLForNaturalSearch>
    <ListingType>Chinese</ListingType>
    <Location>port st lucie, fl</Location>
    <PaymentMethods>PayPal</PaymentMethods>
    <GalleryURL>' + GARNET_GALLERY_IMG + '</GalleryURL>
    <PictureURL>http://i.ebayimg.com/17/!BVNbPJQBmk~$(KGrHgoOKj!EjlLmZDmvBKRURE(oYQ~~_1.JPG?set_id=8800005007</PictureURL>
    <PostalCode>34953</PostalCode>
    <PrimaryCategoryID>306</PrimaryCategoryID>
    <PrimaryCategoryName>Music:Records</PrimaryCategoryName>
    <Quantity>1</Quantity>
    <Seller>
      <UserID>' + GARNET_SELLERID + '</UserID>
      <FeedbackRatingStar>Turquoise</FeedbackRatingStar>
      <FeedbackScore>390</FeedbackScore>
      <PositiveFeedbackPercent>99.7</PositiveFeedbackPercent>
    </Seller>
    <BidCount>' + GARNET_BIDCOUNT.to_s + '</BidCount>
    <ConvertedCurrentPrice currencyID="USD">' + GARNET_PRICE.to_s + '</ConvertedCurrentPrice>
    <CurrentPrice currencyID="USD">5.0</CurrentPrice>
    <ListingStatus>Completed</ListingStatus>
    <QuantitySold>0</QuantitySold>
    <ReserveMet>true</ReserveMet>
    <ShipToLocations>Worldwide</ShipToLocations>
    <Site>US</Site>
    <TimeLeft>PT0S</TimeLeft>
    <Title>4--45 RPM--Reggae--Garnet Silk/Johnny Osbourne/etc.</Title>
    <HitCount>11</HitCount>
    <PrimaryCategoryIDPath>11233:306</PrimaryCategoryIDPath>
    <Storefront>
      <StoreURL>http://stores.ebay.com/id=0</StoreURL>
      <StoreName>
      </StoreName>
    </Storefront>
    <Country>US</Country>
    <ReturnPolicy>
      <Refund>Money Back</Refund>
      <ReturnsWithin>3 Days</ReturnsWithin>
      <ReturnsAccepted>Returns Accepted</ReturnsAccepted>
      <ShippingCostPaidBy>Buyer</ShippingCostPaidBy>
    </ReturnPolicy>
    <MinimumToBid currencyID="USD">5.0</MinimumToBid>
    <AutoPay>false</AutoPay>
    <PaymentAllowedSite>CanadaFrench</PaymentAllowedSite>
    <PaymentAllowedSite>Canada</PaymentAllowedSite>
    <PaymentAllowedSite>US</PaymentAllowedSite>
    <IntegratedMerchantCreditCardEnabled>false</IntegratedMerchantCreditCardEnabled>
    <HandlingTime>4</HandlingTime>
  </Item>'

end