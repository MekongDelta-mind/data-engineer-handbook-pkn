/*
 * 

A DDL for an user_devices_cumulated table that has:

    a device_activity_datelist which tracks a users active days by browser_type
    data type here should look similar to MAP<STRING, ARRAY[DATE]> Adding a 
        OR 
   	(tried this thing)you could have browser_type as a column with multiple rows for each user (either way works, just be consistent!)


 */

SELECT *
FROM users u
ORDER BY user_id; 

SELECT *
FROM events e
ORDER BY user_id;

SELECT *
FROM events e 
WHERE user_id ='8572187529989597';

SELECT *
FROM devices d 
ORDER BY device_id ;

-- unique device types:
SELECT DISTINCT(browser_type) 
FROM devices d; 
/*
 * Spider_Bot,LinkedInBot, ZoominfoBot, 3+bottle, Maxthon, Applebot, Yeti, DataForSeoBot, SeekportBot, Facebook, ICC-Crawler, 
 * WhatsApp, Googlebot, Apple Mail, Other, Safari, Mediatoolkitbot, LightspeedSystemsCrawler, de/bot, SMTBot, ) Bot, PetalBot, 
 * Chrome Mobile, YandexMedia, TwitterBot, Iron, vuhuvBot, Jooblebot, Neevabot, Opera Mobile, Opera Tablet, SemrushBot, pingbot, 
 * B2B Bot, Chromium, Spark%20Desktop%20Helper, ThinkBot, K7MLWCBot, WellKnownBot, DotBot, AdsTxtCrawlerTP, DuckDuckBot, 
 * heritrix, Firefox Beta, //botta, Nutch, DuckDuckGo-Favicons-Bot, BSbot, AwarioSmartBot, Iceweasel, PhantomBot, BLEXBot, 
 * Mail.ru Chromium Browser, Bytespider, Investment Crawler, Chrome Mobile iOS, WidgetKitExtension, TkBot, com/bot, okhttp, 
 * t3versionsBot, Wget, TestBot, 3w24bot, Adsbot, BingPreview, Sogou Explorer, Opera, Crawlson, coccocbot, CCBot, 
 * Chrome Frame, Scrapy, SeznamBot, NetFront, Client, Discordbot, IE, OmniWeb, tikirobot, BrightEdge Crawler, aiHitBot, 
 * Linespider, Preview Service; bot, HeadlessChrome, Edge, AwarioBot, AhrefsBot, Semanticbot, YandexBot, Chrome Mobile WebView, 
 * Nokia, SafeDNSBot, ; Bot, KStandBot, curl, Nicecrawler, Firefox, WeChatShareExtensionNew, Python-urllib, 
 * _please_add_disallow_to_the_robots, MojeekBot, QQ Browser Mobile, Yandex Browser, SeaMonkey, Android, Dragon, 
 * Reeder, msnbot, Baiduspider, Googlebot-Image, BananaBot, Python Requests, SummalyBot, MJ12bot, ISSCyberRiskCrawler, 
 * DF Bot, therobots, Refindbot, Twitterbot, tapbots, web-crawlers, Konqueror, AppEngine-Google, Firefox Alpha, 
 * Lynx, Slackbot-LinkExpanding, 2ip bot, FacebookBot, Screaming Frog SEO Spider, social.dbot, tobbot, Chrome, tur.bot, 
 * Firefox iOS, SEMC-Browser, UC Browser, Mobile Safari UI/WKWebView, Opera Mini, archive.org_bot, Mobile Safari, 
 * SearchAtlas Bot, Puffin, //botsin, PaperLiBot, crawler, SEMrushBot, Electron, ; bot, WebKit Nightly, bitlybot, Firefox Mobile, 
 * IE Mobile, Spark, ev-crawler, Apache-HttpClient, Pale Moon, Nimbostratus-Bot, Swiftfox, Uptimebot, LivelapBot, bingbot, 
 * Firefox (Shiretoko), SerendeputyBot, ZaldamoSearchBot, domainsbot, RepoLookoutBot, //botany, 
 * Internet-structure-research-project-bot, Vivaldi, Linkbot, thoughtbot, Seekport Crawler, linkdexbot, linkbot, 
 * GooglePlusBot, webprosbot, Gaisbot, HubSpot Crawler, QQ Browser, MixrankBot, davbot, SiteAuditBot, libwww-perl, Java, 
 * Samsung Internet, Nokia Services (WAP) Browser, Minimo, Bear, AccompanyBot, Canary-iOS, spider, JobboerseBot, serpstatbot, 
 * Amazon Silk, robot, Amazonbot, ZaldomoSearchBot, WhatStuffWhereBot
*/

