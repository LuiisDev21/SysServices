-- CLASE: BASE DE DATOS DISTRIBUIDA
-- PROYECTO: BASE DE DATOS PARA UN SISTEMA DE ADMISION HOSPITALARIO


CREATE DATABASE HospitalNHME; 
go


USE HospitalNHME;
GO



CREATE TABLE Cls_Estados(
    Id_Estado INT PRIMARY KEY IDENTITY(1,1),
    Estado VARCHAR(80) NOT NULL,
    Fecha_Creacion DATETIME NOT NULL,
    Fecha_Modificacion DATETIME NOT NULL,
    Activo BIT NOT NULL
)

CREATE TABLE Cls_Tipo_Catalogos(
    Id_Tipo_Catalogo INT PRIMARY KEY IDENTITY(1,1),
    Tipo_Catalogo VARCHAR(80) NOT NULL,
    Fecha_Creacion DATETIME NOT NULL,
    Fecha_Modificacion DATETIME NOT NULL,
    Activo BIT NOT NULL
)

CREATE TABLE Cls_Catalogos(
    Id_Catalogo INT PRIMARY KEY IDENTITY(1,1),
    Id_Tipo_Catalogo INT REFERENCES Cls_Tipo_Catalogos(Id_Tipo_Catalogo),
    Catalogo VARCHAR(80) NOT NULL,
    Fecha_Creacion DATETIME NOT NULL,
    Fecha_Modificacion DATETIME NOT NULL,
    Activo BIT NOT NULL
)

CREATE TABLE Tbl_Personas(
    Id_Persona INT PRIMARY KEY IDENTITY(1,1),
    Primer_Nombre VARCHAR(30) NOT NULL DEFAULT 'S/N',
    Segundo_Nombre VARCHAR(30) DEFAULT 'S/N',
    Primer_Apellido VARCHAR(30) NOT NULL DEFAULT 'S/A',
    Segundo_Apellido VARCHAR(30) DEFAULT 'S/A',
    Genero VARCHAR(20) NOT NULL,
    Fecha_Nacimiento DATE NOT NULL,
    Telefono VARCHAR(50) NULL,
    Tipo_Persona INT REFERENCES Cls_Catalogos(Id_Catalogo),
    Fecha_Creacion DATETIME NOT NULL,
    Fecha_Modificacion DATETIME NOT NULL,
    Id_Estado INT REFERENCES Cls_Estados(Id_Estado)
)

CREATE TABLE Tbl_Pacientes(
    Id_Paciente INT PRIMARY KEY IDENTITY(1,1),
    Id_Persona INT REFERENCES Tbl_Personas(Id_Persona),
    Numero_Inss VARCHAR(10) NOT NULL UNIQUE,
    Tipo_Paciente INT REFERENCES Cls_Catalogos(Id_Catalogo),
    Estado_Paciente INT REFERENCES Cls_Catalogos(Id_Catalogo),
    Fecha_Creacion DATETIME NOT NULL,
    Fecha_Modificacion DATETIME NOT NULL,
    Id_Estado INT REFERENCES Cls_Estados(Id_Estado)
)

CREATE TABLE Tbl_Admins(
    Id_Admin INT PRIMARY KEY IDENTITY(1,1),
    Id_Persona INT REFERENCES Tbl_Personas(Id_Persona),
    Tipo_Admin INT REFERENCES Cls_Catalogos(Id_Catalogo),
    Usuario VARCHAR(80) NOT NULL UNIQUE,
    UserPass VARCHAR(80) NOT NULL,
    Fecha_Creacion DATETIME NOT NULL,
    Fecha_Modificacion DATETIME NOT NULL,
    Id_Estado INT REFERENCES Cls_Estados(Id_Estado)
)


CREATE TABLE Tbl_Lugares(
    Id_Lugar INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Lugar VARCHAR(80) NOT NULL,
    Fecha_Creacion DATETIME NOT NULL,
    Fecha_Modificacion DATETIME NOT NULL,
    Id_Estado INT REFERENCES Cls_Estados(Id_Estado)
)


CREATE TABLE Tbl_Especialidades(
    Id_Especialidad INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Especialidad VARCHAR(80) NOT NULL,
    Id_Lugar INT REFERENCES Tbl_Lugares(Id_Lugar),
    Fecha_Creacion DATETIME NOT NULL,
    Fecha_Modificacion DATETIME NOT NULL,
    Id_Estado INT REFERENCES Cls_Estados(Id_Estado)
)

CREATE TABLE Tbl_Citas(
    Id_Cita INT PRIMARY KEY IDENTITY(1,1),
    Id_Paciente INT REFERENCES Tbl_Pacientes(Id_Paciente),
    Id_Especialidad INT REFERENCES Tbl_Especialidades(Id_Especialidad),
    Fecha_Cita DATETIME NOT NULL,
    Estado_Cita INT REFERENCES Cls_Catalogos(Id_Catalogo),
    Observacion VARCHAR(255) NULL,
    Fecha_Creacion DATETIME NOT NULL,
    Fecha_Modificacion DATETIME NOT NULL,
    Id_Estado INT REFERENCES Cls_Estados(Id_Estado)
)

CREATE TABLE Tbl_Admision(
    Id_Admision INT PRIMARY KEY IDENTITY(1,1),
    Id_Paciente INT REFERENCES Tbl_Pacientes(Id_Paciente),
    Id_Especialidad INT REFERENCES Tbl_Especialidades(Id_Especialidad),
    Fecha_Admision DATETIME NOT NULL,
    Observacion VARCHAR(255) NULL,
    Fecha_Creacion DATETIME NOT NULL,
    Fecha_Modificacion DATETIME NOT NULL,
    Id_Estado INT REFERENCES Cls_Estados(Id_Estado)
)
