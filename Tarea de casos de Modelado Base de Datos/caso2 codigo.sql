-- Caso 2: Biblioteca del centro

DROP DATABASE IF EXISTS biblioteca;
CREATE DATABASE biblioteca CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE biblioteca;

CREATE TABLE autor (
    cod_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre    VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE libro (
    cod_libro    INT AUTO_INCREMENT PRIMARY KEY,
    titulo       VARCHAR(150) NOT NULL,
    isbn         VARCHAR(20)  NOT NULL UNIQUE,
    editorial    VARCHAR(80),
    num_paginas  INT CHECK (num_paginas > 0)
) ENGINE=InnoDB;

CREATE TABLE autor_libro (
    cod_autor INT NOT NULL,
    cod_libro INT NOT NULL,
    PRIMARY KEY (cod_autor, cod_libro),
    CONSTRAINT fk_al_autor FOREIGN KEY (cod_autor) REFERENCES autor (cod_autor)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_al_libro FOREIGN KEY (cod_libro) REFERENCES libro (cod_libro)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE ejemplar (
    cod_ejemplar INT AUTO_INCREMENT PRIMARY KEY,
    localizacion VARCHAR(60) NOT NULL,
    cod_libro    INT NOT NULL,
    CONSTRAINT fk_ejemplar_libro FOREIGN KEY (cod_libro) REFERENCES libro (cod_libro)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE usuario (
    cod_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    direccion   VARCHAR(120),
    telefono    VARCHAR(20)
) ENGINE=InnoDB;

CREATE TABLE prestamo (
    cod_usuario      INT  NOT NULL,
    cod_ejemplar     INT  NOT NULL,
    fecha_prestamo   DATE NOT NULL,
    fecha_devolucion DATE NULL,
    PRIMARY KEY (cod_usuario, cod_ejemplar, fecha_prestamo),
    CONSTRAINT fk_prest_usuario  FOREIGN KEY (cod_usuario)  REFERENCES usuario (cod_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_prest_ejemplar FOREIGN KEY (cod_ejemplar) REFERENCES ejemplar (cod_ejemplar)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_fechas CHECK (fecha_devolucion IS NULL OR fecha_devolucion >= fecha_prestamo)
) ENGINE=InnoDB;
