# TASKFLOW

Aplicación móvil en Flutter para organizar tareas académicas.

## Alcance de TaskFlow

Problema: necesito organizar actividades académicas y saber cuáles faltan.
Usuario objetivo: estudiante que planifica entregas semanales.

### Historias de usuario y criterios de aceptación
1. Como estudiante, quiero listar mis tareas para ver qué debo hacer.
   Criterio: la lista muestra título, prioridad y estado de cada tarea.
2. Como estudiante, quiero abrir una tarea para leer su descripción.
   Criterio: al tocar una tarjeta aparece el detalle de la tarea elegida.
3. Como estudiante, quiero crear una tarea para registrar un pendiente.
   Criterio: el formulario guarda una tarea válida y la lista la muestra.
4. Como estudiante, quiero editar una tarea para corregir sus datos.
   Criterio: los cambios guardados aparecen en lista y detalle.
5. Como estudiante, quiero eliminar una tarea terminada para limpiar la lista.
   Criterio: después de confirmar, la tarea desaparece de la lista.

### Modelo de datos
Task: id (entero único), title (texto), description (texto),
priority (Alta, Media o Baja), isCompleted (verdadero/falso),
userId (entero que identifica al usuario de prueba).

### Pantallas previstas
Lista: tarjetas de tareas y acción para crear.
Detalle: información completa y futuras acciones de editar o eliminar.
Formulario: campos de título, descripción y prioridad.

### Requisitos no funcionales
La navegación debe tener textos comprensibles.
Un id inexistente debe mostrar un mensaje en vez de cerrar la app.

### Contrato de API que necesitaremos
GET /tasks        listar tareas
GET /tasks/:id    consultar detalle
POST /tasks       crear tarea
PATCH /tasks/:id  actualizar tarea
DELETE /tasks/:id eliminar tarea

### API de tareas

TaskFlow consulta tareas de JSONPlaceholder mediante HTTPS:

- URL base: `https://jsonplaceholder.typicode.com`
- Endpoint: `GET /todos`
- Parámetro de filtro: `userId=2` (limita los resultados al usuario 2)
- Campos que llegan del servidor: `id`, `title`, `completed`, `userId`
- Valores que TaskFlow completa por defecto: `description` → `'Sin descripción (API)'`, `priority` → `'Sin prioridad (API)'`
- El campo `completed` del servidor se lee como `isCompleted` del modelo local.
- Marcar una tarea como completada es solo local: el cambio se guarda en la copia en memoria y se pierde al reiniciar la app.

## Estructura

- `lib/task.dart`: modelo `Task` con constructor, campos y `Task.fromJson`.
- `lib/main.dart`: lista, detalle y navegación con go_router.
- `test/widget_test.dart`: prueba de la pantalla de lista.

## Ejecutar

```bash
flutter pub get
flutter run
```
