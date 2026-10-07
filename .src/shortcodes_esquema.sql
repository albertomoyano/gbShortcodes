-- ============================================
-- shortcodes.sqlite — CATÁLOGO DE SHORTCODES DE GBPUBLISHER
-- Esquema versión 5 (la 2 agrega clase; la 3, la regla de liberación;
-- la 4, la tabla modos: un modo nuevo es un dato, no un cambio de esquema;
-- la 5, el grupo composicion: instrucciones de composición del PDF, SC-38)
-- Creación manual:  sqlite3 shortcodes.sqlite < shortcodes_esquema.sql
-- La aplicación crea la base sola en el primer arranque, con este
-- mismo DDL (m_Base.SentenciasDDL). Si se cambia uno, se cambia el otro.
-- ============================================

PRAGMA foreign_keys = ON;

-- --- 1. MODOS: CÓMO SE INSERTA UN SHORTCODE, Y CON QUÉ TIPO ---
-- CADA FILA ES UN PAR (modo, tipo) PERMITIDO. AGREGAR UN MODO ES UN
-- SCRIPT DE DATOS, NO UNA MIGRACIÓN; LO QUE HACE CADA MODO AL INSERTAR
-- LO DECIDE gbpublisher (m_Shortcodes.InsertarShortcode).
CREATE TABLE modos (
  modo        TEXT NOT NULL CHECK (modo <> '' AND modo NOT GLOB '*[^a-z-]*'),
  tipo        TEXT NOT NULL CHECK (tipo IN ('bloque','linea')),
  descripcion TEXT NOT NULL CHECK (descripcion <> ''),
  PRIMARY KEY (modo, tipo)
);

INSERT INTO modos (modo, tipo, descripcion) VALUES
  ('envolver',   'bloque', 'Rodea la selección con la apertura y el cierre.'),
  ('envolver',   'linea',  'Rodea la selección dentro del párrafo: [texto]{.clase}.'),
  ('plantilla',  'bloque', 'Inserta apertura, marcador y cierre, sin selección.'),
  ('plantilla',  'linea',  'Inserta apertura, marcador y cierre dentro del párrafo, sin selección.'),
  ('figura',     'bloque', 'El camino de FMain.InsertarFigura de gbpublisher (SC-32).'),
  ('dos-partes', 'bloque', 'Envolver, si la selección tiene la forma {primera}{segunda} (SC-35).');

-- --- 2. SHORTCODES: UNA FILA POR SHORTCODE ---
-- LO QUE SE EXPORTA A gbpublisher: nombre, clase, etiqueta, tipo, grupo, perfil,
-- orden, estados, modo, apertura, cierre, que_es, ejemplo, como_sale.
-- LO QUE QUEDA EN gbShortcodes: mapeos, notas y pendiente.
CREATE TABLE shortcodes (
  id_shortcode       INTEGER PRIMARY KEY,
  nombre             TEXT    NOT NULL UNIQUE
                     CHECK (nombre <> '' AND nombre NOT GLOB '*[^a-z0-9-]*'),
  -- LA CLASE DE PANDOC QUE ESCRIBE EL .md ({.fig}, ::: epigraph, ]{.gloss}).
  -- ES LA CLAVE CON QUE gbpublisher VALIDA Y EMPAREJA LOS CIERRES. NO ES
  -- ÚNICA: LAS VARIANTES (fig-fullwidth, table-landscape) COMPARTEN CLASE
  clase              TEXT    NOT NULL
                     CHECK (clase <> '' AND clase NOT GLOB '*[^a-z0-9-]*'),
  etiqueta           TEXT    NOT NULL CHECK (etiqueta <> ''),
  tipo               TEXT    NOT NULL CHECK (tipo IN ('bloque','linea')),
  grupo              TEXT    NOT NULL CHECK (grupo IN ('comun','estructura','disciplinar','composicion')),
  perfil             TEXT    CHECK (perfil <> '' AND perfil NOT GLOB '*[^a-z_]*'),
  orden              INTEGER NOT NULL,
  estado_libro       TEXT    NOT NULL DEFAULT 'no_aplica'
                     CHECK (estado_libro IN ('no_aplica','borrador','liberado')),
  estado_revista     TEXT    NOT NULL DEFAULT 'no_aplica'
                     CHECK (estado_revista IN ('no_aplica','borrador','liberado')),
  -- EL PAR (modo, tipo) TIENE QUE ESTAR EN modos (CLAVE FORÁNEA ABAJO)
  modo               TEXT    NOT NULL DEFAULT 'envolver',
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
  -- LO LIBERADO SE MUESTRA EN LA AYUDA: SIN HUECOS
  CHECK ((estado_libro <> 'liberado' AND estado_revista <> 'liberado')
         OR (que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL)),
  -- LIBERADO ES TERMINADO: SIN PENDIENTES (SC-34)
  CHECK ((estado_libro <> 'liberado' AND estado_revista <> 'liberado')
         OR pendiente IS NULL),
  -- SE LIBERA PARA LOS DOS PRODUCTOS, O PARA UNO SI EL OTRO NO APLICA:
  -- NUNCA LIBERADO EN UNO Y BORRADOR EN EL OTRO (SC-34)
  CHECK (NOT (estado_libro = 'liberado' AND estado_revista = 'borrador')
         AND NOT (estado_revista = 'liberado' AND estado_libro = 'borrador')),
  -- QUÉ MODOS VALEN PARA CADA TIPO LO DICE LA TABLA modos (LA FIGURA,
  -- POR EJEMPLO, SOLO EXISTE COMO BLOQUE)
  FOREIGN KEY (modo, tipo) REFERENCES modos (modo, tipo)
);

CREATE INDEX ix_shortcodes_orden ON shortcodes (grupo, perfil, orden);
CREATE INDEX ix_shortcodes_clase ON shortcodes (clase);

-- --- 3. VERSIÓN DE ESQUEMA ---
CREATE TABLE esquema_version (
  version INTEGER NOT NULL,
  fecha   TEXT    NOT NULL
);

INSERT INTO esquema_version (version, fecha) VALUES (5, date('now'));
