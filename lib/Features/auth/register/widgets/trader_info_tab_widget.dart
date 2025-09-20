import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';
import 'package:Tosell/core/widgets/inputs/rounded_drop_button.dart';
import 'package:Tosell/core/widgets/inputs/phone_number_field.dart';
import 'package:Tosell/core/widgets/inputs/image_picker_widget.dart';
import 'package:Tosell/core/widgets/buttons/FillButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'dart:io';

/// ✅ ويدجت محتوى تاب معلومات التاجر
class TraderInfoTabWidget extends StatefulWidget {
  const TraderInfoTabWidget({super.key});

  @override
  State<TraderInfoTabWidget> createState() => _TraderInfoTabWidgetState();
}

class _TraderInfoTabWidgetState extends State<TraderInfoTabWidget> {
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedDailyOrders;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  File? _selectedStoreImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "شعار المتجر",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 24 / 16, // line-height / font-size
            letterSpacing: 0,
          ),
          textAlign: TextAlign.right,
        ),
        const Gap(AppSpaces.small),

        // ويدجت اختيار شعار المتجر
        Center(
          child: ImagePickerWidget(
            width: 100,
            height: 100,
            borderWidth: 1,
            borderRadius: 16, // Border Radius/large
            borderColor: Theme.of(context).primaryColor,
            backgroundColor: Colors.transparent,
            iconSize: 24,
            onImageSelected: (File? image) {
              setState(() {
                _selectedStoreImage = image;
              });
            },
          ),
        ),

        const Gap(AppSpaces.large),

        const Text(
          'اسم صاحب المتجر',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 24 / 16, // line-height / font-size
            letterSpacing: 0,
          ),
          textAlign: TextAlign.right,
        ),
        const Gap(AppSpaces.small),

        CustomTextFormField(
          label: '',
          showLabel: false,
          controller: _ownerNameController,
          hint: 'أدخل اسم صاحب المتجر',
          prefixInner: Container(
            width: 24,
            height: 24,
            padding: const EdgeInsets.all(14),
            child: SvgPicture.asset(
              'assets/svg/User.svg',
              width: 24,
              height: 24,
              color: Colors.black,
            ),
          ),
        ),

        const Gap(AppSpaces.large),

        // اسم المتجر
        const Text(
          'اسم المتجر',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 24 / 16,
            letterSpacing: 0,
          ),
          textAlign: TextAlign.right,
        ),
        const Gap(AppSpaces.small),

        CustomTextFormField(
          label: '',
          showLabel: false,
          controller: _storeNameController,
          hint: 'أدخل اسم المتجر',
          prefixInner: Container(
            width: 24,
            height: 24,
            padding: const EdgeInsets.all(14),
            child: SvgPicture.asset(
              'assets/svg/store.svg',
              width: 24,
              height: 24,
              color: Colors.black,
            ),
          ),
        ),

        const Gap(AppSpaces.large),

        // الطلبات اليومية المتوقعة
        const Text(
          'الطلبات اليومية المتوقعة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 24 / 16,
            letterSpacing: 0,
          ),
          textAlign: TextAlign.right,
        ),
        const Gap(AppSpaces.small),

        Container(
          width: 398,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(AppSpaces.large),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedDailyOrders,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'كم طلب',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ],
                ),
              ),
              selectedItemBuilder: (context) {
                return [
                  '0-10 طلبات',
                  '10-20 طلب',
                  '20-30 طلب',
                  '30-50 طلب',
                  'أكثر من 50 طلب'
                ].map((String value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        Text(
                          value,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
              items: [
                DropdownMenuItem(value: '0-10', child: Text('0-10 طلبات')),
                DropdownMenuItem(value: '10-20', child: Text('10-20 طلب')),
                DropdownMenuItem(value: '20-30', child: Text('20-30 طلب')),
                DropdownMenuItem(value: '30-50', child: Text('30-50 طلب')),
                DropdownMenuItem(value: '50+', child: Text('أكثر من 50 طلب')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDailyOrders = value;
                });
              },
              isExpanded: true,
              icon: const SizedBox.shrink(),
            ),
          ),
        ),

        const Gap(AppSpaces.large),

        // رقم الهاتف
        PhoneNumberField(
          label: 'رقم الهاتف',
          controller: _phoneController,
          hint: 'أدخل رقم الهاتف',
          onChanged: (value) {
            // Handle phone number change
          },
        ),

        const Gap(AppSpaces.large),

        // كلمة المرور
        Text(
          'كلمة المرور',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 24 / 16,
            letterSpacing: 0,
          ),
          textAlign: TextAlign.right,
        ),
        const Gap(AppSpaces.small),

        CustomTextFormField(
          label: '',
          showLabel: false,
          controller: _passwordController,
          hint: '********',
          obscureText: !_isPasswordVisible,
          prefixInner: Container(
            width: 24,
            height: 24,
            padding: const EdgeInsets.all(14),
            child: SvgPicture.asset(
              'assets/svg/lock.svg',
              width: 24,
              height: 24,
              color: Colors.black,
            ),
          ),
          suffixInner: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[600],
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),

        const Gap(AppSpaces.large),

        // تأكيد كلمة المرور
        const Text(
          'تأكيد كلمة المرور',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 24 / 16,
            letterSpacing: 0,
          ),
          textAlign: TextAlign.right,
        ),
        const Gap(AppSpaces.small),

        CustomTextFormField(
          label: '',
          showLabel: false,
          controller: _confirmPasswordController,
          hint: '********',
          obscureText: !_isConfirmPasswordVisible,
          prefixInner: Container(
            width: 24,
            height: 24,
            padding: const EdgeInsets.all(14),
            child: SvgPicture.asset(
              'assets/svg/lock.svg',
              width: 24,
              height: 24,
              color: Colors.black,
            ),
          ),
          suffixInner: IconButton(
            icon: Icon(
              _isConfirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey[600],
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
          ),
        ),

        const Gap(50),

        // أزرار التنقل
        Row(
          children: [
            // زر السابق (معطل)
            Expanded(
              child: FillButton(
                label: 'السابق',
                width: 195,
                height: 50,
                borderRadius: 24, // Border Radius/large
                color: const Color(0xFFD9D9D9), // لون معطل
                textColor: Colors.grey[600],
                onPressed: () {
                  // لا يعمل - معطل
                },
              ),
            ),

            const Gap(AppSpaces.medium),

            // زر التالي
            Expanded(
              child: FillButton(
                label: 'التالي',
                width: 195,
                height: 50,
                borderRadius: 24, // Border Radius/large
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  // التنقل للتاب التالي
                  _handleNext();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleNext() {
    // التحقق من صحة البيانات
    if (_ownerNameController.text.isEmpty ||
        _storeNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _selectedDailyOrders == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى ملء جميع الحقول المطلوبة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كلمة المرور وتأكيد كلمة المرور غير متطابقتين'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // الانتقال للتاب التالي
    // يمكن إضافة منطق التنقل هنا
  }

  @override
  void dispose() {
    _ownerNameController.dispose();
    _storeNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
