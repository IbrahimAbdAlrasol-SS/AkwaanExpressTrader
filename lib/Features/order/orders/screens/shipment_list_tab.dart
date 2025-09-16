import 'package:Tosell/Features/order/orders/models/OrderFilter.dart';
import 'package:Tosell/Features/order/orders/models/Shipment.dart';
import 'package:Tosell/Features/order/orders/widgets/shipment_cart_Item.dart';

import 'package:Tosell/paging/generic_paged_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/paging/generic_paged_list_view.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';

class shipmentInfoTab extends ConsumerStatefulWidget {
  final FetchPage<Shipment> fetchPage;
  final OrderFilter? filter;
  const shipmentInfoTab({super.key, this.filter, required this.fetchPage});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _shipmentInfoTabState();
}

class _shipmentInfoTabState extends ConsumerState<shipmentInfoTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget _buildNoShipmentsFound() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/svg/NoItemsFound.gif', width: 240, height: 240),
            Text(
              'لا توجد شحنات مضافة',
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xffE96363),
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'لم يتم إنشاء أي شحنات بعد',
              style: context.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: const Color(0xff698596),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GenericPagedListView<Shipment>(
      itemBuilder: (context, shipment, index) =>
          ShipmentCartItem(shipment: shipment),
      fetchPage: (page, filter) async {
        return await widget.fetchPage(page);
      },
      noItemsFoundIndicatorBuilder: _buildNoShipmentsFound(),
    );
  }
}
