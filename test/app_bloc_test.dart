import 'dart:typed_data' show Uint8List;
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiblocproviderexampleapp/bloc/app_bloc.dart';
import 'package:multiblocproviderexampleapp/bloc/app_state.dart';
import 'package:multiblocproviderexampleapp/bloc/bloc_events.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

final url1Data = 'url1'.toUint8List();
final url2Data = 'url2'.toUint8List();

enum Errors { dummy }

void main() {
  blocTest<AppBloc, AppState>(
    'Initial state of the bloc should be empty',
    build: () => AppBloc(urls: []),
    verify: (appBloc) => expect(appBloc.state, const AppState.empty()),
  );

  // load valid data and compare states
  blocTest<AppBloc, AppState>(
    'Test the ability to load a URL',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(url1Data),
    ),
    act: (appBloc) => appBloc.add(const LoadNextUrlEvent()),
    expect: () => [
      const AppState(isLoading: true, data: null, error: null),
      AppState(isLoading: false, data: url1Data, error: null),
    ],
  );

  // test throwing an error from url loader
  blocTest<AppBloc, AppState>(
    'Throw an error in url loader and catch it',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.error(Errors.dummy),
    ),
    act: (appBloc) => appBloc.add(const LoadNextUrlEvent()),
    expect: () => [
      const AppState(isLoading: true, data: null, error: null),
      const AppState(isLoading: false, data: null, error: Errors.dummy),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Test the ability to load more than one URL',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(url2Data),
    ),
    act: (appBloc) {
      appBloc.add(
        const LoadNextUrlEvent(),
      );
      appBloc.add(
        const LoadNextUrlEvent(),
      );
    },
    expect: () => [
      const AppState(isLoading: true, data: null, error: null),
      AppState(isLoading: false, data: url2Data, error: null),
      const AppState(isLoading: true, data: null, error: null),
      AppState(isLoading: false, data: url2Data, error: null),
    ],
  );
}
