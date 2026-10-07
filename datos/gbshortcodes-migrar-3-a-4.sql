-- ============================================================
-- Migración del esquema de gbShortcodes de la versión 3 a la 4
-- ------------------------------------------------------------
-- Agrega el modo separador: un bloque vacío que se inserta sin
-- selección y en una línea vacía (SC-36, el froufrou). Es un bloque.
-- Modifica: la tabla shortcodes, que se rehace con la restricción
-- nueva (SQLite no cambia un CHECK en su lugar). Los datos no cambian.
-- Antes de migrar se aplican los scripts de la versión 3 pendientes
-- (gbshortcodes-act-002.sql): el importador de la 4 ya no los acepta.
-- Se corre desde una terminal: la aplicación no abre una base v3.
-- Migración: 3 a 4
-- Esquema: 3
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

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
  modo               TEXT    NOT NULL DEFAULT 'envolver'
                     CHECK (modo IN ('envolver','plantilla','figura','dos-partes','separador')),
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
  -- EL SEPARADOR ES UN BLOQUE VACÍO EN UNA LÍNEA PROPIA (SC-36)
  CHECK (modo <> 'separador' OR tipo = 'bloque'),
  -- LO LIBERADO SE MUESTRA EN LA AYUDA: SIN HUECOS
  CHECK ((estado_libro <> 'liberado' AND estado_revista <> 'liberado')
         OR (que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL)),
  -- LIBERADO ES TERMINADO: SIN PENDIENTES (SC-34)
  CHECK ((estado_libro <> 'liberado' AND estado_revista <> 'liberado')
         OR pendiente IS NULL),
  -- SE LIBERA PARA LOS DOS PRODUCTOS, O PARA UNO SI EL OTRO NO APLICA:
  -- NUNCA LIBERADO EN UNO Y BORRADOR EN EL OTRO (SC-34)
  CHECK (NOT (estado_libro = 'liberado' AND estado_revista = 'borrador')
         AND NOT (estado_revista = 'liberado' AND estado_libro = 'borrador'))
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
