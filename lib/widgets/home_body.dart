// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:intl/intl.dart';
// import 'package:to_do_app/utils/helper_methods.dart';

// class HomeBody extends StatelessWidget {
//   const HomeBody({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final localizations = MaterialLocalizations.of(context);
//     // TODO delete the following line and modify the file accordingly
//     // DataHandler handler = DataHandler();

//     return MasonryGridView.count(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 6,
//         vertical: 6,
//       ),
//       itemCount: getEntrySize() as int,
//       crossAxisCount: 2,
//       mainAxisSpacing: 4,
//       crossAxisSpacing: 6,
//       itemBuilder: (context, index) {
//         return Card(
//           // color: toDos[index][DatabaseProvider.color],
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 12, top: 6),
//             child: Column(
//               children: [
//                 ListTile(
//                   title: Text(toDos[index][DatabaseProvider.titleColumn]),
//                   subtitle: Text(toDos[index]
//                       [DatabaseProvider.descriptionColumn] as String),
//                 ),
//                 const SizedBox(
//                   height: 2,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(3),
//                       decoration: BoxDecoration(
//                         border: Border.all(),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Row(
//                         children: [
//                           Text(
//                             DateFormat("d MMMM ")
//                                 .format(toDos[index][DatabaseProvider.date]),
//                           ),
//                           Text(
//                             localizations.formatTimeOfDay(
//                                 toDos[index][DatabaseProvider.time]),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
