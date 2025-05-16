# SysServices - Sistema Hospitalario de Admisión

SysServices es un sistema hospitalario de admisión y gestión de citas desarrollado como proyecto académico para la clase de **Programación Orientada a Objetos**.

## Descripción

El sistema permite la administración de pacientes, admisiones hospitalarias y citas médicas, facilitando la gestión de información relevante para el personal administrativo de un hospital.

## Características principales

- Registro y búsqueda de pacientes.
- Admisión de pacientes a especialidades médicas.
- Gestión y asignación de citas médicas.
- Visualización de historiales de admisión y citas.
- Interfaz gráfica amigable desarrollada en Windows Forms.
- Arquitectura en capas: Presentación, Negocio, Datos y Entidad.
- Uso de procedimientos almacenados y base de datos SQL Server.

## Estructura del proyecto

- **Capa_Presentacion**: Interfaz gráfica de usuario (Windows Forms).
- **Capa_Negocio**: Lógica de negocio y validaciones.
- **Capa_Datos**: Acceso a datos y conexión con la base de datos.
- **Capa_Entidad**: Definición de entidades y modelos de datos.
- **Database**: Scripts SQL para la creación de tablas, procedimientos e índices.

## Requisitos

- Visual Studio 2019 o superior
- .NET Framework 4.7.2
- SQL Server (local o remoto)

## Instalación y ejecución

1. Clona o descarga este repositorio.
2. Restaura los paquetes NuGet necesarios.
3. Configura la cadena de conexión a tu base de datos en el archivo correspondiente de la capa de datos.
4. Ejecuta los scripts de la carpeta `Database` para crear la base de datos y sus objetos.
5. Compila y ejecuta el proyecto desde Visual Studio.

