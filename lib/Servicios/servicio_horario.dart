// // Función para obtener las asignaturas desde la base de datos
//   Future<List<Asignatura>> obtenerAsignaturasPorUsuario() async {
//     final supabase = Supabase.instance.client;
//     final Session? session = supabase.auth.currentSession;
//     final userId = session?.user.id;

//     if (userId == null) {
//       throw ArgumentError('El userId no puede ser nulo');
//     }

//     final response = await supabase
//         .from('asignaturas')
//         .select('nombre, dias_semana')
//         .eq('id_usuario', userId);

//     if (response.isEmpty) {
//       print('Error al obtener asignaturas:');
//       return [];
//     }

//     print(response);
//     List<Asignatura> asignaturas = [];
//     for (var row in response as List<Map<String, dynamic>>) {
//       // Convertir la lista de strings 'true'/'false' a List<bool>
//       List<bool> diasSeleccionados = (row['dias_semana'] as List<dynamic>)
//           .map((e) => e == 'true')
//           .toList();
//       asignaturas.add(Asignatura(
//         nombre: row['nombre'],
//         diasSeleccionados: diasSeleccionados,
//       ));
//     }
//     print(asignaturas);
//     return asignaturas;
//   }