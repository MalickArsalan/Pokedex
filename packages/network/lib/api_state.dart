import 'dart:io';

import 'package:equatable/equatable.dart';

import 'custom_exception.dart';

class ApiState<T> extends Equatable {
  const ApiState({
    this.response,
    this.apiResponseState = ApiResponseState.idle,
    this.e,
  });

  final T? response;
  final CustomException? e;
  final ApiResponseState apiResponseState;

  @override
  List<Object?> get props => [response, apiResponseState, e];

  ApiState<T> copyWith(
          {T? response,
          CustomException? e,
          ApiResponseState? apiResponseState}) =>
      ApiState(
        response: response ?? this.response,
        apiResponseState: apiResponseState ?? this.apiResponseState,
        e: e ?? this.e,
      );
}

Future<ApiState<T>> apiCall<T>(
  Future<T> Function() f,
) async {
  try {
    final response = await f();
    return ApiState<T>(
      response: response,
      apiResponseState: ApiResponseState.success,
    );
  } on SocketException catch (_) {
    return ApiState<T>(
      e: const CustomException('Unable to connect to the internet.'),
      apiResponseState: ApiResponseState.socketError,
    );
  } on Exception catch (e) {
    return ApiState<T>(
      e: CustomException(e.toString()),
      apiResponseState: ApiResponseState.genericError,
    );
  }
}

enum ApiResponseState {
  /// Used when the form has not been sent yet.
  idle,

  /// Used to disable all buttons and add a progress indicator to the main one.
  inProgress,

  /// Used to close the screen and navigate back to the caller screen.
  success,

  /// Used to display a generic snack bar saying that an error has occurred
  genericError,

  // Used to display a socket error snack bar saying that socket error occurs
  socketError
}