SELECT DISTINCT(device_type) 
FROM devices d; 
/*
 * Samsung SM-A736B, Ericsson K750i, XiaoMi Redmi Note 5A Prime, Samsung SM-M135FU, MHA-AL00, Samsung SM-M515F, 
 * Samsung SM-G960F, Samsung SM-G975F, OnePlus ONEPLUS A5010, Samsung SM-G985F, Samsung SM-G973W, XiaoMi MI 6X, 
 * SC-02B, Samsung SM-M127F, XiaoMi Redmi 7A, Samsung SM-A025F, XiaoMi Redmi Note 4X, Samsung SM-M426B, 
 * Samsung SM-G981U1, Samsung SM-G965F, Samsung SM-F721B, OnePlus ONEPLUS A6000, POT-LX3, Samsung SM-A505FN, 
 * Samsung SM-G935F, Asus X00TD, vivo $2, RNE-L21, Samsung SM-G960W, Samsung SM-G975U1, Samsung SM-A716S, 
 * Samsung SM-N950U, Samsung SM-J737T, Samsung SM-G781B, Other, HUAWEI $2, XiaoMi Redmi Note 8 Pro, Samsung SM-G965U, 
 * Samsung SM-G998U1, ALP-AL00, Samsung SM-G977N, Samsung SM-A705FN, HTC One $2, Samsung SM-J737A, Samsung SM-A515F, 
 * Samsung SM-A207M, Samsung SM-G955F, Nokia$2$3, Samsung SM-N900T, Samsung SM-G781V, LG $2, iPad, Samsung SM-F926B, 
 * DUK-L09, YAL-L21, Samsung SM-M215F, LYA-L29, Samsung SM-N980F, Samsung SM-A025U, iPhone, Samsung SM-N986U1, 
 * Samsung Galaxy Nexus, Samsung SM-N970U1, DRA-LX9, Samsung SM-G973U, Samsung SM-A315G, Samsung SM-S918W, 
 * Samsung SM-S906E, Generic Tablet, CPH1729, Samsung SM-N975U, AFTMM, Samsung SM-A530F, Huawei Browser, Samsung SM-M136B, 
 * Samsung SM-M526BR, Samsung SM-G892U, Samsung SM-T310, Samsung SM-F711U1, Oppo R11, XT1052, Samsung GT-I9100 , 
 * Samsung SM-S906B, HTC Dream , Samsung SM-A307FN, Samsung SM-A705GM, Samsung SM-A426B, ANE-LX1, OnePlus ONEPLUS A5000, 
 * XiaoMi HM NOTE 1S, XiaoMi Redmi 4, Samsung SM-G991B, XiaoMi Redmi 3S, Samsung SM-G965U1, Samsung SM-G715U1, Samsung SM-A305G, 
 * Asus kunst, Infinix $2, TAS-AL00, Samsung SM-A546E, Samsung SM-S767VL, LYA-L09, Samsung SM-G986B, Samsung SM-A305GT, 
 * Samsung SM-G990E, Samsung SM-T870, Lenovo P2a42, Gionee M7, SOV33, Samsung SM-G930A, Samsung SM-A525M, Samsung SM-F936B, 
 * HTC Sensation $2, LIO-AL00, Samsung SM-N960F, Samsung SM-G9810, Samsung SM-A426U, Samsung SM-T500, Samsung SM-G973F, 
 * Samsung SM-N986B, Samsung SM-M326B, Samsung SM-A520W, Samsung SM-M225FV, Samsung SM-N960U, Samsung SM-M127G, 
 * Samsung SM-F711B, Samsung SM-G930F, Samsung SM-G988U, Samsung SM-N970U, COL-L29, iOS-Device, Samsung SM-G930S, 
 * Samsung SM-G990B2, Samsung GT-I9502 , Gionee S12, Samsung SM-A415F, Android SDK built for x86, ANE-AL00, 
 * Samsung SM-G965W, Samsung SM-G986U1, Motorola Droid, SonyEricsson$2, Samsung SM-G955U, Samsung SM-A225M, Samsung SM-A520F, 
 * Samsung SM-G935V, Samsung GT-P5210 , Samsung SM-A215U, Samsung SM-A725F, Samsung SM-A526U, Samsung SM-A226BR, FRD-AL10, 
 * Samsung SM-J600FN, Samsung SM-G950U1, XiaoMi MI 9, Samsung SM-A125U, Samsung SM-A135F, Samsung SM-A516U, Samsung SM-G991W, 
 * EVR-L29, Samsung SM-G9500, VOG-L04, Samsung SM-A225F, Samsung SM-A125U1, BLA-AL00, POT-LX1A, Pixel 6, Spider, 
 * Samsung SM-A047F, Samsung SM-J320FN, Samsung SM-A326W, Samsung SM-G950F, Samsung SM-A127M, Lenovo K8 Plus, Samsung SM-A536E, 
 * Samsung SM-S9080, Samsung SM-G960U1, Lenovo TB-8504X, Samsung SM-G996U1, Samsung SM-A042F, Samsung SM-S901U, Asus Nexus 10, 
 * Samsung SM-E225F, Samsung SM-G988U1, Pixel 4a, Samsung SM-G986U, Lenovo K53a48, XiaoMi Redmi 5, HTC D200LVW, POT-LX1, 
 * MAR-LX1A, Ericsson W810i, Samsung SM-S901U1, ART-L29N, Samsung SM-F926U, Lenovo TB-X306F, Samsung SM-S916U, Oppo R9s Plus, 
 * Samsung SM-G970F, Samsung SM-G998W, Samsung SM-S901B, LIO-AN00, Samsung SM-G996U, Samsung SM-M115F, Samsung SM-G996B, 
 * Samsung SM-M315F, Samsung SM-G960U, Samsung SM-G950W, Oppo R11s, Samsung SM-J700F, Samsung SM-C5000, Samsung SM-S908U1, 
 * Samsung SM-G970U, Samsung SM-N975W, Samsung SM-M015G, Samsung SM-S911B, Samsung SM-F721U1, Kindle Fire HDX 7" WiFi, 
 * Samsung SM-M215G, Samsung SM-M526B, DRA-LX5, HTC Nexus One, Samsung SM-G770F, Samsung SM-S911U, Samsung SM-A505F, 
 * Samsung SM-N976B, Samsung SM-A205W, Pixel 3a, Samsung $2, XiaoMi Redmi 8A Dual, Nexus 5X, Samsung SM-F711W, PAL-LX9, 
 * Mi Note 2, Samsung SM-M305F, Samsung SM-G930V, Samsung SM-M307F, Pixel 1, Samsung SM-F926U1, Samsung SM-G973U1, Samsung SM-A536U,
 *  Samsung SM-S908U, Samsung SM-S908E, Samsung SM-E236B, Samsung SM-F127G, Samsung SM-S918U, OnePlus ONEPLUS A6010, 
 * Samsung SM-G998U, Samsung SM-M236B, Samsung SM-N986W, Oppo A83t, Samsung SM-T580, Samsung SM-S901E, Samsung SM-M205F, 
 * VOG-L29, Samsung SM-G970U1, HTC Desire $2 $3, Nokia undefined$2$3, Samsung SM-A716U1, XiaoMi Redmi K20 Pro, Samsung SM-A536B, 
 * Samsung SM-G981N, XiaoMi Redmi Note 5, Pixel 3, Samsung SM-A035F, XiaoMi Redmi Note 6 Pro, Pixel 5, XiaoMi Redmi Note 9S, 
 * Samsung SM-A325F, Samsung GT-P5113 , Samsung SM-A750FN, Samsung SM-G980F, Samsung SM-A205F, Samsung SM-N975F, XiaoMi Redmi 4A, 
 * Samsung SM-A336E, Samsung SM-S901W, Samsung SM-A136B, EML-L29, Mac, JKM-LX1, Samsung SM-A217M, CLT-L29, XiaoMi HM NOTE 1W, 
 * Samsung SM-G950U, 17MB150WB, Samsung SM-G998B, Samsung SM-M536B, Moto $2, Samsung SM-A336B, Samsung SM-M307FN, JAD-LX9, 
 * EML-L09, LYA-AL00, Samsung SM-S918U1, Samsung SM-E426B, XiaoMi Redmi Note 8T, Samsung SM-G780F, Samsung SM-G780G, 
 * Samsung SM-G970W, XiaoMi MI 8, LYA-AL10, Samsung SM-A315F, XiaoMi Redmi Note 4, Huawei Nexus 6P, XiaoMi Redmi Note 8, 
 * Samsung SM-A405FN, Samsung SM-G955U1, Samsung SM-T530NU, Samsung SM-A226B, Samsung SM-G975U, Samsung SM-G988B, Samsung SM-A125F, 
 * XiaoMi Redmi 8, Samsung SM-S906U, Samsung SM-G781W, HTC U11, Samsung SM-G925F, Kindle, Nexus 5, EML-AL00, Pixel 2 XL, Samsung SM-J810G, 
 * OnePlus ONEPLUS A6003, Samsung SCH-I535, Samsung SM-S908W, VS415PP, Samsung SM-G981W, XiaoMi Redmi Note 7 Pro, Samsung SM-S918B, 
 * Samsung SM-M317F, SNE-LX1, Samsung SM-S916B, CDY-NX9B, ELE-L29, XiaoMi Redmi 7, Samsung SM-A136U, ELE-AL00, Samsung SM-J730G, 
 * Samsung SM-G990W, ZTE BA520, XiaoMi Redmi K20, Samsung SM-A525F, Samsung SM-J701F, Samsung SM-A426U1, Samsung SM-A326B, Pixel 2, 
 * Samsung SM-M325F, LG-$2, Samsung SM-G9900, Nokia N73, sdk, Samsung SM-A715F, XiaoMi Redmi Y2, Samsung SM-G955W, Samsung SM-J250F, 
 * Samsung SM-P610, XiaoMi MI MAX 2, XiaoMi Redmi Note 9 Pro, FIG-LX1, Samsung SM-A235F, Generic Smartphone, Samsung SM-A135M, 
 * Samsung SM-E625F, Pixel 5a, LYA-L0C, Samsung SM-M336B, Samsung SM-S908B, STK-LX3, STK-L21, ALCATEL ONE TOUCH 7047A, INE-LX1r, 
 * XiaoMi Redmi Note 11, MAR-LX2, Samsung SM-G9910, XiaoMi Redmi Note 5 Pro, Samsung SM-G990B, Samsung SM-M336BU, jhs561, 
 * Samsung SM-G900P, Samsung SM-A5360, BLA-L09, JNY-LX1, Samsung SM-G9650, Samsung SM-G991U, Samsung SM-A325M, iPod, AMN-LX9, 
 * ANE-LX2, XiaoMi Redmi Note 7, BLN-AL40, Asus X01BDA, Samsung SM-A526U1, Medion Lifetab E7312, INE-LX1, Samsung SM-G781U, 
 * Samsung SM-A217F, Samsung SM-N981B, Samsung SM-A127F, Samsung SM-A605F, XiaoMi Redmi 4X, Asus I01WD, BGO-DL09, Lenovo A7020a48, 
 * CLT-L09, Samsung SM-A715W, Samsung SM-A037F, Samsung SM-J610F, Samsung SM-N960U1, Samsung SM-G9730, Samsung SM-N960W, 
 * Samsung SM-G9600, Samsung SM-G781U1, Samsung SM-A326U, $2, Mi Note 3, Samsung SM-A526B, Samsung SM-A305F, Generic Feature Phone, 
 * Samsung SM-A105G, XiaoMi MI 2, Samsung SM-J330FN, HTC ADR6300, Samsung SM-G986W, Samsung SM-J700M, Samsung SM-G981U, 
 * Samsung SM-A505G, Asus X00ID, Oppo A37m, TECNO $2, Samsung SM-N950F, XiaoMi Redmi 9C, Samsung SM-G9750, XiaoMi MI 6, 
 * XiaoMi Redmi 3, ELS-NX9, Samsung SM-N975U1, Samsung SM-F936U1, Samsung SM-N970F, PPA-LX2, Pixel 6a, VKY-AL00, Samsung SM-J700P, 
 * Samsung SM-A528B, MAR-LX3A, Pixel 7, VTR-L09, Samsung SM-N770F
 * */

