-- ============================================================
-- esquema-v3-a-v4: migración del esquema de gbShortcodes de la 3 a la 4
-- ------------------------------------------------------------
-- Agrega la tabla modos: cada par (modo, tipo) permitido es una fila, y
-- shortcodes la refiere por clave foránea. Desde la 4, un modo nuevo es
-- un script de datos, no un cambio de esquema.
-- Modifica: la tabla shortcodes, que se rehace sin la lista de modos en
-- un CHECK y con la clave foránea. Los datos no cambian.
-- La corre la propia aplicación al abrir una base v3 (también se puede
-- correr con el importador de la 4 desde una terminal).
-- Migración: 3 a 4
-- Esquema: 3
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

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

-- CADA SHORTCODE USA UN PAR (modo, tipo) QUE EXISTE
INSERT INTO _verif SELECT 'pares (modo, tipo) conocidos', COUNT(*) = 0 FROM shortcodes s
  WHERE NOT EXISTS (SELECT 1 FROM modos m WHERE m.modo = s.modo AND m.tipo = s.tipo);

CREATE TABLE shortcodes_v4 (
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
  grupo              TEXT    NOT NULL CHECK (grupo IN ('comun','estructura','disciplinar')),
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

INSERT INTO shortcodes_v4 (id_shortcode, nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion)
SELECT id_shortcode, nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion FROM shortcodes;

INSERT INTO _verif SELECT 'filas copiadas',
  (SELECT COUNT(*) FROM shortcodes_v4) = (SELECT COUNT(*) FROM shortcodes);

DROP TABLE shortcodes;
ALTER TABLE shortcodes_v4 RENAME TO shortcodes;
CREATE INDEX ix_shortcodes_orden ON shortcodes (grupo, perfil, orden);
CREATE INDEX ix_shortcodes_clase ON shortcodes (clase);

INSERT INTO esquema_version (version, fecha) VALUES (4, date('now'));

DROP TABLE _verif;

COMMIT;
