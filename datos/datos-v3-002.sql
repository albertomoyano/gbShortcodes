-- ============================================================
-- datos-v3-002 (antes gbshortcodes-act-002)
-- ------------------------------------------------------------
-- Modifica: fig-fullwidth. Se libera para revistas (en libros no aplica:
-- el libro no tiene columna lateral). Textos de la ayuda y notas al día
-- con la figura de revista de SC-32.
-- Requiere datos-v3-001.sql (esquema 3).
-- Esquema: 3
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- LA FILA ESTÁ COMO LA DEJÓ LA CARGA INICIAL
INSERT INTO _verif SELECT 'fig-fullwidth en borrador', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'fig-fullwidth' AND estado_libro = 'no_aplica' AND estado_revista = 'borrador'
    AND como_sale IS NULL AND pendiente IS NULL;

UPDATE shortcodes SET
  que_es = 'Imagen con su pie que, en el PDF de la revista, ocupa el ancho de la caja más la columna lateral. Es solo de revistas: el libro no tiene columna lateral.

El botón pide la imagen, la copia a `media/` y escribe el bloque completo, con `.fullwidth`. El identificador sale del nombre del archivo: `mapa.png` da `#fig-mapa`. Queda reemplazar el texto provisorio del pie, que es obligatorio.',
  como_sale = 'En el PDF ocupa el ancho de la caja más la columna lateral, centrada en ese espacio, con su número y su pie como una figura común.

En el HTML, el EPUB y el ODT sale como una figura común, al ancho de la columna: en pantalla no hay columna lateral.

El pie admite formato y citas. Con `alt="..."` en la apertura, ese texto describe la imagen en el EPUB; si falta, se usa el pie. En una revista no hay referencia cruzada: la mención a la figura la escribe el autor como texto («figura 2»).',
  notas = 'Revista: cite-to-xref.lua arma el <fig specific-use="fullwidth"> (SC-32); jats-to-latex.xsl lo compone con adjustwidth hasta el borde de la columna lateral. jats-to-html.xsl y jats-to-epub.xsl no lo distinguen de una figura común.',
  estado_revista = 'liberado',
  fecha_modificacion = datetime('now','localtime')
 WHERE nombre = 'fig-fullwidth';

INSERT INTO _verif SELECT 'fig-fullwidth liberada', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'fig-fullwidth' AND estado_revista = 'liberado' AND estado_libro = 'no_aplica';

DROP TABLE _verif;

COMMIT;

SELECT nombre, estado_libro, estado_revista FROM shortcodes WHERE nombre LIKE 'fig%';
