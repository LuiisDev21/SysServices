CREATE OR ALTER PROCEDURE BuscarPaciente
    @NumeroINSS VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.Numero_Inss AS 'INSS',
        pers.Primer_Nombre AS 'Nombre',
        pers.Segundo_Nombre AS 'Segundo Nombre',
        pers.Primer_Apellido AS 'Apellido',
        pers.Segundo_Apellido AS 'Segundo Apellido',
        pers.Telefono AS 'Telefono',
        pers.Genero AS 'Genero',
        DATEDIFF(YEAR, pers.Fecha_Nacimiento, GETDATE()) AS 'Edad',
        cat_tipo.Catalogo AS 'Tipo Paciente',
        est.Estado AS 'Estado Registro'
    FROM 
        Tbl_Pacientes p
        INNER JOIN Tbl_Personas pers ON p.Id_Persona = pers.Id_Persona
        INNER JOIN Cls_Catalogos cat_tipo ON p.Tipo_Paciente = cat_tipo.Id_Catalogo
        INNER JOIN Cls_Estados est ON p.Id_Estado = est.Id_Estado
    WHERE 
        p.Numero_Inss = @NumeroINSS
        AND p.Id_Estado = 1; 
END

EXEC BuscarPaciente @NumeroINSS = '4499632';


CREATE OR ALTER PROCEDURE ListarAdmisiones 
    @FechaInicio DATETIME = NULL,
    @FechaFin DATETIME = NULL,
    @IdEspecialidad INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    

    IF @FechaInicio IS NULL
        SET @FechaInicio = CAST(DATEADD(DAY, -30, GETDATE()) AS DATE)
    
    IF @FechaFin IS NULL
        SET @FechaFin = CAST(GETDATE() AS DATE)
    

    SET @FechaFin = DATEADD(DAY, 1, @FechaFin)
    
    SELECT 
        a.Id_Admision AS 'Numero_Admision',
        p.Numero_Inss AS 'INSS',
        RTRIM(pers.Primer_Nombre) + 
        CASE WHEN pers.Segundo_Nombre = 'S/N' THEN '' ELSE ' ' + RTRIM(pers.Segundo_Nombre) END + 
        ' ' + RTRIM(pers.Primer_Apellido) + 
        CASE WHEN pers.Segundo_Apellido = 'S/A' THEN '' ELSE ' ' + RTRIM(pers.Segundo_Apellido) END
        AS 'Nombre_Completo',
        
        e.Nombre_Especialidad AS 'Especialidad',
        a.Fecha_Creacion AS 'Fecha de Creaci�n'
    FROM 
        Tbl_Admision a
        INNER JOIN Tbl_Pacientes p ON a.Id_Paciente = p.Id_Paciente
        INNER JOIN Tbl_Personas pers ON p.Id_Persona = pers.Id_Persona
        INNER JOIN Tbl_Especialidades e ON a.Id_Especialidad = e.Id_Especialidad
    WHERE
        (a.Fecha_Admision >= @FechaInicio AND a.Fecha_Admision < @FechaFin)
        AND (@IdEspecialidad IS NULL OR a.Id_Especialidad = @IdEspecialidad)
        AND a.Id_Estado = 1
    ORDER BY
        a.Fecha_Creacion DESC;
END

exec ListarAdmisiones



