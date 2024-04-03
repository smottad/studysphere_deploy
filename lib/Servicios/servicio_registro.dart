import 'package:postgres/postgres.dart';

class ServicioBaseDatos {
  Future<Connection?> iniciarConexion() async {
    // Add a return statement at the end of the method
    try {
      final connection = await Connection.open(
        Endpoint(
          host:
              '192.168.56.1', // la dirección IP del servidor de base de datos, por el momento es localhost pero la ip del computador
          port: 5432,
          database: 'ejemplo',
          username: 'postgres',
          password: 'Adm&n2531', // la contraseña de la base de datos
        ),
      );
      print('Conexión establecida con la base de datos');
      return connection;
    } catch (e) {
      print('Error al establecer conexión con la base de datos: $e');
      return null;
    }
  }

  Future<void> cerrarConexion(connection) async {
    try {
      await connection?.close();
      print('Conexión cerrada con la base de datos');
    } catch (e) {
      print('Error al cerrar conexión con la base de datos: $e');
    }
  }

  Future<String> insertarRegistros(String nombre, String correo, String edad,
      String telefono, String contrasena) async {
    final connection =
        await iniciarConexion(); // Espera a que la conexión se establezca

    try {
      if (connection != null) {
        // Verificar si el correo ya está registrado en la base de datos
        final result = await connection.execute(
          Sql.named('SELECT COUNT(*) FROM Usuarios WHERE Correo=@correo'),
          parameters: {'correo': correo},
        );

        // Si el correo ya está registrado, mostrar un mensaje de error
        if (result.isNotEmpty && (result[0][0] as int) > 0) {
          print('El correo ya está registrado');
          await cerrarConexion(connection); // Cerrar la conexión antes de salir
          return "El correo ya está registrado";
        }

        // Si el correo no está registrado, insertar el nuevo usuario en la base de datos
        print("hasta aqui bien");
        await connection.execute(
          r'INSERT INTO Usuarios (Nombre, Correo, Edad, Telefono, Contraseña ) VALUES ($1, $2, $3, $4, $5)',
          parameters: [
            nombre,
            correo,
            edad,
            telefono,
            contrasena,
          ],
        );

        print('Usuario registrado correctamente');
        await cerrarConexion(connection); // Cerrar la conexión antes de salir
        return "Usuario registrado correctamente";
      } else {
        print('No se pudo establecer la conexión con la base de datos');
        return "No se pudo establecer la conexión con la base de datos";
      }
    } catch (e) {
      print('Error al registrar usuario: $e');
      await cerrarConexion(connection); // Cerrar la conexión en caso de error
      throw e; // Relanzar la excepción para que el código que llama a esta función pueda manejarla
    }
  }
}
