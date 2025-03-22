import 'package:collection/collection.dart'
    show IterableNumberExtension, IterableExtension;
import 'package:decimal/decimal.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PlutoAggregateHelper {
  static num sum({
    required Iterable<PlutoRow> rows,
    required PlutoColumn column,
    PlutoAggregateFilter? filter,
    int? decimalDigits,
  }) {
    if (column.type is! PlutoColumnTypeWithNumberFormat ||
        !_hasColumnField(rows: rows, column: column)) {
      return 0;
    }

    final numberColumn = column.type as PlutoColumnTypeWithNumberFormat;

    final foundItems = filter != null
        ? rows.where((row) => filter(row.cells[column.field]!))
        : rows;

    final Iterable<num> numbers = foundItems.map(
      (e) => e.cells[column.field]!.value,
    );

    return numberColumn.toNumber(numberColumn.applyFormat(numbers.sum));
  }

  static num average({
    required Iterable<PlutoRow> rows,
    required PlutoColumn column,
    PlutoAggregateFilter? filter,
    int? decimalDigits,
  }) {
    if (column.type is! PlutoColumnTypeWithNumberFormat ||
        !_hasColumnField(rows: rows, column: column)) {
      return 0;
    }

    final numberColumn = column.type as PlutoColumnTypeWithNumberFormat;

    final foundItems = filter != null
        ? rows.where((row) => filter(row.cells[column.field]!))
        : rows;

    final Iterable<num> numbers = foundItems.map(
      (e) => e.cells[column.field]!.value,
    );

    return numberColumn.toNumber(numberColumn.applyFormat(numbers.average));
  }

  static num? min({
    required Iterable<PlutoRow> rows,
    required PlutoColumn column,
    PlutoAggregateFilter? filter,
    int? decimalDigits,
  }) {
    if (column.type is! PlutoColumnTypeWithNumberFormat ||
        !_hasColumnField(rows: rows, column: column)) {
      return null;
    }

    final foundItems = filter != null
        ? rows.where((row) => filter(row.cells[column.field]!))
        : rows;

    final Iterable<num> mapValues = foundItems.map(
      (e) => e.cells[column.field]!.value,
    );

    return mapValues.minOrNull;
  }

  static num? max({
    required Iterable<PlutoRow> rows,
    required PlutoColumn column,
    PlutoAggregateFilter? filter,
    int? decimalDigits,
  }) {
    if (column.type is! PlutoColumnTypeWithNumberFormat ||
        !_hasColumnField(rows: rows, column: column)) {
      return null;
    }

    final foundItems = filter != null
        ? rows.where((row) => filter(row.cells[column.field]!))
        : rows;

    final Iterable<num> mapValues = foundItems.map(
      (e) => e.cells[column.field]!.value,
    );

    return mapValues.maxOrNull;
  }

  static int count({
    required Iterable<PlutoRow> rows,
    required PlutoColumn column,
    PlutoAggregateFilter? filter,
    int? decimalDigits,
  }) {
    if (!_hasColumnField(rows: rows, column: column)) {
      return 0;
    }

    final foundItems = filter != null
        ? rows.where((row) => filter(row.cells[column.field]!))
        : rows;

    return foundItems.length;
  }

  static num? decimalSum({
    required Iterable<PlutoRow> rows,
    required PlutoColumn column,
    PlutoAggregateFilter? filter,
    required int decimalDigits,
  }) {
    if (!_hasColumnField(rows: rows, column: column)) {
      return 0;
    }

    final foundItems = filter != null
        ? rows.where((row) => filter(row.cells[column.field]!))
        : rows;


    final Decimal sum = foundItems.fold(Decimal.zero, (p, c) {
      final value = c.cells[column.field]!.value;
      final Decimal decimalValue = value is Decimal ? value : Decimal.zero;
      return p + decimalValue;
    });

    return num.parse(sum.toStringAsFixed(decimalDigits));
  }

  static bool _hasColumnField({
    required Iterable<PlutoRow> rows,
    required PlutoColumn column,
  }) {
    return rows.firstOrNull?.cells.containsKey(column.field) == true;
  }
}
