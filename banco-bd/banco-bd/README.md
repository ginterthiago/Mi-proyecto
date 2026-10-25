# Sistema Bancario: Base de datos relacional y documental

Trabajo práctico de Bases de Datos. El sistema usa dos bases:

- **Relacional (PostgreSQL):** datos principales y críticos (clientes, cuentas, transacciones, etc.).
- **Documental (Firestore):** datos de caché y preferencias, de acceso rápido y sin información sensible.

Ambas se relacionan mediante el `cliente_id` (UUID).

## Estructura del repositorio

```
banco-bd/
├── README.md
├── relacional/
│   ├── 01_schema.sql        # Creación de la base y las tablas
│   ├── 02_datos.sql         # Datos mock
│   ├── 03_consultas.sql     # Consultas de ejemplo
│   └── DER.md               # Diagrama Entidad-Relación (Mermaid)
└── documental/
    ├── preferencias.json
    ├── sesiones_recientes.json
    ├── transacciones_recientes.json
    ├── sesiones_activas.json
    └── consultas_firestore.md
```

## Cómo ejecutar la parte relacional

Requiere PostgreSQL. Desde la carpeta `relacional/`:

```bash
psql -U postgres -f 01_schema.sql
psql -U postgres -d banco -f 02_datos.sql
psql -U postgres -d banco -f 03_consultas.sql
```

> Si se usa MySQL: cambiar `UUID` por `CHAR(36)` y `SERIAL` por `INT AUTO_INCREMENT`, y quitar `\c banco`.

## Tablas (relacional)

`clientes`, `cuentas`, `transacciones`, `empleados`, `prestamos`, `tarjetas`, `tipos_de_tarjeta`, `sucursales`, `tipos_de_cuenta`.

El diagrama está en [relacional/DER.md](relacional/DER.md).

## Colecciones (documental)

| Colección | Contenido |
|---|---|
| `preferencias` | Tema, idioma y notificaciones |
| `sesiones_recientes` | Últimos inicios de sesión |
| `transacciones_recientes` | Últimos movimientos (datos enmascarados) |
| `sesiones_activas` | Datos temporales de sesiones en curso |

No se guardan DNI, saldos, contraseñas ni números completos de cuenta o tarjeta.
Las consultas con `curl` están en [documental/consultas_firestore.md](documental/consultas_firestore.md).

## Aclaración

Los datos son ficticios. En un sistema real, DNI y números de tarjeta deberían almacenarse cifrados.
