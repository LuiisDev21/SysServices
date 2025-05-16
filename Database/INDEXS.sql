-- CLASE: BASE DE DATOS DISTRIBUIDA
-- PROYECTO: BASE DE DATOS PARA UN SISTEMA DE ADMISION HOSPITALARIO

USE HospitalNHME
GO

-- INDEX -> Tbl_Personas
CREATE INDEX IX_Tbl_Personas_TipoPersona ON Tbl_Personas (Tipo_Persona); 
-- Razon: Optimiza busquedas por tipo de persona
-- Peso: 40kb

-- INDEX -> Tbl_Pacientes
CREATE UNIQUE INDEX IX_Tbl_Pacientes_NumeroInss ON Tbl_Pacientes (Numero_Inss);
-- Razon: Acelera filtros por numero de inss
-- Peso: 72kb

CREATE INDEX IX_Tbl_Personas_IdEstado ON Tbl_Personas (Id_Estado); 
-- Razon: Acelera filtros por estado activo/inactivo
-- Peso: 40kb

-- INDEX -> Tbl_Pacientes
CREATE INDEX IX_Tbl_Pacientes_IdPersona ON Tbl_Pacientes (Id_Persona); 
-- Razon: Agiliza JOINs con Tbl_Personas
-- Peso: 72kb

CREATE INDEX IX_Tbl_Pacientes_TipoEstado ON Tbl_Pacientes (Tipo_Paciente, Estado_Paciente); 
-- Razon: Mejora consultas que filtran por tipo y estado del paciente
-- Peso: 72kb

-- INDEX -> Tbl_Citas
CREATE INDEX IX_Tbl_Citas_PacienteFecha ON Tbl_Citas (Id_Paciente, Fecha_Cita); 
-- Razon: Optimiza consultas de historial de citas por paciente y fecha

CREATE INDEX IX_Tbl_Citas_Especialidad ON Tbl_Citas (Id_Especialidad); 
-- Razon: Acelera busquedas por especialidad 

CREATE INDEX IX_Tbl_Citas_Fecha ON Tbl_Citas (Fecha_Cita); 
-- Razon: Facilita reportes por rangos de fechas

-- INDEX -> Tbl_Admision
CREATE INDEX IX_Tbl_Admision_PacienteFecha ON Tbl_Admision (Id_Paciente, Fecha_Admision); 
-- Razon: Mejora consultas de admisiones por paciente y fecha
-- Peso: 40kb
CREATE INDEX IX_Tbl_Admision_Fecha ON Tbl_Admision (Fecha_Admision); 
-- Razon: Optimiza filtros por fecha de admision
-- Peso: 40kb

-- INDEX -> Tbl_Especialidades
CREATE INDEX IX_Tbl_Especialidades_Lugar ON Tbl_Especialidades (Id_Lugar); 
-- Razon: Optimiza JOINs con Tbl_Lugares
-- Peso: 24kb
