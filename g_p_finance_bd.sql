CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    -- Longitud de 255 para soportar hashes robustos (BCrypt/Argon2)
    password_hash VARCHAR(255) NOT NULL, 
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    nombre_categoria VARCHAR(50) NOT NULL,
    -- 'Ingreso' para sueldos/extras, 'Gasto' para servicios/compras
    tipo_movimiento ENUM('Ingreso', 'Gasto') NOT NULL, 
    limite_mensual DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE transacciones (
    id_transaccion INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_categoria INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    descripcion VARCHAR(255),
    -- Permite filtrar por día, mes o año fácilmente
    fecha_movimiento DATE NOT NULL, 
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE metas_ahorro (
    id_meta INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    nombre_meta VARCHAR(100) NOT NULL,
    monto_objetivo DECIMAL(10,2) NOT NULL,
    monto_actual DECIMAL(10,2) DEFAULT 0,
    fecha_limite DATE,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);