-- ============================================================
-- Script: DB_AsistenciaINPE
-- Descripcion: Creacion de la base de datos para el Sistema de
--              Registro de Asistencia del Personal del INPE
-- Motor: SQL Server
-- ============================================================

-- 1. CREACION DE LA BASE DE DATOS
-- ============================================================
IF DB_ID('DB_AsistenciaINPE') IS NULL
BEGIN
    CREATE DATABASE DB_AsistenciaINPE;
END
GO

USE DB_AsistenciaINPE;
GO

-- 2. CREACION DE TABLAS
-- ============================================================

-- 2.1 Tabla: Anio (tabla maestra / independiente)
-- ============================================================
IF OBJECT_ID('dbo.Anio', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Anio (
        idAnio     INT          NOT NULL IDENTITY(1,1),
        inicioAnio DATE         NOT NULL,
        finAnio    DATE         NOT NULL,
        CONSTRAINT PK_Anio PRIMARY KEY (idAnio)
    );
END
GO

-- 2.2 Tabla: Turno (depende de Anio)
-- ============================================================
IF OBJECT_ID('dbo.Turno', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Turno (
        idT       INT          NOT NULL IDENTITY(1,1),
        nombreT   VARCHAR(50)  NOT NULL,
        inicioT   TIME         NOT NULL,
        finT      TIME         NOT NULL,
        idAnio    INT          NOT NULL,
        CONSTRAINT PK_Turno    PRIMARY KEY (idT),
        CONSTRAINT FK_Turno_Anio FOREIGN KEY (idAnio)
            REFERENCES dbo.Anio (idAnio)
    );
END
GO

-- 2.3 Tabla: Empleado (tabla maestra / independiente, con auto-referencia)
-- ============================================================
IF OBJECT_ID('dbo.Empleado', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Empleado (
        idE           INT          NOT NULL IDENTITY(1,1),
        tipoDocumE    VARCHAR(20)  NOT NULL,
        nroDocumE     VARCHAR(15)  NOT NULL,
        nombresE      VARCHAR(50)  NOT NULL,
        paternoE      VARCHAR(50)  NOT NULL,
        maternoE      VARCHAR(50)  NOT NULL,
        celularE      VARCHAR(15)  NULL,
        idE_supervisor INT         NULL,
        CONSTRAINT PK_Empleado PRIMARY KEY (idE),
        CONSTRAINT FK_Empleado_Supervisor FOREIGN KEY (idE_supervisor)
            REFERENCES dbo.Empleado (idE)
    );
END
GO

-- 2.4 Tabla: Asistencia (tabla transaccional, depende de Turno y Empleado)
-- ============================================================
IF OBJECT_ID('dbo.Asistencia', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Asistencia (
        idA           INT          NOT NULL IDENTITY(1,1),
        fechaA        DATE         NOT NULL,
        diaA          VARCHAR(15)  NOT NULL,
        esFeriadoA    BIT          NOT NULL,
        asistioA      BIT          NOT NULL,
        tardoA        BIT          NOT NULL,
        horaEntradaA  TIME         NULL,
        horaSalidaA   TIME         NULL,
        idT           INT          NOT NULL,
        idE           INT          NOT NULL,
        CONSTRAINT PK_Asistencia PRIMARY KEY (idA),
        CONSTRAINT FK_Asistencia_Turno FOREIGN KEY (idT)
            REFERENCES dbo.Turno (idT),
        CONSTRAINT FK_Asistencia_Empleado FOREIGN KEY (idE)
            REFERENCES dbo.Empleado (idE)
    );
END
GO
