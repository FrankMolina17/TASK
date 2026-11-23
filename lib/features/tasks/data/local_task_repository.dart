import '../domain/task.dart';
import 'task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  final List<Task> _tasks = [
    const Task(
      id: 1,
      title: 'Personalizar la bienvenida de TaskFlow',
      description:
          'Mostrar nombre, curso y mensaje motivacional en la primera pantalla',
      priority: 'Alta',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 2,
      title: 'Agregar y completar tareas con setState',
      description:
          'Convertir la bienvenida en StatefulWidget y controlar pendientes',
      priority: 'Alta',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 3,
      title: 'Construir el listado local de tareas',
      description: 'Modelar Task, extraer TaskCard y usar ListView.builder',
      priority: 'Alta',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 4,
      title: 'Preparar la navegación al detalle',
      description:
          'Usar el id de cada tarea para abrir una pantalla de detalle',
      priority: 'Media',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 5,
      title: 'Conectar el backlog a una API',
      description: 'Reemplazar los datos locales por una arquitectura MVVM',
      priority: 'Baja',
      isCompleted: false,
      userId: 1,
    ),
  ];

  @override
  Future<List<Task>> getTasks() async => List.unmodifiable(_tasks);

  @override
  void save(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
  }
}
