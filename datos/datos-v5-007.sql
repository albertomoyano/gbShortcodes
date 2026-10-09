-- ============================================================
-- datos-v5-007: conversación (SC-43)
-- ------------------------------------------------------------
-- Da de alta, los cuatro en borrador para libros y revistas:
--   conversacion   el bloque que envuelve los turnos
--   pregunta       turno de quien pregunta
--   respuesta      turno de quien responde
--   acotacion      acotación entre turnos ([Risas], [Se corta…])
-- Baja:
--   speech (clase speech): el bloque viejo ::: {.speech speaker=""}.
--   conversacion.lua frena un ::: {.speech} que quede en un .md con un
--   mensaje que nombra el nuevo.
-- Los ejemplos son conversaciones completas: el documento de prueba
-- de cada producto junta los ejemplos, y un turno suelto lo frenaría.
-- Requiere gbpublisher con conversacion.lua en las tres cadenas, las
-- seis hojas (conversacion-comun.xsl) y el contrato 12.
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES ---
-- EL BLOQUE VIEJO EXISTE; LOS NOMBRES Y LAS CLASES NUEVOS ESTÁN LIBRES
INSERT INTO _verif SELECT 'speech presente', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'speech' AND clase = 'speech';
INSERT INTO _verif SELECT 'nombres libres', COUNT(*) = 0 FROM shortcodes
  WHERE nombre IN ('conversacion', 'pregunta', 'respuesta', 'acotacion')
     OR clase IN ('conversacion', 'pregunta', 'respuesta', 'acotacion');
INSERT INTO _verif SELECT 'modo envolver de bloque', COUNT(*) = 1 FROM modos
  WHERE modo = 'envolver' AND tipo = 'bloque';

-- --- 2. BAJA DEL BLOQUE VIEJO ---
DELETE FROM shortcodes WHERE nombre = 'speech';

-- --- 3. ALTA ---
INSERT INTO shortcodes
  (nombre, clase, etiqueta, tipo, grupo, perfil, orden,
   estado_libro, estado_revista, modo, apertura, cierre,
   que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente,
   fecha_alta, fecha_modificacion)
VALUES
-- CONVERSACIÓN
('conversacion', 'conversacion', 'Conversación', 'bloque', 'comun', NULL, 190,
 'borrador', 'borrador', 'envolver', '::: conversacion', ':::',
 'Una entrevista, un reportaje o un tramo de historia oral: preguntas y respuestas con la etiqueta de quien habla. No es para obras teatrales. Una cita breve dentro de un párrafo no se marca: va entre comillas.

Se seleccionan los turnos ya marcados y se aplica el shortcode. Adentro solo van turnos —Pregunta y Respuesta— y acotaciones; el primer turno es una pregunta. Una acotación puede ir antes de la primera pregunta.

La etiqueta la decide el texto: si el original da el nombre, el turno lleva quien="Nombre"; si no, sale la etiqueta por omisión, P. y R. (Q. y A. en un texto en inglés).',
 '::: conversacion

::: acotacion

[Comienza la grabación]

[/acotacion]: # ()
:::

::: {.pregunta quien="Ana Pérez"}

¿Cuándo empezó todo?

[/pregunta]: # ()
:::

::: {.respuesta quien="Juan López"}

En 1990, *más o menos*.

Éramos cuatro y ninguno sabía lo que hacía.

[/respuesta]: # ()
:::

::: pregunta

¿Y después?

[/pregunta]: # ()
:::

::: respuesta

Después vino la imprenta [risas].

[/respuesta]: # ()
:::

[/conversacion]: # ()
:::',
 'La etiqueta sale siempre en mayúsculas y en línea, abriendo el primer párrafo del turno: ANA PÉREZ ¿Cuándo empezó todo?

En el PDF, toda la conversación en sans y en cuerpo chico, sin sangría, con un espacio chico entre turnos y entre párrafos, y un espacio mediano antes y después del bloque; la etiqueta en peso normal. Una pregunta no queda sola al pie de la página. En el HTML, la letra del texto; las etiquetas en negrita, y la de la pregunta además en azul. En el EPUB, como en el HTML, todo en negro. En el ODT, la etiqueta en negrita.

Una conversación vacía, con texto suelto, o que empieza con una respuesta detiene la conversión con un mensaje. El bloque viejo ::: {.speech} también.',
 'qandaset defaultlabel="qanda" role="conversacion"', 'disp-quote content-type="conversacion"',
 'Lo controla conversacion.lua en las tres cadenas (revista, libro y ODT); lo serializan cite-to-xref.lua (revista) y fenced-divs-to-elements-db.lua (libro). En revista la etiqueta por omisión depende de -M gb-idioma, que pasa m_XML.ArgumentoIdiomaPandoc; en libro la pone la hoja según xml:lang. La etiqueta en mayúsculas la da gbv:etiqueta (conversacion-comun.xsl), común a las seis hojas. PDF: entorno gbconversacion y \gbetiqueta, contrato 12 (preambulo-contrato.tex) y su gemelo en m_XML.ObtenerPreambuloEmbebido; \nopagebreak[4] después de cada pregunta. ODT: conversacion.lua la resuelve en párrafos.',
 'Probar en Mint: libro (PDF, HTML, EPUB) y revista (PDF, HTML, EPUB, ODT); inserción desde el panel; los casos que frenan.',
 datetime('now','localtime'), datetime('now','localtime')),

