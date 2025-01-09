import 'package:flutter/material.dart';

import '../main.dart';

const APP_NAME = 'Jivanand';
const APP_NAME_TAG_LINE = 'JITO JIVANAND AYURVEDA';
var defaultPrimaryColor = const Color(0xFF3C4930);

// Don't add slash at the end of the url



const DEFAULT_LANGUAGE = 'en';

/// You can change this to your Provider App package name
/// This will be used in Registered As Partner in Sign In Screen where your users can redirect to the Play/App Store for Provider App
/// You can specify in Admin Panel, These will be used if you don't specify in Admin Panel
const PROVIDER_PACKAGE_NAME = 'com.iqonic.provider';
const IOS_LINK_FOR_PARTNER = "https://apps.apple.com/in/app/handyman-provider-app/id1596025324";

const IOS_LINK_FOR_USER = 'https://apps.apple.com/us/app/handyman-service-user/id1591427211';

const DASHBOARD_AUTO_SLIDER_SECOND = 3;
const OTP_TEXT_FIELD_LENGTH = 6;

/*const DOMAIN_URL = 'https://dresoul.unicommerce.com/';*/
const BASE_URL1 = 'https://jivan.veercreation.co.in/api/';
const BASE_URL2 = 'http://192.168.11.10:8000/api/';
var BASE_URL = isTestMode ? BASE_URL2 : BASE_URL1;
/*
const BASE_URL_MY = 'https://vlpark.in/index.php/Api_bakery/';
const BASE_URL_MY_IMG = 'https://vlpark.in/uploads/Bakery/';
const BASE_URL_MY_CAT_IMG = 'https://vlpark.in/uploads/Bakery/Category/';
const BASE_URL_MY_PRODUCT_IMG = 'https://vlpark.in/uploads/Bakery/Product/';*/


var BASE_URL_PRODUCT_IMG1 = 'http://192.168.11.10:8000/storage/images/';
var BASE_URL_PRODUCT_IMG2 = 'https://veercreation.co.in/storage/images/';
var BASE_URL_PRODUCT_IMG = isTestMode ? BASE_URL_PRODUCT_IMG1 : BASE_URL_PRODUCT_IMG2;
var BASE_URL_PRODUCT_THUMB_IMG1 = 'http://192.168.11.10:8000/storage/thumbnail/';
var BASE_URL_PRODUCT_THUMB_IMG2 = 'https://veercreation.co.in/storage/thumbnail/';
var BASE_URL_PRODUCT_THUMB_IMG = isTestMode ? BASE_URL_PRODUCT_THUMB_IMG1 : BASE_URL_PRODUCT_THUMB_IMG2;



const TERMS_CONDITION_URL = 'https://iqonic.design/terms-of-use/';
const PRIVACY_POLICY_URL = 'https://iqonic.design/privacy-policy/';
const HELP_AND_SUPPORT_URL = 'https://iqonic.design/privacy-policy/';
const REFUND_POLICY_URL = 'https://iqonic.design/licensing-terms-more/#refund-policy';
const INQUIRY_SUPPORT_EMAIL = 'hello@iqonic.design';

/// You can add help line number here for contact. It's demo number
const HELP_LINE_NUMBER = '+15265897485';

//Airtel Money Payments
///It Supports ["UGX", "NGN", "TZS", "KES", "RWF", "ZMW", "CFA", "XOF", "XAF", "CDF", "USD", "XAF", "SCR", "MGA", "MWK"]
const AIRTEL_CURRENCY_CODE = "MWK";
const AIRTEL_COUNTRY_CODE = "MW";
const AIRTEL_TEST_BASE_URL = 'https://openapiuat.airtel.africa/'; //Test Url
const AIRTEL_LIVE_BASE_URL = 'https://openapi.airtel.africa/'; // Live Url

/// PAYSTACK PAYMENT DETAIL
const PAYSTACK_CURRENCY_CODE = 'NGN';

/// Nigeria Currency

/// STRIPE PAYMENT DETAIL
const STRIPE_MERCHANT_COUNTRY_CODE = 'IN';
const STRIPE_CURRENCY_CODE = 'INR';

/// RAZORPAY PAYMENT DETAIL
const RAZORPAY_CURRENCY_CODE = 'INR';

/// PAYPAL PAYMENT DETAIL
const PAYPAL_CURRENCY_CODE = 'USD';

/// SADAD PAYMENT DETAIL
const SADAD_API_URL = 'https://api-s.sadad.qa';
const SADAD_PAY_URL = "https://d.sadad.qa";

DateTime todayDate = DateTime(2022, 8, 24);


//Chat Module File Upload Configs
const chatFilesAllowedExtensions = [
  'jpg', 'jpeg', 'png', 'gif', 'webp', // Images
  'pdf', 'txt', // Documents
  'mkv', 'mp4', // Video
  'mp3', // Audio
];

const max_acceptable_file_size = 5; //Size in Mb
