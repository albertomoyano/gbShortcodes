-- ============================================================
-- esquema-v4-a-v5: migración del esquema de gbShortcodes de la 4 a la 5
-- ------------------------------------------------------------
-- Agrega el grupo composicion: instrucciones de composición que solo
-- afectan al PDF, como el espacio vertical (SC-38, SC-39). Va al final
-- del catálogo.
-- Modifica: la tabla shortcodes, que se rehace con la lista de grupos
-- nueva en su CHECK (SQLite no cambia un CHECK en su lugar). Los datos
-- no cambian.
-- La corre la propia aplicación al abrir una base v4 (también se puede
-- correr con el importador de la 5 desde una terminal).
-- Migración: 4 a 5
-- Esquema: 4
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- NINGUNA FILA TIENE UN GRUPO FUERA DE LA LISTA NUEVA
INSERT INTO _verif SELECT 'grupos conocidos', COUNT(*) = 0 FROM shortcodes
  WHERE grupo NOT IN ('comun','estructura','disciplinar','composicion');

CREATE TABLE shortcodes_v5 (
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

INSERT INTO shortcodes_v5 (id_shortcode, nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion)
SELECT id_shortcode, nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion FROM shortcodes;

INSERT INTO _verif SELECT 'filas copiadas',
  (SELECT COUNT(*) FROM shortcodes_v5) = (SELECT COUNT(*) FROM shortcodes);

DROP TABLE shortcodes;
ALTER TABLE shortcodes_v5 RENAME TO shortcodes;
CREATE INDEX ix_shortcodes_orden ON shortcodes (grupo, perfil, orden);
CREATE INDEX ix_shortcodes_clase ON shortcodes (clase);

-- LA CLAVE FORÁNEA A modos SIGUE VALIENDO DESPUÉS DE REHACER LA TABLA
INSERT INTO _verif SELECT 'claves foráneas', COUNT(*) = 0 FROM pragma_foreign_key_check('shortcodes');

INSERT INTO esquema_version (version, fecha) VALUES (5, date('now'));

DROP TABLE _verif;

COMMIT;
