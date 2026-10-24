-- ============================================================
-- datos-v5-016: cifras y cantidades (SC-64, SC-65)
-- ------------------------------------------------------------
-- Da de alta tres filas en línea, grupo comun, modo plantilla:
--   num        \num{•}          una cifra
--   si         \SI{•}{}         una cifra con su unidad
--   si-rango   \SIrange{•}{}{}  un rango con su unidad
-- En borrador para libros y revistas hasta probarlas en Mint.
-- Requiere gbpublisher con cifras.lua en las tres cadenas,
-- f:cifra-latex en tex-comun.xsl, sus plantillas en
-- docbook-to-latex.xsl y jats-to-latex.xsl, el contrato 15 del libro
-- y el \sisetup en el preámbulo de la revista.
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES ---
-- LOS NOMBRES Y LAS CLASES ESTÁN LIBRES; EL MODO plantilla EN LÍNEA EXISTE;
-- sptext OCUPA EL ORDEN 20 Y NADA EL 30, 40 NI 50 DEL GRUPO EN LÍNEA
INSERT INTO _verif SELECT 'nombres libres', COUNT(*) = 0 FROM shortcodes
  WHERE nombre IN ('num', 'si', 'si-rango') OR clase IN ('num', 'si', 'si-rango');
INSERT INTO _verif SELECT 'modo plantilla en línea', COUNT(*) = 1 FROM modos
  WHERE modo = 'plantilla' AND tipo = 'linea';
INSERT INTO _verif SELECT 'órdenes libres', COUNT(*) = 0 FROM shortcodes
  WHERE grupo = 'comun' AND tipo = 'linea' AND orden IN (30, 40, 50);

-- --- 2. LAS TRES FILAS ---
-- LA AYUDA ES LA MISMA EN LAS TRES SALVO LA FORMA: EL DICCIONARIO ES UNO
-- SOLO (SC-64) Y CONVIENE QUE EL EDITOR LO VEA DESDE CUALQUIERA

INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion)
VALUES ('num', 'num', 'Cifra (\num)', 'linea', 'comun', NULL, 30, 'borrador', 'borrador', 'plantilla', '\num{', '}',
        'Una cifra que es una cantidad, con el formato de la norma internacional (SC-64). Se escribe con la entrada de siunitx: dígitos sin separador de miles, punto decimal y `e` para el exponente: `\num{1500}`, `\num{12000}`, `\num{2.5}`, `\num{1.2e6}`. El formato lo pone cada salida.

Se inserta `\num{•}` con el marcador seleccionado, y encima se escribe la cifra.

Los números que llevan punto por identidad («ley 34.555», «decreto 2.345/26») se escriben como texto común, sin `\num`.',
        'Un total de \num{12000} personas, \num{1500} de ellas en el área.',
        'En el PDF, la cifra compuesta por siunitx: «12 000», «1500» (las de cuatro dígitos no se agrupan), «2.5». En un título, también en los marcadores del PDF.

En el HTML, el EPUB y el ODT, el mismo formato, con un espacio fino que no corta la línea entre los grupos.

Una cifra con coma, con punto de miles o con letras detiene la conversión con un mensaje que dice qué falla. Una cifra con punto de miles escrita fuera de `\num` da un aviso al generar el capítulo.',
        '<phrase role="cantidad" remap="num 12000">12 000</phrase>: el texto formateado, y la entrada en remap (SC-65)',
        '<named-content content-type="cantidad" specific-use="num 12000">12 000</named-content>: el texto formateado, y la entrada en specific-use (SC-65)',
        'Filtro cifras.lua, en las tres cadenas, antes de todo filtro que serialice con pandoc.write: libro, después de corte-titulo.lua y antes de cite-to-biblioref-db.lua; revista, después de corte-titulo.lua y antes de cite-to-xref.lua; ODT, después de corte-titulo.lua. Sin él, Pandoc descartaba la orden (GV-116). docbook-to-latex.xsl y jats-to-latex.xsl la vuelven a \num{…} con f:cifra-latex (tex-comun.xsl); en el argumento opcional de un título, \texorpdfstring.',
        'Probar en Mint con un libro y una revista reales: PDF (también en un título, una nota y una celda), HTML, EPUB, ODT, inserción desde el panel y un caso que frene.',
        datetime('now','localtime'), datetime('now','localtime'));

INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion)
VALUES ('si', 'si', 'Cantidad con unidad (\SI)', 'linea', 'comun', NULL, 40, 'borrador', 'borrador', 'plantilla', '\SI{', '}{}',
        'Una cifra con su unidad, o un porcentaje, con el formato de la norma internacional (SC-64): la unidad separada de la cifra, el grado pegado. La cifra se escribe como en `\num`; la unidad, con las órdenes de siunitx: `\SI{2.5}{\hour}`, `\SI{88}{\percent}`, `\SI{48}{\kilo\metre\per\hour}`, `\SI{1500}{\square\metre}`, `\SI{30}{\degree}`, `\SI{450}{\euro}`.

Unidades: `\hour`, `\metre`, `\gram`, `\tonne`, `\degree`, `\percent`, `\euro`; el prefijo `\kilo` (con el metro y el gramo), `\square` y `\cubic` (con el metro), y un `\per` con una unidad después. `\degree` y `\percent` van solos. Nada más: lo que no está en la lista detiene la conversión.

Se inserta `\SI{•}{}` con el marcador seleccionado: se escribe la cifra y la unidad va en las segundas llaves. Un porcentaje de una sola cifra se escribe en letras («4 por ciento»).',
        'El \SI{88}{\percent} del padrón, a \SI{48}{\kilo\metre\per\hour} durante \SI{2.5}{\hour}.',
        'En el PDF, la cantidad compuesta por siunitx: «88 %», «48 km/h» (la barra en la línea, sin fracción), «2.5 h», «30°». En un título, también en los marcadores del PDF.

En el HTML, el EPUB y el ODT, el mismo formato, con un espacio fino que no corta la línea entre la cifra y la unidad.

Una unidad fuera de la lista, un prefijo o una potencia que no van con esa unidad, o una orden con menos argumentos, detienen la conversión con un mensaje. Un porcentaje escrito suelto («88%») da un aviso al generar el capítulo.',
        '<phrase role="cantidad" remap="SI 88 percent">88 %</phrase>: el texto formateado, y la entrada en remap (SC-65)',
        '<named-content content-type="cantidad" specific-use="SI 88 percent">88 %</named-content>: el texto formateado, y la entrada en specific-use (SC-65)',
        'Lo mismo que num: cifras.lua en las tres cadenas y f:cifra-latex en las hojas LaTeX, que rearman \SI{…}{\…} desde la ficha.',
        'Probar en Mint con un libro y una revista reales: PDF (también en un título, una nota y una celda), HTML, EPUB, ODT, inserción desde el panel y un caso que frene.',
        datetime('now','localtime'), datetime('now','localtime'));

INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion)
VALUES ('si-rango', 'si-rango', 'Rango con unidad (\SIrange)', 'linea', 'comun', NULL, 50, 'borrador', 'borrador', 'plantilla', '\SIrange{', '}{}{}',
        'Dos cifras con su unidad, como rango: `\SIrange{50}{51}{\degree}`, `\SIrange{10}{20}{\percent}`. Las cifras y la unidad se escriben como en `\SI`; la unidad va una sola vez y sale repetida en las dos cifras.

Se inserta `\SIrange{•}{}{}` con el marcador seleccionado: la primera cifra, la segunda y la unidad, cada una en sus llaves.

La palabra del rango la pone el idioma de la pieza: «a» en español y portugués, «to» en inglés, y las demás lenguas que trae siunitx (catalán, francés, alemán, italiano, polaco, esloveno).',
        'Entre \SIrange{50}{51}{\degree} de latitud y del \SIrange{10}{20}{\percent} de la muestra.',
        'En el PDF, el rango compuesto por siunitx: «50° a 51°», «10 % a 20 %». En el HTML, el EPUB y el ODT, el mismo texto.

En una pieza en un idioma que siunitx no conoce, detiene la conversión con un mensaje.',
        '<phrase role="cantidad" remap="SIrange 50 51 degree">50° a 51°</phrase>: el texto formateado, y la entrada en remap (SC-65)',
        '<named-content content-type="cantidad" specific-use="SIrange 50 51 degree">50° a 51°</named-content>: el texto formateado, y la entrada en specific-use (SC-65)',
        'Lo mismo que num. La palabra del rango: libro, -M gb-idioma-pieza (el idioma del capítulo); revista y ODT, -M gb-idioma.',
        'Probar en Mint con un libro y una revista reales: PDF, HTML, EPUB, ODT, inserción desde el panel, un capítulo en inglés y un caso que frene.',
        datetime('now','localtime'), datetime('now','localtime'));

INSERT INTO _verif SELECT 'tres filas escritas', COUNT(*) = 3 FROM shortcodes
  WHERE nombre IN ('num', 'si', 'si-rango') AND tipo = 'linea' AND grupo = 'comun'
    AND modo = 'plantilla' AND estado_libro = 'borrador' AND estado_revista = 'borrador';
INSERT INTO _verif SELECT 'aperturas y cierres', COUNT(*) = 3 FROM shortcodes
  WHERE (nombre = 'num' AND apertura = '\num{' AND cierre = '}')
     OR (nombre = 'si' AND apertura = '\SI{' AND cierre = '}{}')
     OR (nombre = 'si-rango' AND apertura = '\SIrange{' AND cierre = '}{}{}');

DROP TABLE _verif;

COMMIT;

SELECT nombre, etiqueta, orden, modo, apertura, cierre, estado_libro, estado_revista
  FROM shortcodes WHERE grupo = 'comun' AND tipo = 'linea' ORDER BY orden;
