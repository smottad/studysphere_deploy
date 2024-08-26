import 'package:flutter/material.dart';
import 'package:studysphere/Servicios/servicio_abrir_nav.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
final Session? session = supabase.auth.currentSession;
esPremium() async {
  final response = await supabase
      .from('usuarios')
      .select("tipo_cuenta")
      .eq("id", session!.user.id);
  return response[0];
}

AppBar appBar(BuildContext context, String titulo,
    {int color = 0, bool menu = false}) {
  Color colorTexto = Theme.of(context).colorScheme.onPrimary;
  Color colorBar = Theme.of(context).colorScheme.primary;
  if (color == 1) {
    colorTexto = Theme.of(context).colorScheme.onSecondary;
    colorBar = Theme.of(context).colorScheme.secondary;
  } else if (color == 2) {
    colorTexto = Theme.of(context).colorScheme.onTertiary;
    colorBar = Theme.of(context).colorScheme.tertiary;
  }
  Widget? leading;
  if (menu) {
    leading = Builder(builder: (BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      );
    });
  }
  return AppBar(
    leading: leading,
    titleTextStyle:
        Theme.of(context).textTheme.headlineMedium?.copyWith(color: colorTexto),
    backgroundColor: colorBar,
    foregroundColor: colorTexto,
    elevation: 2,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FutureBuilder(
            future: esPremium(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: const CircularProgressIndicator(),
                );
              }
              if (snapshot.data != null) {
                var result = snapshot.data as Map;
                if (result['tipo_cuenta'] == 0) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: const Image(
                      alignment: Alignment.centerLeft,
                      image: AssetImage("lib/Assets/premium_crown.png"),
                      height: 30,
                    ),
                  );
                }
                return InkWell(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: 40,
                    child: Row(
                      children: [
                        Text(
                          "Mejora a premium",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: colorTexto),
                        ),
                        const Image(
                            height: 30,
                            image: AssetImage("lib/Assets/free_crown.png")),
                      ],
                    ),
                  ),
                  onTap: () => abrirNav(context,
                      "https://studysphere-react.vercel.app/pagos?userId=${session?.user.id}"),
                );
              }
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: const CircularProgressIndicator(),
              );
            }),
        const Spacer(),
        Text(titulo),
        const Spacer(),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.15,
          child: const Image(
            alignment: Alignment.centerRight,
            image: AssetImage("lib/Assets/logo.png"),
            fit: BoxFit.contain,
            height: 55,
          ),
        ),
      ],
    ),
  );
}
