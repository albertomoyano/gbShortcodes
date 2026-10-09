-- ============================================================
-- datos-v5-010: verso (SC-49)
-- ------------------------------------------------------------
-- Modifica:
--   verse: la ayuda completa (que_es, ejemplo, como_sale), los
--   mapeos, las notas y el pendiente. Sigue en borrador para
--   libros y revistas hasta probarlo en Mint.
--   epigraph: la ayuda dice que el texto puede ser un verso. Sigue
--   liberado: solo cambia el texto (como_sale).
-- Requiere gbpublisher con verso.lua en las tres cadenas,
-- dos-partes.lua con el verso en el epígrafe, las seis hojas
-- (verso-comun.xsl) y el contrato 14.
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES ---
-- verse EN BORRADOR EN LOS DOS PRODUCTOS; EL EPÍGRAFE CON EL TEXTO QUE
-- SE REEMPLAZA
INSERT INTO _verif SELECT 'verse en borrador', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'verse' AND clase = 'verse'
    AND estado_libro = 'borrador' AND estado_revista = 'borrador';
INSERT INTO _verif SELECT 'epigraph con el texto viejo', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'epigraph'
    AND instr(como_sale, 'El texto puede tener varios párrafos; la atribución, uno solo.') > 0;

-- --- 2. VERSO ---
UPDATE shortcodes SET
  que_es = 'Un poema, o un fragmento, compuesto en versos: cada verso en su línea, las estrofas separadas, y la sangría de cada verso cuando el original la tiene.

Se escriben los versos uno por línea y las estrofas separadas por una línea en blanco; después se seleccionan y se aplica el shortcode. Los versos admiten bastardilla, negrita, citas y notas; una bastardilla puede abarcar varios versos.

La sangría se da con un patrón, a mano en la apertura: `::: {.verse patron="0101"}`. Cada dígito es un verso y dice cuántas sangrías lleva (de 0 a 9). Un grupo de dígitos vale para todas las estrofas; varios, separados por espacio, van uno por estrofa: un soneto, `patron="0110 0110 010 010"`. Los versos que exceden su grupo van sin sangría. `patron="alterno"` sangra los versos pares de cada estrofa.

Si una estrofa empieza con «- », «# », «> » o «1. », Pandoc la lee como lista, título o cita: se escribe `\-`, `\#`, `\>` o `1\.`.

Para un epígrafe en verso, el verso va solo como primera parte, con la llave de apertura y la de cierre en su propio párrafo: `{`, una línea en blanco, el bloque del verso, otra línea en blanco y `}{atribución}`.',
  ejemplo = '::: {.verse patron="01"}

Caminante, son tus *huellas*
el camino y nada más;

caminante, no hay camino,
se hace camino al andar.

[/verse]: # ()
:::',
  como_sale = 'Cada verso en su línea y las estrofas separadas por un espacio menor que una línea. Un verso que no entra en la caja sigue en la línea de abajo, más adentro. Cada sangría es de 1,5 em.

En el PDF, en bastardilla y corrido a la izquierda (en una revista, 14 pt, como la cita); se compone con el paquete verse de LaTeX. En el HTML y el EPUB, igual. En el ODT, un párrafo por estrofa con un salto entre versos y la sangría como espacios.

En un epígrafe, el verso toma la letra del epígrafe, sin bastardilla y sin margen propio, y la atribución va debajo del filete.

Un verso vacío, con algo que no es una estrofa (una lista, un título), con un identificador, otra clase u otro atributo que patron, o con un patrón mal formado, detiene la conversión con un mensaje.',
  mapeo_docbook = 'blockquote role="verso" con un literallayout role="verse" por estrofa y un phrase role="linea" por verso, con dos espacios por nivel de sangría delante; en un epígrafe, los literallayout sueltos dentro de epigraph',
  mapeo_jats = 'verse-group (el poema) con un verse-group por estrofa y verse-line, con indent-level si lleva sangría; en un epígrafe, dentro de disp-quote specific-use="epigraph"',
  notas = 'Lo controla y normaliza verso.lua en las tres cadenas (revista, libro y ODT): resuelve el patrón y deja un Div .estrofa por estrofa y un Div .linea (nivel) por verso; parte una marca que cruza versos. Lo serializan cite-to-xref.lua (revista) y fenced-divs-to-elements-db.lua (libro). dos-partes.lua acepta el verso como primera parte del epígrafe y lo marca con la clase en-epigrafe. Las seis hojas leen estrofas, versos y nivel con verso-comun.xsl. PDF: entornos gbverso y gbversoepigrafe sobre el verse del paquete verse, contrato 14 (preambulo-contrato.tex) y su gemelo en m_XML.ObtenerPreambuloEmbebido; \vin por nivel y \relax delante de cada verso (GV-93). ODT: verso.lua lo resuelve en un párrafo por estrofa.',
  pendiente = 'Probar en Mint: libro y revista (PDF, HTML, EPUB, ODT), con el verso suelto y en un epígrafe; inserción desde el panel; los casos que frenan.',
  fecha_modificacion = datetime('now','localtime')
WHERE nombre = 'verse';

-- --- 3. EPÍGRAFE: EL TEXTO PUEDE SER UN VERSO ---
UPDATE shortcodes SET
  como_sale = replace(como_sale,
    'El texto puede tener varios párrafos; la atribución, uno solo.',
    'El texto puede tener varios párrafos, o ser un verso (ver Verso); la atribución, uno solo.'),
  fecha_modificacion = datetime('now','localtime')
WHERE nombre = 'epigraph';

-- --- 4. VERIFICACIÓN ---
INSERT INTO _verif SELECT 'verse con la ayuda nueva', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'verse' AND instr(ejemplo, 'patron="01"') > 0
    AND que_es IS NOT NULL AND como_sale IS NOT NULL
    AND estado_libro = 'borrador' AND estado_revista = 'borrador';
INSERT INTO _verif SELECT 'epigraph con el texto nuevo', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'epigraph' AND instr(como_sale, 'o ser un verso (ver Verso)') > 0
    AND estado_libro = 'liberado' AND estado_revista = 'liberado';

DROP TABLE _verif;

COMMIT;

SELECT nombre, estado_libro, estado_revista FROM shortcodes
WHERE nombre IN ('verse', 'epigraph') ORDER BY orden;
