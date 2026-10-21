-- ============================================================
-- datos-v5-014: letra volada (SC-62)
-- ------------------------------------------------------------
-- Da de alta:
--   sptext, letra volada en línea (n\sptext{o}), grupo comun, modo
--   plantilla: inserta \sptext{•} con el marcador seleccionado. En
--   borrador para libros y revistas hasta probarlo en Mint.
-- Requiere gbpublisher con volada.lua en las tres cadenas,
-- f:volada-latex en tex-comun.xsl y las plantillas de la volada en
-- docbook-to-latex.xsl y jats-to-latex.xsl.
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES ---
-- EL NOMBRE Y LA CLASE ESTÁN LIBRES; EL MODO plantilla EN LÍNEA EXISTE
INSERT INTO _verif SELECT 'sptext libre', COUNT(*) = 0 FROM shortcodes
  WHERE nombre = 'sptext' OR clase = 'sptext';
INSERT INTO _verif SELECT 'modo plantilla en línea', COUNT(*) = 1 FROM modos
  WHERE modo = 'plantilla' AND tipo = 'linea';

-- --- 2. SPTEXT ---
-- ORDEN 20: DESPUÉS DE codigo-linea, LA OTRA MARCA EN LÍNEA DEL GRUPO
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion)
VALUES ('sptext', 'sptext', 'Letra volada (n.º, 1.ª)', 'linea', 'comun', NULL, 20, 'borrador', 'borrador', 'plantilla', '\sptext{', '}',
        'Letra volada de los ordinales y las abreviaturas: n.º, 1.ª, 3.er, C.ía, V.º B.º. Se escribe como en LaTeX, igual que en las referencias: la base, pegada, y la volada entre llaves, sin punto. El punto lo pone la orden.

Se ubica el cursor después de la base (la n, el 1) y se inserta: queda `\sptext{•}` con el marcador seleccionado, y encima se escribe la volada.

La volada lleva una o más minúsculas, con o sin tilde. La base es una letra o una cifra, nunca un punto: `n.\sptext{o}` saldría con dos. Es del español: no va en un texto en otro idioma.',
        'El n\sptext{o} 3 de la revista, la 1\sptext{a} edición y el 3\sptext{er} piso.',
        'En el PDF, «n.º» con la volada de babel-spanish (`\sptext`), del tamaño y a la altura que corresponden. En un título, también en el sumario y en los marcadores del PDF.

En el HTML y el EPUB, el punto y la volada en superíndice. En el ODT, igual.

Una volada vacía, con mayúsculas o cifras adentro, sin una letra o una cifra pegada antes, con un punto antes, o en un texto que no está en español, detiene la conversión con un mensaje que dice qué falla.',
        'n.<superscript role="volada">o</superscript>: el punto en el texto (SC-58, SC-62)',
        'n.<sup specific-use="volada">o</sup>: el punto en el texto (SC-58, SC-62)',
        'Filtro volada.lua, en las tres cadenas, antes de todo filtro que serialice con pandoc.write: libro, segundo (antes de cite-to-biblioref-db.lua); revista, después de alinear.lua y antes de cite-to-xref.lua; ODT, después de alinear.lua. Sin él, Pandoc descartaba la orden (GV-116). Escribe en el canónico el punto y la volada marcada, como SC-58. docbook-to-latex.xsl y jats-to-latex.xsl la vuelven a \sptext{…} con f:volada-latex (tex-comun.xsl) y le quitan el punto al texto anterior; en el argumento opcional de un título, \texorpdfstring (GV-118). Las hojas LaTeX frenan si el xml:lang no es español. HTML y EPUB: las plantillas de superíndice de siempre.',
        'Probar en Mint con un libro y una revista reales: PDF (también en un título y su marcador), HTML, EPUB, inserción desde el panel y un caso que frene.',
        datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO _verif SELECT 'sptext escrito', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'sptext' AND tipo = 'linea' AND grupo = 'comun' AND modo = 'plantilla'
    AND apertura = '\sptext{' AND cierre = '}'
    AND estado_libro = 'borrador' AND estado_revista = 'borrador';

DROP TABLE _verif;

COMMIT;

SELECT nombre, etiqueta, tipo, grupo, orden, modo, apertura, cierre, estado_libro, estado_revista
  FROM shortcodes WHERE nombre = 'sptext';
