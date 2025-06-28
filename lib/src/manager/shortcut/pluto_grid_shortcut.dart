import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pluto_grid/pluto_grid.dart';

/// Class for setting shortcut actions.
///
/// Defaults to [PlutoGridShortcut.defaultActions] if not passing [actions].
class PlutoGridShortcut {
  const PlutoGridShortcut({
    Map<ShortcutActivator, PlutoGridShortcutAction>? actions,
  }) : _actions = actions;

  /// Custom shortcuts and actions.
  ///
  /// When the shortcut set in [ShortcutActivator] is input,
  /// the [PlutoGridShortcutAction.execute] method is executed.
  Map<ShortcutActivator, PlutoGridShortcutAction> get actions =>
      _actions ?? defaultActions;

  final Map<ShortcutActivator, PlutoGridShortcutAction>? _actions;

  /// If the shortcut registered in [actions] matches,
  /// the action for the shortcut is executed.
  ///
  /// If there is no matching shortcut and returns false ,
  /// the default shortcut behavior is processed.
  bool handle({
    required PlutoKeyManagerEvent keyEvent,
    required PlutoGridStateManager stateManager,
    required HardwareKeyboard state,
  }) {
    for (final action in actions.entries) {
      if (action.key.accepts(keyEvent.event, state)) {
        action.value.execute(keyEvent: keyEvent, stateManager: stateManager);
        return true;
      }
    }

    return false;
  }

  bool shortcutHasAction({
    required PlutoKeyManagerEvent keyEvent,
    required HardwareKeyboard state
  }) {
    var handledActions = actions.entries.where((action) => action.key.accepts(keyEvent.event, state));
    return handledActions.isNotEmpty;
  }

  static final Map<ShortcutActivator, PlutoGridShortcutAction> defaultActions =
  {
    // Move cell focus
    const SingleActivator(LogicalKeyboardKey.arrowLeft):
    const PlutoGridActionMoveCellFocus(PlutoMoveDirection.left),
    const SingleActivator(LogicalKeyboardKey.arrowRight):
    const PlutoGridActionMoveCellFocus(PlutoMoveDirection.right),
    const SingleActivator(LogicalKeyboardKey.arrowUp):
    const PlutoGridActionMoveCellFocus(PlutoMoveDirection.up),
    const SingleActivator(LogicalKeyboardKey.arrowDown):
    const PlutoGridActionMoveCellFocus(PlutoMoveDirection.down),
    // Move selected cell focus
    const SingleActivator(LogicalKeyboardKey.arrowLeft, shift: true):
    const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.left),
    const SingleActivator(LogicalKeyboardKey.arrowRight, shift: true):
    const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.right),
    const SingleActivator(LogicalKeyboardKey.arrowUp, shift: true):
    const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.up),
    const SingleActivator(LogicalKeyboardKey.arrowDown, shift: true):
    const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.down),
    // Move cell focus by page vertically
    const SingleActivator(LogicalKeyboardKey.pageUp):
    const PlutoGridActionMoveCellFocusByPage(PlutoMoveDirection.up),
    const SingleActivator(LogicalKeyboardKey.pageDown):
    const PlutoGridActionMoveCellFocusByPage(PlutoMoveDirection.down),
    // Move cell focus by page vertically
    const SingleActivator(LogicalKeyboardKey.pageUp, shift: true):
    const PlutoGridActionMoveSelectedCellFocusByPage(PlutoMoveDirection.up),
    const SingleActivator(LogicalKeyboardKey.pageDown, shift: true):
    const PlutoGridActionMoveSelectedCellFocusByPage(
        PlutoMoveDirection.down),
    // Move page when pagination is enabled
    const SingleActivator(LogicalKeyboardKey.pageUp, alt: true):
    const PlutoGridActionMoveCellFocusByPage(PlutoMoveDirection.left),
    const SingleActivator(LogicalKeyboardKey.pageDown, alt: true):
    const PlutoGridActionMoveCellFocusByPage(PlutoMoveDirection.right),
    // Default tab key action
    const SingleActivator(LogicalKeyboardKey.tab): const PlutoGridActionDefaultTab(),
    const SingleActivator(LogicalKeyboardKey.tab, shift: true):
    const PlutoGridActionDefaultTab(),
    // Default enter key action
    const SingleActivator(LogicalKeyboardKey.enter):
    const PlutoGridActionDefaultEnterKey(),
    const SingleActivator(LogicalKeyboardKey.numpadEnter):
    const PlutoGridActionDefaultEnterKey(),
    const SingleActivator(LogicalKeyboardKey.enter, shift: true):
    const PlutoGridActionDefaultEnterKey(),
    // Default escape key action
    // LogicalKeySet(LogicalKeyboardKey.escape):
    //     const PlutoGridActionDefaultEscapeKey(),
    // Move cell focus to edge
    const SingleActivator(LogicalKeyboardKey.home):
    const PlutoGridActionMoveCellFocusToEdge(PlutoMoveDirection.left),
    const SingleActivator(LogicalKeyboardKey.end):
    const PlutoGridActionMoveCellFocusToEdge(PlutoMoveDirection.right),
    const SingleActivator(LogicalKeyboardKey.home, control: true):
    const PlutoGridActionMoveCellFocusToEdge(PlutoMoveDirection.up),
    const SingleActivator(LogicalKeyboardKey.end, control: true):
    const PlutoGridActionMoveCellFocusToEdge(PlutoMoveDirection.down),
    // Move selected cell focus to edge
    const SingleActivator(LogicalKeyboardKey.home, shift: true):
    const PlutoGridActionMoveSelectedCellFocusToEdge(
        PlutoMoveDirection.left),
    const SingleActivator(LogicalKeyboardKey.end, shift: true):
    const PlutoGridActionMoveSelectedCellFocusToEdge(
        PlutoMoveDirection.right),
    const SingleActivator(LogicalKeyboardKey.home, control: true, shift: true):
    const PlutoGridActionMoveSelectedCellFocusToEdge(PlutoMoveDirection.up),
    const SingleActivator(LogicalKeyboardKey.end, control: true, shift: true):
    const PlutoGridActionMoveSelectedCellFocusToEdge(
        PlutoMoveDirection.down),
    // Set editing
    const SingleActivator(LogicalKeyboardKey.f2): const PlutoGridActionSetEditing(),
    // Focus to column filter
    const SingleActivator(LogicalKeyboardKey.f3):
    const PlutoGridActionFocusToColumnFilter(),
    // Toggle column sort
    const SingleActivator(LogicalKeyboardKey.f4):
    const PlutoGridActionToggleColumnSort(),
    // Copy the values of cells
    const SingleActivator(LogicalKeyboardKey.keyC, control: true):
    const PlutoGridActionCopyValues(),
    // Paste values from clipboard
    const SingleActivator(LogicalKeyboardKey.keyV, control: true):
    const PlutoGridActionPasteValues(),
    // Select all cells or rows
    // LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA):
    //     const PlutoGridActionSelectAll(),
  };
}
