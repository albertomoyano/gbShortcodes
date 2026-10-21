-- ============================================================
-- datos-v5-012: alineación de párrafos en el PDF (SC-61)
-- ------------------------------------------------------------
-- Da de alta:
--   alinear-izq, alinear-centro y alinear-der, instrucciones de
--   composición de un tramo: alinean uno o más párrafos en el PDF.
--   Grupo composicion, modo envolver, después de espaciov. En
--   borrador para libros y revistas hasta probarlos en Mint.
-- Requiere gbpublisher con alinear.lua en las tres cadenas, las
-- funciones f:alinear-* en tex-comun.xsl, la plantilla de párrafo de
-- docbook-to-latex.xsl y jats-to-latex.xsl, y Destino por modo en
-- m_AnalizarProyecto.
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES ---
-- LOS NOMBRES Y LAS CLASES ESTÁN LIBRES; EL MODO envolver DE BLOQUE EXISTE;
-- espaciov ES EL ÚNICO DEL GRUPO composicion, CON ORDEN 10
INSERT INTO _verif SELECT 'nombres y clases libres', COUNT(*) = 0 FROM shortcodes
  WHERE nombre IN ('alinear-izq', 'alinear-centro', 'alinear-der')
     OR clase IN ('alinear-izq', 'alinear-centro', 'alinear-der');
INSERT INTO _verif SELECT 'modo envolver de bloque', COUNT(*) = 1 FROM modos
  WHERE modo = 'envolver' AND tipo = 'bloque';
INSERT INTO _verif SELECT 'composicion: solo espaciov, orden 10', COUNT(*) = 1 FROM shortcodes
  WHERE grupo = 'composicion' AND nombre = 'espaciov' AND orden = 10;
INSERT INTO _verif SELECT 'composicion: nada más', COUNT(*) = 1 FROM shortcodes
  WHERE grupo = 'composicion';

