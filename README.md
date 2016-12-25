# Bibing Salas Bot

Bot para gestionar las reservas de salas de la Biblioteca de la ETSI de
Sevilla.

**NOTA: Para funcionar necesita de un `uvus` y `contraseña` para poder
realizar la autenticación. Estos datos se almacenarán en una base de datos.
Para mayor seguridad, la contraseña se almacenará cifrada usando un código que
se preguntará al usuario cada vez que sea necesario usarse.**

## Uso

El bot en Telegram es [@SalasETSIBot](http://telegram.me/SalasETSIBot). Una vez
inicializado el bot, se podrá usar el comando `/ayuda` para listar las
funcionalidades disponibles.

## Funcionamiento

La lógica está programada en Elixir y funciona como un servicio que se
comunica tanto con la API de Telegram para bots como con la API REST
**no oficial** para la reserva de salas
([http://api.salas.gonebe.com](http://api.salas.gonebe.com)) cuyo
código fuente puede encontrarse en
[https://bigomby.github.io/bibing-salas-api](https://bigomby.github.io/bibing-salas-api).

## Roadmap

| Funcionalidad                            | Versión | Estado actual |  
|------------------------------------------|---------|---------------|
| Cliente para la API de Reserva de Salas  | 0.1     | 0.0%          |
| Cliente para la API Telegram Bots        | 0.2     | Pendiente     |
| Persistencia                             | 0.3     | Pendiente     |
| Cola de tareas                           | 0.4     | Pendiente     |
| Lógica del bot                           | 0.5     | Pendiente     |
| API para administración                  | 0.6     | Pendiente     |
| Métricas                                 | 0.7     | Pendiente     |
| Release                                  | 1.0     | Pendiente     |
