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

  Future<bool> iniciarSesion(String correo, String contrasena) async {
    final connection = await iniciarConexion();
    try {
      if (connection != null) {
        // Verificar si existe un usuario con el correo proporcionado
        final correoResult = await connection.execute(
          Sql.named('SELECT COUNT(*) FROM Usuarios WHERE Correo = @correo'),
          parameters: {
            'correo': correo,
          },
        );

        // Verificar si existe un usuario con la contraseña proporcionada
        final contrasenaResult = await connection.execute(
          Sql.named(
              'SELECT COUNT(*) FROM Usuarios WHERE Contraseña = @contrasena'),
          parameters: {
            'contrasena': contrasena,
          },
        );

        // Si no hay usuarios con el correo proporcionado, el correo es incorrecto
        if (correoResult.isNotEmpty && (correoResult[0][0] as int) == 0) {
          print('El correo electrónico proporcionado es incorrecto');
          await cerrarConexion(connection);
          return false;
        }

        // Si no hay usuarios con la contraseña proporcionada, la contraseña es incorrecta
        if (contrasenaResult.isNotEmpty &&
            (contrasenaResult[0][0] as int) == 0) {
          print('La contraseña proporcionada es incorrecta');
          await cerrarConexion(connection);
          return false;
        }

        // Si hay al menos un usuario con el correo y la contraseña proporcionados, el inicio de sesión es exitoso
        final result = await connection.execute(
          Sql.named(
              'SELECT COUNT(*) FROM Usuarios WHERE Correo = @correo AND Contraseña = @contrasena'),
          parameters: {
            'correo': correo,
            'contrasena': contrasena,
          },
        );

        if (result.isNotEmpty && (result[0][0] as int) > 0) {
          print('Inicio de sesión exitoso');
          await cerrarConexion(connection);
          return true;
        } else {
          print('Correo electrónico o contraseña incorrectos');
          await cerrarConexion(connection);
          return false;
        }
      } else {
        print('No se pudo establecer la conexión con la base de datos');
        return false;
      }
    } catch (e) {
      print('Error al iniciar sesión: $e');
      await cerrarConexion(connection);
      throw e;
    }
  }
}
