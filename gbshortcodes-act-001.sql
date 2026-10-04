-- ============================================================
-- gbshortcodes-act-001
-- ------------------------------------------------------------
-- Modifica: epigraph. Pasa al modo dos-partes, con la forma
-- {texto}{atribución} (SC-35), y se libera para libros y revistas.
-- Requiere el esquema 3 (gbshortcodes-migrar-2-a-3.sql) y gbpublisher
-- con dos-partes.lua.
-- Esquema: 3
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- LA FILA ESTÁ COMO LA DEJÓ LA CARGA INICIAL
INSERT INTO _verif SELECT 'epigraph en borrador', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'epigraph' AND modo = 'envolver'
    AND estado_libro = 'borrador' AND estado_revista = 'borrador';

UPDATE shortcodes SET
  modo = 'dos-partes',
  ejemplo = '::: epigraph

{El conocimiento es *poder*.}{Francis Bacon, *Meditationes sacrae*}

[/epigraph]: # ()
:::',
  que_es = 'Cita breve al comienzo de un capítulo, un artículo o una sección, con su atribución.

Se escribe en dos partes entre llaves, pegadas: `{texto}{atribución}`. Las llaves las escribe quien marca; después se selecciona todo y se aplica el shortcode, que controla la forma antes de insertar. Las dos partes admiten bastardilla, negrita, rayas y citas. La atribución puede quedar vacía: `{texto}{}`.',
  como_sale = 'Sale a la derecha, en un bloque del 60 % del ancho de la columna, en letra menor y sin corte de palabra: el texto alineado a la izquierda, un filete de 0,6 pt y la atribución alineada a la derecha. Sin atribución no hay filete.

Es igual en libros y revistas, y en el PDF, el EPUB y el HTML. En el ODT salen el texto y la atribución como dos párrafos con su estilo.

El texto puede tener varios párrafos; la atribución, uno solo. Un epígrafe que no tiene la forma `{…}{…}` detiene la conversión con un mensaje.',
  mapeo_docbook = 'epigraph',
  mapeo_jats = 'disp-quote specific-use="epigraph"',
  notas = 'Lo parte dos-partes.lua en las tres cadenas (revista, libro y ODT). Libro: <epigraph><attribution>; revista: <disp-quote specific-use="epigraph"><attrib>. PDF: \gbepigrafe, en preambulo-contrato.tex y en m_XML.ObtenerPreambuloEmbebido (gemelas). ODT: estilos gbEpigrafe y gbEpigrafeAtrib de reference.ott.',
  pendiente = NULL,
  estado_libro = 'liberado',
  estado_revista = 'liberado',
  fecha_modificacion = datetime('now','localtime')
 WHERE nombre = 'epigraph';

INSERT INTO _verif SELECT 'epigraph liberado', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'epigraph' AND modo = 'dos-partes'
    AND estado_libro = 'liberado' AND estado_revista = 'liberado';

DROP TABLE _verif;

COMMIT;

SELECT nombre, modo, estado_libro, estado_revista FROM shortcodes WHERE nombre = 'epigraph';
