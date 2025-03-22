import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/src/model/pluto_column.dart';
import 'package:pluto_grid/src/model/pluto_column_type.dart';
import 'package:pluto_grid/src/pluto_grid.dart';

extension DecimalFormat on Decimal {
  String format([int decimalDigits = 2]) => DecimalFormatter(NumberFormat.decimalPatternDigits(locale: "en_IN", decimalDigits: decimalDigits)).format(this);
}

class PlutoDecimalColumn extends PlutoColumn {
  PlutoDecimalColumn({
    required String title,
    required String field,
    PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.start,
    PlutoColumnTextAlign titleTextAlign = PlutoColumnTextAlign.start,
    int decimalDigits = 2,
    bool readOnly = false,
    double width = PlutoGridSettings.columnWidth,
    bool hide = false,
    PlutoColumnFooterRenderer? footerRenderer,
  }) : super(
    title: title,
    field: field,
    textAlign: textAlign,
    titleTextAlign: titleTextAlign,
    type: PlutoColumnType.text(),
    width: width,
    hide: hide,
    readOnly: readOnly,
    footerRenderer: footerRenderer,
    renderer: (rendererContext) {
      final value = rendererContext.cell.value;
      final Decimal decimalValue = value is Decimal ? value : Decimal.zero;
      return Text(
        decimalValue.format(decimalDigits),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: rendererContext.stateManager.configuration.style.cellTextStyle,
        textAlign: rendererContext.column.textAlign.value,
      );
    },
  );
}