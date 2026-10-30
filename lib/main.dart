import 'package:flutter/material.dart';

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
    return MaterialApp(
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
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String appName = 'TaskFlow';
  static const String courseName = 'Aplicaciones Móviles';
  static const String studentName = 'Franklin Molina';
  static const String welcomeMessage =
      'Bienvenido a TaskFlow. Organiza tus pendientes y avanza el reto final conectado a una API.';
  static const int pendingTasks = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TaskFlowPalette.deepTeal,
        foregroundColor: Colors.white,
        title: const Text(appName),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: TaskFlowPalette.deepTeal,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: TaskFlowPalette.mint,
                      size: 56,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      appName,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                'Hola, $studentName',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: TaskFlowPalette.deepTeal,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                welcomeMessage,
                style: TextStyle(
                  color: TaskFlowPalette.teal,
                  height: 1.4,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
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
                          Icons.assignment_outlined,
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
            ],
          ),
        ),
      ),
    );
  }
}
