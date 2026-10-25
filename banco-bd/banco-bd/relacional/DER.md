# DER (Diagrama Entidad-Relación)

GitHub renderiza este diagrama automáticamente.

```mermaid
erDiagram
    SUCURSALES ||--o{ EMPLEADOS : "tiene"
    SUCURSALES ||--o{ CUENTAS : "administra"
    CLIENTES ||--o{ CUENTAS : "posee"
    CLIENTES ||--o{ PRESTAMOS : "solicita"
    EMPLEADOS ||--o{ PRESTAMOS : "gestiona"
    EMPLEADOS |o--o{ TRANSACCIONES : "registra"
    TIPOS_DE_CUENTA ||--o{ CUENTAS : "clasifica"
    CUENTAS ||--o{ TRANSACCIONES : "origen"
    CUENTAS |o--o{ TRANSACCIONES : "destino"
    CUENTAS ||--o{ TARJETAS : "tiene"
    TIPOS_DE_TARJETA ||--o{ TARJETAS : "clasifica"

    SUCURSALES {
        int sucursal_id PK
        string nombre
        string direccion
        string ciudad
        string telefono
    }
    CLIENTES {
        uuid cliente_id PK
        string nombre
        string apellido
        string dni
        string email
        string telefono
        string direccion
        date fecha_nacimiento
        date fecha_registro
    }
    EMPLEADOS {
        int empleado_id PK
        string nombre
        string apellido
        string cargo
        string email
        decimal salario
        date fecha_contratacion
        int sucursal_id FK
    }
    TIPOS_DE_CUENTA {
        int tipo_cuenta_id PK
        string nombre
        string descripcion
        decimal tasa_interes
        decimal costo_mantenimiento
    }
    CUENTAS {
        int cuenta_id PK
        string numero_cuenta
        decimal saldo
        date fecha_apertura
        string estado
        uuid cliente_id FK
        int tipo_cuenta_id FK
        int sucursal_id FK
    }
    TRANSACCIONES {
        int transaccion_id PK
        string tipo
        decimal monto
        timestamp fecha
        string descripcion
        int cuenta_origen_id FK
        int cuenta_destino_id FK
        int empleado_id FK
    }
    PRESTAMOS {
        int prestamo_id PK
        decimal monto
        decimal tasa_interes
        int plazo_meses
        date fecha_inicio
        string estado
        uuid cliente_id FK
        int empleado_id FK
    }
    TIPOS_DE_TARJETA {
        int tipo_tarjeta_id PK
        string nombre
        string descripcion
        decimal limite_maximo
    }
    TARJETAS {
        int tarjeta_id PK
        string numero_tarjeta
        date fecha_emision
        date fecha_vencimiento
        string estado
        int cuenta_id FK
        int tipo_tarjeta_id FK
    }
```

## Resumen de relaciones

- Una sucursal tiene muchos empleados y administra muchas cuentas (1:N).
- Un cliente puede tener muchas cuentas y muchos préstamos (1:N).
- Un tipo de cuenta clasifica muchas cuentas (1:N).
- Una cuenta tiene muchas transacciones y muchas tarjetas (1:N).
- Un tipo de tarjeta clasifica muchas tarjetas (1:N).
- Un empleado gestiona muchos préstamos y puede registrar transacciones (1:N).