-- PREGUNTA
('pregunta', 'pregunta', 'Pregunta', 'bloque', 'comun', NULL, 200,
 'borrador', 'borrador', 'envolver', '::: pregunta', ':::',
 'Un turno de quien pregunta, dentro de una Conversación.

Se selecciona el texto del turno —uno o varios párrafos— y se aplica el shortcode. Si el original da el nombre de quien pregunta, se agrega a mano: ::: {.pregunta quien="Ana Pérez"}. Sin quien, sale P. (Q. en un texto en inglés).

En una revista el turno solo admite párrafos, con bastardilla, negrita, citas y notas. En un libro admite además listas y citas en bloque.',
 '::: conversacion

::: {.pregunta quien="Ana Pérez"}

¿Cuándo empezó todo?

[/pregunta]: # ()
:::

::: respuesta

En 1990.

[/respuesta]: # ()
:::

[/conversacion]: # ()
:::',
 'La etiqueta abre el primer párrafo, en mayúsculas: ANA PÉREZ ¿Cuándo empezó todo? En el HTML, en negrita y azul; en el EPUB y el ODT, en negrita; en el PDF, en peso normal. Una pregunta no queda sola al pie de la página del PDF.

Una pregunta fuera de una Conversación, vacía, con quien="" o, en una revista, con una lista adentro, detiene la conversión con un mensaje.',
 'question (con label si hay quien)', 'speech content-type="pregunta" con speaker',
 'quien → <label> en libro y <speaker> en revista. Sin quien: libro, sin label (la etiqueta la pone la hoja); revista, <speaker> con la etiqueta por omisión que escribe conversacion.lua.',
 'Probar en Mint junto con Conversación.',
 datetime('now','localtime'), datetime('now','localtime')),

-- RESPUESTA
('respuesta', 'respuesta', 'Respuesta', 'bloque', 'comun', NULL, 210,
 'borrador', 'borrador', 'envolver', '::: respuesta', ':::',
 'Un turno de quien responde, dentro de una Conversación. Varias respuestas seguidas a una misma pregunta son varios turnos: historia oral con más de dos voces.

Se selecciona el texto del turno —uno o varios párrafos— y se aplica el shortcode. Si el original da el nombre de quien responde, se agrega a mano: ::: {.respuesta quien="Juan López"}. Sin quien, sale R. (A. en un texto en inglés).

En una revista el turno solo admite párrafos, con bastardilla, negrita, citas y notas. En un libro admite además listas y citas en bloque.',
 '::: conversacion

::: pregunta

¿Cuándo empezó todo?

[/pregunta]: # ()
:::

::: {.respuesta quien="Juan López"}

En 1990.

Éramos cuatro.

[/respuesta]: # ()
:::

[/conversacion]: # ()
:::',
 'La etiqueta abre el primer párrafo, en mayúsculas: JUAN LÓPEZ En 1990. En el HTML, el EPUB y el ODT, en negrita; en el PDF, en peso normal.

Una respuesta fuera de una Conversación, vacía, con quien="", antes de toda pregunta o, en una revista, con una lista adentro, detiene la conversión con un mensaje.',
 'answer (con label si hay quien)', 'speech content-type="respuesta" con speaker',
 'quien → <label> en libro y <speaker> en revista. Una respuesta sin pregunta antes frena: qandaentry exige question (GV-82).',
 'Probar en Mint junto con Conversación.',
 datetime('now','localtime'), datetime('now','localtime')),

-- ACOTACIÓN
('acotacion', 'acotacion', 'Acotación', 'bloque', 'comun', NULL, 220,
 'borrador', 'borrador', 'envolver', '::: acotacion', ':::',
 'Una acotación de la transcripción entre dos turnos, dentro de una Conversación: [Se interrumpe la grabación], [Pausa larga].

Se selecciona el párrafo y se aplica el shortcode. Solo admite párrafos y no lleva quien. Una acotación dentro de un turno, como [risas], no se marca: va entre corchetes en el texto.',
 '::: conversacion

::: pregunta

¿Y después?

[/pregunta]: # ()
:::

::: acotacion

[Se interrumpe la grabación]

[/acotacion]: # ()
:::

::: respuesta

Después vino la imprenta.

[/respuesta]: # ()
:::

[/conversacion]: # ()
:::',
 'Un párrafo como los de los turnos, sin etiqueta. En el PDF, en la letra de la conversación.

Una acotación fuera de una Conversación, vacía, con quien o con algo que no sea un párrafo detiene la conversión con un mensaje.',
 'para role="acotacion" (antes de la primera entrada o al final del turno anterior)', 'p content-type="acotacion"',
 'En libro el esquema no admite un para entre dos qandaentry (GV-82): fenced-divs-to-elements-db.lua la pone al final del turno anterior, o suelta en el qandaset antes de la primera entrada.',
 'Probar en Mint junto con Conversación.',
 datetime('now','localtime'), datetime('now','localtime'));

-- --- 4. VERIFICACIÓN ---
INSERT INTO _verif SELECT 'speech dado de baja', COUNT(*) = 0 FROM shortcodes
  WHERE nombre = 'speech' OR clase = 'speech';
INSERT INTO _verif SELECT 'cuatro de conversación', COUNT(*) = 4 FROM shortcodes
  WHERE nombre IN ('conversacion', 'pregunta', 'respuesta', 'acotacion')
    AND modo = 'envolver' AND tipo = 'bloque'
    AND estado_libro = 'borrador' AND estado_revista = 'borrador';
INSERT INTO _verif SELECT 'ayuda completa', COUNT(*) = 4 FROM shortcodes
  WHERE nombre IN ('conversacion', 'pregunta', 'respuesta', 'acotacion')
    AND que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL;
INSERT INTO _verif SELECT 'claves foráneas', COUNT(*) = 0 FROM pragma_foreign_key_check('shortcodes');

DROP TABLE _verif;

COMMIT;

SELECT nombre, clase, orden, modo, estado_libro, estado_revista
FROM shortcodes WHERE nombre IN ('conversacion', 'pregunta', 'respuesta', 'acotacion')
ORDER BY orden;