/**
 * A DDL for an user_devices_cumulated table that has:
    a device_activity_datelist which tracks a users active days by browser_type
    data type here should look similar to MAP<STRING, ARRAY[DATE]>
        or you could have browser_type as a column with multiple rows for each user (either way works, just be consistent!)
 */

DROP TABLE IF EXISTS user_devices_cumulated;
CREATE TABLE user_devices_cumulated (
	user_id TEXT, -- converting FROM BIGINT TO TEXT AS getting OUT OF RANGE error
	device_activity_datelist DATE[], -- list OF dates IN the past WHERE the USER was active
	present_date DATE, -- `date` IN the tutorial query IS changed TO present_date
	browser_type TEXT,
	PRIMARY KEY (user_id, present_date, browser_type) -- should we ADD the browser TYPE OR NOT?
);

/*
A cumulative query to generate device_activity_datelist from events
    this is somehwat easy ot do once you create the required table and query
    similar to previous weeks thing
*/

SELECT DATE(CAST(event_time AS TIMESTAMP)) FROM events e; 


SELECT 
	MAX(event_time), MIN(event_time)
FROM
events e; 
/*
 * THIS IS THE WRONG FORM OF THE DATES
|max|min|
|---|---|
|2023-01-31 23:51:51.685000|2023-01-01 00:06:50.079000| WHICH IS WRONG as  check the symbol for data type beside thecolumn name. 
 * */

