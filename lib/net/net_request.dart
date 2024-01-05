// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qm_widget/net/net_resp.dart';

class NetRequest {
  static int codeBadResponse = -1;
  static int codeSendTimeout = -1001;
  static int codeReceiveTimeout = -1002;
  static int codeCancel = -1003;
  static int codeConnectionError = -1004;
  static int codeConnectionTimeout = -1005;
  static int codeBadCertificate = -1006;
  static int codeUnknown = -1007;
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
      if (convertFunc != null) {
        return convertFunc.call(res?.data);
      } else {
        resp.data = res?.data as T;
      }
    } else {
      if (convertFunc != null) {
        return convertFunc.call({
          "code": res?.statusCode ?? -1,
          "message": res?.statusMessage ?? "",
        });
      }
    }
    return resp;
  }

  Future<NetResp<T>> handleError<T>(
    DioException e, {
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) async {
    return (NetRequest.onError ??
            (DioException it) {
              String msg = it.message ?? "";
              int code = -1;
              switch (it.type) {
                case DioExceptionType.sendTimeout:
                  msg = "发送超时";
                  code = codeSendTimeout;
                  break;
                case DioExceptionType.receiveTimeout:
                  msg = "接收超时";
                  code = codeReceiveTimeout;
                  break;
                case DioExceptionType.cancel:
                  msg = "请求被取消";
                  code = codeCancel;
                  break;
                case DioExceptionType.connectionError:
                  msg = "连接错误[${it.error}]";
                  code = codeConnectionError;
                  break;
                case DioExceptionType.connectionTimeout:
                  msg = "连接超时";
                  code = codeConnectionTimeout;
                  break;
                case DioExceptionType.badCertificate:
                  msg = "证书错误";
                  code = codeBadCertificate;
                  break;
                case DioExceptionType.badResponse:
                  return handleResponse(
                    it.response,
                    convertFunc: convertFunc,
                    respConvertFunc: respConvertFunc,
                  );
                case DioExceptionType.unknown:
                  msg = "${it.error}";
                  code = codeUnknown;
                  break;
              }
              debugPrint("handleError:$it");
              return NetResp<T>(msg: msg, code: code);
            })
        .call(e);
  }

  Future<NetResp<T>> post<T>(
    String url, {
    required dynamic params,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) async {
    debugPrint("client:$client");
    Response<Map>? res;
    try {
      res = await client.post<Map>(
        url,
        cancelToken: cancelToken,
        data: params,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e) {
      if (e is DioException) {
        return handleError(e,
            convertFunc: convertFunc, respConvertFunc: respConvertFunc);
      }
      return NetResp(msg: ERROR_UNDEFINED);
    }

    return handleResponse<T>(res,
        convertFunc: convertFunc, respConvertFunc: respConvertFunc);
  }

  Future<NetResp<T>> put<T>(
    String url, {
    required dynamic params,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) async {
    Response<Map>? res;
    try {
      res = await client.put<Map>(
        url,
        cancelToken: cancelToken,
        data: params,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e) {
      if (e is DioException) {
        return handleError(e,
            convertFunc: convertFunc, respConvertFunc: respConvertFunc);
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
      if (e is DioException) {
        return handleError(e,
            convertFunc: convertFunc, respConvertFunc: respConvertFunc);
      }
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
            responseType: ResponseType.stream,
            followRedirects: false,
            headers: headers,
          ));
    } catch (e) {
      if (e is DioException) {
        return handleError(e,
            convertFunc: convertFunc, respConvertFunc: respConvertFunc);
      }
    }
    return handleResponse<T>(res,
        convertFunc: convertFunc, respConvertFunc: respConvertFunc);
  }

  Future<NetResp<T>> get<T>(
    String url, {
    required Map<String, dynamic> params,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) async {
    Response? res;
    try {
      res = await client.get(url,
          cancelToken: cancelToken,
          queryParameters: params,
          options: Options(headers: headers));
    } catch (e) {
      if (e is DioException) {
        return handleError(e,
            convertFunc: convertFunc, respConvertFunc: respConvertFunc);
      }
    }
    return handleResponse<T>(res,
        convertFunc: convertFunc, respConvertFunc: respConvertFunc);
  }

  Future<NetResp<T>> delete<T>(
    String url, {
    required Map<String, dynamic> params,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) async {
    Response? res;
    try {
      res = await client.delete(url,
          cancelToken: cancelToken,
          queryParameters: params,
          options: Options(headers: headers));
    } catch (e) {
      if (e is DioException) {
        return handleError(e,
            convertFunc: convertFunc, respConvertFunc: respConvertFunc);
      }
    }
    return handleResponse<T>(res,
        convertFunc: convertFunc, respConvertFunc: respConvertFunc);
  }
}
