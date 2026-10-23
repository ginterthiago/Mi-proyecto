// =====================================================
// Base DOCUMENTAL (MongoDB) - base: reclamos_muni
// Responsabilidad: datos variables / semiestructurados:
// atributos propios de cada categoria, fotos, tareas,
// observaciones y datos adicionales de cada intervencion.
// Las claves "reclamo_id" / "intervencion_id" apuntan a PostgreSQL.
// =====================================================

// ---------- Coleccion: reclamo_detalle ----------

// Ejemplo 1: perdida de agua
db.reclamo_detalle.insertOne({
  _id: ObjectId("650000000000000000000001"),
  reclamo_id: 1,                       // referencia logica -> reclamo.id (PostgreSQL)
  categoria: "perdida_agua",
  fotos: [
    { url: "https://storage.muni.gob/reclamos/1/foto1.jpg", fecha: ISODate("2026-10-20T10:15:00Z") }
  ],
  datos_especificos: {
    tipo_canieria: "PVC",
    diametro_mm: 110,
    caudal_estimado: "alto",
    afecta_calzada: true
  },
  creado: ISODate("2026-10-20T10:15:00Z")
});

// Ejemplo 2: luminaria danada (campos distintos)
db.reclamo_detalle.insertOne({
  _id: ObjectId("650000000000000000000002"),
  reclamo_id: 2,
  categoria: "luminaria",
  fotos: [],
  datos_especificos: {
    numero_poste: "P-4521",
    tipo_lampara: "LED",
    apagada_desde: ISODate("2026-10-15T00:00:00Z"),
    cuadra_completa_sin_luz: false
  },
  creado: ISODate("2026-10-21T09:00:00Z")
});

// Ejemplo 3: bache
db.reclamo_detalle.insertOne({
  _id: ObjectId("650000000000000000000003"),
  reclamo_id: 3,
  categoria: "bache",
  fotos: [{ url: "https://storage.muni.gob/reclamos/3/bache.jpg" }],
  datos_especificos: { profundidad_cm: 15, ancho_cm: 60, tipo_calzada: "asfalto", riesgo_transito: "alto" },
  creado: new Date()
});

// ---------- Coleccion: intervencion_detalle ----------
db.intervencion_detalle.insertOne({
  _id: ObjectId("650000000000000000000011"),
  intervencion_id: 1,                  // referencia logica -> intervencion.id (PostgreSQL)
  reclamo_id: 1,
  empleado_id: 2,                      // referencia logica -> empleado.id (PostgreSQL)
  fecha: ISODate("2026-10-22T08:30:00Z"),
  tareas: [
    { descripcion: "Excavacion en vereda", completada: true },
    { descripcion: "Reemplazo de tramo de canieria", completada: true },
    { descripcion: "Relleno y reposicion de vereda", completada: false }
  ],
  observaciones: [
    { empleado_id: 2, fecha: ISODate("2026-10-22T11:00:00Z"),
      texto: "Se detecto otra fisura 2 m mas adelante, requiere nueva visita." }
  ],
  fotos: [
    { url: "https://storage.muni.gob/intervenciones/1/antes.jpg", tipo: "antes" },
    { url: "https://storage.muni.gob/intervenciones/1/despues.jpg", tipo: "despues" }
  ],
  datos_adicionales: {
    materiales: [{ item: "Canieria PVC 110mm", cantidad: 3 }],
    maquinaria: "retroexcavadora",
    horas_trabajadas: 4.5
  }
});

// ---------- Indices ----------
db.reclamo_detalle.createIndex({ reclamo_id: 1 }, { unique: true });
db.reclamo_detalle.createIndex({ categoria: 1 });
db.intervencion_detalle.createIndex({ intervencion_id: 1 }, { unique: true });
db.intervencion_detalle.createIndex({ reclamo_id: 1 });

// ---------- Consultas de ejemplo ----------
db.reclamo_detalle.findOne({ reclamo_id: 1 });
db.intervencion_detalle.find({ reclamo_id: 1 }).sort({ fecha: 1 });
db.reclamo_detalle.find({ categoria: "luminaria", "datos_especificos.numero_poste": "P-4521" });
