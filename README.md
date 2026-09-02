# 🗄️ Diseño y Manipulación de Tablas SQL: Módulo de Proveedores
Diseño relacional, DDL, DML e integración de módulos de proveedores en SQL Server Management.

## 📌 Tabla de Contenidos
1. [Descripción del Proyecto](#descripción-del-proyecto)
2. [Arquitectura de Base de Datos](#arquitectura-de-base-de-datos)
3. [Requerimientos Técnicos Implementados](#requerimientos-técnicos-implementados)
4. [Manejo de Errores e Integridad de Datos](#manejo-de-errores-e-integridad-de-datos)
5. [Estructura del Repositorio](#estructura-del-repositorio)
6. [Contacto](#contacto)

---

## 📖 Descripción del Proyecto
Integración de un nuevo módulo de **Proveedores de Capacitación** a una base de datos relacional de gestión de ventas. El proyecto abarca el diseño del esquema DDL (Data Definition Language) con reglas de validación estrictas y la simulación de operaciones DML (Data Manipulation Language) garantizando la integridad referencial.

## 📐 Arquitectura de Base de Datos
El modelo relacional integra las entidades principales del negocio:
* `clientes`, `productos`, `sucursales` y `ventas`.
* Nueva entidad: `proveedores_capacitaciones` (con clave primaria autoincremental, restricción UNIQUE en RUT y CHECK en categorías válidas).

## 🛠️ Requerimientos Técnicos Implementados
1. **Creación de Tabla (DDL):** Definición de tipos de datos, valores por defecto (`estado DEFAULT TRUE`) y restricciones `CHECK (categoria IN ('Interno', 'Externo'))`.
2. **Inserción de Registros (DML):** Carga de datos válidos y documentación de excepciones por violación de restricciones.
3. **Actualización de Registros (UPDATE):** Modificación de estado y categoría condicionado por filtros `WHERE`.
4. **Eliminación Segura (DELETE):** Eliminación condicional de registros inactivos (`estado = FALSE`), justificando las buenas prácticas para evitar pérdidas masivas de datos en producción.

## ⚠️ Manejo de Errores e Integridad
Se documentaron intencionalmente dos escenarios de fallo:
* **Error de Duplicidad:** Intento de inserción de RUT duplicado (Violación de restricción `UNIQUE`).
* **Error de Dominio:** Inserción de categoría no permitida (`'Internacional'`), bloqueada por la restricción `CHECK`.

## 📁 Estructura del Repositorio
├── sql/
│   ├── arquitectura_base.sql                  # Esquema base de la base de datos
│   └── prueba_disenio_manipulacion_sql.sql    # Script principal con solución DDL/DML
└── README.md                                  # Documentación técnica

---
👤 **Autor:** Juan Pablo Donoso Aedo | [LinkedIn](https://www.linkedin.com/in/juanpdonoso/)