SELECT 
	MIN(DATE(CAST(event_time AS TIMESTAMP))) AS min_date,
	MAX(DATE(CAST(event_time AS TIMESTAMP))) AS max_date
FROM events e; 

/*
"min_date","max_date"
2023-01-01,2023-01-31
 */

SELECT * FROM events e;
SELECT * FROM devices d ORDER BY device_id ;

SELECT count(*) from events;
SELECT count(*) FROM devices; 

SELECT * from events WHERE device_id = '9906756820661180000'; -- 8 rows 
SELECT * FROM devices d WHERE device_id = '9906756820661180000'; 
-- 2 rows
-- 2 rows are duplicates so we have to for sure dedupe the values in devices

/*
 * checking hte duplicates in device
 */

SELECT 
	device_id ,count(1) AS count_num 
FROM  devices d 
GROUP BY 1
HAVING 
    count(1) > 1
ORDER BY 2 desc; 
   
/*
 * the events can have duplicates for the same device
 * but the device tables should have unique values. this hsould be dealth with, 
 * before inserting the same into the required table
 */

SELECT *
FROM devices d 
WHERE device_id = '14457715635265700000';

/*
 * events would be MORE than the device
 * so to collect all the activity we should left join events with the device not the other way round
 *  what should be joined with what?
 */

