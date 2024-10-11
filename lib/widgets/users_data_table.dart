import 'package:flutter/material.dart';

class MyDataSource extends DataTableSource {
  static const List<int> _displayIndexToRawIndex = <int>[0, 1, 2, 3];

  late List<List<Comparable<Object>>> sortedData;

  void setData(List<List<Comparable<Object>>> rawData, int sortColumn,
      bool sortAscending) {
    sortedData = rawData.toList()
      ..sort((List<Comparable<Object>> a, List<Comparable<Object>> b) {
        final Comparable<Object> cellA = a[_displayIndexToRawIndex[sortColumn]];
        final Comparable<Object> cellB = b[_displayIndexToRawIndex[sortColumn]];
        return cellA.compareTo(cellB) * (sortAscending ? 1 : -1);
      });
    notifyListeners();
  }

  @override
  int get rowCount => sortedData.length;

  static DataCell cellFor(Object data) {
    String value;
    if (data is DateTime) {
      value =
          '${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}';
    } else {
      value = data.toString();
    }
    return DataCell(Text(value));
  }

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        cellFor(sortedData[index][0]), // Username
        cellFor(sortedData[index][1]), // Name
        cellFor(sortedData[index][2]), // Email
        cellFor(sortedData[index][3]), // Created Date
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

class DataTableExample extends StatefulWidget {
  const DataTableExample({super.key});

  @override
  State<DataTableExample> createState() => _DataTableExampleState();
}

class _DataTableExampleState extends State<DataTableExample> {
  final MyDataSource dataSource = MyDataSource()..setData(users, 0, true);

  int _columnIndex = 0;
  bool _columnAscending = true;

