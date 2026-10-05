 -- Caso 3: Aplicación de ventas

DROP DATABASE IF EXISTS ventas;
CREATE DATABASE ventas CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ventas;

CREATE TABLE estado (
    clave_estado CHAR(3)       PRIMARY KEY,
    nombre       VARCHAR(60)   NOT NULL,
    cargoxEnvio  DECIMAL(10,2) NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE cliente (
    num_cliente  INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL,
    estatus      VARCHAR(20)  NOT NULL DEFAULT 'Activo',
    clave_estado CHAR(3)      NOT NULL,
    CONSTRAINT fk_cliente_estado FOREIGN KEY (clave_estado) REFERENCES estado (clave_estado)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE producto (
    num_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(100)  NOT NULL,
    color        VARCHAR(30),
    precio       DECIMAL(10,2) NOT NULL CHECK (precio >= 0)
) ENGINE=InnoDB;

CREATE TABLE orden (
    num_cliente  INT NOT NULL,
    num_producto INT NOT NULL,
    cantidad     INT NOT NULL CHECK (cantidad > 0),
    PRIMARY KEY (num_cliente, num_producto),
    CONSTRAINT fk_orden_cliente  FOREIGN KEY (num_cliente)  REFERENCES cliente (num_cliente)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_orden_producto FOREIGN KEY (num_producto) REFERENCES producto (num_producto)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE cuenta (
    num_cuenta  INT AUTO_INCREMENT PRIMARY KEY,
    saldo       DECIMAL(12,2) NOT NULL DEFAULT 0,
    num_cliente INT NOT NULL UNIQUE,      
    CONSTRAINT fk_cuenta_cliente FOREIGN KEY (num_cliente) REFERENCES cliente (num_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE tipo_movimiento (
    clave_tipo  CHAR(3)      PRIMARY KEY,
    descripcion VARCHAR(60)  NOT NULL
) ENGINE=InnoDB;

CREATE TABLE movimiento (
    num_cuenta     INT NOT NULL,
    num_movimiento INT NOT NULL,          
    importe        DECIMAL(12,2) NOT NULL,
    clave_tipo     CHAR(3) NOT NULL,
    PRIMARY KEY (num_cuenta, num_movimiento),
    CONSTRAINT fk_mov_cuenta FOREIGN KEY (num_cuenta) REFERENCES cuenta (num_cuenta)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_mov_tipo FOREIGN KEY (clave_tipo) REFERENCES tipo_movimiento (clave_tipo)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

DELIMITER $$
CREATE TRIGGER trg_movimiento_consecutivo
BEFORE INSERT ON movimiento
FOR EACH ROW
BEGIN
    SET NEW.num_movimiento = (
        SELECT IFNULL(MAX(num_movimiento), 0) + 1
        FROM movimiento
        WHERE num_cuenta = NEW.num_cuenta
    );
END$$
DELIMITER ;


