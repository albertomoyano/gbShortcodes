-- ============================================
-- shortcodes.sqlite — CATÁLOGO DE SHORTCODES DE GBPUBLISHER
-- Esquema versión 1
-- Creación manual:  sqlite3 shortcodes.sqlite < shortcodes_esquema.sql
-- La aplicación crea la base sola en el primer arranque, con este
-- mismo DDL (m_Base.SentenciasDDL). Si se cambia uno, se cambia el otro.
-- ============================================

PRAGMA foreign_keys = ON;

-- --- 1. SHORTCODES: UNA FILA POR SHORTCODE ---
-- LO QUE SE EXPORTA A gbpublisher: nombre, etiqueta, tipo, grupo, perfil,
-- orden, estados, modo, apertura, cierre, que_es, ejemplo, como_sale.
-- LO QUE QUEDA EN gbShortcodes: mapeos, notas y pendiente.
CREATE TABLE shortcodes (
  id_shortcode       INTEGER PRIMARY KEY,
  nombre             TEXT    NOT NULL UNIQUE
                     CHECK (nombre <> '' AND nombre NOT GLOB '*[^a-z0-9-]*'),
  etiqueta           TEXT    NOT NULL CHECK (etiqueta <> ''),
  tipo               TEXT    NOT NULL CHECK (tipo IN ('bloque','linea')),
  grupo              TEXT    NOT NULL CHECK (grupo IN ('comun','estructura','disciplinar')),
  perfil             TEXT    CHECK (perfil <> '' AND perfil NOT GLOB '*[^a-z_]*'),
  orden              INTEGER NOT NULL,
  estado_libro       TEXT    NOT NULL DEFAULT 'no_aplica'
                     CHECK (estado_libro IN ('no_aplica','borrador','liberado')),
  estado_revista     TEXT    NOT NULL DEFAULT 'no_aplica'
                     CHECK (estado_revista IN ('no_aplica','borrador','liberado')),
  modo               TEXT    NOT NULL DEFAULT 'envolver'
                     CHECK (modo IN ('envolver','plantilla','figura')),
  apertura           TEXT    NOT NULL CHECK (apertura <> ''),
  cierre             TEXT    NOT NULL CHECK (cierre <> ''),
  -- LOS TRES TEXTOS DE LA AYUDA ADMITEN NULL A PROPÓSITO: GAMBAS ESCRIBE
  -- LA CADENA VACÍA COMO NULL (GV-68, GV-34), Y UN NOT NULL HARÍA FALLAR
  -- EL GUARDADO DE UNA SECCIÓN VACÍA. SIN TEXTO ES NULL, NUNCA ''
  que_es             TEXT    CHECK (que_es <> ''),
  ejemplo            TEXT    CHECK (ejemplo <> ''),
  como_sale          TEXT    CHECK (como_sale <> ''),
  mapeo_docbook      TEXT,
  mapeo_jats         TEXT,
  notas              TEXT,
  pendiente          TEXT,
  fecha_alta         TEXT    NOT NULL,
  fecha_modificacion TEXT    NOT NULL,
  -- EL PERFIL ES DE LOS DISCIPLINARES Y SOLO DE ELLOS
  CHECK ((grupo = 'disciplinar') = (perfil IS NOT NULL)),
  -- UN SHORTCODE QUE NO APLICA A NADA NO TIENE LUGAR EN EL CATÁLOGO
  CHECK (estado_libro <> 'no_aplica' OR estado_revista <> 'no_aplica'),
  -- LA FIGURA ES UN BLOQUE: ELIGE LA IMAGEN Y ARMA EL div ENTERO
  CHECK (modo <> 'figura' OR tipo = 'bloque'),
  -- LO LIBERADO SE MUESTRA EN LA AYUDA: SIN HUECOS
  CHECK ((estado_libro <> 'liberado' AND estado_revista <> 'liberado')
         OR (que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL))
);

CREATE INDEX ix_shortcodes_orden ON shortcodes (grupo, perfil, orden);

-- --- 2. VERSIÓN DE ESQUEMA ---
CREATE TABLE esquema_version (
  version INTEGER NOT NULL,
  fecha   TEXT    NOT NULL
);

INSERT INTO esquema_version (version, fecha) VALUES (1, date('now'));