SELECT
--count(*) 
*
FROM
	events e
LEFT JOIN 
devices d 
ON
	e.device_id = d.device_id
WHERE e.device_id  = '9906756820661180000'; 


SELECT
--count(*) 
*
FROM
	events e
LEFT JOIN 
devices d 
ON
	d.device_id = e.device_id
WHERE e.device_id  = '9906756820661180000'; 

--- casting event time into date and selecting specific date from the table

SELECT DATE(CAST(e.event_time AS TIMESTAMP)) AS proper_timestamp
FROM events e 
ORDER BY proper_timestamp DESC ;

SELECT version(); ------checking the VERSION OF the SQL

SELECT * 
FROM events e 
WHERE DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-01');

------ below is the way to send the values during the runtime
--SELECT * 
--FROM events e 
--WHERE DATE(:CAST(e.event_time AS TIMESTAMP)) = DATE(:'2023-01-01');


SELECT
--count(*) 
*
FROM
	events e
LEFT JOIN 
devices d 
ON
	d.device_id = e.device_id
WHERE e.device_id  = '9906756820661180000'
AND 
DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-09') ; -- because there IS NO record FOR '2023-01-01', so it doesn't return any value 

-- the correct today's query 
SELECT
*
FROM
	events e
LEFT JOIN 
devices d 
ON
	d.device_id = e.device_id
AND 
DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-01');  -- removing the date SPECIFIC query BEFORE adding INTO the actual query


--- grouping all the times they were active. here you first decide what amount of time periond means "active" ?
SELECT
e.user_id,
d.browser_type,
DATE(CAST(e.event_time AS TIMESTAMP)) AS device_activity_datelist
FROM
		events e
	LEFT JOIN 
	devices d 
	ON
		d.device_id = e.device_id
	--AND DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-01');  -- removing the date SPECIFIC query BEFORE adding INTO the actual query
WHERE 
	DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-01')
	AND user_id IS NOT NULL 
	GROUP BY 1,2,3; 

-- starting query wher the yestreday date is 2022-12-31 and today is 2023-01-01 where the yesterday's values should be nulls
--- as the max date is 2023-01-31, so the max date would be 2023-01-31. So the data should be filled day-to-day basis one day at a time.

-- INCREMENTAL QUERY TO INSERT THE VALUES INTO THE TABLE

-- checking if the vlaues are correct enough to selected from 
WITH 
yesterday AS (
	SELECT 
	*
	FROM 
	user_devices_cumulated udc 
	WHERE present_date = DATE('2022-12-31')
),
today AS ( 
		SELECT
		*
		FROM
			events e
		LEFT JOIN 
		devices d 
		ON
			d.device_id = e.device_id
		
)
SELECT 
* 
FROM 
today t
FULL OUTER JOIN yesterday y 
ON t.user_id = y.user_id;
;

-- grouping the today's data . WHY? and checking what are the columns we are getting

WITH 
yesterday AS (
	SELECT 
	*
	FROM 
	user_devices_cumulated udc 
	WHERE present_date = DATE('2022-12-31')
),
today AS ( 
		SELECT
		e.user_id,
		d.browser_type,
		DATE(CAST(e.event_time AS TIMESTAMP)) AS device_activity_datelist
		FROM
				events e
			LEFT JOIN 
			devices d 
			ON
				d.device_id = e.device_id
		WHERE 
			DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-01')
			AND user_id IS NOT NULL 
			GROUP BY 1,2,3
)
SELECT 
	*
