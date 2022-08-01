// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qm_widget/net/net_resp.dart';

class NetRequest {
  static String ERROR_UNDEFINED = "通讯异常";
  final Dio _client;
  static NetResp<T> Function<T>(DioError)? onError;
  Dio get client => _client;
  NetRequest(this._client);
  NetResp<T> handleResponse<T>(
    Response? res, {
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) {
    NetResp<T> resp = NetResp(
        code: res?.statusCode ?? -1,
        msg: res?.statusMessage ?? ERROR_UNDEFINED);
    if (respConvertFunc != null) {
      return respConvertFunc.call(res);
    }
    if ((res?.statusCode ?? -1) == 200) {
      Map data = res?.data ?? {};
      if (convertFunc != null) {
        return convertFunc.call(data);
      } else {
        resp.data = data as T;
      }
    }
    return resp;
  }

  Future<NetResp<T>> handleError<T>(DioError e) async {
    return (NetRequest.onError ??
            (it) {
              String msg = it.message;
              switch (it.type) {
                case DioErrorType.sendTimeout:
                  msg = "发送超时";
                  break;
                case DioErrorType.receiveTimeout:
                  msg = "接收超时";
                  break;
                case DioErrorType.cancel:
                  msg = "请求被取消";
                  break;
                case DioErrorType.connectTimeout:
                  msg = "连接超时";
                  break;
                case DioErrorType.response:
                  break;
                case DioErrorType.other:
                  msg = "${it.error}";
                  break;
              }
              debugPrint("handleError:$it");
              return NetResp(msg: msg);
            })
        .call(e);
  }

  Future<NetResp<T>> post<T>(
    String url, {
    required dynamic params,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) async {
    debugPrint("client:$client");
    Response<Map>? res;
    try {
      res = await client.post<Map>(
        url,
        data: params,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e) {
      debugPrint("Http Error:$url");
      debugPrint("Http Error:$e");
      if (e is DioError) {
        return handleError(e);
      }
      return NetResp(msg: ERROR_UNDEFINED);
    }

    return handleResponse<T>(res,
        convertFunc: convertFunc, respConvertFunc: respConvertFunc);
  }

  Future<NetResp<T>> put<T>(
    String url, {
    required dynamic params,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) async {
    Response<Map>? res;
    try {
      res = await client.put<Map>(
        url,
        data: params,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e) {
      debugPrint("Http Error:$url");
      debugPrint("Http Error:$e");
      if (e is DioError) {
        return handleError(e);
      }
      return NetResp(msg: ERROR_UNDEFINED);
    }

    return handleResponse<T>(res,
        convertFunc: convertFunc, respConvertFunc: respConvertFunc);
  }

  Future<NetResp<T>> form<T>(
    String url, {
    required dynamic params,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    Response? res;
    try {
      res = await client.post(url,
          data: params, //FormData.fromMap(params),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
          options: Options(
              headers: headers,
              followRedirects: false,
              validateStatus: (code) => (code ?? 0) < 500,
              contentType:
                  ContentType.parse("application/x-www-form-urlencoded")
                      .value));
    } catch (e) {
      debugPrint("Http Error:$e");
    }
    return handleResponse<T>(res,
        convertFunc: convertFunc, respConvertFunc: respConvertFunc);
  }

  Future<NetResp<T>> download<T>(
    String url,
    String savePath, {
    CancelToken? cancelToken,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
    ProgressCallback? onReceiveProgress,
  }) async {
    Response? res;
    try {
      res = await client.download(url, savePath,
          queryParameters: params,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          options: Options(
            headers: headers,
          ));
    } catch (e) {
      debugPrint("Http Error:$e");
    }
    return handleResponse<T>(res,
        convertFunc: convertFunc, respConvertFunc: respConvertFunc);
  }

  Future<NetResp<T>> get<T>(
    String url, {
    required Map<String, dynamic> params,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) async {
    Response? res;
    try {
      res = await client.get(url,
          queryParameters: params, options: Options(headers: headers));
    } catch (e) {
      debugPrint("Http Error:$e");
    }
    return handleResponse<T>(res,
        convertFunc: convertFunc, respConvertFunc: respConvertFunc);
  }

  Future<NetResp<T>> delete<T>(
    String url, {
    required Map<String, dynamic> params,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) async {
    Response? res;
    try {
      res = await client.delete(url,
          queryParameters: params, options: Options(headers: headers));
    } catch (e) {
      debugPrint("Http Error:$e");
    }
    return handleResponse<T>(res,
        convertFunc: convertFunc, respConvertFunc: respConvertFunc);
  }
}
