// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:yoyo_school_app/config/constants/constants.dart';
// import 'package:yoyo_school_app/config/router/navigation_helper.dart';
// import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
// import 'package:yoyo_school_app/core/widgets/app_bar.dart';
// import 'package:yoyo_school_app/features/home/model/classes_model.dart';
// import 'package:yoyo_school_app/features/phrases/presentation/phrases_view_model.dart';

// class PhrasesDetails extends StatelessWidget {
//   final Classes classes;
//   const PhrasesDetails({super.key, required this.classes});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<PhrasesViewModel>(
//       create: (_) => PhrasesViewModel(classes),
//       child: Consumer<PhrasesViewModel>(
//         builder: (context, provider, wi) {
//           return DefaultTabController(
//             length: 2,
//             child: Scaffold(
//               body: CustomScrollView(
//                 slivers: [
//                   // Hero container
//                   SliverToBoxAdapter(
//                     child: Hero(
//                       tag: classes.launguage ?? "",
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withAlpha(70),
//                               spreadRadius: 5,
//                               blurRadius: 4,
//                               offset: Offset(0, 3),
//                             ),
//                           ],
//                           image: DecorationImage(
//                             image: AssetImage(provider.classes.img ?? ""),
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(height: 120, child: getAppBar()),
//                               SizedBox(height: 20),
//                               Text(
//                                 provider.classes.launguage ?? "",
//                                 style: AppTextStyles.textTheme.headlineSmall!
//                                     .copyWith(color: Colors.white),
//                               ),
//                               Text(
//                                 provider.classes.name ?? "",
//                                 style: AppTextStyles.textTheme.headlineSmall!
//                                     .copyWith(color: Colors.white),
//                               ),
//                               Text(
//                                 "${text.level}${provider.classes.level}",
//                                 style: AppTextStyles.textTheme.headlineSmall!
//                                     .copyWith(color: Colors.white),
//                               ),
//                               SizedBox(height: 20),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         text.classText,
//                                         style: AppTextStyles
//                                             .textTheme
//                                             .headlineSmall!
//                                             .copyWith(color: Colors.white),
//                                       ),
//                                       SizedBox(width: 5),
//                                       Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                           Container(
//                                             height: 60,
//                                             width: 60,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(100),
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                           Container(
//                                             height: 55,
//                                             width: 55,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(100),
//                                               image: DecorationImage(
//                                                 image: AssetImage(
//                                                   ImageConstants.loginBg,
//                                                 ),
//                                               ),
//                                             ),
//                                             child: Center(
//                                               child: Text(
//                                                 "88%",
//                                                 style: AppTextStyles
//                                                     .textTheme
//                                                     .bodyLarge!
//                                                     .copyWith(
//                                                       color: Colors.white,
//                                                     ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         text.you,
//                                         style: AppTextStyles
//                                             .textTheme
//                                             .headlineSmall!
//                                             .copyWith(color: Colors.white),
//                                       ),
//                                       SizedBox(width: 5),
//                                       Container(
//                                         height: 55,
//                                         width: 55,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                             100,
//                                           ),
//                                           color: Colors.white,
//                                         ),
//                                         child: Center(
//                                           child: Text(
//                                             "0%",
//                                             style: AppTextStyles
//                                                 .textTheme
//                                                 .bodyLarge!
//                                                 .copyWith(color: Colors.black),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 20),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SliverToBoxAdapter(child: SizedBox(height: 30)),

//                   SliverPersistentHeader(
//                     pinned: true,
//                     delegate: _SliverAppBarDelegate(
//                       TabBar(
//                         labelColor: Colors.white,
//                         dividerColor: Colors.transparent,
//                         unselectedLabelColor: Colors.black,
//                         indicatorSize: TabBarIndicatorSize.tab,
//                         indicatorWeight: 1,
//                         indicatorPadding: EdgeInsetsGeometry.symmetric(
//                           horizontal: 26,
//                         ),
//                         indicator: BoxDecoration(
//                           color: provider.color,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         tabs: [
//                           Tab(text: text.newText),
//                           Tab(text: text.recorded),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // TabBarView content
//                   SliverFillRemaining(
//                     child: TabBarView(
//                       children: [
//                         // First tab content
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 26),
//                           child: ListView.separated(
//                             itemBuilder: (context, index) {
//                               return PhrasesWidget(
//                                 title: "¿Puedes repetir eso por favor?",
//                                 subTitle: "can you repeat that Please?",
//                               );
//                             },
//                             separatorBuilder: (context, index) {
//                               return SizedBox(height: 20);
//                             },
//                             itemCount: 5,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 26),
//                           child: ListView.separated(
//                             itemBuilder: (context, index) {
//                               return PhrasesWidget(
//                                 title: "¿Puedes repetir eso por favor?",
//                                 subTitle: "can you repeat that Please?",
//                                 precentage: "88%",
//                               );
//                             },
//                             separatorBuilder: (context, index) {
//                               return SizedBox(height: 20);
//                             },
//                             itemCount: 5,
//                           ),
//                         ),

//                         // Second tab content
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class PhrasesWidget extends StatelessWidget {
//   final String title;
//   final String subTitle;
//   final String? precentage;
//   const PhrasesWidget({
//     super.key,
//     required this.title,
//     required this.subTitle,
//     this.precentage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 132,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Color(0xFFFFC3FE)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 76,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               gradient: LinearGradient(
//                 colors: [Color(0xFFEF2E36), Color(0xFFFEE37F)],
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 if (precentage != null)
//                   Container(
//                     height: 55,
//                     width: 55,
//                     margin: EdgeInsets.only(top: 20),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(100),
//                       color: Colors.white,
//                     ),
//                     child: Center(
//                       child: Text(
//                         precentage!,
//                         style: AppTextStyles.textTheme.bodyLarge!.copyWith(
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 IconButton(
//                   onPressed: () {},
//                   icon: Icon(
//                     Icons.play_arrow_outlined,
//                     size: 35,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 26.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text(
//                     title,
//                     maxLines: 2,
//                     style: AppTextStyles.textTheme.titleLarge,
//                   ),
//                   Text(
//                     subTitle,
//                     style: AppTextStyles.textTheme.bodyMedium,
//                     maxLines: 2,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Helper class for pinned Sliver TabBar
// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar _tabBar;
//   _SliverAppBarDelegate(this._tabBar);

//   @override
//   double get minExtent => _tabBar.preferredSize.height;

//   @override
//   double get maxExtent => _tabBar.preferredSize.height;

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return Container(child: _tabBar);
//   }

//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return true;
//   }
// }
