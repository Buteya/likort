import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberInput extends StatefulWidget {
  final Function(String) onPhoneNumberChanged;

  const PhoneNumberInput({super.key, required this.onPhoneNumberChanged});

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  String initialCountry = 'KE';
  PhoneNumber number = PhoneNumber(isoCode: 'KE');

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        widget.onPhoneNumberChanged(number.phoneNumber ?? '');
      },
      initialValue: number,
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      selectorTextStyle: const TextStyle(color: Colors.black),
      textFieldController: TextEditingController(),
      formatInput: false,
      maxLength: 15,
      countrySelectorScrollControlled: true,
      inputDecoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Phone Number',
      ),
    );
  }
}
