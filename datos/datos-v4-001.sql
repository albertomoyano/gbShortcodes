-- ============================================================
-- datos-v4-001: froufrou
-- ------------------------------------------------------------
-- Da de alta:
--   el modo separador (bloque): un bloque vacío, sin selección y con el
--   cursor al principio de una línea vacía (SC-36)
--   froufrou, separador ornamental de libros, liberado para libros; en
--   revistas no aplica
-- Requiere gbpublisher con el froufrou en fenced-divs-to-elements-db.lua
-- y el modo separador en m_Shortcodes.
-- Esquema: 4
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- EL MODO, EL NOMBRE Y LA CLASE ESTÁN LIBRES
INSERT INTO _verif SELECT 'modo separador libre', COUNT(*) = 0 FROM modos WHERE modo = 'separador';
INSERT INTO _verif SELECT 'froufrou libre', COUNT(*) = 0 FROM shortcodes
  WHERE nombre = 'froufrou' OR clase = 'froufrou';

INSERT INTO modos (modo, tipo, descripcion) VALUES
  ('separador', 'bloque', 'Un bloque vacío, sin selección y en una línea vacía (SC-36).');

INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion)
VALUES ('froufrou', 'froufrou', 'Froufrou (separador)', 'bloque', 'comun', NULL, 140, 'liberado', 'no_aplica', 'separador', '::: froufrou', ':::',
        'Separador ornamental entre dos tramos de un texto: marca un cambio de escena, de tiempo o de tono sin abrir una sección. Es solo de libros.

Va en una línea vacía entre dos párrafos: el shortcode no admite una selección y pide el cursor al principio de una línea vacía. El bloque no lleva contenido.', '::: froufrou

[/froufrou]: # ()
:::', 'En el PDF sale el ornamento del paquete `froufrou` de LaTeX, centrado, con el espacio que trae el paquete.

En el HTML y el EPUB salen tres asteriscos centrados, separados por 1 cm, sin depender de la fuente; los lectores de pantalla lo anuncian como separador.

En una revista no se usa: un bloque escrito a mano en un artículo detiene la conversión. Un froufrou con contenido también la detiene.', 'para role="froufrou"', NULL, 'Libro: fenced-divs-to-elements-db.lua escribe <para role="froufrou">* * *</para> (DocBook no tiene elemento de separación; el texto lo muestra cualquier lector). PDF: \froufrou, con \usepackage{froufrou} en preambulo-contrato.tex. HTML: flex con column-gap de 1 cm (la salida está indentada); EPUB: margen de 1 cm entre los span. Revista: cite-to-xref.lua frena. ODT de libros: todavía no existe.', NULL,
        datetime('now','localtime'), datetime('now','localtime'));

INSERT INTO _verif SELECT 'froufrou escrito', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'froufrou' AND modo = 'separador' AND estado_libro = 'liberado';

DROP TABLE _verif;

COMMIT;

SELECT nombre, modo, estado_libro, estado_revista FROM shortcodes WHERE nombre = 'froufrou';
