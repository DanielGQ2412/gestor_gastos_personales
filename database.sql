-- 1. Gestión de Usuarios (Incluye seguridad)
CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL, -- Para almacenar la contraseña encriptada
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Módulo 1: Fuentes de Ingreso (Configuración del usuario)
CREATE TABLE fuentes_ingreso (
    id_fuente INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    nombre_fuente VARCHAR(50) NOT NULL, -- Ej: Sueldo, Emprendimiento
    frecuencia ENUM('Diario', 'Semanal', 'Quincenal', 'Mensual') NOT NULL,
    monto_esperado DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- 3. Módulo 2: Categorías de Gastos (Configuración y Alertas)
CREATE TABLE categorias_gastos (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    nombre_categoria VARCHAR(50) NOT NULL, -- Ej: Tarjetas, Alimentación, Recibos
    limite_alerta DECIMAL(10,2) DEFAULT 0, -- Mejora: Alerta cuando se supera este límite
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- 4. Registro de Movimientos (Ingresos y Gastos Reales)
-- Esta tabla une el Módulo 1 y 2 para el Módulo 3 (Resumen Financiero)
CREATE TABLE transacciones (
    id_transaccion INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    tipo ENUM('Ingreso', 'Gasto') NOT NULL,
    id_referencia INT NOT NULL, -- id_fuente si es ingreso, id_categoria si es gasto
    monto DECIMAL(10,2) NOT NULL,
    descripcion TEXT, -- Detalles adicionales o entidad (ej: Banco X)
    fecha_movimiento DATE NOT NULL, -- Para filtros por fechas
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- 5. Mejora: Metas de Ahorro
CREATE TABLE metas_ahorro (
    id_meta INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    nombre_meta VARCHAR(100) NOT NULL,
    monto_objetivo DECIMAL(10,2) NOT NULL,
    monto_actual DECIMAL(10,2) DEFAULT 0,
    fecha_limite DATE,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- Perrogordo20
CREATE TABLE metas_De_Retiro (
    
)

