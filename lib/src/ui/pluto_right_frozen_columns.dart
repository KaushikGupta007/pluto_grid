import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PlutoRightFrozenColumns extends PlutoStatefulWidget {
  @override
  final PlutoGridStateManager stateManager;

  const PlutoRightFrozenColumns(
    this.stateManager, {
    Key? key,
  }) : super(key: key);

  @override
  PlutoRightFrozenColumnsState createState() => PlutoRightFrozenColumnsState();
}

abstract class _PlutoRightFrozenColumnsStateWithChange
    extends PlutoStateWithChange<PlutoRightFrozenColumns> {
  bool? _showColumnGroups;

  List<PlutoColumn>? _columns;

  List<PlutoColumnGroupPair>? _columnGroups;

  int? _itemCount;

  @override
  bool allowStream(event) {
    return !(event is PlutoSetCurrentCellStreamNotifierEvent ||
        event is PlutoVisibilityColumnStreamNotifierEvent);
  }

  @override
  void onChange(event) {
    resetState((update) {
      _showColumnGroups = update<bool?>(
        _showColumnGroups,
        widget.stateManager.showColumnGroups,
      );

      _columns = update<List<PlutoColumn>?>(
        _columns,
        widget.stateManager.rightFrozenColumns,
        compare: listEquals,
      );

      if (changed && _showColumnGroups == true) {
        _columnGroups = widget.stateManager.separateLinkedGroup(
          columnGroupList: widget.stateManager.refColumnGroups!,
          columns: _columns!,
        );
      }

      _itemCount = update<int?>(_itemCount, _getItemCount());
    });
  }

  int _getItemCount() {
    return _showColumnGroups == true ? _columnGroups!.length : _columns!.length;
  }
}

class PlutoRightFrozenColumnsState
    extends _PlutoRightFrozenColumnsStateWithChange {
  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
        delegate: MainColumnLayoutDelegate(widget.stateManager, _columns!),
        children: _showColumnGroups == true
            ? _columnGroups!
                .map((PlutoColumnGroupPair e) => LayoutId(
                      id: e.key,
                      child: PlutoBaseColumnGroup(
                        stateManager: widget.stateManager,
                        columnGroup: e,
                        depth: widget.stateManager.columnGroupDepth(
                          widget.stateManager.refColumnGroups!,
                        ),
                      ),
                    ))
                .toList()
            : _columns!
                .map((e) => LayoutId(
                      id: e.field,
                      child: PlutoBaseColumn(
                        stateManager: widget.stateManager,
                        column: e,
                      ),
                    ))
                .toList());
  }
}