FROM 
today t
FULL OUTER JOIN yesterday y 
ON t.user_id = y.user_id;

-- selecting speicif rows based(EXCEPT datelist) on what ot be inserted into the user_devices_cumulated table

WITH 
yesterday AS (
	SELECT 
	*
	FROM 
	user_devices_cumulated udc 
	WHERE present_date = DATE('2022-12-31')
),
today AS ( 
		SELECT
		CAST(e.user_id AS TEXT) AS user_id,
		d.browser_type,
		DATE(CAST(e.event_time AS TIMESTAMP)) AS curr_date
		FROM
				events e
			LEFT JOIN 
			devices d 
			ON
				d.device_id = e.device_id
		WHERE 
			DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-01')
			AND user_id IS NOT NULL 
			GROUP BY 1,2,3
)
SELECT 
	COALESCE(t.user_id,y.user_id) AS user_id,
	NULL AS device_activity_datelist,
	COALESCE(t.curr_date, y.present_date + INTERVAL '1 day') AS present_date, -- present_date IS the date IN the user_devices_cumulated TABLE
	t.browser_type AS browser_type
--	y.browser_type AS yesterday_bt -- today's browser_type should be used NOT yesterday days. WHY?
FROM 
today t
FULL OUTER JOIN yesterday y 
ON t.user_id = y.user_id;

-- selecting speicif rows based on what ot be inserted into the user_devices_cumulated table

--- ERROR : SQL Error [22003]: ERROR: bigint out of range Error position:
--- converted the user_id into text
INSERT INTO user_devices_cumulated
WITH 
yesterday AS (
	SELECT 
	*
	FROM 
	user_devices_cumulated udc 
	WHERE present_date = DATE('2022-12-31')
),
today AS ( 
		SELECT
		CAST(e.user_id AS TEXT) AS user_id,
		d.browser_type,
		DATE(CAST(e.event_time AS TIMESTAMP)) AS curr_date
		FROM
				events e
			LEFT JOIN 
			devices d 
			ON
				d.device_id = e.device_id
		WHERE 
			DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-01')
			AND user_id IS NOT NULL AND browser_type IS NOT NULL 
			GROUP BY 1,2,3
)
SELECT 
	COALESCE(t.user_id,y.user_id) AS user_id,
	CASE WHEN y.present_date IS NULL 
			THEN ARRAY[t.curr_date]
		WHEN t.curr_date IS NULL THEN y.device_activity_datelist  -- WHEN a today's DAY IS inactive THEN we SKIP it AND keep ALL the previous datelist
		ELSE ARRAY[t.curr_date] || y.device_activity_datelist
		END
	AS device_activity_datelist,
	COALESCE(t.curr_date, y.present_date + INTERVAL '1 day') AS present_date, -- present_date IS the date IN the user_devices_cumulated TABLE
	COALESCE(t.browser_type, y.browser_type) AS browser_type
FROM 
today t
FULL OUTER JOIN yesterday y 
ON t.user_id = y.user_id AND t.browser_type = y.browser_type;

SELECT * 
FROM user_devices_cumulated udc; 

-------------------------START FROM HERE-------------------------- Inserting next values TREATING YESTERDAY AS 2023-01-01 AND TODAY AS 2023-01-02

SELECT * 
FROM user_devices_cumulated udc
WHERE present_date = DATE('2023-01-01'); 

-- ERRORs while inserting the values 
-- SQL Error [23505]: ERROR: duplicate key value violates unique constraint "user_devices_cumulated_pkey"Detail: Key (user_id, present_date, browser_type)=(9446887345398050000, 2023-01-03, Android) already exists.

WITH 
yesterday AS (
	SELECT 
	*
	FROM 
	user_devices_cumulated udc 
	WHERE present_date = DATE('2023-01-01') AND user_id = '9446887345398050000'
),
today AS ( 
		SELECT
		CAST(e.user_id AS TEXT) AS user_id,
		d.browser_type,
		DATE(CAST(e.event_time AS TIMESTAMP)) AS curr_date
		FROM
				events e
			LEFT JOIN 
			devices d 
			ON
				d.device_id = e.device_id
		WHERE 
			DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-03')
			AND user_id IS NOT NULL AND user_id = '9446887345398050000'
			GROUP BY 1,2,3
)
SELECT 
	*
