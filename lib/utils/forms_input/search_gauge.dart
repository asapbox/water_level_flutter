import 'package:formz/formz.dart';

enum SearchGaugeInputError { empty }

class SearchGaugeInput extends FormzInput<String, SearchGaugeInputError> {
  const SearchGaugeInput.pure() : super.pure('');

  const SearchGaugeInput.dirty([String value = '']) : super.dirty(value);

  @override
  SearchGaugeInputError? validator(String? value) {
    return value?.isNotEmpty ?? true ? null : SearchGaugeInputError.empty;
  }
}
