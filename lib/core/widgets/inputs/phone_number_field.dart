import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/config/constants/spaces.dart';

class PhoneNumberField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const PhoneNumberField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.validator,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  // الدول العربية فقط مع العراق كافتراضي
  final List<CountryCode> _arabCountries = [
    CountryCode(name: 'العراق', code: '+964', flag: '🇮🇶'),
    CountryCode(name: 'السعودية', code: '+966', flag: '🇸🇦'),
    CountryCode(name: 'الإمارات', code: '+971', flag: '🇦🇪'),
    CountryCode(name: 'الكويت', code: '+965', flag: '🇰🇼'),
    CountryCode(name: 'قطر', code: '+974', flag: '🇶🇦'),
    CountryCode(name: 'البحرين', code: '+973', flag: '🇧🇭'),
    CountryCode(name: 'عمان', code: '+968', flag: '🇴🇲'),
    CountryCode(name: 'الأردن', code: '+962', flag: '🇯🇴'),
    CountryCode(name: 'لبنان', code: '+961', flag: '🇱🇧'),
    CountryCode(name: 'سوريا', code: '+963', flag: '🇸🇾'),
    CountryCode(name: 'فلسطين', code: '+970', flag: '🇵🇸'),
    CountryCode(name: 'مصر', code: '+20', flag: '🇪🇬'),
    CountryCode(name: 'ليبيا', code: '+218', flag: '🇱🇾'),
    CountryCode(name: 'تونس', code: '+216', flag: '🇹🇳'),
    CountryCode(name: 'الجزائر', code: '+213', flag: '🇩🇿'),
    CountryCode(name: 'المغرب', code: '+212', flag: '🇲🇦'),
    CountryCode(name: 'السودان', code: '+249', flag: '🇸🇩'),
    CountryCode(name: 'اليمن', code: '+967', flag: '🇾🇪'),
  ];

  late CountryCode _selectedCountry;

  @override
  void initState() {
    super.initState();
    // العراق كافتراضي
    _selectedCountry = _arabCountries.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 24 / 16,
            letterSpacing: 0,
          ),
          textAlign: TextAlign.right,
        ),
        const Gap(AppSpaces.small),
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(AppSpaces.large),
          ),
          child: Row(
            children: [
              // رمز الدولة (بداخل الحقل)
              InkWell(
                onTap: _showCountryPicker,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(AppSpaces.large),
                  bottomRight: Radius.circular(AppSpaces.large),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(AppSpaces.large),
                      bottomRight: Radius.circular(AppSpaces.large),
                    ),
                    border: Border(
                      left: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedCountry.flag,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Gap(4),
                      Text(
                        _selectedCountry.code,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const Gap(4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              // حقل رقم الهاتف
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.right,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  onChanged: widget.onChanged,
                  validator: widget.validator,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // مقبض السحب
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // العنوان
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'اختر رمز الدولة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),

            // قائمة الدول العربية
            Expanded(
              child: ListView.builder(
                itemCount: _arabCountries.length,
                itemBuilder: (context, index) {
                  final country = _arabCountries[index];
                  final isSelected = country.code == _selectedCountry.code;

                  return ListTile(
                    leading: Text(
                      country.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      country.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.black87,
                      ),
                    ),
                    trailing: Text(
                      country.code,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[600],
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    onTap: () {
                      setState(() {
                        _selectedCountry = country;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// نموذج بيانات رمز الدولة
class CountryCode {
  final String name;
  final String code;
  final String flag;

  CountryCode({
    required this.name,
    required this.code,
    required this.flag,
  });
}
