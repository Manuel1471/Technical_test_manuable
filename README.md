# Prueba Técnica

Este proyecto es una aplicación desarrollada en Elixir que sigue una arquitectura limpia y modular. La estructura del proyecto está diseñada para separar las responsabilidades y facilitar el mantenimiento y la escalabilidad.

Si se gusta ver los pasos para crear el proyecto, se uso [Trello](https://trello.com/b/GhpC3gHM/prueba-tecnica-manuable) para separar las tareas

## Requisitos

Para poder ejecutar este proyecto, necesitas tener instaladas las siguientes versiones de Elixir, Erlang y Phoenix:

- **Elixir**: ~> 1.14
- **Erlang**: ~> 24 (recomendado)
- **Phoenix**: ~> 1.7.14

Ademas de tener MySQL.

## Acceso a la base de datos

Para poder hacer que el proyecto acceda a la base de datos, tiene que modificar las siguientes lineas en el archivo config/dev.exs y config/test.exs para que coincidan con sus credenciales, estas son unas de prueba.

```ex
  username: System.get_env("USERNAME_DB") || "root",
  password: System.get_env("PASSWORD_DB") || "root",
  hostname: System.get_env("HOST_DB") || "localhost",
  port: System.get_env("PORT_DB") || 3306,
```

Deberia quedar algo asi:

```ex
  username: System.get_env("USERNAME_DB") || "user",
  password: System.get_env("USERNAME_DB") || "password",
  hostname: System.get_env("USERNAME_DB") || "localhost",
  port: System.get_env("USERNAME_DB") || 3306,
```
Nota:
  - Aspectos a mejorar, agregar las variables de entorno desde el .env

## Estructura del Proyecto

El proyecto está organizado en los siguientes directorios y módulos:

### `config/`
Contiene los archivos de configuración de la aplicación, como `config.exs`, `dev.exs`, `test.exs`, y `prod.exs`. Estos archivos definen las configuraciones específicas para cada entorno.

### `test/`
Aquí se encuentran las pruebas unitarias y de integración de la aplicación. Las pruebas están organizadas en subdirectorios que reflejan la estructura del código fuente.

### `lib/`
Este es el directorio principal donde reside el código fuente de la aplicación. Está dividido en dos partes principales: `prueba_tecnica` y `prueba_tecnica_web`.

#### `prueba_tecnica/`
Contiene la lógica de negocio de la aplicación, organizada en diferentes módulos y contextos.

- **`application.ex`**: Define la aplicación principal y sus supervisores.

- **`core/`**: Contiene los módulos principales de la aplicación, organizados por dominios.

  - **`accounts/`**: Gestiona la lógica del negocio relacionada con los usuarios.
    - **`entities/`**: Define las entidades del dominio, como `user.ex`.
    - **`use_cases/`**: Contiene los casos de uso para el usuario en `use_cases_users.ex`.

  - **`authorization/`**: Gestiona la lógica del negocio  de autorización y roles.
    - **`entities/`**: Define las entidades relacionadas con la autorización, como `role.ex` y `permission.ex`.
    - **`use_cases/`**: Contiene los casos de uso, como `use_cases_roles.ex` y `use_cases_permissions.ex`.

  - **`tenancy/`**: Gestiona la lógica del negocio  relacionada con los inquilinos (tenants).
    - **`entities/`**: Define las entidades relacionadas con los inquilinos, como `tenant.ex`.
    - **`use_cases/`**: Contiene los casos de uso, como `use_cases_tenants.ex`.

  - **`infrastructure/`**: Contiene todo lo que tenga que ver con uso de librerias, funcionex auxiliares, etc. Esto es para no tener que ver codigo que manda llamar una funcion de una libreria desconocida.
    - **`repo.ex`**: Define el repositorio principal de la aplicación.
    - **`jwt_auth.ex`**: Implementación de la autenticación JWT de manera que el codigo que tiene que ver con el lado tecnico se separa de la logica necesaria en el plug.
  
  - **`interfaces/`**: Contiene las conexiones con la base de datos y todo lo relacionado con lo tecnico, esto hace que la logica se separe de las llamadas a librerias o queries.
    - **`repositories/`**: Contiene los repositorios de queries para cada una de las necesidades de la logica de negocio.
      - **`tenant_entity.ex`**: Guarda los queries relacionados con tenants.
      - **`user_entity.ex`**: Guarda los queries relacionados con users.
      - **`role_entity.ex`**: Guarda los queries relacionados con roles.
      - **`permission_entity.ex`**: Guarda los queries relacionados con permissions.

#### `prueba_tecnica_web/`
Contiene la capa web de la aplicación, que maneja las solicitudes HTTP y las respuestas.

- **`controllers/`**: Contiene los controladores que manejan las solicitudes HTTP, estos se encargar de transformar y pasar la informacion a la logica del negocio.
  - **`user_controller.ex`**: Controlador para gestionar las operaciones relacionadas con usuarios.
  - **`role_controller.ex`**: Controlador para gestionar las operaciones relacionadas con roles.
  - **`permission_controller.ex`**: Controlador para gestionar las operaciones relacionadas con permisos.
  - **`tenant_controller.ex`**: Controlador para gestionar las operaciones relacionadas con tenats.

- **`plugs/`**: Contiene los plugs que manejan las solicitudes HTTP, estos plugs solo manejan la logica del plug, para funciones que utilizan las librerias se encuentra en `jwt_auth.ex`.
  - **`admin_rol_plug.ex`**: Plug para manejar la autorizacion de los administradores.
  - **`auth_plug.ex`**: Plug para gestionar las autenticaciones.

- **`endpoint.ex`**: Define el endpoint principal de la aplicación.

- **`gettext.ex`**: Configuración para la internacionalización (i18n).

- **`router.ex`**: Define las rutas de la aplicación.

- **`telemetry.ex`**: Configuración para la telemetría y monitoreo.

- **`prueba_tecnica.ex`**: Define el módulo principal de la aplicación.

- **`prueba_tecnica_web.ex`**: Define el módulo principal de la capa web.

## Cómo Ejecutar el Proyecto

1. **Clona el repositorio**:
   ```bash
   git clone https://github.com/tu-usuario/prueba_tecnica.git
   cd prueba_tecnica
   ```

2. Instala las dependencias, corre las migraciones, inicializa algunos datos:
    ```bash
    mix setup
    ```
3. Correr el proyecto:
    ```bash
    mix phx.server
    ```

4. Accede a la aplicación: Abre tu navegador y visita http://localhost:4000.
