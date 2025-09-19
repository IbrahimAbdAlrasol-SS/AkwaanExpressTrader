import 'dart:io';

import 'package:Tosell/core/api/client/BaseClient.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/model_core/User.dart';
import 'package:Tosell/core/utils/extensions/GlobalToast.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:Tosell/core/widgets/buttons/FillButton.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Tosell/Features/profile/providers/profile_provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  File? _selectedImage;
  bool isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _changeLoadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    var userState = ref.watch(profileNotifierProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: userState.when(
        data: (user) => _buildUi(user),
        error: (error, stack) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildUi(User user, {bool isLoading = false}) {
    nameController.text = user.fullName ?? '';
    phoneController.text = user.phoneNumber ?? '';

    return Column(
      children: [
        const SafeArea(
          child: CustomAppBar(
            title: "تغيير المعلومات الشخصية",
            showBackButton: true,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : user.img != null
                                  ? NetworkImage(imageUrl + user.img!)
                                  : const AssetImage(
                                      "assets/images/default_avatar.jpg",
                                    ) as ImageProvider,
                          radius: 50,
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IconButton(
                              icon: SvgPicture.asset(
                                "assets/svg/pin.svg",
                                color: const Color(0xffFFE500),
                              ),
                              onPressed: _pickImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: buildInputField(
                      "أسم المتجر",
                      user.fullName ?? "أسم المتجر",
                      controller: nameController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'يرجى إدخال اسم المتجر'
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "رقم هاتف المتجر",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF121416),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal",
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(27),
                            border: Border.all(
                                color: const Color(0xFFF1F2F4), width: 1),
                          ),
                          child: IntlPhoneField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(27),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "07xx xxx xxx",
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF70798F),
                                fontFamily: "Tajawal",
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(27),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(27),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            initialCountryCode: 'IQ',
                            languageCode: 'ar',
                            textAlign: TextAlign.right,
                            showCountryFlag: false,
                            showDropdownIcon: false,
                            disableLengthCheck: true,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: "Tajawal",
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: null,
                            onChanged: (phone) {
                              HapticFeedback.lightImpact();
                              // Format phone number with debouncing
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                if (mounted) {
                                  phoneController.text = phone.completeNumber;
                                }
                              });
                            },
                            onSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white,
          ),
          width: double.infinity,
          padding:
              const EdgeInsets.only(bottom: 30, left: 16, right: 16, top: 16),
          child: FillButton(
            label: 'حفظ',
            isLoading: isLoading,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _changeLoadingState(true);
                var result =
                    await ref.read(profileNotifierProvider.notifier).updateUser(
                          user: User(
                            fullName: nameController.text,
                            phoneNumber: phoneController.text,
                            img: _selectedImage?.path,
                          ),
                        );
                _changeLoadingState(false);
                if (result.$1 == null) {
                  GlobalToast.show(
                    context: context,
                    message: result.$2 ?? "Unexpected error occurred",
                    backgroundColor: Theme.of(context).colorScheme.error,
                    textColor: Colors.white,
                  );
                } else {
                  GlobalToast.show(
                    context: context,
                    message: "تم تحديث المعلومات بنجاح",
                    backgroundColor: context.colorScheme.primary,
                    textColor: Colors.white,
                  );
                  SharedPreferencesHelper.updateUser(result.$1!);
                  if (context.mounted) {
                    context.pushReplacement(AppRoutes.home);
                  }
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildInputField(
    String label,
    String hint, {
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF121416),
            fontWeight: FontWeight.bold,
            fontFamily: "Tajawal",
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFFF1F2F4), width: 1),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            inputFormatters: keyboardType == TextInputType.number
                ? [FilteringTextInputFormatter.digitsOnly]
                : null,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide.none,
              ),
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Color(0xFF70798F),
                fontFamily: "Tajawal",
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
            ),
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: "Tajawal",
            ),
          ),
        ),
      ],
    );
  }
}
