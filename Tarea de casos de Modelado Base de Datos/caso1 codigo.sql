-- Caso 1: Clínica Vida nueva

DROP DATABASE IF EXISTS clinica_vida_nueva;
CREATE DATABASE clinica_vida_nueva CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE clinica_vida_nueva;

CREATE TABLE paciente (
    cod_paciente     INT AUTO_INCREMENT PRIMARY KEY,
    nombre           VARCHAR(50)  NOT NULL,
    apellidos        VARCHAR(80)  NOT NULL,
    direccion        VARCHAR(120),
    poblacion        VARCHAR(60),
    provincia        VARCHAR(60),
    codigo_postal    VARCHAR(10),
    telefono         VARCHAR(20),
    fecha_nacimiento DATE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE medico (
    cod_medico    INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(50) NOT NULL,
    apellidos     VARCHAR(80) NOT NULL,
    telefono      VARCHAR(20),
    especialidad  VARCHAR(60) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE ingreso (
    cod_paciente   INT NOT NULL,
    cod_ingreso    INT NOT NULL,         
    habitacion     INT NOT NULL,
    cama           INT NOT NULL,
    fecha_ingreso  DATE NOT NULL,
    cod_medico     INT NOT NULL,          
    PRIMARY KEY (cod_paciente, cod_ingreso),
    CONSTRAINT fk_ingreso_paciente FOREIGN KEY (cod_paciente)
        REFERENCES paciente (cod_paciente) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ingreso_medico FOREIGN KEY (cod_medico)
        REFERENCES medico (cod_medico) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;


DELIMITER $$
CREATE TRIGGER trg_ingreso_codigo
BEFORE INSERT ON ingreso
FOR EACH ROW
BEGIN
    SET NEW.cod_ingreso = (
        SELECT IFNULL(MAX(cod_ingreso), 0) + 1
        FROM ingreso
        WHERE cod_paciente = NEW.cod_paciente
    );
END$$
DELIMITER ;


