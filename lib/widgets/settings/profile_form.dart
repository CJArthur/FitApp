import 'package:fitapp/controllers/profile_controller.dart';
import 'package:fitapp/data/models/user_profile.dart';
import 'package:fitapp/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

// Форма хранит введённый текст, а ProfileController — сохранённые данные.
class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key, required this.initialProfile});

  final UserProfile initialProfile;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  // У каждого поля свой контроллер, как в форме добавления тренировки.
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  bool _saving = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.initialProfile;
    // При открытии страницы заполняем поля сохранёнными данными.
    // Дальше пользователь меняет только текст полей, а не сам профиль.
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _middleNameController.text = profile.middleName;
    _birthDateController.text = profile.birthDate;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _heightController.text = _formatNumber(profile.height);
    _weightController.text = _formatNumber(profile.weight);
    _targetWeightController.text = _formatNumber(profile.targetWeight);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  bool _isValidNumber(String text) {
    if (text.isEmpty) return true; // Поле можно оставить пустым.
    final number = double.tryParse(text);
    if (number == null || !number.isFinite || number <= 0) {
      return false;
    }
    return true;
  }

  bool _isValidBirthDate(String text) {
    if (text.isEmpty) return true;

    // Разбиваем 12.05.1995 на день, месяц и год обычным split.
    final parts = text.split('.');
    if (parts.length != 3) return false;
    if (parts[0].length != 2 || parts[1].length != 2 || parts[2].length != 4) {
      return false;
    }
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return false;

    final date = DateTime(year, month, day);
    // Например, 31 февраля DateTime переносит в март. Сверка это обнаружит.
    if (year < 1900 || date.day != day || date.month != month ||
        date.year != year || date.isAfter(DateTime.now())) {
      return false;
    }
    return true;
  }

  Future<void> _showError(String message) {
    return showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text('Не удалось сохранить'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (_saving) return;

    // Читаем поля и убираем пробелы по краям.
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final middleName = _middleNameController.text.trim();
    final birthDate = _birthDateController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    // Для дробного веса принимаем и 78.5, и 78,5.
    final height = _heightController.text.trim().replaceAll(',', '.');
    final weight = _weightController.text.trim().replaceAll(',', '.');
    final targetWeight = _targetWeightController.text.trim().replaceAll(',', '.');

    // Проверки выполняются перед созданием объекта, как в форме тренировки.
    if (!_isValidNumber(height) || !_isValidNumber(weight) ||
        !_isValidNumber(targetWeight)) {
      await _showError('Рост, вес и цель должны быть числами больше нуля.');
      return;
    }
    if (!_isValidBirthDate(birthDate)) {
      await _showError('Проверьте дату рождения. Формат: ДД.ММ.ГГГГ.');
      return;
    }
    // Простая проверка email без регулярных выражений.
    if (email.isNotEmpty) {
      final parts = email.split('@');
      if (parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty ||
          !parts[1].contains('.') || parts[1].startsWith('.') ||
          parts[1].endsWith('.') || email.contains(' ') ||
          email.contains('\t') || email.contains('\n')) {
        await _showError('Проверьте email. Пример: name@mail.ru.');
        return;
      }
    }

    if (!mounted) return;
    FocusScope.of(context).unfocus();
    final controller = context.read<ProfileController>();
    final profile = UserProfile(
      firstName: firstName,
      lastName: lastName,
      middleName: middleName,
      birthDate: birthDate,
      email: email,
      phone: phone,
      // Пустое поле превращается в null, заполненное — в число.
      height: double.tryParse(height),
      weight: double.tryParse(weight),
      targetWeight: double.tryParse(targetWeight),
    );
    setState(() {
      _saving = true;
      _saved = false;
    });
    try {
      // Контроллер → DAO → SQLite. После записи notifyListeners обновит шапку.
      await controller.save(profile);
      if (mounted) setState(() => _saved = true);
    } catch (_) {
      if (mounted) {
        await _showError('Данные остались в форме. Попробуйте ещё раз.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accent.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Поля, их проверки и кнопка сохранения находятся в одном виджете.
        _buildSectionTitle('ЛИЧНЫЕ ДАННЫЕ'),
        CupertinoFormSection.insetGrouped(
          margin: EdgeInsets.zero,
          backgroundColor: CupertinoColors.transparent,
          decoration: BoxDecoration(
            color: AppColors.accentCard.resolveFrom(context),
            borderRadius: BorderRadius.circular(16),
          ),
          children: [
            _buildField('Имя', _firstNameController, placeholder: 'Не указано'),
            _buildField('Фамилия', _lastNameController, placeholder: 'Не указано'),
            _buildField('Отчество', _middleNameController, placeholder: 'Не указано'),
            _buildField('Дата рождения', _birthDateController,
                placeholder: 'ДД.ММ.ГГГГ', keyboardType: TextInputType.datetime),
            _buildField('Email', _emailController,
                placeholder: 'Не указан', keyboardType: TextInputType.emailAddress),
            _buildField('Телефон', _phoneController,
                placeholder: 'Не указан', keyboardType: TextInputType.phone),
            _buildField('Рост, см', _heightController,
                placeholder: 'Не указан',
                keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            _buildField('Вес, кг', _weightController,
                placeholder: 'Не указан',
                keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            _buildField('Цель, кг', _targetWeightController,
                placeholder: 'Желаемый вес',
                keyboardType: const TextInputType.numberWithOptions(decimal: true)),
          ],
        ),
        const SizedBox(height: 16),
        CupertinoButton(
          color: accent,
          borderRadius: BorderRadius.circular(14),
          onPressed: _saving ? null : _save,
          child: _saving
              ? const CupertinoActivityIndicator()
              : Text(
                  _saved ? 'Сохранено' : 'Сохранить',
                  style: TextStyle(
                    color: AppColors.accentText.resolveFrom(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ],
    );
  }

  // Один простой метод для одинакового оформления полей.
  // Передаём контроллер напрямую, без поиска в карте по строковому ключу.
  Widget _buildField(
    String label,
    TextEditingController controller, {
    required String placeholder,
    TextInputType? keyboardType,
  }) {
    return CupertinoFormRow(
      prefix: SizedBox(
        width: 112,
        child: Text(label, style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: CupertinoTextField.borderless(
        controller: controller,
        readOnly: _saving,
        placeholder: placeholder,
        textAlign: TextAlign.end,
        style: TextStyle(fontSize: 14, color: CupertinoColors.label.resolveFrom(context)),
        keyboardType: keyboardType,
        autocorrect: keyboardType == null,
        padding: EdgeInsets.zero,
        onChanged: (_) {
          // После редактирования снова показываем на кнопке «Сохранить».
          if (_saved) {
            setState(() {
              _saved = false;
            });
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 28, 0, 12),
      child: Text(title, style: const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w600, color: CupertinoColors.systemGrey,
      )),
    );
  }
}

String _formatNumber(double? value) {
  if (value == null) return '';
  // Целое число выводим как 78, дробное — как 78.5.
  if (value == value.truncateToDouble()) {
    return value.toInt().toString();
  }
  return value.toString();
}
