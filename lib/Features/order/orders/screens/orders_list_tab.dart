import 'package:Tosell/Features/order/orders/models/Order.dart';
import 'package:Tosell/Features/order/orders/models/OrderFilter.dart';
import 'package:Tosell/Features/order/orders/providers/orders_provider.dart';
import 'package:Tosell/Features/order/orders/providers/shipments_provider.dart';
import 'package:Tosell/Features/order/orders/widgets/order_card_item.dart';
import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/paging/generic_paged_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/Features/order/orders/models/Order.dart';
import 'package:Tosell/Features/order/orders/models/OrderFilter.dart';
import 'package:Tosell/Features/order/orders/models/Shipment.dart';
import 'package:Tosell/paging/generic_paged_list_view.dart';
import 'package:Tosell/paging/generic_paged_grid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/widgets/buttons/FillButton.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';

class OrdersListTab extends ConsumerStatefulWidget {
  final FetchPage<Order> fetchPage;
  final OrderFilter? filter;
  const OrdersListTab({super.key, this.filter, required this.fetchPage});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrdersListTabState();
}

class _OrdersListTabState extends ConsumerState<OrdersListTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _isMultiSelectMode = false;
  final Set<String> _selectedOrderIds = {};
  List<Order> _allOrders = [];

  void _toggleMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedOrderIds.clear();
      }
    });
  }

  Widget _buildNoItemsFound() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/svg/NoItemsFound.gif', width: 240, height: 240),
            Text(
              'لا توجد طلبات مضافة',
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xffE96363),
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'اضغط على زر "جديد" لإضافة طلب جديد و ارساله الى زبونك',
              style: context.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: const Color(0xff698596),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: FillButton(
                label: 'إضافة اول طلب',
                onPressed: () => context.push(AppRoutes.addOrder),
                icon: SvgPicture.asset('assets/svg/navigation_add.svg',
                    color: const Color(0xffFAFEFD)),
                reverse: true,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _toggleOrderSelection(String orderId) {
    setState(() {
      if (_selectedOrderIds.contains(orderId)) {
        _selectedOrderIds.remove(orderId);
      } else {
        _selectedOrderIds.add(orderId);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedOrderIds.clear();
      for (var order in _allOrders) {
        if (order.id != null && order.status != null) {
          _selectedOrderIds.add(order.id!);
        }
      }
    });
  }

  void _clearAll() {
    setState(() {
      _selectedOrderIds.clear();
    });
  }

  void _createShipment() async {
    // التحقق من وجود طلبات محددة
    if (_selectedOrderIds.isEmpty) {
      _showMessage('يرجى تحديد طلبات لإنشاء الشحنة', Colors.orange);
      return;
    }

    // فلترة الطلبات المتاحة فقط (status = 0: Pending أو 1: InPickUpShipment)
    final availableOrderIds = <String>[];
    final unavailableOrderIds = <String>[];

    final ordersState = ref.read(ordersNotifierProvider);
    final currentOrders = ordersState.value ?? [];

    for (String orderId in _selectedOrderIds) {
      try {
        final order = currentOrders.where((order) => order.id == orderId).first;

        if (order.status == 0 || order.status == 1) {
          availableOrderIds.add(orderId);
        } else {
          unavailableOrderIds.add(orderId);
        }
      } catch (e) {
        // إذا لم يتم العثور على الطلب، نتجاهله
        unavailableOrderIds.add(orderId);
      }
    }

    if (availableOrderIds.isEmpty) {
      _showMessage(
          'جميع الطلبات المحددة غير متاحة للشحن.\nيمكن شحن الطلبات في حالة "في الانتظار" أو "في شحنة الاستحصال" فقط.',
          Colors.orange);
      return;
    }

    if (unavailableOrderIds.isNotEmpty) {
      _showMessage(
          'تم استبعاد ${unavailableOrderIds.length} طلب غير متاح للشحن',
          Colors.orange);
    }

    // تحضير البيانات
    final orders = availableOrderIds.map((id) => {'orderId': id}).toList();

    final shipmentData = {
      'delivered': null,
      'delegateId': null,
      'merchantId': null,
      'orders': orders,
      'priority': null
    };

    // إرسال الطلب
    final result = await ref
        .read(shipmentsNotifierProvider.notifier)
        .createShipment(shipmentData: shipmentData);

    // معالجة النتيجة
    if (result.$1 != null) {
      _showMessage('تم إنشاء الشحنة بنجاح (${availableOrderIds.length} طلب)',
          Colors.green);
      _resetSelection();
    } else {
      // معالجة أنواع الأخطاء المختلفة
      String errorMessage = result.$2 ?? 'فشل في إنشاء الشحنة';

      if (errorMessage.contains('Order already in shipment')) {
        errorMessage =
            'بعض الطلبات المحددة موجودة بالفعل في شحنة أخرى غير مكتملة.\nيرجى اختيار طلبات أخرى أو التحقق من حالة الطلبات.';
      } else if (errorMessage.contains('400')) {
        errorMessage = 'خطأ في البيانات المرسلة. يرجى المحاولة مرة أخرى.';
      }

      _showMessage(errorMessage, Colors.red);
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  void _resetSelection() {
    setState(() {
      _selectedOrderIds.clear();
      _isMultiSelectMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Column(
        children: [
          // Multi-select header
          if (_isMultiSelectMode)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Select all button
                  GestureDetector(
                    onTap: _selectAll,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/CheckSquare.svg',
                            width: 16,
                            height: 16,
                            color: Colors.white,
                          ),
                          const Gap(AppSpaces.exSmall),
                          const Text(
                            'تحديد الكل',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(AppSpaces.small),
                  // Clear all button
                  GestureDetector(
                    onTap: _clearAll,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/x.svg',
                            width: 16,
                            height: 16,
                            color: Colors.white,
                          ),
                          const Gap(AppSpaces.exSmall),
                          Text(
                            'إلغاء الكل',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Selected count
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Text(
                      'محدد: ${_selectedOrderIds.length}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Orders list
          Expanded(
            child: GenericPagedListView<Order>(
              itemBuilder: (context, order, index) {
                // Update all orders list for select all functionality
                if (!_allOrders.any((o) => o.id == order.id)) {
                  _allOrders.add(order);
                }

                return OrderCardItem(
                  order: order,
                  isMultiSelectMode: _isMultiSelectMode,
                  isSelected: _selectedOrderIds.contains(order.id),
                  onSelectionToggle: () =>
                      _toggleOrderSelection(order.id ?? ''),
                  onTap: () {
                    if (!_isMultiSelectMode) {
                      context.push(AppRoutes.orderDetails, extra: order.code);
                    }
                  },
                );
              },
              fetchPage: (page, filter) async {
                final result = await widget.fetchPage(page);
                if (result.data != null) {
                  for (var order in result.data!) {
                    if (!_allOrders.any((o) => o.id == order.id)) {
                      _allOrders.add(order);
                    }
                  }
                }
                return result;
              },
              noItemsFoundIndicatorBuilder: _buildNoItemsFound(),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // زر إرسال الشحنة (يظهر فقط في وضع التحديد المتعدد)
          if (_isMultiSelectMode && _selectedOrderIds.isNotEmpty)
            FloatingActionButton.extended(
              onPressed: _createShipment,
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 8,
              icon: SvgPicture.asset(
                'assets/svg/Truck.svg',
                width: 20,
                height: 20,
                color: Colors.white,
              ),
              label: Text(
                'إرسال شحنة (${_selectedOrderIds.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (_isMultiSelectMode && _selectedOrderIds.isNotEmpty)
            const Gap(AppSpaces.small),
          // زر التحديد المتعدد
          FloatingActionButton(
            onPressed: _toggleMultiSelectMode,
            backgroundColor: _isMultiSelectMode
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 8,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isMultiSelectMode
                  ? const Icon(
                      Icons.close,
                      key: ValueKey('close'),
                    )
                  : SvgPicture.asset(
                      'assets/svg/CheckSquare.svg',
                      key: const ValueKey('select'),
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
