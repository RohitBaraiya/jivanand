import 'dart:convert';
import 'dart:io';

import 'package:jivanand/main.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/configs.dart';
import 'package:jivanand/utils/constant.dart';
import 'package:jivanand/utils/model_keys.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

Map<String, String> buildHeaderTokens({required String urlType,}) {
  Map<String, String> header = {};

 // if(urlType == 'my'){
 //   header.putIfAbsent('apikey', () => '');
 // }else{
    if (appStore.isLoggedIn) header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${appStore.token}');
   // header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
    header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json; charset=utf-8');
 // }
  header.addAll(defaultHeaders());

  log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint, {required String urlType}) {
  Uri url = Uri.parse(endPoint);
  if(urlType == 'my'){
    if (!endPoint.startsWith('http')) url = Uri.parse('$BASE_URL$endPoint');
  }else {
    if (!endPoint.startsWith('http')) url = Uri.parse('$BASE_URL$endPoint');
  }
  log('URL: ${url.toString()}');

  return url;
}

Future<Response> buildHttpResponse(
    String endPoint, {required String urlType,
      HttpMethodType method = HttpMethodType.GET,
      Map? request,
      Map<String, String>? header,
    }) async {
  var headers = header ?? buildHeaderTokens(urlType: urlType);
  Uri url = buildBaseUrl(endPoint,urlType: urlType);

  Response response;

  try {
    if (method == HttpMethodType.POST) {
      // log('Request: ${jsonEncode(request)}');
      //response = await http.post(url, body: request, headers: headers);
      if(urlType == 'my'){
        response = await http.post(url, body: request, headers: headers).timeout(const Duration(seconds: 20));
      }else{
        response = await http.post(url, body: jsonEncode(request), headers: headers).timeout(const Duration(seconds: 20));
      }
    } else if (method == HttpMethodType.DELETE) {
      response = await delete(url, headers: headers).timeout(const Duration(seconds: 20));
    } else if (method == HttpMethodType.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers).timeout(const Duration(seconds: 20));
    } else {
      response = await get(url, headers: headers).timeout(const Duration(seconds: 20));
    }

    /* log('Response (${method.name}) ${response.statusCode}: ${response.body}'); */
    apiPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      hasRequest: method == HttpMethodType.POST || method == HttpMethodType.PUT,
      request: jsonEncode(request),
      statusCode: response.statusCode,
      responseBody: response.body,
      methodtype: method.name,
    );
    return response;
  } on Exception catch (e) {
    log('buildHttpResponse: $e');
    if (!await isNetworkAvailable()) {
      throw errorInternetNotAvailable;
    } else {
      throw errorSomethingWentWrong;
    }
  }
}

Future handleResponse(Response response, {HttpResponseType httpResponseType = HttpResponseType.JSON}) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  if (response.statusCode == 400) {
    throw language.badRequest;
  } else if (response.statusCode == 403) {
    throw language.forbidden;
  } else if (response.statusCode == 404) {
    throw language.pageNotFound;
  } else if (response.statusCode == 429) {
    throw language.tooManyRequests;
  } else if (response.statusCode == 500) {
    throw language.internalServerError;
  } else if (response.statusCode == 502) {
    throw language.badGateway;
  } else if (response.statusCode == 503) {
    throw language.serviceUnavailable;
  } else if (response.statusCode == 504) {
    throw language.gatewayTimeout;
  } else if (response.statusCode == 401) {
    throw 'invalid_token';
  }

  if (httpResponseType == HttpResponseType.JSON) {
    if (response.body.isJson()) {
      var body = jsonDecode(response.body);

      if (response.statusCode.isSuccessful()) {
        if (body is Map && body.containsKey('status') && !body['status']) {
          throw parseHtmlString(body['message'] ?? errorSomethingWentWrong);
        } else {
          return body;
        }
      } else {
        throw parseHtmlString(body['message'] ?? errorSomethingWentWrong);
      }
    } else {
      throw errorSomethingWentWrong;
    }
  } else if (httpResponseType == HttpResponseType.BODY_BYTES) {
    return response.bodyBytes;
  } else if (httpResponseType == HttpResponseType.FULL_RESPONSE) {
    return response;
  } else if (httpResponseType == HttpResponseType.STRING) {
    return response.body;
  } else {
    throw errorSomethingWentWrong;
  }
}

