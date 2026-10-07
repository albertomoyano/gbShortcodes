-- ============================================================
-- datos-v5-003: recuadros (SC-41)
-- ------------------------------------------------------------
-- Baja:
--   boxed-text (clase box): el recuadro viejo, con type="info" y
--   plantilla de MySQL sin uso. recuadros.lua frena un ::: {.box}
--   que quede en un .md con un mensaje que nombra los nuevos.
-- Alta (las cuatro en borrador, modo por clase, cierre :::):
--   recuadro          recuadro simple           libro y revista
--   recuadro-ancho    recuadro simple, ancho    solo revista
--   recuadrob         recuadro con barra        libro y revista
--   recuadrob-ancho   recuadro con barra, ancho solo revista
--   Las variantes de ancho comparten clase con su recuadro, como
--   fig-fullwidth con figure: la clase es la que empareja el cierre.
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES ---
-- EL RECUADRO VIEJO EXISTE Y NINGUNO DE LOS NUEVOS
INSERT INTO _verif SELECT 'boxed-text presente', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'boxed-text' AND clase = 'box';
INSERT INTO _verif SELECT 'recuadros ausentes', COUNT(*) = 0 FROM shortcodes
  WHERE nombre IN ('recuadro', 'recuadro-ancho', 'recuadrob', 'recuadrob-ancho')
     OR clase IN ('recuadro', 'recuadrob');
-- LOS MODOS QUE SE USAN EXISTEN PARA EL TIPO bloque
INSERT INTO _verif SELECT 'modos disponibles', COUNT(*) = 2 FROM modos
  WHERE tipo = 'bloque' AND modo IN ('envolver', 'dos-partes');

-- --- 2. BAJA DEL RECUADRO VIEJO ---
DELETE FROM shortcodes WHERE nombre = 'boxed-text';

-- --- 3. ALTA DE LOS RECUADROS ---
INSERT INTO shortcodes
  (nombre, clase, etiqueta, tipo, grupo, perfil, orden,
   estado_libro, estado_revista, modo, apertura, cierre,
   que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente,
   fecha_alta, fecha_modificacion)
VALUES
-- RECUADRO SIMPLE
('recuadro', 'recuadro', 'Recuadro', 'bloque', 'comun', NULL, 150,
 'borrador', 'borrador', 'envolver', '::: recuadro', ':::',
 'Texto destacado dentro de un recuadro con fondo gris y filete.

Se selecciona el texto —uno o más párrafos— y se aplica el shortcode. Admite todo lo que admite un párrafo común: bastardilla, negrita, comillas, rayas y citas bibliográficas.',
 '::: recuadro

Los datos se relevaron entre 2019 y 2021 en tres provincias (Pérez, 2020).

La muestra final fue de 1200 casos.

[/recuadro]: # ()
:::',
 'Un recuadro con fondo gris claro, filete de 1 pt y esquinas redondeadas. En el PDF y el HTML el filete es del azul de la publicación; en el EPUB, negro. El fondo es siempre gris. Si el libro va a imprenta, el paso a escala de grises lo hace el taller.

Un recuadro largo continúa en la página siguiente. En el ODT salen solo los párrafos, sin recuadro.

No admite notas al pie: en el PDF quedarían dentro del recuadro y numeradas aparte. La nota va en un párrafo fuera del recuadro. Tampoco admite listas, tablas, figuras ni otro recuadro adentro. Cualquiera de esos casos detiene la conversión con un mensaje.',
 'sidebar role="recuadro"', 'boxed-text content-type="recuadro"',
 'Lo controla recuadros.lua en las tres cadenas (revista, libro y ODT) y frena el viejo ::: {.box}. Libro: fenced-divs-to-elements-db.lua arma <sidebar role="recuadro">. Revista: cite-to-xref.lua arma <boxed-text content-type="recuadro">. PDF: entorno gbRecuadro, en preambulo-contrato.tex (v10) y en m_XML.ObtenerPreambuloEmbebido (gemelos). HTML y EPUB: div.recuadro; CSS en gbpublisher.css, jats-to-html.xsl, gbpublisher-epub-libro.css y m_GenerarEpub.',
 'Probar en Mint: libro y revista, PDF, HTML, EPUB y ODT.',
 datetime('now','localtime'), datetime('now','localtime')),

