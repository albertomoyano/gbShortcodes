-- ============================================================
-- datos-v5-005: código (SC-42)
-- ------------------------------------------------------------
-- Da de alta:
--   el modo codigo, para bloque y para línea: en bloque pide el lenguaje
--   (y en el listado, el nombre) y cerca la selección con ~~~ lenguaje;
--   en línea la envuelve en comillas inversas
--   codigo         bloque de código cercado          libro y revista
--   listado        bloque con pie «Código N»         libro y revista
--   codigo-linea   código dentro del párrafo         libro y revista
--   los tres en borrador
-- Baja:
--   code (clase code): el bloque viejo ::: {.code language=""}, con la
--   plantilla de MySQL sin uso. codigo.lua frena un ::: {.code} que
--   quede en un .md con un mensaje que nombra el nuevo.
-- Requiere gbpublisher con codigo.lua en las tres cadenas, el coloreo
-- previo (colorear_codigo.sh), las seis hojas y el modo codigo en
-- m_Shortcodes, m_CatalogoShortcodes y FCodigo.
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES ---
-- EL BLOQUE VIEJO EXISTE; EL MODO Y LOS NOMBRES NUEVOS ESTÁN LIBRES
INSERT INTO _verif SELECT 'code presente', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'code' AND clase = 'code';
INSERT INTO _verif SELECT 'modo codigo libre', COUNT(*) = 0 FROM modos WHERE modo = 'codigo';
INSERT INTO _verif SELECT 'nombres libres', COUNT(*) = 0 FROM shortcodes
  WHERE nombre IN ('codigo', 'listado', 'codigo-linea') OR clase IN ('codigo', 'listado');

-- --- 2. EL MODO ---
INSERT INTO modos (modo, tipo, descripcion) VALUES
  ('codigo', 'bloque', 'Pide el lenguaje (y el nombre del listado) y cerca la selección con ~~~ lenguaje (SC-42).'),
  ('codigo', 'linea',  'Envuelve la selección en comillas inversas, más que las que tenga adentro (SC-42).');

-- --- 3. BAJA DEL BLOQUE VIEJO ---
DELETE FROM shortcodes WHERE nombre = 'code';

-- --- 4. ALTA ---
INSERT INTO shortcodes
  (nombre, clase, etiqueta, tipo, grupo, perfil, orden,
   estado_libro, estado_revista, modo, apertura, cierre,
   que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente,
   fecha_alta, fecha_modificacion)
VALUES
-- BLOQUE DE CÓDIGO
('codigo', 'codigo', 'Código', 'bloque', 'comun', NULL, 20,
 'borrador', 'borrador', 'codigo', '~~~', '~~~',
 'Bloque de código de programación, con las líneas numeradas y coloreado según el lenguaje.

Se selecciona el código y se aplica el shortcode: pide el lenguaje y cerca la selección con `~~~ lenguaje`. Lenguajes: python, r, sql, bash, javascript, json, yaml, markdown, latex, html, xml, xslt, css, lua, docbook, jats, y texto para un bloque sin color.

Una línea demasiado larga se corta a mano: se termina con ↩ y se sigue en la línea siguiente, que sale sin número. El corte no es automático.',
 '~~~ python
def factorial(n):
    """Devuelve el factorial de n, para cualquier ↩
    entero no negativo."""
    if n <= 1:
        return 1
    return n * factorial(n - 1)
~~~',
 'En el PDF de pantalla y en el HTML, una caja oscura con la paleta Gruvbox: el nombre del lenguaje arriba, los números de línea en gris, el código coloreado y el ↩ del corte en gris. En el HTML, el número y el ↩ no se copian con el código.

En el PDF de un libro en estado «Imprenta», fondo blanco, texto negro y sin color; la negrita de las palabras clave y la bastardilla de los comentarios se conservan. En el EPUB, fondo negro y texto blanco, sin color, con los números de línea. En el ODT, el bloque con el resaltado claro de Pandoc.

Un bloque sin lenguaje, con un lenguaje fuera de la lista o con un identificador detiene la conversión con un mensaje. El bloque viejo ::: {.code} también.',
 'programlisting language="…" (sin language para texto)', 'code language="…" (sin language para texto)',
 'Lo controla y escribe codigo.lua en las tres cadenas (revista, libro y ODT). El color no va al canónico: colorear_codigo.sh (extraer-codigo.xsl más colorear_codigo.lua, con el resaltador de Pandoc) lo pone antes de las hojas de PDF y HTML, y las hojas lo leen con el parámetro codigo_dir. El bloque lo arman f:codigo-latex (tex-comun.xsl) y gbc:bloque-html (codigo-comun.xsl). PDF: entorno gbCodigo, contrato 11 (preambulo-contrato.tex) y su gemelo en m_XML.ObtenerPreambuloEmbebido; la bandera codigocolor sale del estado del libro. No es un Div: no lleva ancla de cierre, y el verificador de cierres (SC-33) no lo cuenta.',
 'Probar en Mint: libro (PDF en producción y en imprenta, HTML, EPUB) y revista (PDF, HTML, EPUB, ODT); inserción desde el panel.',
 datetime('now','localtime'), datetime('now','localtime')),

