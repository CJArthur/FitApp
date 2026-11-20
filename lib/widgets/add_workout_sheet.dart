import 'package:fitapp/l10n/app_localizations.dart';
import 'package:fitapp/controllers/workouts_controller.dart';
import 'package:fitapp/data/models/workout.dart';
import 'package:fitapp/data/models/workout_template.dart';
import 'package:fitapp/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

// Точка входа: вызываем этой функцией
Future<void> showAddWorkoutSheet(BuildContext context) {
  final controller = context.read<WorkoutsController>();
  return showCupertinoModalPopup(
    context: context,
    builder: (_) => ChangeNotifierProvider.value(
      // передаём тот же контроллер внутрь модалки
      value: controller,
      child: const _AddWorkoutSheet(),
    ),
  );
}

class _AddWorkoutSheet extends StatelessWidget {
  const _AddWorkoutSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Свой маленький навигатор — чтобы переключать "список шаблонов" <-> "форма",
      // не выходя из модалки
      child: Navigator(
        onGenerateRoute: (_) => CupertinoPageRoute(
          builder: (_) => const _TemplatesPage(),
        ),
      ),
    );
  }
}

class _TemplatesPage extends StatelessWidget {
  const _TemplatesPage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.addWorkout),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(l10n.close),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: workoutTemplates.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final template = workoutTemplates[index];
                  return _TemplateCard(template: template);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CupertinoButton(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(14),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => const _CustomWorkoutForm()),
                  );
                },
                child: Text(l10n.customWorkout, style: TextStyle(color: AppColors.accentText.resolveFrom(context))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template});

  final WorkoutTemplate template;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentCard.resolveFrom(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(template.time, style: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 13)),
                const SizedBox(height: 4),
                Text(template.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  l10n.workoutDetails(template.coach, template.durationMinutes),
                  style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
                ),
              ],
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              final controller = context.read<WorkoutsController>();
              await controller.addWorkout(Workout(
                date: controller.formattedSelectedDate, // геттер, добавим ниже
                title: template.title,
                time: template.time,
                coach: template.coach,
                durationMinutes: template.durationMinutes,
              ));
              if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Icon(CupertinoIcons.add_circled_solid, size: 28, color: CupertinoColors.activeGreen),
          ),
        ],
      ),
    );
  }
}

class _CustomWorkoutForm extends StatefulWidget {
  const _CustomWorkoutForm();

  @override
  State<_CustomWorkoutForm> createState() => _CustomWorkoutFormState();
}

class _CustomWorkoutFormState extends State<_CustomWorkoutForm> {
  DateTime _time = DateTime(0, 0, 0, 0, 0); // только время важно, дата игнорируется
  final _titleController = TextEditingController();
  final _trainerController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _trainerController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final h = _time.hour.toString().padLeft(2, '0');
    final m = _time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  // Сохранение нашей тренировки
  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final title = _titleController.text.trim();
    final duration = int.tryParse(_durationController.text.trim());

    if (title.isEmpty || duration == null || duration <= 0) {
      // Простая валидация: без красивых ошибок под полями, просто не даём сохранить
      showCupertinoDialog(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: Text(l10n.checkFields),
          content: Text(l10n.workoutValidation),
          actions: [
            CupertinoDialogAction(
              child: Text(l10n.ok),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        ),
      );
      return;
    }
    
    final controller = context.read<WorkoutsController>();
    final trainer = _trainerController.text.trim();

    await controller.addWorkout(Workout(
      date: controller.formattedSelectedDate,
      title: title,
      time: _formattedTime,
      coach: trainer.isEmpty ? '—' : trainer,
      durationMinutes: duration,
    ));

    if (mounted) Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.customWorkout),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _save,
          child: Text(l10n.save),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l10n.time, style: TextStyle(color: CupertinoColors.systemGrey)),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: _time,
                use24hFormat: true,
                onDateTimeChanged: (value) => setState(() => _time = value),
              ),
            ),
            const SizedBox(height: 16),
            _buildField(l10n.workoutTitle, _titleController, placeholder: l10n.workoutExample),
            const SizedBox(height: 16),
            _buildField(l10n.coachOptional, _trainerController, placeholder: l10n.coachName),
            const SizedBox(height: 16),
            _buildField(
              l10n.durationMinutes,
              _durationController,
              placeholder: '60',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildField(
    String label,
    TextEditingController controller, {
    required String placeholder,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: CupertinoColors.systemGrey)),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          keyboardType: keyboardType,
          padding: const EdgeInsets.all(12),
        ),
      ],
    );
  }
}