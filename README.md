<div align="center">

# SPAFEU Database

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17+-4169E1?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![SQL](https://img.shields.io/badge/SQL-Standard-003B57?logo=postgresql&logoColor=white)]()
[![Windows](https://img.shields.io/badge/Windows-Script%20de%20instalación-0078D6?logo=windows&logoColor=white)]()

Base de datos PostgreSQL para el **Sistema de Promoción de Actividad Física en Entornos Universitarios (SPAFEU)**.

Este repositorio contiene el esquema relacional, tipos de datos personalizados, relaciones de integridad referencial y datos semilla necesarios para gestionar usuarios, perfiles de salud, protocolos de actividad física, ejercicios, cuestionarios y sesiones de entrenamiento.

</div>

---

## Tabla de contenidos

1. [Descripción general](#descripción-general)
2. [Características](#características)
3. [Tecnologías y requisitos](#tecnologías-y-requisitos)
4. [Estructura del repositorio](#estructura-del-repositorio)
5. [Instalación](#instalación)
   - [Instalación automática (Windows)](#instalación-automática-windows)
   - [Instalación manual](#instalación-manual)
6. [Modelo de datos](#modelo-de-datos)
7. [Convenciones y estándares](#convenciones-y-estándares)
8. [Contribución](#contribución)
9. [Contribuyentes](#contribuyentes)
10. [Licencia](#licencia)

---

## Descripción general

SPAFEU es una plataforma orientada a promover hábitos de actividad física en comunidades universitarias. El módulo de base de datos centraliza la información necesaria para:

- Registrar y autenticar usuarios con roles diferenciados.
- Almacenar perfiles de salud y condición física de cada usuario.
- Aplicar cuestionarios de evaluación (PAR-Q e historial de actividad física).
- Asignar protocolos de ejercicio personalizados según el nivel de actividad física.
- Registrar sesiones de ejercicio completadas por los usuarios.
- Gestionar la relación entre sedes (campus) y programas académicos.

---

## Características

- Esquema relacional normalizado en el esquema `public` de PostgreSQL.
- Tipos personalizados (`ENUM`) para estados, roles y niveles de actividad física.
- Claves primarias y foráneas con restricciones de integridad referencial.
- Índices únicos para garantizar la consistencia de datos críticos.
- Datos iniciales incluidos:
  - 4 sedes universitarias.
  - 36 programas académicos.
  - Relación sede-programa activa.
  - Cuestionarios PAR-Q e historial de actividad física con opciones y preguntas.
  - 4 protocolos de actividad física con objetivos y ejercicios clasificados.
- Gestión de tokens de seguridad:
  - Activación de cuentas (`account_activation_tokens`).
  - Refresh tokens (`refresh_tokens`) con estado `REVOKED`.
- Historial de niveles de actividad física (`user_level_history`).
- Script de instalación automatizado para entornos Windows.

---

## Tecnologías y requisitos

| Tecnología | Versión recomendada | Descripción |
|------------|---------------------|-------------|
| [![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17+-4169E1?logo=postgresql&logoColor=white)](https://www.postgresql.org/) | `17 o superior` | Motor de base de datos relacional principal |
| [![psql](https://img.shields.io/badge/psql-Incluido-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/docs/current/app-psql.html) | Incluido con PostgreSQL | Cliente de línea de comandos de PostgreSQL |
| [![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D6?logo=windows&logoColor=white)](https://www.microsoft.com/windows) | `10/11` | Sistema operativo recomendado para el script `install.bat` |

### Requisitos previos

1. Tener PostgreSQL instalado y en ejecución.
2. Crear previamente la base de datos `spafeu_db`:

   ```sql
   CREATE DATABASE spafeu_db WITH ENCODING = 'UTF8';
   ```

3. Disponer de un usuario con permisos suficientes para crear objetos y ejecutar `INSERT` (por ejemplo, `postgres`).
4. El comando `psql` debe estar disponible en la variable de entorno `PATH`.

---

## Estructura del repositorio

```
db/
├── README.md
└── release/
    └── 0.0.1/
        ├── 01_types.sql      # Tipos de datos personalizados (ENUM)
        ├── 02_schema.sql     # Definición de tablas, claves y relaciones
        ├── 03_import.sql     # Datos iniciales (seed data)
        └── install.bat       # Script de instalación automática para Windows
```

---

## Instalación

### Instalación automática (Windows)

1. Abrir una terminal en `release/0.0.1`.
2. Ejecutar el script de instalación:

   ```cmd
   install.bat
   ```

El script ejecutará los archivos SQL en el orden correcto, usando codificación `UTF8` y el usuario `postgres`. Si ocurre algún error, el proceso se detendrá y mostrará un mensaje.

> El script asume que la base de datos `spafeu_db` ya existe. Si aún no la has creado, ejecuta el comando SQL de la sección [Requisitos previos](#requisitos-previos).

### Instalación manual

Si prefieres no usar el script `install.bat`, ejecuta los archivos SQL en el siguiente orden:

```bash
psql -U postgres -d spafeu_db --encoding=UTF8 -f 01_types.sql
psql -U postgres -d spafeu_db --encoding=UTF8 -f 02_schema.sql
psql -U postgres -d spafeu_db --encoding=UTF8 -f 03_import.sql
```

**Orden de ejecución obligatorio:**

1. `01_types.sql` — Crea los tipos personalizados (`ENUM`) usados por el esquema.
2. `02_schema.sql` — Crea las tablas, secuencias, restricciones y claves foráneas.
3. `03_import.sql` — Inserta los datos iniciales.

---

## Modelo de datos

El esquema incluye las siguientes entidades principales:

| Entidad | Descripción |
|---------|-------------|
| `users` | Usuarios registrados en el sistema. |
| `roles` | Roles disponibles (`ROLE_USER`, `ROLE_SUPERVISOR`, `ROLE_ADMIN`, `ROLE_SUPERADMIN`, `ROLE_VALIDADOR`, `ROLE_VALIDADOR_WALLET`). |
| `users_roles` | Relación muchos-a-muchos entre usuarios y roles. |
| `user_health_profile` | Perfil de salud del usuario (IMC, peso, altura, sexo, fecha de nacimiento, semestre, sede, programa, nivel de actividad física). |
| `password_reset_tokens` | Tokens para recuperación de contraseña con estado y expiración. |
| `account_activation_tokens` | Tokens para activación de cuentas de usuario. |
| `refresh_tokens` | Tokens de refresco de sesión con estado activo/revocado. |
| `user_level_history` | Histórico de cambios en el nivel de actividad física de cada usuario. |
| `campus` | Sedes universitarias. |
| `academic_program` | Programas académicos. |
| `campus_program` | Relación entre sedes y programas activos. |
| `questionnaire` | Cuestionarios de evaluación. |
| `question` | Preguntas de cada cuestionario. |
| `option` | Opciones de respuesta. |
| `question_option` | Relación entre preguntas y opciones válidas. |
| `user_answer` | Respuestas de los usuarios a los cuestionarios. |
| `physical_activity_protocol` | Protocolos de actividad física por nivel. |
| `protocol_objective` | Objetivos de cada protocolo. |
| `exercise` | Ejercicios asociados a un protocolo, tipo, intensidad y duración. |
| `activity_type` | Tipos de actividad (aeróbica, fuerza, coordinación, flexibilidad, vuelta a la calma). |
| `intensity_type` | Niveles de intensidad. |
| `duration_type` | Descripciones de duración o volumen. |
| `user_exercise_session` | Registro de sesiones de ejercicio realizadas por los usuarios. |
| `mobile_application` | Aplicaciones móviles vinculadas a ejercicios. |

---

## Convenciones y estándares

- **Esquema:** Todos los objetos se crean en el esquema `public`.
- **Codificación:** UTF-8.
- **Nombres de tablas y columnas:** En minúsculas y `snake_case`.
- **Claves primarias:** Identidad autogenerada (`GENERATED BY DEFAULT AS IDENTITY`) para mantener la compatibilidad con inserciones de datos iniciales.
- **Claves foráneas:** Definidas explícitamente para garantizar la integridad referencial.
- **Tipos personalizados:** Definidos en un archivo separado para facilitar el versionado y la reutilización.

---

## Contribución

Si deseas contribuir al esquema de base de datos:

1. Crea una nueva carpeta de versión dentro de `release/` para cambios mayores.
2. Mantén el orden de ejecución: tipos → esquema → datos.
3. Incluye scripts idempotentes cuando sea posible.
4. Documenta cualquier cambio en este `README.md` y en el historial de versiones.

---

## Contribuyentes

Agradecemos a las personas que han participado en la construcción y evolución de este proyecto:

| 👤 Nombre | 📧 Correo | 🛠️ Rol / Contribución |
|-----------|-----------|------------------------|
| Cristian Misse | cgmisse@gmail.com | Diseño e implementación del esquema de base de datos, datos iniciales y scripts de instalación |

### Cómo aparecer aquí

> ¿Quieres aparecer aquí? Realiza una contribución significativa y añade tu nombre en un pull request.

---

## Licencia

Este proyecto es de uso interno para la Universidad y el proyecto SPAFEU. Consulta con el equipo de arquitectura antes de distribuir o modificar el esquema fuera del alcance autorizado.

---

**Versión actual:** `0.0.1`

Para dudas o soporte técnico, contacta al equipo de desarrollo de SPAFEU.