-- --- 2. ALINEAR-IZQ ---
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion)
VALUES ('alinear-izq', 'alinear-izq', 'Alinear a la izquierda (PDF)', 'bloque', 'composicion', NULL, 20, 'borrador', 'borrador', 'envolver', '::: alinear-izq', ':::',
        'Instrucción de composición para el PDF: compone uno o más párrafos a la izquierda, sin sangría y sin cortar palabras. Sirve para lo que en la página impresa va en otro lugar que el texto corrido: un lugar y una fecha, una firma, un renglón de cierre. Afecta solo al PDF, de libros y de revistas; en el EPUB y el HTML el párrafo sale como cualquier otro, que en una pantalla se lee mejor.

Se selecciona el texto, párrafos enteros, y se inserta: el bloque lo rodea. Cada renglón es su propio párrafo, separado del siguiente por una línea en blanco; el salto de línea manual (la barra invertida o los dos espacios al final) no se admite.

No agrega espacio arriba ni abajo: si hace falta aire, va un `espaciov` antes o después.',
        '::: alinear-izq

Nota: los datos de este cuadro fueron provistos por la dirección de la revista.

[/alinear-izq]: # ()
:::',
        'En el PDF, cada párrafo del bloque a la izquierda, en bandera: el margen derecho queda irregular, sin sangría de primera línea y sin corte de palabra (`\raggedright` de LaTeX). Una nota al pie del párrafo sale como cualquier otra nota.

En el EPUB, el HTML y los indexadores, el párrafo común. En el ODT, los párrafos sin el bloque.

Un bloque vacío, con algo que no sea un párrafo (un título, una lista, una figura, otro bloque), con un salto de línea manual, con atributos en la apertura, o dentro de otro bloque, una lista, una tabla o una nota, detiene la conversión con un mensaje que dice qué falla.',
        '<?gb-alinear izq?> al comienzo de cada para del bloque (instrucción de procesamiento, SC-38)',
        '<?gb-alinear izq?> al comienzo de cada p del bloque (instrucción de procesamiento, SC-38)',
        'Filtro alinear.lua, en las tres cadenas, justo después de espacio-vertical.lua: revista (después de unwrap-structural-divs.lua), libro (antes de fenced-divs-to-elements-db.lua) y ODT (deja los párrafos sin el bloque). Desenvuelve el bloque y escribe la ficha al comienzo de cada párrafo (SC-61). La plantilla de párrafo de docbook-to-latex.xsl y jats-to-latex.xsl la toma con f:alinear-ficha y envuelve el párrafo con f:alinear-abre y f:alinear-cierra (tex-comun.xsl): \begingroup\raggedright\noindent … \par\endgroup. Una ficha fuera del comienzo de un párrafo del cuerpo corta la transformación. jats-to-scielo y jats-to-redalyc quitan toda instrucción gb-. Las hojas de HTML y EPUB no escriben nada por la regla incorporada de XSLT. m_AnalizarProyecto cuenta el texto como cuerpo (modo envolver).',
        'Probar en Mint con un libro y una revista reales: inserción desde el panel, PDF con el preámbulo del proyecto, HTML y EPUB sin rastro, ODT y conteo del análisis.',
        datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO _verif SELECT 'alinear-izq escrito', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'alinear-izq' AND grupo = 'composicion' AND modo = 'envolver'
    AND estado_libro = 'borrador' AND estado_revista = 'borrador';

-- --- 3. ALINEAR-CENTRO ---
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion)
VALUES ('alinear-centro', 'alinear-centro', 'Centrar (PDF)', 'bloque', 'composicion', NULL, 30, 'borrador', 'borrador', 'envolver', '::: alinear-centro', ':::',
        'Instrucción de composición para el PDF: compone uno o más párrafos al centro, sin sangría y sin cortar palabras. Sirve para lo que en la página impresa va en otro lugar que el texto corrido: un lugar y una fecha, una firma, un renglón de cierre. Afecta solo al PDF, de libros y de revistas; en el EPUB y el HTML el párrafo sale como cualquier otro, que en una pantalla se lee mejor.

Se selecciona el texto, párrafos enteros, y se inserta: el bloque lo rodea. Cada renglón es su propio párrafo, separado del siguiente por una línea en blanco; el salto de línea manual (la barra invertida o los dos espacios al final) no se admite.

No agrega espacio arriba ni abajo: si hace falta aire, va un `espaciov` antes o después.',
        '::: alinear-centro

Fin

[/alinear-centro]: # ()
:::',
        'En el PDF, cada párrafo del bloque centrado en la caja, sin sangría de primera línea y sin corte de palabra (`\centering` de LaTeX). Una nota al pie del párrafo sale como cualquier otra nota.

En el EPUB, el HTML y los indexadores, el párrafo común. En el ODT, los párrafos sin el bloque.

Un bloque vacío, con algo que no sea un párrafo (un título, una lista, una figura, otro bloque), con un salto de línea manual, con atributos en la apertura, o dentro de otro bloque, una lista, una tabla o una nota, detiene la conversión con un mensaje que dice qué falla.',
        '<?gb-alinear centro?> al comienzo de cada para del bloque (instrucción de procesamiento, SC-38)',
        '<?gb-alinear centro?> al comienzo de cada p del bloque (instrucción de procesamiento, SC-38)',
        'Filtro alinear.lua, en las tres cadenas, justo después de espacio-vertical.lua: revista (después de unwrap-structural-divs.lua), libro (antes de fenced-divs-to-elements-db.lua) y ODT (deja los párrafos sin el bloque). Desenvuelve el bloque y escribe la ficha al comienzo de cada párrafo (SC-61). La plantilla de párrafo de docbook-to-latex.xsl y jats-to-latex.xsl la toma con f:alinear-ficha y envuelve el párrafo con f:alinear-abre y f:alinear-cierra (tex-comun.xsl): \begingroup\centering\noindent … \par\endgroup. Una ficha fuera del comienzo de un párrafo del cuerpo corta la transformación. jats-to-scielo y jats-to-redalyc quitan toda instrucción gb-. Las hojas de HTML y EPUB no escriben nada por la regla incorporada de XSLT. m_AnalizarProyecto cuenta el texto como cuerpo (modo envolver).',
        'Probar en Mint con un libro y una revista reales: inserción desde el panel, PDF con el preámbulo del proyecto, HTML y EPUB sin rastro, ODT y conteo del análisis.',
        datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO _verif SELECT 'alinear-centro escrito', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'alinear-centro' AND grupo = 'composicion' AND modo = 'envolver'
    AND estado_libro = 'borrador' AND estado_revista = 'borrador';

-- --- 4. ALINEAR-DER ---
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion)
VALUES ('alinear-der', 'alinear-der', 'Alinear a la derecha (PDF)', 'bloque', 'composicion', NULL, 40, 'borrador', 'borrador', 'envolver', '::: alinear-der', ':::',
        'Instrucción de composición para el PDF: compone uno o más párrafos a la derecha, sin sangría y sin cortar palabras. Sirve para lo que en la página impresa va en otro lugar que el texto corrido: un lugar y una fecha, una firma, un renglón de cierre. Afecta solo al PDF, de libros y de revistas; en el EPUB y el HTML el párrafo sale como cualquier otro, que en una pantalla se lee mejor.

Se selecciona el texto, párrafos enteros, y se inserta: el bloque lo rodea. Cada renglón es su propio párrafo, separado del siguiente por una línea en blanco; el salto de línea manual (la barra invertida o los dos espacios al final) no se admite.

No agrega espacio arriba ni abajo: si hace falta aire, va un `espaciov` antes o después.',
        '::: alinear-der

19 de octubre de 2026, Ciudad de México

[/alinear-der]: # ()
:::',
        'En el PDF, cada párrafo del bloque contra el margen derecho, sin sangría de primera línea y sin corte de palabra (`\raggedleft` de LaTeX). Una nota al pie del párrafo sale como cualquier otra nota.

En el EPUB, el HTML y los indexadores, el párrafo común. En el ODT, los párrafos sin el bloque.

Un bloque vacío, con algo que no sea un párrafo (un título, una lista, una figura, otro bloque), con un salto de línea manual, con atributos en la apertura, o dentro de otro bloque, una lista, una tabla o una nota, detiene la conversión con un mensaje que dice qué falla.',
        '<?gb-alinear der?> al comienzo de cada para del bloque (instrucción de procesamiento, SC-38)',
        '<?gb-alinear der?> al comienzo de cada p del bloque (instrucción de procesamiento, SC-38)',
        'Filtro alinear.lua, en las tres cadenas, justo después de espacio-vertical.lua: revista (después de unwrap-structural-divs.lua), libro (antes de fenced-divs-to-elements-db.lua) y ODT (deja los párrafos sin el bloque). Desenvuelve el bloque y escribe la ficha al comienzo de cada párrafo (SC-61). La plantilla de párrafo de docbook-to-latex.xsl y jats-to-latex.xsl la toma con f:alinear-ficha y envuelve el párrafo con f:alinear-abre y f:alinear-cierra (tex-comun.xsl): \begingroup\raggedleft\noindent … \par\endgroup. Una ficha fuera del comienzo de un párrafo del cuerpo corta la transformación. jats-to-scielo y jats-to-redalyc quitan toda instrucción gb-. Las hojas de HTML y EPUB no escriben nada por la regla incorporada de XSLT. m_AnalizarProyecto cuenta el texto como cuerpo (modo envolver).',
        'Probar en Mint con un libro y una revista reales: inserción desde el panel, PDF con el preámbulo del proyecto, HTML y EPUB sin rastro, ODT y conteo del análisis.',
        datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO _verif SELECT 'alinear-der escrito', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'alinear-der' AND grupo = 'composicion' AND modo = 'envolver'
    AND estado_libro = 'borrador' AND estado_revista = 'borrador';

DROP TABLE _verif;

COMMIT;

SELECT nombre, etiqueta, grupo, orden, modo, estado_libro, estado_revista FROM shortcodes
 WHERE grupo = 'composicion' ORDER BY orden;
