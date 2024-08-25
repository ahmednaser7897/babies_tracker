// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../app/app_sized_box.dart';
// import '../../../controller/hospital/hospital_cubit.dart';
// import '../../componnents/screen_builder.dart';
// import '../../componnents/users_lists.dart';

// class HospitalsHome extends StatefulWidget {
//   const HospitalsHome({super.key});

//   @override
//   State<HospitalsHome> createState() => _HospitalsHomeState();
// }

// class _HospitalsHomeState extends State<HospitalsHome> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<HospitalCubit, HospitalState>(
//       buildWhen: (previous, current) =>
//           current is LoadingGetHomeData ||
//           current is ScGetHomeData ||
//           current is ErorrGetHomeData,
//       listener: (context, state) {},
//       builder: (context, state) {
//         HospitalCubit cubit = HospitalCubit.get(context);
//         return screenBuilder(
//           contant: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppSizedBox.h2,
//                     buildHospitalsList(hospitels: cubit.hospitals),
//                     AppSizedBox.h2,
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           isEmpty: false,
//           isErorr: state is ErorrGetHomeData,
//           isLoading: state is LoadingGetHomeData,
//           isSc: state is ScGetHomeData || cubit.hospitals.isNotEmpty,
//         );
//       },
//     );
//   }
// }
