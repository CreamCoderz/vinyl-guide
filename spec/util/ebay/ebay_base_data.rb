module EbayBaseData

  # ---------------- TIME ---------------------------
  CURRENT_EBAY_TIME = '2009-07-19T23:42:25.000Z'

  SAMPLE_GET_EBAY_TIME_REQUEST = '/shopping?version=517&appid=WillSulz-7420-475d-9a40-2fb8b491a6fd&callname=geteBayTime'

  SAMPLE_GET_EBAY_TIME_RESPONSE = ' <GeteBayTimeResponse xmlns="urn:ebay:apis:eBLBaseComponents">
   <Timestamp>' + CURRENT_EBAY_TIME + '</Timestamp>
   <Ack>Success</Ack>
   <Build>e625__Bundled_9633847_R1</Build>
   <Version>625</Version>
  </GeteBayTimeResponse>'

  # ---------------- FINDING -------------------------
  SAMPLE_BASE_URL = 'http://open.api.ebay.com'
  SAMPLE_BASE_FIND_HOST = 'svcs.ebay.com'
  SAMPLE_BASE_FIND_URL = "http://#{SAMPLE_BASE_FIND_HOST}"


  SAMPLE_FIND_ITEMS_REQUEST = SAMPLE_BASE_URL + '/shopping?version=517&appid=WillSulz-7420-475d-9a40-2fb8b491a6fd&callname=FindItemsAdvanced&CategoryID=306&DescriptionSearch=true&EndTimeFrom=2009-07-09T01:00:00.000Z&EndTimeTo=2009-07-10T01:00:00.000Z&MaxEntries=100&PageNumber=1&QueryKeywords=reggae'

  item_1_endtime_utc = '2009-07-03T23:42:25.000Z'
  item_2_endtime_utc = '2009-07-03T23:46:05.000Z'
  item_3_endtime_utc = '2009-07-03T23:48:32.000Z'
  item_4_endtime_utc = '2009-07-03T23:48:32.000Z'
  item_5_endtime_utc = '2009-07-03T23:49:57.000Z'

  #TODO: these dates are not parsing correctly
  FOUND_ITEM_1 = [120440899019, DateTime.parse(item_1_endtime_utc)]
  FOUND_ITEM_2 = [260436558510, DateTime.parse(item_2_endtime_utc)]
  FOUND_ITEM_3 = [300325824658, DateTime.parse(item_3_endtime_utc)]
  FOUND_ITEM_4 = [300325824769, DateTime.parse(item_4_endtime_utc)]
  FOUND_ITEM_5 = [300325824946, DateTime.parse(item_5_endtime_utc)]

  FOUND_ITEM_6 = [348943784329, DateTime.parse(item_4_endtime_utc)]
  FOUND_ITEM_7 = [437893478942, DateTime.parse(item_5_endtime_utc)]

  FOUND_ITEMS = [FOUND_ITEM_1, FOUND_ITEM_2, FOUND_ITEM_3, FOUND_ITEM_4, FOUND_ITEM_5]

  EMPTY_FIND_ITEMS_RESPONSE = '<?xml version=\'1.0\' encoding=\'UTF-8\'?>
<findItemsAdvancedResponse xmlns:ms="http://www.ebay.com/marketplace/services"
                           xmlns="http://www.ebay.com/marketplace/search/v1/services">
    <ack>Success</ack>
    <version>1.0.1</version>
    <timestamp>2009-09-19T21:25:54.384Z</timestamp>
    <searchResult count="0"/>
    <paginationOutput>
        <totalPages>0</totalPages>
        <totalEntries>0</totalEntries>
        <pageNumber>0</pageNumber>
        <entriesPerPage>100</entriesPerPage>
    </paginationOutput>
</findItemsAdvancedResponse>'

  AUCTIONS_RESPONSE_HEAD = "<?xml version='1.0' encoding='UTF-8'?>