CREATE OR ALTER PROCEDURE GuardarAdmision
    @Numero_Inss VARCHAR(10),  
    @Id_Especialidad INT,          
    @Observacion VARCHAR(255) = NULL,
    @Id_Admin INT                
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Fecha_Actual DATETIME = GETDATE();
    DECLARE @Id_Estado_Activo INT = 1; 
    DECLARE @NuevaAdmisionID INT;
    DECLARE @Id_Paciente INT;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        SELECT @Id_Paciente = Id_Paciente 
        FROM Tbl_Pacientes 
        WHERE Numero_Inss = @Numero_Inss AND Id_Estado = @Id_Estado_Activo;
        
        IF @Id_Paciente IS NULL
        BEGIN
            RAISERROR('No se encontr� un paciente activo con el n�mero de INSS proporcionado.', 16, 1);
            RETURN;
        END
        IF NOT EXISTS (SELECT 1 FROM Tbl_Especialidades WHERE Id_Especialidad = @Id_Especialidad AND Id_Estado = @Id_Estado_Activo)
        BEGIN
            RAISERROR('La especialidad especificada no existe o no est� activa.',@Id_Especialidad , 16, 1);
            RETURN;
        END
        IF NOT EXISTS (SELECT 1 FROM Tbl_Admins WHERE Id_Admin = @Id_Admin AND Id_Estado = @Id_Estado_Activo)
        BEGIN
            RAISERROR('El administrador especificado no existe o no est� activo.', 16, 1);
            RETURN;
        END
        INSERT INTO Tbl_Admision (
            Id_Paciente,
            Id_Especialidad,
            Fecha_Admision,
            Observacion,
            Fecha_Creacion,
            Fecha_Modificacion,
            Id_Estado
        ) VALUES (
            @Id_Paciente,
            @Id_Especialidad,
            @Fecha_Actual,
            @Observacion,
            @Fecha_Actual,
            @Fecha_Actual,
            @Id_Estado_Activo
        );
        
        SET @NuevaAdmisionID = SCOPE_IDENTITY();

        
        COMMIT TRANSACTION;
        
        SELECT 
            a.Id_Admision AS 'N� Admisi�n',
            p.Numero_Inss AS 'INSS',
            RTRIM(pers.Primer_Nombre) + 
                CASE WHEN pers.Segundo_Nombre = 'S/N' THEN '' ELSE ' ' + RTRIM(pers.Segundo_Nombre) END + ' ' + RTRIM(pers.Primer_Apellido) + 
                CASE WHEN pers.Segundo_Apellido = 'S/A' THEN '' ELSE ' ' + RTRIM(pers.Segundo_Apellido) END AS 'Nombre Completo',
            e.Nombre_Especialidad AS 'Especialidad',
            a.Fecha_Creacion AS 'Fecha de Creaci�n'
        FROM 
            Tbl_Admision a
            INNER JOIN Tbl_Pacientes p ON a.Id_Paciente = p.Id_Paciente
            INNER JOIN Tbl_Personas pers ON p.Id_Persona = pers.Id_Persona
            INNER JOIN Tbl_Especialidades e ON a.Id_Especialidad = e.Id_Especialidad
        WHERE 
            a.Id_Admision = @NuevaAdmisionID;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END

EXEC GuardarAdmision 
    @Numero_Inss = '4499632',
    @Id_Especialidad = 12, 
    @Observacion = 'AUTH', 
    @Id_Admin = 1;



CREATE OR ALTER PROCEDURE AdmisionesPaciente
    @NumeroINSS VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar si el paciente existe
    IF NOT EXISTS (SELECT 1 FROM Tbl_Pacientes WHERE Numero_Inss = @NumeroINSS)
    BEGIN
        PRINT 'No se encontr� ning�n paciente con el n�mero de INSS proporcionado.';
        RETURN;
    END
    
    -- Obtener todas las admisiones del paciente
    SELECT 
        a.Id_Admision AS 'N� Admisi�n',
        RTRIM(pers.Primer_Nombre) + 
            CASE WHEN pers.Segundo_Nombre = 'S/N' THEN '' ELSE ' ' + RTRIM(pers.Segundo_Nombre) END + 
            ' ' + RTRIM(pers.Primer_Apellido) + 
            CASE WHEN pers.Segundo_Apellido = 'S/A' THEN '' ELSE ' ' + RTRIM(pers.Segundo_Apellido) END
            AS 'Nombre Completo',
        e.Nombre_Especialidad AS 'Especialidad',
        a.Fecha_Creacion AS 'Fecha de Creaci�n',
        a.Observacion AS 'Observaciones'
    FROM 
        Tbl_Admision a
        INNER JOIN Tbl_Pacientes p ON a.Id_Paciente = p.Id_Paciente
        INNER JOIN Tbl_Personas pers ON p.Id_Persona = pers.Id_Persona
        INNER JOIN Tbl_Especialidades e ON a.Id_Especialidad = e.Id_Especialidad
    WHERE 
        p.Numero_Inss = @NumeroINSS
    ORDER BY 
        a.Fecha_Creacion DESC;
        
    -- Si no se encontraron admisiones para este paciente, mostrar un mensaje
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'El paciente existe pero no tiene admisiones registradas.';
    END
END

exec AdmisionesPaciente @NumeroINSS = '4499632';


CREATE OR ALTER PROCEDURE InsertarCita
    @Numero_Inss VARCHAR(10),         
    @Id_Especialidad INT,           
    @Fecha_Cita DATETIME,           
    @Observacion VARCHAR(255) = NULL,  
    @Id_Admin INT                    
