import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zdy_flutter/net/Api.dart';

class NetUtil {
  static final debug = true;
  static BuildContext context = null;

  /// 服务器路径
  static final host = Api.BaseUrl;
  static final baseUrl = host + '/v2/';

  ///  基础信息配置
  static final Dio _dio = new Dio(new BaseOptions(
      method: "get",
      headers: {"token": getToken()},
      baseUrl: host,
      connectTimeout: 5000,
      receiveTimeout: 5000,
      followRedirects: true));

  /// 代理设置，方便抓包来进行接口调节

//  static void setProxy() {
//    _dio.onHttpClientCreate = (HttpClient client) {
//      // config the http client
//      client.findProxy = (uri) {
//        //proxy all request to localhost:8888
//        return "PROXY 192.168.1.151:8888";
//      };
//      // you can also create a new HttpClient to dio
//      // return new HttpClient();
//    };
//  }

  static String token;

  static final LogicError unknowError = LogicError(-1, "未知异常");

  static Future<Map<String, dynamic>> getJson<T>(
          String uri, Map<String, dynamic> paras) =>
      _httpJson("get", uri, data: paras).then(logicalErrorTransform);

  static Future<Map<String, dynamic>> getForm<T>(
          String uri, Map<String, dynamic> paras) =>
      _httpJson("get", uri, data: paras, dataIsJson: false)
          .then(logicalErrorTransform);

  /// 表单方式的post
  static Future<Map<String, dynamic>> postForm<T>(
          String uri, Map<String, dynamic> paras) =>
      _httpJson("post", uri, data: paras, dataIsJson: false)
          .then(logicalErrorTransform);

  /// requestBody (json格式参数) 方式的 post
  static Future<Map<String, dynamic>> postJson(
          String uri, Map<String, dynamic> body) =>
      _httpJson("post", uri, data: body).then(logicalErrorTransform);

  static Future<Map<String, dynamic>> deleteJson<T>(
          String uri, Map<String, dynamic> body) =>
      _httpJson("delete", uri, data: body).then(logicalErrorTransform);

  /// requestBody (json格式参数) 方式的 put
  static Future<Map<String, dynamic>> putJson<T>(
          String uri, Map<String, dynamic> body) =>
      _httpJson("put", uri, data: body).then(logicalErrorTransform);

  /// 表单方式的 put
  static Future<Map<String, dynamic>> putForm<T>(
          String uri, Map<String, dynamic> body) =>
      _httpJson("put", uri, data: body, dataIsJson: false)
          .then(logicalErrorTransform);

  /// 文件上传  返回json数据为字符串
  static Future<T> putFile<T>(String uri, String filePath) {
    var name =
        filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    FormData formData = new FormData.from({
      "multipartFile": new UploadFileInfo(new File(filePath), name,
          contentType: ContentType.parse("image/$suffix"))
    });

    var enToken = token == null ? "" : Uri.encodeFull(token);
    return _dio
        .put<Map<String, dynamic>>("$uri?token=$enToken", data: formData)
        .then(logicalErrorTransform);
  }

  static Future<Response<Map<String, dynamic>>> _httpJson(
      String method, String uri,
      {Map<String, dynamic> data, bool dataIsJson = true}) {
    Options op =
        new Options(contentType: ContentType.parse("application/json"));
    op.headers = {"token": "test"};
    op.method = method;

    if (debug) {
      print('<net url>------$uri');
      print('<net method>------$method');
      print('<net params>------$data');
      print('<net header>------' + _dio.options.headers.toString());
    }

    if (method == "post") {
      return _dio.request<Map<String, dynamic>>(uri, data: data, options: op);
    } else {
      return _dio.request<Map<String, dynamic>>(uri,
          queryParameters: data, options: op);
    }
  }

  /// 对请求返回的数据进行统一的处理
  /// 如果成功则将我们需要的数据返回出去，否则进异常处理方法，返回异常信息
  static Future<T> logicalErrorTransform<T>(
      Response<Map<String, dynamic>> resp) {
    print('<net resp>------$resp');
    if (resp.data != null) {
      if (resp.data["errorCode"] == "100") {
        T realData = resp.data["data"];
        return Future.value(realData);
      }
    }

    if (debug) {
      print('resp--------$resp');
      print('resp.data--------${resp.data}');
    }

    LogicError error;
    if (resp.data != null && resp.data["errorCode"] != 100) {
      if (resp.data['data'] != null) {
        /// 失败时  错误提示在 data中时
        /// 收到token过期时  直接进入登录页面
        Map<String, dynamic> realData = resp.data["data"];
        error = new LogicError(resp.data["errorCode"], realData['errorMsg']);
      } else {
        /// 失败时  错误提示在 message中时
        error = new LogicError(resp.data["errorCode"], resp.data["errorMsg"]);
      }
    } else {
      error = unknowError;
    }
    return Future.error(error);
  }

  ///获取授权token
  static getToken() {
//    String token = await LocalStorage.get(LocalStorage.TOKEN_KEY);
//    return token;
    return "test";
  }
}

/// 统一异常类
class LogicError {
  num errorCode;
  String msg;

  LogicError(errorCode, msg) {
    this.errorCode = errorCode;
    this.msg = msg;
  }
}