-- LISTADO
('listado', 'listado', 'Listado de código', 'bloque', 'comun', NULL, 25,
 'borrador', 'borrador', 'codigo', '::: {.listado #lst-}', ':::',
 'Bloque de código con un pie numerado debajo, como las figuras: «Código 2.3» en los libros, por capítulo, y «Código 3» en las revistas. Tiene su propia cuenta: no se mezcla con la de las figuras.

Se selecciona el código y se aplica el shortcode: pide el lenguaje y el nombre del listado, que es su identificador (lst-nombre) y no se puede repetir en el archivo. Inserta el bloque con el marcador • seleccionado en el lugar del pie, para escribirlo encima. El pie admite bastardilla, negrita y citas.

Las referencias cruzadas (@lst-…) todavía no están disponibles: la mención se escribe como texto («código 2.3»).',
 '::: {.listado #lst-factorial}

~~~ python
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)
~~~

Factorial *recursivo*.

[/listado]: # ()
:::',
 'El bloque sale igual que el de Código —caja, números de línea y color según la salida— y debajo va el pie: «Código 2.3. Factorial recursivo.» En el PDF, en letra chica con el rótulo en negrita; en el HTML, con el estilo del pie de las figuras. En el ODT, el bloque y el pie, sin número.

Un listado sin nombre, sin el bloque o sin el pie, con algo más adentro o con el marcador • sin reemplazar detiene la conversión con un mensaje. También una referencia @lst-…, hasta que estén implementadas.',
 'example role="listado" xml:id="lst-…" con title y programlisting', 'fig id="lst-…" fig-type="listado" con caption y code',
 'codigo.lua controla la forma y escribe el bloque; cite-to-xref.lua (revista) y fenced-divs-to-elements-db.lua (libro) arman el envoltorio con el pie. Número: PDF, contador gbcodigo (\gbPieCodigo, contrato 11), por pieza en libros como figure; HTML y EPUB de libro, nl:numero-listado (numeracion-libro.xsl); de revista, xsl:number sobre fig[@fig-type=''listado''], y las figuras dejaron de contar los listados. SciELO: el code pasa a preformat dentro del fig (válido en JATS Publishing 1.0, medido con el DTD de packtools). @lst- frena en libros (cite-to-biblioref-db.lua) y en revistas (cite-to-xref.lua).',
 'Probar en Mint: libro y revista, todas las salidas; inserción desde el panel, con un nombre repetido.',
 datetime('now','localtime'), datetime('now','localtime')),

-- CÓDIGO EN LÍNEA
('codigo-linea', 'codigo', 'Código en línea', 'linea', 'comun', NULL, 10,
 'borrador', 'borrador', 'codigo', '`', '`',
 'Código, un nombre de archivo o un comando dentro del párrafo, en letra monoespaciada.

Se selecciona el texto y se aplica el shortcode: lo envuelve en comillas inversas, `así`. Si el texto ya tiene comillas inversas adentro, la cerca lleva una más. Va en una sola línea: para varias, el bloque de código.',
 'La función `factorial()` está en el archivo `matematica.py`.',
 'En el PDF, en IBM Plex Mono. En el HTML, en IBM Plex Mono sobre un fondo gris claro. En el EPUB y el ODT, en la monoespaciada del lector o del procesador. No se colorea.',
 'literal', 'monospace',
 'Es la marca de Pandoc para el código en línea: no hay filtro. Los escritores de Pandoc dan <literal> y <monospace>; las hojas lo componen con \texttt (PDF) y code.code-inline (HTML y EPUB).',
 'Probar en Mint: inserción desde el panel, también con una comilla inversa adentro.',
 datetime('now','localtime'), datetime('now','localtime'));

-- --- 5. VERIFICACIÓN ---
INSERT INTO _verif SELECT 'code dado de baja', COUNT(*) = 0 FROM shortcodes
  WHERE nombre = 'code' OR clase = 'code';
INSERT INTO _verif SELECT 'tres de código', COUNT(*) = 3 FROM shortcodes
  WHERE nombre IN ('codigo', 'listado', 'codigo-linea') AND modo = 'codigo'
    AND estado_libro = 'borrador' AND estado_revista = 'borrador';
INSERT INTO _verif SELECT 'ayuda completa', COUNT(*) = 3 FROM shortcodes
  WHERE nombre IN ('codigo', 'listado', 'codigo-linea')
    AND que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL;
INSERT INTO _verif SELECT 'claves foráneas', COUNT(*) = 0 FROM pragma_foreign_key_check('shortcodes');

DROP TABLE _verif;

COMMIT;

SELECT nombre, clase, tipo, orden, modo, estado_libro, estado_revista
FROM shortcodes WHERE modo = 'codigo' ORDER BY tipo, orden;