BEGIN
    SET NOCOUNT ON;

    DECLARE @Id_Paciente INT;          
    DECLARE @Id_Estado_Activo INT = 1;
    DECLARE @Id_Estado_Cita INT = 17;   
    DECLARE @NuevaCitaID INT;          

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT @Id_Paciente = Id_Paciente 
        FROM Tbl_Pacientes 
        WHERE Numero_Inss = @Numero_Inss AND Id_Estado = @Id_Estado_Activo;

        IF @Id_Paciente IS NULL
        BEGIN
            RAISERROR('No se encontr� un paciente activo con el n�mero de INSS proporcionado.', 16, 1);
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Tbl_Especialidades WHERE Id_Especialidad = @Id_Especialidad AND Id_Estado = @Id_Estado_Activo)
        BEGIN
            RAISERROR('La especialidad especificada no existe o no est� activa.', 16, 1);
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Tbl_Admins WHERE Id_Admin = @Id_Admin AND Id_Estado = @Id_Estado_Activo)
        BEGIN
            RAISERROR('El administrador especificado no existe o no est� activo.', 16, 1);
            RETURN;
        END

        -- Insertar la nueva cita
        INSERT INTO Tbl_Citas (
            Id_Paciente,
            Id_Especialidad,
            Fecha_Cita,
            Observacion,
            Fecha_Creacion,
            Fecha_Modificacion,
            Estado_Cita 
        ) VALUES (
            @Id_Paciente,
            @Id_Especialidad,
            @Fecha_Cita,
            @Observacion,
            GETDATE(),  
            GETDATE(),  
            @Id_Estado_Cita 
        );

        SET @NuevaCitaID = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SELECT 
            c.Id_Cita AS 'N� Cita',
            p.Numero_Inss AS 'INSS',
            RTRIM(pers.Primer_Nombre) + 
                CASE WHEN pers.Segundo_Nombre = 'S/N' THEN '' ELSE ' ' + RTRIM(pers.Segundo_Nombre) END + ' ' + 
                RTRIM(pers.Primer_Apellido) + 
                CASE WHEN pers.Segundo_Apellido = 'S/A' THEN '' ELSE ' ' + RTRIM(pers.Segundo_Apellido) END AS 'Nombre Completo',
            e.Nombre_Especialidad AS 'Especialidad',
            c.Fecha_Cita AS 'Fecha de Cita',
            c.Observacion AS 'Observaciones',
            cat_estado.Catalogo AS 'Estado de la Cita'
        FROM 
            Tbl_Citas c
            INNER JOIN Tbl_Pacientes p ON c.Id_Paciente = p.Id_Paciente
            INNER JOIN Tbl_Personas pers ON p.Id_Persona = pers.Id_Persona
            INNER JOIN Tbl_Especialidades e ON c.Id_Especialidad = e.Id_Especialidad
            INNER JOIN Cls_Catalogos cat_estado ON c.Estado_Cita = cat_estado.Id_Catalogo
        WHERE 
            c.Id_Cita = @NuevaCitaID;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END


select * from Tbl_Citas

EXEC InsertarCita 
    @Numero_Inss = '4499632', 
    @Id_Especialidad = 15, 
    @Fecha_Cita = '2023-10-15', 
    @Observacion = 'Consulta de seguimiento', 
    @Id_Admin = 1;  


CREATE OR ALTER PROCEDURE HistorialCitas
    @Numero_Inss VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Tbl_Pacientes WHERE Numero_Inss = @Numero_Inss)
    BEGIN
        PRINT 'No se encontr� ning�n paciente con el n�mero de INSS proporcionado.';
        RETURN;
    END

    SELECT 
        c.Id_Cita AS 'N� Cita',
        p.Numero_Inss AS 'INSS',
        RTRIM(pers.Primer_Nombre) + 
            CASE WHEN pers.Segundo_Nombre = 'S/N' THEN '' ELSE ' ' + RTRIM(pers.Segundo_Nombre) END + ' ' + 
            RTRIM(pers.Primer_Apellido) + 
            CASE WHEN pers.Segundo_Apellido = 'S/A' THEN '' ELSE ' ' + RTRIM(pers.Segundo_Apellido) END AS 'Nombre Completo',
        e.Nombre_Especialidad AS 'Especialidad',
        c.Fecha_Cita AS 'Fecha de Cita',
        c.Observacion AS 'Observaciones',
        cat_estado.Catalogo AS 'Estado de la Cita'
    FROM 
        Tbl_Citas c
        INNER JOIN Tbl_Pacientes p ON c.Id_Paciente = p.Id_Paciente
        INNER JOIN Tbl_Personas pers ON p.Id_Persona = pers.Id_Persona
        INNER JOIN Tbl_Especialidades e ON c.Id_Especialidad = e.Id_Especialidad
        INNER JOIN Cls_Catalogos cat_estado ON c.Estado_Cita = cat_estado.Id_Catalogo
    WHERE 
        p.Numero_Inss = @Numero_Inss
    ORDER BY 
        c.Fecha_Cita DESC;
        
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'El paciente existe pero no tiene citas registradas.';
    END
END

EXEC HistorialCitas @Numero_Inss = '4499632';
