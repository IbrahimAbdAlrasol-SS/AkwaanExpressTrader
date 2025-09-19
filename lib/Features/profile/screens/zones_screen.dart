import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:Tosell/core/widgets/buttons/FillButton.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/Features/profile/models/zone.dart' as ZoneModel;
import 'package:Tosell/Features/profile/providers/zone_provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ZonesScreen extends ConsumerStatefulWidget {
  final String PageTitle;
  const ZonesScreen({super.key, required this.PageTitle});

  @override
  ConsumerState<ZonesScreen> createState() => _ZonesScreenState();
}

class _ZonesScreenState extends ConsumerState<ZonesScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {}

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var zonesState = ref.watch(zoneNotifierProvider);
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        // footer: CustomFooter(
        //   builder: (BuildContext context, LoadStatus? mode) {
        //     if (mode == LoadStatus.noMore) {
        //       return Container(height: 0);
        //     }
        //     if (mode == LoadStatus.idle) {
        //       return Container(height: 0); // Empty when idle
        //     } else if (mode == LoadStatus.loading) {
        //       return const Center(
        //           child:
        //               CircularProgressIndicator()); // Circular progress during loading
        //     } else if (mode == LoadStatus.failed) {
        //       return const Center(
        //           child: Text("فشل")); // Show message if loading fails
        //     } else if (mode == LoadStatus.canLoading) {
        //       return const Center(child: Text("اسحب لجلب المزيد"));
        //     } else {
        //       return Container(); // Hide when there is no data to load
        //     }
        //   },
        // ),
        child: SafeArea(
          child: SingleChildScrollView(
            // ************************************************ ممكن يسبب مشكلة بسلاسة اللمس ********************
            physics: const BouncingScrollPhysics(), // تحسين سلاسة التحكم
            // ************************************************************************************************
            padding: const EdgeInsets.symmetric(
                horizontal: 12.0, vertical: 8.0), // تحسين padding عام
            child: Column(
              children: [
                CustomAppBar(
                  title: widget.PageTitle,
                  showBackButton: true,
                ),
                // addressProvider.isFetching
                //     ? Center(child: CircularProgressIndicator())
                //     : addressProvider.addresses.isNotEmpty
                zonesState.when(
                  data: (data) => _buildUi(data),
                  loading: () =>
                      const Center(child: const CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text(error.toString()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20.0), // تحسين padding
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Expanded(
          child: FillButton(
            color: context.colorScheme.primary,
            icon: SvgPicture.asset(
              "assets/svg/navigation_add.svg",
              color: Colors.white,
            ),
            reverse: true,
            label: "إضافة عنوان جديد",
            onPressed: () {
             
            },
          ),
        ),
      ),
    );
  }

  ListView _buildUi(List<ZoneModel.Zone> zones) {
    return ListView.builder(
      shrinkWrap: true,
      // تحسين سلاسة التحكم - استخدام BouncingScrollPhysics بدلاً من NeverScrollableScrollPhysics
      physics: const BouncingScrollPhysics(), // تحسين سلاسة التحكم
      padding: const EdgeInsets.symmetric(
          horizontal: 20.0, vertical: 12.0), // تحسين padding
      itemCount: zones.length,
      itemBuilder: (context, index) =>
          buildZoneCart(zones[index], Theme.of(context)),
    );
  }

  Widget buildZoneCart(ZoneModel.Zone zone, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20), // تحسين المسافة بين العناصر
      padding: const EdgeInsets.symmetric(
          horizontal: 24, vertical: 18), // تحسين padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFFF1F2F4), // specify the border color
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            //? Location Icon
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFEDE7F6),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/svg/savedLocation.svg",
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zone.name ?? 'لايوجد',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  zone.governorate?.name ?? 'لايوجد',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          //? Edit Icon
          IconButton(
            icon: SvgPicture.asset(
              "assets/svg/pin.svg",
              color: const Color(0xFFFFE500),
            ),
            onPressed: () {
             
            },
          ),
          //? Delete Icon
          IconButton(
            icon: SvgPicture.asset(
              "assets/svg/49. TrashSimple.svg",
              color: const Color(0xffE96363),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
