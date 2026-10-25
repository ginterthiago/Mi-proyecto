# Consultas a Firestore (REST)

Reemplazar `MI_PROYECTO` por el ID del proyecto de Firebase.
El ID de cada documento es el `cliente_id` (UUID).

```bash
# Listar todas las preferencias
curl "https://firestore.googleapis.com/v1/projects/MI_PROYECTO/databases/(default)/documents/preferencias"

# Preferencias de un cliente
curl "https://firestore.googleapis.com/v1/projects/MI_PROYECTO/databases/(default)/documents/preferencias/123e4567-e89b-12d3-a456-426614174000"

# Transacciones recientes de un cliente
curl "https://firestore.googleapis.com/v1/projects/MI_PROYECTO/databases/(default)/documents/transacciones_recientes/123e4567-e89b-12d3-a456-426614174000"

# Sesiones recientes de un cliente
curl "https://firestore.googleapis.com/v1/projects/MI_PROYECTO/databases/(default)/documents/sesiones_recientes/123e4567-e89b-12d3-a456-426614174001"
```

## Notas

- Firestore devuelve los campos con su tipo (por ejemplo `{"stringValue": "oscuro"}`), por lo que la respuesta se ve distinta del JSON original.
- Las reglas de seguridad del proyecto deben permitir lectura, o `curl` devolverá error 403.
- Para cargar los JSON en Firestore se puede usar la consola de Firebase o un script con el SDK de Firebase Admin.