-- RECUADRO SIMPLE, ANCHO COMPLETO (SOLO REVISTAS)
('recuadro-ancho', 'recuadro', 'Recuadro de ancho completo', 'bloque', 'comun', NULL, 160,
 'no_aplica', 'borrador', 'envolver', '::: {.recuadro .fullwidth}', ':::',
 'Recuadro que, en el PDF de la revista, ocupa el ancho de la caja más la columna lateral. Es solo de revistas: el libro no tiene columna lateral.

Se marca igual que el recuadro: se selecciona el texto y se aplica el shortcode.',
 '::: {.recuadro .fullwidth}

Los datos se relevaron entre 2019 y 2021 en tres provincias (Pérez, 2020).

[/recuadro]: # ()
:::',
 'En el PDF ocupa el ancho de la caja más la columna lateral, como una figura de ancho completo; por lo demás es un recuadro común.

En el HTML, el EPUB y el ODT sale como un recuadro común: en pantalla no hay columna lateral.

No admite notas al pie, listas, tablas, figuras ni otro recuadro adentro: detienen la conversión con un mensaje. En un libro, .fullwidth también la detiene.',
 NULL, 'boxed-text content-type="recuadro" specific-use="fullwidth"',
 'Revista: cite-to-xref.lua arma <boxed-text content-type="recuadro" specific-use="fullwidth">; jats-to-latex.xsl lo compone con el mismo adjustwidth de figuras y tablas (SC-32). jats-to-html.xsl y jats-to-epub.xsl no lo distinguen. En libros recuadros.lua frena .fullwidth.',
 'Probar en Mint: revista, PDF, HTML, EPUB y ODT.',
 datetime('now','localtime'), datetime('now','localtime')),

-- RECUADRO CON BARRA
('recuadrob', 'recuadrob', 'Recuadro con barra', 'bloque', 'comun', NULL, 170,
 'borrador', 'borrador', 'dos-partes', '::: recuadrob', ':::',
 'Recuadro con fondo gris y una barra de color arriba, con un título breve.

Se escribe en dos partes entre llaves, pegadas: `{texto de la barra}{texto del recuadro}`. Las llaves las escribe quien marca; después se selecciona todo y se aplica el shortcode, que controla la forma antes de insertar. La barra es una sola línea; el texto puede tener varios párrafos y no puede quedar vacío. Las dos partes admiten bastardilla, negrita, comillas, rayas y citas.',
 '::: recuadrob

{Para recordar}{Los datos se relevaron entre 2019 y 2021 (Pérez, 2020).

La muestra final fue de 1200 casos.}

[/recuadrob]: # ()
:::',
 'Un recuadro con fondo gris claro, sin filete y con esquinas rectas. Arriba, una barra de 1 pica de alto con el título en blanco, centrado en alto. En el PDF y el HTML la barra es del azul de la publicación y el título va en versalitas; en el EPUB la barra es negra y el título sale en mayúsculas, como sea que esté escrito, y sin bastardilla ni negrita. El fondo es siempre gris. Si el libro va a imprenta, el paso a escala de grises lo hace el taller.

Un recuadro largo continúa en la página siguiente. En el ODT sale el título como un párrafo en negrita y mayúsculas, y después los párrafos del texto.

No admite notas al pie: en el PDF quedarían dentro del recuadro y numeradas aparte. La nota va en un párrafo fuera del recuadro. Tampoco admite listas, tablas, figuras ni otro recuadro adentro. Cualquiera de esos casos, o un recuadro que no tiene la forma `{…}{…}`, detiene la conversión con un mensaje.',
 'sidebar role="recuadro-barra"', 'boxed-text content-type="recuadro-barra"',
 'Lo parte dos-partes.lua (tabla CLASES: varios1=false, varios2=true, vacia2=false; gemela de m_Shortcodes.ProblemaDosPartes) y lo controla recuadros.lua. Libro: <sidebar role="recuadro-barra"><title>. Revista: <boxed-text content-type="recuadro-barra"><caption><title>. PDF: entorno gbRecuadroBarra (gemelos en preambulo-contrato.tex v10 y m_XML). EPUB: el título lo pasa a mayúsculas el XSLT con upper-case(), no el CSS.',
 'Probar en Mint: libro y revista, PDF, HTML, EPUB y ODT; inserción desde el panel con la selección {…}{…}.',
 datetime('now','localtime'), datetime('now','localtime')),

