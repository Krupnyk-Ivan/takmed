// Mocks generated by Mockito 5.4.6 from annotations
// in takmed/test/stats_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:sqflite/sqflite.dart' as _i2;
import 'package:takmed/database/stats_db_helper.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDatabase_0 extends _i1.SmartFake implements _i2.Database {
  _FakeDatabase_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [StatsDatabaseHelper].
///
/// See the documentation for Mockito's code generation for more information.
class MockStatsDatabaseHelper extends _i1.Mock
    implements _i3.StatsDatabaseHelper {
  MockStatsDatabaseHelper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Database> get database =>
      (super.noSuchMethod(
            Invocation.getter(#database),
            returnValue: _i4.Future<_i2.Database>.value(
              _FakeDatabase_0(this, Invocation.getter(#database)),
            ),
          )
          as _i4.Future<_i2.Database>);

  @override
  _i4.Future<List<Map<String, dynamic>>> getAllStats() =>
      (super.noSuchMethod(
            Invocation.method(#getAllStats, []),
            returnValue: _i4.Future<List<Map<String, dynamic>>>.value(
              <Map<String, dynamic>>[],
            ),
          )
          as _i4.Future<List<Map<String, dynamic>>>);

  @override
  _i4.Future<void> insertStat(Map<String, dynamic>? stat) =>
      (super.noSuchMethod(
            Invocation.method(#insertStat, [stat]),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<List<Map<String, dynamic>>> getStats() =>
      (super.noSuchMethod(
            Invocation.method(#getStats, []),
            returnValue: _i4.Future<List<Map<String, dynamic>>>.value(
              <Map<String, dynamic>>[],
            ),
          )
          as _i4.Future<List<Map<String, dynamic>>>);

  @override
  _i4.Future<List<Map<String, dynamic>>> getStatsByTestId(int? testId) =>
      (super.noSuchMethod(
            Invocation.method(#getStatsByTestId, [testId]),
            returnValue: _i4.Future<List<Map<String, dynamic>>>.value(
              <Map<String, dynamic>>[],
            ),
          )
          as _i4.Future<List<Map<String, dynamic>>>);

  @override
  void getStatsByTest(int? testId) => super.noSuchMethod(
    Invocation.method(#getStatsByTest, [testId]),
    returnValueForMissingStub: null,
  );

  @override
  void onTestCompleted(int? userId, int? testId, int? score, int? timeTaken) =>
      super.noSuchMethod(
        Invocation.method(#onTestCompleted, [userId, testId, score, timeTaken]),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<List<Map<String, dynamic>>> getStatsByUserId(int? userId) =>
      (super.noSuchMethod(
            Invocation.method(#getStatsByUserId, [userId]),
            returnValue: _i4.Future<List<Map<String, dynamic>>>.value(
              <Map<String, dynamic>>[],
            ),
          )
          as _i4.Future<List<Map<String, dynamic>>>);
}
