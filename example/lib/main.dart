import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlutoGrid Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RowLazyPaginationPage(),
    );
  }
}

class RowLazyPaginationPage extends StatefulWidget {
  const RowLazyPaginationPage({Key? key}) : super(key: key);

  @override
  State<RowLazyPaginationPage> createState() => _RowLazyPaginationPageState();
}

class _RowLazyPaginationPageState extends State<RowLazyPaginationPage> {
  late final PlutoGridStateManager stateManager;

  final List<PlutoColumn> columns = [];
  final List<PlutoRow> rows = [];
  final List<PlutoRow> fakeFetchedRows = [];

  @override
  void initState() {
    super.initState();

    columns.addAll([
      PlutoColumn(title: 'Id', field: 'id', type: PlutoColumnType.text()),
      PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
      PlutoColumn(title: 'Age', field: 'age', type: PlutoColumnType.number()),
      PlutoColumn(title: 'Role', field: 'role', type: PlutoColumnType.text()),
    ]);

    final rng = Random();
    const firstNames = [
      'Al', 'Alan', 'Alba', 'Albert', 'Alberto', 'Alec', 'Alen',
      'Alex', 'Alexa', 'Alexander', 'Alexandra', 'Alexis',
      'Sam', 'Sama', 'Samantha', 'Samir', 'Samuel',
      'Chris', 'Christa', 'Christian', 'Christina', 'Christine',
      'Jo', 'Joe', 'Joel', 'John', 'Johnny', 'Jon', 'Jonathan',
    ];
    const lastNames = [
      'Smith', 'Smithson', 'Smithfield',
      'Brown', 'Browne', 'Brownell',
      'Clark', 'Clarke', 'Clarkson',
      'Lee', 'Leeds', 'Leeson',
      'King', 'Kingston', 'Kingsley',
    ];
    const roles = ['Programmer', 'Designer', 'Owner', 'Manager', 'Analyst', 'Tester'];
    for (int i = 0; i < 1000; i++) {
      final first = firstNames[rng.nextInt(firstNames.length)];
      final last = lastNames[rng.nextInt(lastNames.length)];
      fakeFetchedRows.add(PlutoRow(cells: {
        'id': PlutoCell(value: 'user${i + 1}'),
        'name': PlutoCell(value: '$first $last'),
        'age': PlutoCell(value: 20 + rng.nextInt(40)),
        'role': PlutoCell(value: roles[rng.nextInt(roles.length)]),
      }));
    }
  }

  Future<PlutoLazyPaginationResponse> fetch(
    PlutoLazyPaginationRequest request,
  ) async {
    List<PlutoRow> tempList = fakeFetchedRows;

    if (request.filterRows.isNotEmpty) {
      final filter = FilterHelper.convertRowsToFilter(
        request.filterRows,
        stateManager.refColumns,
      );
      tempList = fakeFetchedRows.where(filter!).toList();
    }

    if (request.sortColumn != null && !request.sortColumn!.sort.isNone) {
      tempList = [...tempList];
      tempList.sort((a, b) {
        final sortA = request.sortColumn!.sort.isAscending ? a : b;
        final sortB = request.sortColumn!.sort.isAscending ? b : a;
        return request.sortColumn!.type.compare(
          sortA.cells[request.sortColumn!.field]!.valueForSorting,
          sortB.cells[request.sortColumn!.field]!.valueForSorting,
        );
      });
    }

    const pageSize = 100;
    final page = request.page;
    final totalPage = (tempList.length / pageSize).ceil();
    final start = (page - 1) * pageSize;
    final end = start + pageSize;

    final fetchedRows = tempList.getRange(
      max(0, start),
      min(tempList.length, end),
    );

    await Future.delayed(const Duration(milliseconds: 2000));

    return PlutoLazyPaginationResponse(
      totalPage: totalPage,
      rows: fetchedRows.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Row Lazy Pagination')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            stateManager.setShowColumnFilter(true);
          },
          onChanged: (PlutoGridOnChangedEvent event) {
            print(event);
          },
          configuration: const PlutoGridConfiguration(),
          createFooter: (stateManager) {
            return PlutoLazyPagination(
              initialPage: 1,
              initialFetch: true,
              fetchWithSorting: true,
              fetchWithFiltering: true,
              fetch: fetch,
              stateManager: stateManager,
            );
          },
        ),
      ),
    );
  }
}