-- RECUADRO CON BARRA, ANCHO COMPLETO (SOLO REVISTAS)
('recuadrob-ancho', 'recuadrob', 'Recuadro con barra de ancho completo', 'bloque', 'comun', NULL, 180,
 'no_aplica', 'borrador', 'dos-partes', '::: {.recuadrob .fullwidth}', ':::',
 'Recuadro con barra que, en el PDF de la revista, ocupa el ancho de la caja más la columna lateral. Es solo de revistas: el libro no tiene columna lateral.

Se marca igual que el recuadro con barra: `{texto de la barra}{texto del recuadro}`, se selecciona todo y se aplica el shortcode.',
 '::: {.recuadrob .fullwidth}

{Para recordar}{Los datos se relevaron entre 2019 y 2021 (Pérez, 2020).}

[/recuadrob]: # ()
:::',
 'En el PDF ocupa el ancho de la caja más la columna lateral, como una figura de ancho completo; por lo demás es un recuadro con barra común.

En el HTML, el EPUB y el ODT sale como un recuadro con barra común: en pantalla no hay columna lateral.

No admite notas al pie, listas, tablas, figuras ni otro recuadro adentro: detienen la conversión con un mensaje. En un libro, .fullwidth también la detiene.',
 NULL, 'boxed-text content-type="recuadro-barra" specific-use="fullwidth"',
 'Revista: cite-to-xref.lua arma <boxed-text content-type="recuadro-barra" specific-use="fullwidth">; jats-to-latex.xsl lo compone con el mismo adjustwidth de figuras y tablas (SC-32). En libros recuadros.lua frena .fullwidth.',
 'Probar en Mint: revista, PDF, HTML, EPUB y ODT.',
 datetime('now','localtime'), datetime('now','localtime'));

-- --- 4. VERIFICACIÓN ---
INSERT INTO _verif SELECT 'boxed-text dado de baja', COUNT(*) = 0 FROM shortcodes
  WHERE nombre = 'boxed-text' OR clase = 'box';
INSERT INTO _verif SELECT 'cuatro recuadros', COUNT(*) = 4 FROM shortcodes
  WHERE nombre IN ('recuadro', 'recuadro-ancho', 'recuadrob', 'recuadrob-ancho');
INSERT INTO _verif SELECT 'variantes de ancho solo en revistas', COUNT(*) = 2 FROM shortcodes
  WHERE nombre IN ('recuadro-ancho', 'recuadrob-ancho')
    AND estado_libro = 'no_aplica' AND estado_revista = 'borrador'
    AND apertura LIKE '%.fullwidth}';
INSERT INTO _verif SELECT 'recuadrob en dos-partes', COUNT(*) = 2 FROM shortcodes
  WHERE clase = 'recuadrob' AND modo = 'dos-partes';
INSERT INTO _verif SELECT 'ayuda completa', COUNT(*) = 4 FROM shortcodes
  WHERE clase IN ('recuadro', 'recuadrob')
    AND que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL
    AND como_sale LIKE '%notas al pie%';

DROP TABLE _verif;

COMMIT;

SELECT nombre, clase, orden, estado_libro, estado_revista, modo, apertura
FROM shortcodes WHERE clase IN ('recuadro', 'recuadrob') ORDER BY orden;
