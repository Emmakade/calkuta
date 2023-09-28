// import 'package:flutter/material.dart';

// class TransactionListScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Transaction List'),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'All'),
//               Tab(text: 'Deposit'),
//               Tab(text: 'Withdraw'),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             TransactionListView(type: TransactionType.all),
//             TransactionListView(type: TransactionType.deposit),
//             TransactionListView(type: TransactionType.withdraw),
//           ],
//         ),
//       ),
//     );
//   }
// }

// enum TransactionType { all, deposit, withdraw }

// class TransactionListView extends StatelessWidget {
//   final TransactionType type;

//   const TransactionListView({Key? key, required this.type}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Implement transaction list logic based on the selected type
//     return ListView.builder(
//       itemCount: 10,
//       itemBuilder: (context, index) {
//         // Generate list item for each transaction
//         return Card(
//           child: ListTile(
//             leading: Icon(
//               type == TransactionType.deposit
//                   ? Icons.arrow_downward
//                   : Icons.arrow_upward,
//               color:
//                   type == TransactionType.deposit ? Colors.green : Colors.red,
//             ),
//             title: Text('Depositor Name'),
//             subtitle: Text('Date'),
//             trailing: Text(
//               'Amount',
//               style: TextStyle(
//                 color:
//                     type == TransactionType.deposit ? Colors.green : Colors.red,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
