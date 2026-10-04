-- ============================================================
-- Migración del esquema de gbShortcodes de la versión 2 a la 3
-- ------------------------------------------------------------
-- Agrega el modo dos-partes: envolver con control de la forma
-- {primera}{segunda} (SC-35, el epígrafe).
-- Agrega la regla de liberación (SC-34): un shortcode liberado no tiene
-- pendiente, y no está liberado en un producto y en borrador en el otro.
-- Modifica: la tabla shortcodes, que se rehace con las restricciones
-- nuevas (SQLite no cambia un CHECK en su lugar). Los datos no cambian.
-- La única fila de la carga inicial que viola la regla es figure (liberada
-- con un pendiente que pedía referencia cruzada en revistas). La
-- referencia cruzada es solo de libros (SC-32): se quita el pendiente y
-- «Cómo sale» lo explica, solo si la fila sigue como en la carga.
-- Después se comprueba que ninguna fila viole la regla: si una la viola,
-- la migración frena y la base queda como estaba.
-- Se corre desde una terminal: la aplicación no abre una base v2.
-- Migración: 2 a 3
-- Esquema: 2
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- FIGURA: LA REFERENCIA CRUZADA ES SOLO DE LIBROS (SC-32)
UPDATE shortcodes
   SET como_sale = replace(como_sale, 'En un libro se cita con `@fig-mapa`: sale solo el número, como enlace, y la palabra («figura», «fig.») la escribe el editor. Con `alt="..."` en la apertura, ese texto describe la imagen en el EPUB; si falta, se usa el pie.', 'En un libro se cita con `@fig-mapa`: sale solo el número, como enlace, y la palabra («figura», «fig.») la escribe el editor. En una revista no hay referencia cruzada: cada artículo es autónomo, y la mención a la figura la escribe el autor como texto («figura 2»); un `@fig-…` en un artículo detiene la conversión.

Con `alt="..."` en la apertura, ese texto describe la imagen en el EPUB; si falta, se usa el pie.'),
       pendiente = NULL,
       fecha_modificacion = datetime('now','localtime')
 WHERE nombre = 'figure'
   AND pendiente = 'Revistas: @fig-... no es referencia cruzada; cite-to-xref.lua lo trata como cita bibliográfica.';


-- LA REGLA DE LIBERACIÓN SE CUMPLE ANTES DE COPIAR
INSERT INTO _verif SELECT 'ningún liberado con pendiente', COUNT(*) = 0 FROM shortcodes
  WHERE (estado_libro = 'liberado' OR estado_revista = 'liberado') AND pendiente IS NOT NULL;
INSERT INTO _verif SELECT 'ninguno liberado en uno y borrador en otro', COUNT(*) = 0 FROM shortcodes
  WHERE (estado_libro = 'liberado' AND estado_revista = 'borrador')
     OR (estado_revista = 'liberado' AND estado_libro = 'borrador');

CREATE TABLE shortcodes_v3 (
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
                     CHECK (modo IN ('envolver','plantilla','figura','dos-partes')),
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
         OR (que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL)),
  -- LIBERADO ES TERMINADO: SIN PENDIENTES (SC-34)
  CHECK ((estado_libro <> 'liberado' AND estado_revista <> 'liberado')
         OR pendiente IS NULL),
  -- SE LIBERA PARA LOS DOS PRODUCTOS, O PARA UNO SI EL OTRO NO APLICA:
  -- NUNCA LIBERADO EN UNO Y BORRADOR EN EL OTRO (SC-34)
  CHECK (NOT (estado_libro = 'liberado' AND estado_revista = 'borrador')
         AND NOT (estado_revista = 'liberado' AND estado_libro = 'borrador'))
);

INSERT INTO shortcodes_v3 (id_shortcode, nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion)
SELECT id_shortcode, nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion FROM shortcodes;

INSERT INTO _verif SELECT 'filas copiadas',
  (SELECT COUNT(*) FROM shortcodes_v3) = (SELECT COUNT(*) FROM shortcodes);

DROP TABLE shortcodes;
ALTER TABLE shortcodes_v3 RENAME TO shortcodes;
CREATE INDEX ix_shortcodes_orden ON shortcodes (grupo, perfil, orden);
CREATE INDEX ix_shortcodes_clase ON shortcodes (clase);

INSERT INTO esquema_version (version, fecha) VALUES (3, date('now'));

DROP TABLE _verif;

COMMIT;
