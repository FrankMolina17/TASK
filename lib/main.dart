import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowPalette {
  static const Color deepTeal = Color(0xFF0F3D3E);
  static const Color teal = Color(0xFF1A6B6C);
  static const Color mint = Color(0xFF7FD1B9);
  static const Color cream = Color(0xFFF4F1EA);
  static const Color amber = Color(0xFFE8A838);
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: TaskFlowPalette.teal,
          primary: TaskFlowPalette.teal,
          secondary: TaskFlowPalette.amber,
          surface: TaskFlowPalette.cream,
        ),
        scaffoldBackgroundColor: TaskFlowPalette.cream,
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
  });

  final int id;
  final String title;
  final String description;
  final String priority;
  final bool isCompleted;
}

const demoTasks = [
  Task(
    id: 1,
    title: 'Personalizar la bienvenida de TaskFlow',
    description:
        'Mostrar nombre, curso y mensaje motivacional en la primera pantalla',
    priority: 'Alta',
    isCompleted: true,
  ),
  Task(
    id: 2,
    title: 'Agregar y completar tareas con setState',
    description:
        'Convertir la bienvenida en StatefulWidget y controlar pendientes',
    priority: 'Alta',
    isCompleted: true,
  ),
  Task(
    id: 3,
    title: 'Construir el listado local de tareas',
    description: 'Modelar Task, extraer TaskCard y usar ListView.builder',
    priority: 'Alta',
    isCompleted: false,
  ),
  Task(
    id: 4,
    title: 'Preparar la navegación al detalle',
    description: 'Usar el id de cada tarea para abrir una pantalla de detalle',
    priority: 'Media',
    isCompleted: false,
  ),
  Task(
    id: 5,
    title: 'Conectar el backlog a una API',
    description: 'Reemplazar los datos locales por una arquitectura MVVM',
    priority: 'Baja',
    isCompleted: false,
  ),
];

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TaskListScreen()),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        final taskId = int.parse(state.pathParameters['id']!);
        return TaskDetailScreen(taskId: taskId);
      },
    ),
  ],
);

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.onTap});

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: TaskFlowPalette.mint),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isCompleted ? Colors.green : TaskFlowPalette.teal,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: TaskFlowPalette.deepTeal,
            fontWeight: FontWeight.w600,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          '${task.priority} · ${task.description}',
          style: const TextStyle(color: TaskFlowPalette.teal),
        ),
        trailing: IconButton(
          tooltip: 'Ver detalle',
          onPressed: onTap,
          icon: const Icon(
            Icons.chevron_right,
            color: TaskFlowPalette.deepTeal,
          ),
        ),
      ),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TaskFlowPalette.deepTeal,
        foregroundColor: Colors.white,
        title: const Text('Mis tareas'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoTasks.length,
        itemBuilder: (context, index) {
          final task = demoTasks[index];
          return TaskCard(
            task: task,
            onTap: () => context.push('/task/${task.id}'),
          );
        },
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final int taskId;

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red.shade700;
      case 'Media':
        return TaskFlowPalette.amber;
      default:
        return TaskFlowPalette.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = demoTasks.firstWhere((item) => item.id == taskId);
    final statusLabel = task.isCompleted
        ? 'Estado: completada'
        : 'Estado: pendiente';
    final contextualLabel = task.isCompleted
        ? 'Esta tarea ya está cerrada en el backlog'
        : 'Esta tarea sigue abierta y requiere seguimiento';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TaskFlowPalette.deepTeal,
        foregroundColor: Colors.white,
        title: const Text('Detalle de tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: TaskFlowPalette.deepTeal,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              task.description,
              style: const TextStyle(
                color: TaskFlowPalette.teal,
                height: 1.5,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Chip(
              avatar: Icon(
                Icons.flag,
                size: 18,
                color: _priorityColor(task.priority),
              ),
              label: Text('Prioridad: ${task.priority}'),
              backgroundColor: Colors.white,
              side: BorderSide(color: _priorityColor(task.priority)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  task.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: task.isCompleted ? Colors.green : TaskFlowPalette.teal,
                ),
                const SizedBox(width: 8),
                Text(
                  statusLabel,
                  style: const TextStyle(
                    color: TaskFlowPalette.deepTeal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: TaskFlowPalette.mint),
              ),
              child: ListTile(
                leading: Icon(
                  task.isCompleted ? Icons.verified : Icons.schedule,
                  color: task.isCompleted
                      ? Colors.green
                      : TaskFlowPalette.amber,
                ),
                title: Text(
                  contextualLabel,
                  style: const TextStyle(
                    color: TaskFlowPalette.deepTeal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Ruta: /task/${task.id}',
                  style: const TextStyle(color: TaskFlowPalette.teal),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver al listado'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const String appName = 'TaskFlow';
  static const String courseName = 'Aplicaciones Móviles';
  static const int dailyGoal = 5;

  final String studentName = 'Franklin Molina';
  int pendingTasks = 3;
  int completedTasks = 0;

  void _addTask() {
    setState(() {
      pendingTasks++;
    });
  }

  void _completeTask() {
    if (pendingTasks == 0) {
      return;
    }

    setState(() {
      pendingTasks--;
      if (completedTasks < dailyGoal) {
        completedTasks++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusMessage = pendingTasks == 0
        ? '¡Excelente! No tienes tareas pendientes.'
        : 'Aún tienes tareas por organizar.';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TaskFlowPalette.deepTeal,
        foregroundColor: Colors.white,
        title: const Text(appName),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: TaskFlowPalette.deepTeal,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.task_alt,
                      color: TaskFlowPalette.mint,
                      size: 56,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      appName,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      courseName,
                      style: TextStyle(color: TaskFlowPalette.mint),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '¡Hola, $studentName!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: TaskFlowPalette.deepTeal,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                statusMessage,
                style: const TextStyle(
                  color: TaskFlowPalette.teal,
                  height: 1.4,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Completadas hoy: $completedTasks de $dailyGoal',
                style: const TextStyle(
                  color: TaskFlowPalette.deepTeal,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 28),
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: TaskFlowPalette.mint),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: TaskFlowPalette.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.pending_actions,
                          color: TaskFlowPalette.amber,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tareas pendientes',
                              style: TextStyle(
                                color: TaskFlowPalette.teal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '$pendingTasks',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: TaskFlowPalette.deepTeal,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: _addTask,
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar tarea'),
                  ),
                  OutlinedButton.icon(
                    onPressed: pendingTasks == 0 ? null : _completeTask,
                    icon: const Icon(Icons.done),
                    label: const Text('Completar una tarea'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
