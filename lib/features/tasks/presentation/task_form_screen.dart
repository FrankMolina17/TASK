import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Borrador temporal: todavía no se envía a la API (POST en la sesión 10).
class TaskDraft {
  const TaskDraft(this.title, this.description, this.priority, {this.dueDate});

  final String title;
  final String description;
  final String priority;
  final DateTime? dueDate;
}

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  String? _priority;
  DateTime? _dueDate;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  /// La fecha es opcional: dejarla sin elegir no bloquea Guardar.
  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      helpText: 'Fecha opcional de entrega',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    if (!mounted || picked == null) return;
    setState(() => _dueDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final draft = TaskDraft(
      _title.text.trim(),
      _description.text.trim(),
      _priority!,
      dueDate: _dueDate,
    );
    context.pop(draft);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva tarea')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ej. Entregar informe de móviles',
              ),
              validator: (value) {
                final title = value?.trim() ?? '';
                if (title.isEmpty) return 'El título no puede estar vacío.';
                if (title.length < 3) {
                  return 'Escribe al menos 3 caracteres en el título.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Cuéntale a tu yo del futuro qué hay que hacer',
              ),
              maxLines: 3,
              validator: (value) {
                final description = value?.trim() ?? '';
                if (description.isEmpty) {
                  return 'La descripción no puede estar vacía.';
                }
                if (description.length < 5) {
                  return 'Agrega al menos 5 caracteres de descripción.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _priority,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Prioridad'),
              hint: const Text('Elige una prioridad'),
              items: const ['Alta', 'Media', 'Baja']
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              validator: (value) =>
                  value == null ? 'Selecciona una prioridad.' : null,
              onChanged: (value) => setState(() => _priority = value),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDueDate,
                    icon: const Icon(Icons.event),
                    label: Text(
                      _dueDate == null
                          ? 'Agregar fecha (opcional)'
                          : 'Entrega: ${_formatDate(_dueDate!)}',
                    ),
                  ),
                ),
                if (_dueDate != null)
                  IconButton(
                    tooltip: 'Quitar fecha',
                    onPressed: () => setState(() => _dueDate = null),
                    icon: const Icon(Icons.event_busy),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'La fecha es opcional: puedes guardar sin elegirla.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _submit,
                    child: const Text('Guardar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