  void _sort(int columnIndex, bool ascending) {
    setState(() {
      _columnIndex = columnIndex;
      _columnAscending = ascending;
      dataSource.setData(users, _columnIndex, _columnAscending);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      sortColumnIndex: _columnIndex,
      sortAscending: _columnAscending,
      columns: <DataColumn>[
        DataColumn(
          label: const Text('Username'),
          onSort: (int columnIndex, bool ascending) =>
              _sort(columnIndex, ascending),
        ),
        DataColumn(
          label: const Text('Name'),
          onSort: (int columnIndex, bool ascending) =>
              _sort(columnIndex, ascending),
        ),
        DataColumn(
          label: const Text('Email'),
          onSort: (int columnIndex, bool ascending) =>
              _sort(columnIndex, ascending),
        ),
        DataColumn(
          label: const Text('Created Date'),
          onSort: (int columnIndex, bool ascending) =>
              _sort(columnIndex, ascending),
        ),
      ],
      source: dataSource,
    );
  }
}

// Sample user data
final List<List<Comparable<Object>>> users = <List<Comparable<Object>>>[
  <Comparable<Object>>[
    'john_doe', // Username
    'John Doe', // Name
    'john.doe@example.com', // Email
    DateTime(2021, 6, 15), // Created Date
  ],
  <Comparable<Object>>[
    'jane_smith', // Username
    'Jane Smith', // Name
    'jane.smith@example.com', // Email
    DateTime(2021, 7, 22), // Created Date
  ],
  <Comparable<Object>>[
    'mike_johnson', // Username
    'Mike Johnson', // Name
    'mike.johnson@example.com', // Email
    DateTime(2021, 8, 5), // Created Date
  ],
  <Comparable<Object>>[
    'emily_davis', // Username
    'Emily Davis', // Name
    'emily.davis@example.com', // Email
    DateTime(2021, 9, 12), // Created Date
  ],
  <Comparable<Object>>[
    'charles_brown', // Username
    'Charles Brown', // Name
    'charles.brown@example.com', // Email
    DateTime(2022, 1, 3), // Created Date
  ],
  <Comparable<Object>>[
    'lisa_white', // Username
    'Lisa White', // Name
    'lisa.white@example.com', // Email
    DateTime(2022, 2, 17), // Created Date
  ],
  <Comparable<Object>>[
    'david_black', // Username
    'David Black', // Name
    'david.black@example.com', // Email
    DateTime(2022, 3, 5), // Created Date
  ],
  <Comparable<Object>>[
    'susan_green', // Username
    'Susan Green', // Name
    'susan.green@example.com', // Email
    DateTime(2022, 4, 10), // Created Date
  ],
  <Comparable<Object>>[
    'tom_clark', // Username
    'Tom Clark', // Name
    'tom.clark@example.com', // Email
    DateTime(2022, 5, 25), // Created Date
  ],
  <Comparable<Object>>[
    'nancy_williams', // Username
    'Nancy Williams', // Name
    'nancy.williams@example.com', // Email
    DateTime(2022, 6, 7), // Created Date
  ],
  <Comparable<Object>>[
    'henry_jones', // Username
    'Henry Jones', // Name
    'henry.jones@example.com', // Email
    DateTime(2022, 7, 18), // Created Date
  ],
  <Comparable<Object>>[
    'betty_taylor', // Username
    'Betty Taylor', // Name
    'betty.taylor@example.com', // Email
    DateTime(2022, 8, 22), // Created Date
  ],
  <Comparable<Object>>[
    'frank_harris', // Username
    'Frank Harris', // Name
    'frank.harris@example.com', // Email
    DateTime(2022, 9, 3), // Created Date
  ],
  <Comparable<Object>>[
    'amy_moore', // Username
    'Amy Moore', // Name
    'amy.moore@example.com', // Email
    DateTime(2022, 10, 12), // Created Date
  ],
  <Comparable<Object>>[
    'jack_taylor', // Username
    'Jack Taylor', // Name
    'jack.taylor@example.com', // Email
    DateTime(2022, 11, 25), // Created Date
  ],
  <Comparable<Object>>[
    'anna_jones', // Username
    'Anna Jones', // Name
    'anna.jones@example.com', // Email
    DateTime(2022, 12, 30), // Created Date
  ],
  <Comparable<Object>>[
    'steve_wilson', // Username
    'Steve Wilson', // Name
    'steve.wilson@example.com', // Email
    DateTime(2023, 1, 11), // Created Date
  ],
  <Comparable<Object>>[
    'kate_thompson', // Username
    'Kate Thompson', // Name
    'kate.thompson@example.com', // Email
    DateTime(2023, 2, 21), // Created Date
  ],
  <Comparable<Object>>[
    'paul_anderson', // Username
    'Paul Anderson', // Name
    'paul.anderson@example.com', // Email
    DateTime(2023, 3, 15), // Created Date
  ],
  <Comparable<Object>>[
    'laura_king', // Username
    'Laura King', // Name
    'laura.king@example.com', // Email
    DateTime(2023, 4, 2), // Created Date
  ],
  <Comparable<Object>>[
    'chris_baker', // Username
    'Chris Baker', // Name
    'chris.baker@example.com', // Email
    DateTime(2023, 5, 19), // Created Date
  ],
  <Comparable<Object>>[
    'nancy_allen', // Username
    'Nancy Allen', // Name
    'nancy.allen@example.com', // Email
    DateTime(2023, 6, 14), // Created Date
  ],
  <Comparable<Object>>[
    'peter_scott', // Username
    'Peter Scott', // Name
    'peter.scott@example.com', // Email
    DateTime(2023, 7, 25), // Created Date
  ],
  <Comparable<Object>>[
    'rita_morgan', // Username
    'Rita Morgan', // Name
    'rita.morgan@example.com', // Email
    DateTime(2023, 8, 9), // Created Date
  ],
  <Comparable<Object>>[
    'brian_hughes', // Username
    'Brian Hughes', // Name
    'brian.hughes@example.com', // Email
    DateTime(2023, 9, 1), // Created Date
  ],
];
