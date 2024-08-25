import 'package:babies_tracker/model/babies_model.dart';
import 'package:babies_tracker/model/hospital_model.dart';
import 'package:babies_tracker/model/mother_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/ui/componnents/widgets.dart';
import 'package:babies_tracker/app/extensions.dart';
import '../../controller/admin/admin_cubit.dart';
import '../../controller/hospital/hospital_cubit.dart';
import '../../model/doctor_model.dart';
import '../../model/admin_model.dart';

import '../admin/admins/admin_details_screen.dart';
import '../admin/hospitels_screen/hospitel_details_screen.dart';
import '../doctor/mother/baby/baby_details_screen.dart';
import '../hospital/doctors/doctor_details_screen.dart';
import '../hospital/mother/mother_details_screen.dart';

// class ShowUsersScreen extends StatelessWidget {
//   const ShowUsersScreen(
//       {super.key, required this.canEdit, required this.users});
//   final List<UserModel> users;
//   final bool canEdit;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Trainees'),
//         ),
//         body: Container()
//         //buildusersList(users: users, canEdit: canEdit),
//         );
//   }
// }

// class ShowCoachsScreen extends StatelessWidget {
//   const ShowCoachsScreen(
//       {super.key, required this.coachs, required this.canEdit});
//   final List<CoachModel> coachs;
//   final bool canEdit;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Coachs'),
//         ),
//         body: Container()
//         //buildCoachsList(coachs: coachs, canEdit: canEdit),
//         );
//   }
// }

Widget buildAdminList(List<AdminModel> admins) {
  return Builder(builder: (context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: admins.length,
      itemBuilder: (context, index) {
        return BlocConsumer<AdminCubit, AdminState>(
          listener: (context, state) {},
          builder: (context, state) {
            return buildHomeItem(
              ban: admins[index].ban.orFalse(),
              name: admins[index].name.orEmpty(),
              des: admins[index].email.orEmpty(),
              image: admins[index].image,
              id: admins[index].id.orEmpty(),
              assetImage: AppAssets.admin,
              ontap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminDetailsScreen(
                      model: admins[index],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  });
}

Widget buildHospitalsList(
    {required List<HospitalModel> hospitels, bool canEdit = true}) {
  return Builder(builder: (context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: hospitels.length,
      itemBuilder: (context, index) {
        return BlocConsumer<AdminCubit, AdminState>(
          listener: (context, state) {},
          builder: (context, state) {
            return buildHomeItem(
              ban: hospitels[index].ban.orFalse(),
              name: hospitels[index].name.orEmpty(),
              des: hospitels[index].email.orEmpty(),
              id: hospitels[index].id.orEmpty(),
              image: hospitels[index].image,
              assetImage: AppAssets.hospital,
              ontap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HospitelDetailsScreen(
                      model: hospitels[index],
                      //canEdit: canEdit,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  });
}

Widget buildDoctorsList(
    {required List<DoctorModel> doctors, bool canEdit = true}) {
  return Builder(builder: (context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return BlocConsumer<HospitalCubit, HospitalState>(
          listener: (context, state) {},
          builder: (context, state) {
            return buildHomeItem(
              ban: doctors[index].ban.orFalse(),
              name: doctors[index].name.orEmpty(),
              des: doctors[index].email.orEmpty(),
              id: doctors[index].id.orEmpty(),
              image: doctors[index].image,
              assetImage: AppAssets.doctor,
              ontap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDetailsScreen(
                      model: doctors[index],
                      //canEdit: canEdit,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  });
}

Widget buildMothersList(
    {required List<MotherModel> mothers, bool canEdit = true}) {
  print("lins");
  print(mothers.length);
  return Builder(builder: (context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: mothers.length,
      itemBuilder: (context, index) {
        return BlocConsumer<HospitalCubit, HospitalState>(
          listener: (context, state) {},
          builder: (context, state) {
            return buildHomeItem(
              leaft: mothers[index].leaft.orFalse(),
              ban: mothers[index].ban.orFalse(),
              name: mothers[index].name.orEmpty(),
              des: mothers[index].email.orEmpty(),
              id: mothers[index].id.orEmpty(),
              image: mothers[index].image,
              assetImage: AppAssets.mother,
              ontap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MotherDetailsScreen(
                      model: mothers[index],
                      //canEdit: canEdit,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  });
}

Widget buildBabyList({required List<BabieModel> baby, bool canEdit = true}) {
  print("lins");
  print(baby.length);
  return Builder(builder: (context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: baby.length,
      itemBuilder: (context, index) {
        return BlocConsumer<HospitalCubit, HospitalState>(
          listener: (context, state) {},
          builder: (context, state) {
            return buildHomeItem(
              ban: false,
              leaft: baby[index].left.orFalse(),
              name: baby[index].name.orEmpty(),
              des: baby[index].doctorNotes.orEmpty(),
              id: baby[index].id.orEmpty(),
              image: baby[index].photo,
              assetImage: AppAssets.baby,
              ontap: () async {
                var value = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BabyDetailsScreen(
                      model: baby[index],
                    ),
                  ),
                );
                if (value == 'add') {
                  Navigator.pop(context, 'add');
                }
              },
            );
          },
        );
      },
    );
  });
}

// Widget buildusersList({required List<UserModel> users, bool canEdit = true}) {
//   return Builder(builder: (context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.all(0),
//       itemCount: users.orEmpty().length,
//       itemBuilder: (context, index) {
//         return buildHomeItem(
//           ban: users.orEmpty()[index].ban.orFalse(),
//           name: users.orEmpty()[index].name.orEmpty(),
//           des: users.orEmpty()[index].email.orEmpty(),
//           image: users.orEmpty()[index].image,
//           id: users[index].id.orEmpty(),
//           assetImage: AppAssets.user,
//           ontap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => UserDetailsScreen(
//                   model: users.orEmpty()[index],
//                   canEdit: canEdit,
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   });
// }

// Widget buildCoachsList(
//     {required List<CoachModel> coachs,
//     bool canEdit = true,
//     bool isUser = false}) {
//   return Builder(builder: (context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.all(0),
//       itemCount: coachs.orEmpty().length,
//       itemBuilder: (context, index) {
//         return buildHomeItem(
//           ban: coachs.orEmpty()[index].ban.orFalse(),
//           name: coachs.orEmpty()[index].name.orEmpty(),
//           des: coachs.orEmpty()[index].email.orEmpty(),
//           image: coachs.orEmpty()[index].image,
//           id: coachs[index].id.orEmpty(),
//           assetImage: AppAssets.coach,
//           ontap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => CoachDetailsScreen(
//                   coachModel: coachs.orEmpty()[index],
//                   canEdit: canEdit,
//                   isUser: isUser,
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   });
// }