--	COALESCE(t.user_id,y.user_id) AS user_id,
--	CASE WHEN y.present_date IS NULL 
--			THEN ARRAY[t.curr_date]
--		WHEN t.curr_date IS NULL THEN y.device_activity_datelist  -- WHEN a today's DAY IS inactive THEN we SKIP it AND keep ALL the previous datelist
--		ELSE ARRAY[t.curr_date] || y.present_date
--		END
--	AS device_activity_datelist,
--	COALESCE(t.curr_date, y.present_date + INTERVAL '1 day') AS present_date, -- present_date IS the date IN the user_devices_cumulated TABLE
--	t.browser_type AS browser_type
FROM 
today t
FULL OUTER JOIN yesterday y 
ON t.user_id = y.user_id AND t.browser_type = y.browser_type
WHERE t.user_id = '9446887345398050000';

/* running each cte give correct results. while joining it creating additional records 
 * which can be removed by using additional condition ( AND t.browser_type = y.browser_type )to the full outer join.
 * BUT WHY?
 * 
 * the FULL OUTER JOIN produces four rows because it combines each row from today with every row from yesterday, resulting in a Cartesian product for the matching user_id.

To potentially reduce the number of rows, you could consider:

    Inner Join: If you're only interested in cases where there's a match in both tables, use an INNER JOIN instead of a FULL OUTER JOIN.
    Adding a Join Condition: If you have a specific condition to join the tables (other than just the user_id), include that in the JOIN clause to filter out unnecessary combinations.

I hope this explanation clarifies the reason for the four rows in the output.
 */


------ correct number of records using addditional condition on joins for a particular user_id = 9446887345398050000

WITH 
yesterday AS (
	SELECT 
	*
	FROM 
	user_devices_cumulated udc 
	WHERE present_date = DATE('2023-01-01') AND user_id = '9446887345398050000'
),
today AS ( 
		SELECT
		CAST(e.user_id AS TEXT) AS user_id,
		d.browser_type,
		DATE(CAST(e.event_time AS TIMESTAMP)) AS curr_date
		FROM
				events e
			LEFT JOIN 
			devices d 
			ON
				d.device_id = e.device_id
		WHERE 
			DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-03')
			AND user_id IS NOT NULL AND user_id = '9446887345398050000'
			GROUP BY 1,2,3
)
SELECT 
	COALESCE(t.user_id,y.user_id) AS user_id,
	CASE WHEN y.present_date IS NULL 
			THEN ARRAY[t.curr_date]
		WHEN t.curr_date IS NULL THEN y.device_activity_datelist  -- WHEN a today's DAY IS inactive THEN we SKIP it AND keep ALL the previous datelist
		ELSE ARRAY[t.curr_date] || y.present_date
		END
	AS device_activity_datelist,
	COALESCE(t.curr_date, y.present_date + INTERVAL '1 day') AS present_date, -- present_date IS the date IN the user_devices_cumulated TABLE
	t.browser_type AS browser_type
FROM 
today t
FULL OUTER JOIN yesterday y 
ON t.user_id = y.user_id AND t.browser_type = y.browser_type
WHERE t.user_id = '9446887345398050000';

WITH 
yesterday AS (
	SELECT 
	*
	FROM 
	user_devices_cumulated udc 
	WHERE present_date = DATE('2023-01-01')
),
today AS ( 
		SELECT
		CAST(e.user_id AS TEXT) AS user_id,
		d.browser_type,
		DATE(CAST(e.event_time AS TIMESTAMP)) AS curr_date
		FROM
				events e
			LEFT JOIN 
			devices d 
			ON
				d.device_id = e.device_id
		WHERE 
			DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-02')
			AND user_id IS NOT NULL
			GROUP BY 1,2,3 
)
SELECT 
	*
FROM 
today t
FULL OUTER JOIN yesterday y 
ON t.user_id = y.user_id AND t.browser_type = y.browser_type
WHERE t.user_id = '18353350291760800000';

/* for the user id = t.user_id = '18353350291760800000' the results is below:
"user_id","browser_type","curr_date","user_id","device_activity_datelist","present_date","browser_type"
"18353350291760800000",,2023-01-02,,,,
there is no browser type in the toadys values. So filter out the records which doesn't have the browser type.
 */

WITH 
yesterday AS (
	SELECT 
	*
	FROM 
	user_devices_cumulated udc 
	WHERE present_date = DATE('2023-01-01')
),
today AS ( 
		SELECT
		CAST(e.user_id AS TEXT) AS user_id,
		d.browser_type,
		DATE(CAST(e.event_time AS TIMESTAMP)) AS curr_date
		FROM
				events e
			LEFT JOIN 
			devices d 
			ON
				d.device_id = e.device_id
		WHERE 
			DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-02')
			AND user_id IS NOT NULL AND browser_type IS NOT NULL 
			GROUP BY 1,2,3
)
SELECT 
	*