<findItemsAdvancedResponse xmlns:ms=\"http://www.ebay.com/marketplace/services\"
xmlns=\"http://www.ebay.com/marketplace/search/v1/services\">
<ack>Success</ack>
<version>1.0.1</version>
<timestamp>2009-09-19T19:34:26.586Z</timestamp>
<searchResult count=\"100\">"

  # ---------------- DETAILS --------------------------
  TETRACK_ITEMID = 330340439690
  GARNET_ITEMID = 140329666820
  MULTIPLE_ITEMS_CALL = 'GetMultipleItems'
  MULTIPLE_ITEMS_SELECTORS = 'Details,TextDescription,ItemSpecifics'

  USD_CURRENCY = 'USD'
  GBP_CURRENCY = 'GBP'

  TETRACK_DESCRIPTION = 'A1: TETRACK - Let\'s Get Together A2: PABLO ALL STARS - Black Ants Lane Dub B1: JACOB MILLER - Each One Teach One B2: PABLO ALL STARS - Matthew Lane Dub [ROCKERS, JAMAICA] Incredible M- condition copy of this ULTRA RARE and legendary original jamaican Rockers 12". The vocal tracks by Jacob Miller and Tetrack (a version of the Johnny &amp; The Attractions rocksteady classic) are both amazing and so are the two dubs that I have put last in the soundclip below. Listen to this if you don\'t know it! A superb 12" in absolutely AMAZING condition. A-side matrix: A Pabblo 214A B-side matrix: A Pabblo 214B Vinyl condition: M- SOUNDCLIP! Double-click on the "play" button above to listen to SOUND CLIPS of both sides! If the player above doesn\'t work, click HERE to listen to the MP3. Don"t forget to check out my other auctions this week. AIR-MAIL POSTAGE COSTS: 45s: 1-3 45s: $4 to Sweden, $6.50 to Europe, $8 to rest of the world. 4-8 45s: $6 to Sweden, $12 to Europe, $13.50 to rest of the world. 12"s/LPs: 1 LP/12": $6 to Sweden, $13 to Europe, $14 to rest of the world. 2-3 LP/12"s: $8 to Sweden, $21 to Europe, $25 to rest of the world. 4-7 LP/12"s: $11 to Sweden, $32 to Europe, $39 to rest of the world. INSURED/REGISTRRED SHIPPING is available and costs $13 on top of the postage fee quoted above. I know that"s very expensive, but that"s the swedish postal system for you... IMPORTANT! Payment shall be recieved within 10 days. If you can"t pay within that time frame, either contact me so that I know when/if you intend to pay, or DON"T BID if you can"t come up with the money within 10 days after the auction end. PLEASE NOTE! In the unlikely event that it might happen, I can not be held responsible for packages going missing unless you"ve asked to have them sent with insured/registered shipping. Payment is accepted via PayPal. Thanks for looking and good luck bidding!'
  TETRACK_ENDTIME = '2009-07-01T13:34:08.000Z'
  TETRACK_STARTTIME = '2009-06-26T13:34:08.000Z'
  TETRACK_URL = 'http://cgi.ebay.com/TETRACK-Lets-Get-Together-JACOB-MILLER-rare-DUB-ROOTS_W0QQitemZ330340439690QQcategoryZ306QQcmdZViewItem'
  TETRACK_GALLERY_IMG = 'http://thumbs3.ebaystatic.com/pict/3303404396908080_2.jpg'
  TETRACK_PICTURE_IMGS = ['http://i.ebayimg.com/17/!BVNbPJQBmk~$%28KGrHgoOKj!EjlLmZDmvBKRURE%28oYQ~~_1.JPG?set_id=8800005007', 'http://i.ebayimg.com/17/!BVNbPJQBmk~$%28KGrHgoOKj!EjlLmZDmvBKRURE%28oYQ~~_1.JPG?set_id=983289022']
  TETRACK_BIDCOUNT = 7
  TETRACK_PRICE = 405.0
  TETRACK_SELLERID = 'pushkings'
  TETRACK_TITLE = 'TETRACK Let"s Get Together JACOB MILLER rare DUB ROOTS'
  TETRACK_SIZE = 'LP (12-Inch)'
  TETRACK_SUB_GENRE = "Roots"
  TETRACK_CONDITION = "USED"
  TETRACK_SPEED = "33 RPM"
  TETRACK_COUNTRY = "SE"
  TETRACK_HASIMAGE = true

  GARNET_DESCRIPTION = '45 RPM. Garnet Silk--Babylon Be Still/Version. Johnny Osbourne--Play Play Girl. Byron Lee &amp; The Dragonaires--Spring Garden on Fire/Instrumental. Gregory Isaacs--Hard Drugs/Version.. Records between VG+ to VG++. Not Mint. Great Records to add to your collection. Thanks for looking. Please see my other auctions for more great items. Happy Bidding!!'
  GARNET_ENDTIME = '2009-07-03T22:02:53.000Z'
  GARNET_STARTTIME = '2009-06-26T22:02:53.000Z'
  GARNET_URL = 'http://cgi.ebay.com/4-45-RPM-Reggae-Garnet-Silk-Johnny-Osbourne-etc_W0QQitemZ140329666820QQcategoryZ306QQcmdZViewItem'
  GARNET_GALLERY_IMG = 'http://thumbs3.ebaystatic.com/pict/1403296668208080_1.jpg'
  GARNET_PICTURE_IMGS = ['http://i.ebayimg.com/17/!BVNbPJQBmk~$%28KGrHgoOKj!EjlLmZDmvBKRURE%28oYQ~~_1.JPG?set_id=321453232', 'http://i.ebayimg.com/17/!BVNbPJQBmk~$%28KGrHgoOKj!EjlLmZDmvBKRURE%28oYQ~~_1.JPG?set_id=643532421']
  GARNET_BIDCOUNT = 1
  GARNET_PRICE = 5.0
  GARNET_SELLERID = 'ronsuniquerecords'
  GARNET_TITLE = 'Garnet Silk--Babylon Be Still/Version. Johnny Osbourne--Play Play Girl'
  GARNET_SIZE = '12"'
  GARNET_SUB_GENRE = "Dub"
  GARNET_CONDITION = "NEW"
  GARNET_SPEED = "78 RPM"
  GARNET_COUNTRY = "FR"
  GARNET_HASIMAGE = true

  TETRACK_EBAY_ITEM = EbayItemData.new(CGI.unescapeHTML(TETRACK_DESCRIPTION),
          TETRACK_ITEMID, DateUtil.utc_to_date(TETRACK_ENDTIME), DateUtil.utc_to_date(TETRACK_STARTTIME),
          TETRACK_URL, TETRACK_GALLERY_IMG, TETRACK_BIDCOUNT, TETRACK_PRICE, TETRACK_SELLERID,
          CGI.unescapeHTML(TETRACK_TITLE), TETRACK_COUNTRY, TETRACK_PICTURE_IMGS, USD_CURRENCY, TETRACK_SIZE,
          TETRACK_SUB_GENRE, TETRACK_CONDITION, TETRACK_SPEED)

  GARNET_EBAY_ITEM = EbayItemData.new(CGI.unescapeHTML(GARNET_DESCRIPTION),
          GARNET_ITEMID, DateUtil.utc_to_date(GARNET_ENDTIME), DateUtil.utc_to_date(GARNET_STARTTIME),
          GARNET_URL, GARNET_GALLERY_IMG, GARNET_BIDCOUNT, GARNET_PRICE, GARNET_SELLERID,
          CGI.unescapeHTML(GARNET_TITLE), GARNET_COUNTRY, GARNET_PICTURE_IMGS, USD_CURRENCY,
          GARNET_SIZE, GARNET_SUB_GENRE, GARNET_CONDITION, GARNET_SPEED)




  ITEMS_DETAILS_RESPONSE_XML = "<ItemSpecifics>
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
      <Value>Used</Value>
     </NameValueList>
     <NameValueList>
      <Name>Genre</Name>
      <Value>Reggae/Ska</Value>
     </NameValueList>
     <NameValueList>
      <Name>Record Size</Name>
      <Value>LP (12-Inch)</Value>
     </NameValueList>
     <NameValueList>
      <Name>Speed</Name>
      <Value>33 RPM</Value>
     </NameValueList>
     <NameValueList>
      <Name>Sub-Genre</Name>
      <Value></Value>
     </NameValueList>
     <NameValueList>
      <Name>Compilation</Name>
      <Value></Value>
     </NameValueList>
    </ItemSpecifics>"
end