Future<Map<String, dynamic>> handleSadadResponse(Response res) async {
  if (res.body.isJson()) {
    var body = jsonDecode(res.body);

    if (res.statusCode.isSuccessful()) {
      return body;
    } else {
      throw parseHtmlString(body['error']['message']);
    }
  } else {
    throw errorSomethingWentWrong;
  }
}

Future<void> reGenerateToken() async {
  log('Regenerating Token');
  Map req = {
    UserKeys.email: appStore.userEmail,
    UserKeys.password: getStringAsync(USER_PASSWORD),
  };

  /*return await loginUser(req, isSocialLogin: !isLoginTypeUser).then((value) async {
    await appStore.setToken(value.userData!.apiToken.validate());
    appStore.setLoading(false);
  }).catchError((e) {
    log(e);
    throw e;
  });*/
}

Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl,required String urlType,}) async {
  String url = baseUrl ?? buildBaseUrl(endPoint,urlType: urlType).toString();
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest, {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  http.Response response = await http.Response.fromStream(await multiPartRequest.send());
  apiPrint(
    url: multiPartRequest.url.toString(),
    headers: jsonEncode(multiPartRequest.headers),
    request: jsonEncode(multiPartRequest.fields),
    hasRequest: true,
    statusCode: response.statusCode,
    responseBody: response.body,
    methodtype: "MultiPart",
  );

  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body);
  } else {
    try {
      if (response.body.isJson()) {
        var body = jsonDecode(response.body);
        onError?.call(body['message'] ?? errorSomethingWentWrong);
      } else {
        onError?.call(errorSomethingWentWrong);
      }
    } on Exception catch (e) {
      log(e);
      onError?.call(errorSomethingWentWrong);
    }
  }
}

void apiPrint({
  String url = "",
  String endPoint = "",
  String headers = "",
  String request = "",
  int statusCode = 0,
  String responseBody = "",
  String methodtype = "",
  bool hasRequest = false,
}) {
  log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
  log("\u001b[93mUrl: \u001B[39m $url");
  log("\u001b[93mHeader: \u001B[39m \u001b[96m$headers\u001B[39m");
  if (request.isNotEmpty) log("\u001b[93mRequest: \u001B[39m \u001b[96m$request\u001B[39m");
  log('Response ($methodtype) $statusCode: $responseBody');
  log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
}

Map<String, String> buildHeaderForStripe(String stripeKeyPayment) {
  Map<String, String> header = defaultHeaders();

  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/x-www-form-urlencoded');
  header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $stripeKeyPayment');

  return header;
}

Map<String, String> buildHeaderForSadad({String? sadadToken}) {
  Map<String, String> header = defaultHeaders();

  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json');
  if (sadadToken != null) header.putIfAbsent(HttpHeaders.authorizationHeader, () => sadadToken);

  return header;
}

Map<String, String> buildHeaderForFlutterWave(String flutterWaveSecretKey) {
  Map<String, String> header = defaultHeaders();

  header.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer $flutterWaveSecretKey");

  return header;
}

Map<String, String> buildHeaderForAirtelMoney(String accessToken, String XCountry, String XCurrency) {
  Map<String, String> header = defaultHeaders();

  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
  header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $accessToken');
  header.putIfAbsent('X-Country', () => XCountry);
  header.putIfAbsent('X-Currency', () => XCurrency);

  return header;
}

Map<String, String> defaultHeaders() {
  Map<String, String> header = {};

  header.putIfAbsent(HttpHeaders.cacheControlHeader, () => 'no-cache');
  header.putIfAbsent('Access-Control-Allow-Headers', () => '*');
  header.putIfAbsent('Access-Control-Allow-Origin', () => '*');

  return header;
}
