-- ============================================================
-- datos-v5-001: espaciov
-- ------------------------------------------------------------
-- Da de alta:
--   el modo separador-valor (bloque): como el separador, sin selección y
--   con el cursor al principio de una línea vacía, con una línea para el
--   valor que lleva el marcador seleccionado (SC-39)
--   espaciov, espacio vertical del PDF, primer shortcode del grupo
--   composicion, en borrador para libros y revistas
-- Requiere gbpublisher con espacio-vertical.lua en las tres cadenas, la
-- plantilla gb-espacio en tex-comun.xsl y el modo separador-valor en
-- m_Shortcodes y m_CatalogoShortcodes.
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- EL MODO, EL NOMBRE Y LA CLASE ESTÁN LIBRES
INSERT INTO _verif SELECT 'modo separador-valor libre', COUNT(*) = 0 FROM modos WHERE modo = 'separador-valor';
INSERT INTO _verif SELECT 'espaciov libre', COUNT(*) = 0 FROM shortcodes
  WHERE nombre = 'espaciov' OR clase = 'espaciov';

INSERT INTO modos (modo, tipo, descripcion) VALUES
  ('separador-valor', 'bloque', 'Como el separador, con una línea para el valor y el marcador seleccionado (SC-39).');

INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion)
VALUES ('espaciov', 'espaciov', 'Espacio vertical (PDF)', 'bloque', 'composicion', NULL, 10, 'borrador', 'borrador', 'separador-valor', '::: espaciov', ':::',
        'Instrucción de composición para el PDF: agrega o quita espacio vertical, o fuerza un salto de página, en un punto exacto del texto. Sirve para la última pasada de compaginación: salvar una viuda, ganar una línea en la página, separar dos tramos. Afecta solo al PDF, de libros y de revistas; el EPUB y el HTML no cambian.

Va en una línea vacía entre dos párrafos: el shortcode no admite una selección y pide el cursor al principio de una línea vacía. Inserta el bloque con un marcador seleccionado, y encima se escribe el comando de LaTeX, solo en su línea y con la barra.

Valores admitidos: `\smallskip`, `\medskip`, `\bigskip`, `\newpage`, `\clearpage`, `\cleardoublepage` (solo libros), `\vspace{L}`, `\vspace*{L}` y `\enlargethispage{L}`. L es un número con una unidad (`pt`, `mm`, `cm`, `em`, `ex`), o `N\baselineskip`; el decimal va con punto, y puede ser negativa.

Un ajuste de página deja de valer si cambia el texto de arriba: conviene ponerlos al final, cuando el texto ya no se mueve.',
        '::: espaciov

\bigskip

[/espaciov]: # ()
:::',
        'En el PDF sale el comando tal como se escribió: `\bigskip` agrega un espacio grande; `\vspace*{2\baselineskip}` agrega dos líneas, también al principio de una página; `\enlargethispage{\baselineskip}` permite una línea más en la página.

En el EPUB, el HTML y los indexadores no sale nada. En el ODT el bloque se quita.

Un valor fuera de la lista, un bloque vacío, con más de una línea o dentro de otro bloque, una lista, una tabla o una nota detiene la conversión con un mensaje que dice qué falla y cuáles son los valores admitidos.',
        '<?gb-espacio FICHA?> (instrucción de procesamiento, SC-38)', '<?gb-espacio FICHA?> (instrucción de procesamiento, SC-38)',
        'Filtro espacio-vertical.lua, en las tres cadenas: revista (después de unwrap-structural-divs.lua), libro (antes de fenced-divs-to-elements-db.lua) y ODT (quita el bloque). Tiene el diccionario. Escribe en el canónico la instrucción de procesamiento <?gb-espacio FICHA?>, con ficha sin LaTeX: bigskip, vspace* 2baselineskip, enlargethispage 1baselineskip (SC-38). La traduce la plantilla de tex-comun.xsl, común a docbook-to-latex.xsl (que la alcanza en chapter y section) y jats-to-latex.xsl; frena con una ficha desconocida. jats-to-scielo y jats-to-redalyc quitan toda instrucción gb-. Las hojas de HTML y EPUB no escriben nada por la regla incorporada de XSLT.',
        'Probar en Mint con un libro y una revista reales: inserción con el modo separador-valor, PDF compilado y EPUB/HTML sin rastro.',
        datetime('now','localtime'), datetime('now','localtime'));

INSERT INTO _verif SELECT 'espaciov escrito', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'espaciov' AND grupo = 'composicion' AND modo = 'separador-valor';

DROP TABLE _verif;

COMMIT;

SELECT nombre, grupo, modo, estado_libro, estado_revista FROM shortcodes WHERE nombre = 'espaciov';