FROM 
today t
FULL OUTER JOIN yesterday y 
ON t.user_id = y.user_id AND t.browser_type = y.browser_type
WHERE t.user_id = '13547985275289400000' OR y.user_id = '13547985275289400000';

----------------------------------------------------------------------------------------------------------- FInal INSERT QUERY 
INSERT INTO user_devices_cumulated
WITH 
yesterday AS (
	SELECT 
	*
	FROM 
	user_devices_cumulated udc 
	WHERE present_date = DATE('2023-01-01')
),
today AS ( 
		SELECT
		CAST(e.user_id AS TEXT) AS user_id,
		d.browser_type,
		DATE(CAST(e.event_time AS TIMESTAMP)) AS curr_date
		FROM
				events e
			LEFT JOIN 
			devices d 
			ON
				d.device_id = e.device_id
		WHERE 
			DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-02')
			AND user_id IS NOT NULL AND browser_type IS NOT NULL 
			GROUP BY 1,2,3
)
SELECT 
	COALESCE(t.user_id,y.user_id) AS user_id,
	CASE WHEN y.present_date IS NULL 
			THEN ARRAY[t.curr_date]
		WHEN t.curr_date IS NULL THEN y.device_activity_datelist  -- WHEN a today's DAY IS inactive THEN we SKIP it AND keep ALL the previous datelist
		ELSE ARRAY[t.curr_date] || y.device_activity_datelist
		END
	AS device_activity_datelist,
	COALESCE(t.curr_date, y.present_date + INTERVAL '1 day') AS present_date, -- present_date IS the date IN the user_devices_cumulated TABLE
	COALESCE(t.browser_type, y.browser_type) AS browser_type
FROM 
today t
FULL OUTER JOIN yesterday y 
ON t.user_id = y.user_id AND t.browser_type = y.browser_type;




----------CHECKING THE NEXT VALUES TREATING YESTERDAY AS 2023-01-01 AND TODAY AS 2023-01-02
SELECT * 
FROM user_devices_cumulated udc 
WHERE present_date = DATE('2023-01-02');


----  ROlling up all the vlaues into the table TREATING YESTERDAY AS 2023-01-02 AND TODAY AS 2023-01-03


DO $$
DECLARE
    start_date DATE := '2023-01-02';
    end_date DATE := '2023-01-30';
BEGIN
    -- Loop through the date range
    WHILE start_date <= end_date LOOP
        -- Construct the dynamic SQL query
        EXECUTE format(
            'WITH 
            yesterday AS (
                SELECT 
                *
                FROM 
                user_devices_cumulated udc 
                WHERE present_date = %L
            ),
            today AS ( 
                    SELECT
                    CAST(e.user_id AS TEXT) AS user_id,
                    d.browser_type,
                    DATE(CAST(e.event_time AS TIMESTAMP)) AS curr_date
                    FROM
                            events e
                        LEFT JOIN 
                        devices d 
                        ON
                            d.device_id = e.device_id
                    WHERE 
                        DATE(CAST(e.event_time AS TIMESTAMP)) = %L
                        AND user_id IS NOT NULL AND browser_type IS NOT NULL 
                        GROUP BY 1,2,3
            )
            INSERT INTO user_devices_cumulated
            SELECT 
                COALESCE(t.user_id,y.user_id) AS user_id,
                CASE WHEN y.present_date IS NULL 
                        THEN ARRAY[t.curr_date]
                    WHEN t.curr_date IS NULL THEN y.device_activity_datelist  
                    ELSE ARRAY[t.curr_date] || y.device_activity_datelist
                    END
                AS device_activity_datelist,
                COALESCE(t.curr_date, y.present_date + INTERVAL ''1 day'') AS present_date, 
                COALESCE(t.browser_type, y.browser_type) AS browser_type
            FROM 
            today t
            FULL OUTER JOIN yesterday y 
            ON t.user_id = y.user_id AND t.browser_type = y.browser_type;',
            start_date,
            start_date + INTERVAL '1 day'
        );
        -- Increment the start_date for the next iteration
        start_date := start_date + INTERVAL '1 day';
    END LOOP;
END $$;



SELECT * 
FROM user_devices_cumulated udc 
WHERE present_date = DATE('2023-01-30');


SELECT * 
FROM user_devices_cumulated udc 
WHERE present_date = DATE('2023-01-31');









