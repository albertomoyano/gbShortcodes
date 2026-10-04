-- ============================================================
-- Carga inicial del catálogo de shortcodes
-- ------------------------------------------------------------
-- Da de alta: los 77 shortcodes de la tabla shortcodes de MySQL,
-- tomados de gbpublisher-baseline-1.0.0.sql.
-- Modifica: nada. Exige la base vacía.
--
-- Liberada solo la figura (libro y revista). El resto queda en
-- borrador donde aplicaba y en no_aplica donde no.
-- Los ejemplos que Pandoc no lee como se espera llevan pendiente.
-- Los ejemplos de bloque llevan el cierre nombrado (SC-33).
-- Esquema: 3
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- LA CARGA INICIAL VA SOBRE UNA BASE VACÍA
INSERT INTO _verif SELECT 'base vacía', COUNT(*) = 0 FROM shortcodes;

INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('source-quote', 'source', 'Cita de fuente primaria', 'bloque', 'comun', NULL, 10, 'borrador', 'borrador', 'envolver', '::: {.source archivo=""}', ':::', 'Cita textual de documento histórico o fuente primaria con referencia archivística.', '::: {.source archivo="AGN, Sala IX, Legajo 23-5-6"}
En el día de la fecha se procedió a la lectura del acta...

[/source]: # ()
:::', NULL, NULL, 'disp-quote', 'Atributos requeridos (MySQL): archivo

Plantilla JATS (MySQL, sin uso):
<disp-quote content-type="primary-source">
  <p>{{contenido}}</p>
  <attrib>{{archivo}}</attrib>
</disp-quote>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('code', 'code', 'Código fuente', 'bloque', 'comun', NULL, 20, 'borrador', 'borrador', 'envolver', '::: {.code language="python"}
~~~', ':::', 'Bloque de código de programación con resaltado de sintaxis.', '::: {.code language="python"}
~~~
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n-1)
~~~

[/code]: # ()
:::', NULL, NULL, 'code', 'Atributos requeridos (MySQL): language

Plantilla JATS (MySQL, sin uso):
<code language="{{language}}">
~~~
{{contenido}}
~~~
</code>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('epigraph', 'epigraph', 'Epígrafe', 'bloque', 'comun', NULL, 30, 'borrador', 'borrador', 'envolver', '::: epigraph', ':::', 'Cita breve al inicio de un artículo o sección, generalmente de otro autor, que introduce o contextualiza el tema.', '::: epigraph
El conocimiento es poder.
— Francis Bacon

[/epigraph]: # ()
:::', NULL, NULL, 'disp-quote', 'Plantilla JATS (MySQL, sin uso):
<disp-quote content-type="epigraph">
  <p>{{contenido}}</p>
  <attrib>{{atribucion}}</attrib>
</disp-quote>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('case-study', 'case', 'Estudio de caso', 'bloque', 'comun', NULL, 40, 'borrador', 'borrador', 'envolver', '::: {.case id=""}', ':::', 'Descripción de caso analizado con identificador.', '::: {.case id="Empresa-Alpha"}
**Contexto**: Empresa mediana del sector manufacturero...
**Problema**: Caída de productividad del 15%...

[/case]: # ()
:::', NULL, NULL, 'boxed-text', 'Atributos requeridos (MySQL): id

Plantilla JATS (MySQL, sin uso):
<boxed-text content-type="case-study">
  <caption><title>Caso {{id}}</title></caption>
  <p>{{contenido}}</p>
</boxed-text>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('figure', 'fig', 'Figura', 'bloque', 'comun', NULL, 50, 'liberado', 'liberado', 'figura', '::: {.fig #fig-id}', ':::', 'Imagen con su pie. Se numera sola y, en los libros, se puede citar desde el texto.

El botón pide la imagen, la copia a `media/` y escribe el bloque completo. El identificador sale del nombre del archivo: `mapa.png` da `#fig-mapa`. Queda reemplazar el texto provisorio del pie, que es obligatorio.', '::: {.fig #fig-mapa}
![Pie de la figura, con *formato* y citas [@clave]](media/fig-mapa.png)

[/fig]: # ()
:::', 'Sale numerada, con su pie, en el PDF, el EPUB y el HTML.

En un libro, el número es el del PDF en las tres salidas: 2.3 en un capítulo numerado, A.1 en un apéndice, y 1, 2, 3 dentro de una pieza sin número, como la Introducción.

En un libro se cita con `@fig-mapa`: sale solo el número, como enlace, y la palabra («figura», «fig.») la escribe el editor. En una revista no hay referencia cruzada: cada artículo es autónomo, y la mención a la figura la escribe el autor como texto («figura 2»); un `@fig-…` en un artículo detiene la conversión.

Con `alt="..."` en la apertura, ese texto describe la imagen en el EPUB; si falta, se usa el pie.', NULL, 'fig', 'Atributos requeridos (MySQL): id

Plantilla JATS (MySQL, sin uso):
<fig id="{{id}}">
  <label>{{label}}</label>
  <caption><p>{{caption}}</p></caption>
  <graphic xlink:href="{{archivo}}"/>
</fig>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('fig-fullwidth', 'fig', 'Figura ancho total', 'bloque', 'comun', NULL, 60, 'no_aplica', 'borrador', 'figura', '::: {.fig #fig-id .fullwidth}', ':::', 'Imagen, gráfico o ilustración que ocupa el ancho completo de la página (columna de texto + columna lateral). Se centra automáticamente en el espacio disponible.', '::: {.fig #fig-mapa .fullwidth}
![Pie de la figura](media/fig-mapa.png)

[/fig]: # ()
:::', NULL, NULL, 'fig', 'Atributos requeridos (MySQL): #fig-id (identificador único)

Requiere clase .fullwidth además de .fig. El filtro cite-to-xref.lua detecta la clase y agrega specific-use="fullwidth" al <fig> en JATS. El XSLT usa adjustwidth para extender al margen derecho.', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('glossary', 'glossary', 'Glosario', 'bloque', 'comun', NULL, 70, 'borrador', 'borrador', 'envolver', '::: {.glossary term=""}', ':::', 'Definición de término técnico o especializado.', '::: {.glossary term="Hermenéutica"}
Método de interpretación de textos que busca comprender el significado
a partir del contexto histórico y cultural del autor.

[/glossary]: # ()
:::', NULL, NULL, 'def-list', 'Atributos requeridos (MySQL): term

Plantilla JATS (MySQL, sin uso):
<def-list>
  <def-item>
    <term>{{term}}</term>
    <def><p>{{contenido}}</p></def>
  </def-item>
</def-list>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('supplementary', 'supplementary', 'Material suplementario', 'bloque', 'comun', NULL, 80, 'borrador', 'borrador', 'envolver', '::: {.supplementary #supp-id}', ':::', 'Referencia a datos, archivos o contenido adicional disponible como anexo.', '::: {.supplementary #supp-datos}
Dataset completo disponible en: datos_experimento.xlsx

[/supplementary]: # ()
:::', NULL, NULL, 'supplementary-material', 'Atributos requeridos (MySQL): id

Plantilla JATS (MySQL, sin uso):
<supplementary-material id="{{id}}" xlink:href="{{archivo}}">
  <caption><p>{{descripcion}}</p></caption>
</supplementary-material>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('boxed-text', 'box', 'Recuadro', 'bloque', 'comun', NULL, 90, 'borrador', 'borrador', 'envolver', '::: {.box type="info"}', ':::', 'Texto destacado en un recuadro, usado para resúmenes, advertencias o información complementaria.', '::: {.box type="warning"}
**Advertencia**: Los resultados pueden variar según las condiciones ambientales.

[/box]: # ()
:::', NULL, NULL, 'boxed-text', 'Atributos requeridos (MySQL): type

Plantilla JATS (MySQL, sin uso):
<boxed-text content-type="{{type}}">
  <p>{{contenido}}</p>
</boxed-text>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('table-wrap', 'table', 'Tabla', 'bloque', 'comun', NULL, 100, 'borrador', 'borrador', 'envolver', '::: {.table #tbl-id}', ':::', 'Tabla de datos con título y notas al pie opcionales.', '::: {.table #tbl-datos}
| Variable | Grupo A | Grupo B |
|----------|---------|----------|
| Media    | 45.2    | 52.1     |

Tabla 1. Comparación de medias entre grupos.

[/table]: # ()
:::', NULL, NULL, 'table-wrap', 'Atributos requeridos (MySQL): id

Plantilla JATS (MySQL, sin uso):
<table-wrap id="{{id}}">
  <label>{{label}}</label>
  <caption><p>{{caption}}</p></caption>
  <table>{{contenido}}</table>
</table-wrap>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('table-fullwidth', 'table', 'Tabla ancho total', 'bloque', 'comun', NULL, 110, 'no_aplica', 'borrador', 'envolver', '::: {.table #tbl-id .fullwidth}', ':::', 'Tabla que ocupa el ancho completo (columna de texto + columna lateral). Se centra automáticamente.', '::: {.table #tbl-datos .fullwidth}
: Título de la tabla

| Col1 | Col2 |
|------|------|
| dato | dato |

[/table]: # ()
:::', NULL, NULL, 'table-wrap', NULL, NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('table-landscape', 'table', 'Tabla apaisada', 'bloque', 'comun', NULL, 120, 'borrador', 'borrador', 'envolver', '::: {.table #tbl-id .landscape}', ':::', 'Tabla rotada 90° que ocupa página completa. LaTeX la ubica en la primera página siguiente disponible.', '::: {.table #tbl-grande .landscape}
: Título de la tabla

| Col1 | Col2 | Col3 |
|------|------|------|
| dato | dato | dato |

[/table]: # ()
:::', NULL, NULL, 'table-wrap', NULL, 'La apertura usa .landscape y los filtros esperan .rotate.', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('verse', 'verse', 'Verso', 'bloque', 'comun', NULL, 130, 'borrador', 'borrador', 'envolver', '::: verse', ':::', 'Texto poético que preserva saltos de línea y formato original.', '::: verse
Caminante, son tus huellas
el camino y nada más;
caminante, no hay camino,
se hace camino al andar.

[/verse]: # ()
:::', NULL, NULL, 'verse-group', 'Plantilla JATS (MySQL, sin uso):
<verse-group>
  <verse-line>{{linea}}</verse-line>
</verse-group>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-acknowledgments', 'acknowledgments', 'Agradecimientos', 'bloque', 'estructura', NULL, 10, 'no_aplica', 'borrador', 'envolver', '::: {.acknowledgments}', ':::', 'Sección de agradecimientos.', '::: {.acknowledgments}
Los autores agradecen...

[/acknowledgments]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="acknowledgments"><title>Agradecimientos</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-appendix', 'appendix', 'Apéndice', 'bloque', 'estructura', NULL, 20, 'no_aplica', 'borrador', 'envolver', '::: {.appendix}', ':::', 'Sección de apéndice o anexo.', '::: {.appendix}
Datos complementarios.

[/appendix]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="appendix"><title>Apéndice</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-review-article', 'review-article', 'Artículo de revisión', 'bloque', 'estructura', NULL, 30, 'no_aplica', 'borrador', 'envolver', '::: {.review-article}', ':::', 'Sección de revisión bibliográfica.', '::: {.review-article}
Texto de revisión.

[/review-article]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="review-article"><title>Revisión</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-conclusions', 'conclusions', 'Conclusiones', 'bloque', 'estructura', NULL, 40, 'no_aplica', 'borrador', 'envolver', '::: {.conclusions}', ':::', 'Sección de conclusiones.', '::: {.conclusions}
Conclusión principal.

[/conclusions]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="conclusions"><title>Conclusiones</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-conflict-of-interest', 'conflict-of-interest', 'Conflicto de intereses', 'bloque', 'estructura', NULL, 50, 'no_aplica', 'borrador', 'envolver', '::: {.conflict-of-interest}', ':::', 'Declaración de conflicto de intereses.', '::: {.conflict-of-interest}
Los autores declaran...

[/conflict-of-interest]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="conflict-of-interest"><title>Conflicto de intereses</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-correspondence', 'correspondence', 'Correspondencia', 'bloque', 'estructura', NULL, 60, 'no_aplica', 'borrador', 'envolver', '::: {.correspondence}', ':::', 'Cartas al editor o correspondencia.', '::: {.correspondence}
Estimado editor...

[/correspondence]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="correspondence"><title>Correspondencia</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-oration', 'oration', 'Discurso/Ponencia', 'bloque', 'estructura', NULL, 70, 'no_aplica', 'borrador', 'envolver', '::: {.oration}', ':::', 'Discurso o ponencia académica.', '::: {.oration}
Texto de la ponencia.

[/oration]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="oration"><title>Ponencia</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-discussion', 'discussion', 'Discusión', 'bloque', 'estructura', NULL, 80, 'no_aplica', 'borrador', 'envolver', '::: {.discussion}', ':::', 'Sección de discusión.', '::: {.discussion}
Interpretación de resultados.

[/discussion]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="discussion"><title>Discusión</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-editorial', 'editorial', 'Editorial', 'bloque', 'estructura', NULL, 90, 'no_aplica', 'borrador', 'envolver', '::: {.editorial}', ':::', 'Contenido editorial.', '::: {.editorial}
Texto editorial.

[/editorial]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="editorial"><title>Editorial</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-correction', 'correction', 'Fe de erratas', 'bloque', 'estructura', NULL, 100, 'no_aplica', 'borrador', 'envolver', '::: {.correction}', ':::', 'Corrección de errores en artículo publicado. Requerido SciELO/Redalyc.', '::: {.correction}
En la versión publicada...

[/correction]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="correction"><title>Fe de erratas</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-intro', 'intro', 'Introducción', 'bloque', 'estructura', NULL, 110, 'no_aplica', 'borrador', 'envolver', '::: {.intro}', ':::', 'Sección de introducción del artículo.', '::: {.intro}
Texto de introducción.

[/intro]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="intro"><title>Introducción</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-methods', 'methods', 'Materiales y métodos', 'bloque', 'estructura', NULL, 120, 'no_aplica', 'borrador', 'envolver', '::: {.methods}', ':::', 'Sección de materiales y métodos.', '::: {.methods}
Descripción del método.

[/methods]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="methods"><title>Materiales y métodos</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-obituary', 'obituary', 'Necrológica', 'bloque', 'estructura', NULL, 130, 'no_aplica', 'borrador', 'envolver', '::: {.obituary}', ':::', 'Nota necrológica.', '::: {.obituary}
El Dr. X falleció...

[/obituary]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="obituary"><title>In memoriam</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-case-report', 'case-report', 'Reporte de caso', 'bloque', 'estructura', NULL, 140, 'no_aplica', 'borrador', 'envolver', '::: {.case-report}', ':::', 'Sección para reporte de caso clínico.', '::: {.case-report}
Descripción del caso.

[/case-report]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="case-report"><title>Reporte de caso</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-book-review', 'book-review', 'Reseña de libro', 'bloque', 'estructura', NULL, 150, 'no_aplica', 'borrador', 'envolver', '::: {.book-review}', ':::', 'Reseña bibliográfica de libro.', '::: {.book-review}
El libro analizado...

[/book-review]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="book-review"><title>Reseña</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-results', 'results', 'Resultados', 'bloque', 'estructura', NULL, 160, 'no_aplica', 'borrador', 'envolver', '::: {.results}', ':::', 'Sección de resultados.', '::: {.results}
Principal hallazgo.

[/results]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="results"><title>Resultados</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-abstract', 'abstract', 'Resumen estructurado', 'bloque', 'estructura', NULL, 170, 'no_aplica', 'borrador', 'envolver', '::: {.abstract}', ':::', 'Resumen estructurado por secciones.', '::: {.abstract}
Objetivo: ...

[/abstract]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="abstract"><title>Resumen</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('sec-retraction', 'retraction', 'Retractación', 'bloque', 'estructura', NULL, 180, 'no_aplica', 'borrador', 'envolver', '::: {.retraction}', ':::', 'Retractación formal de un artículo publicado. Requerido SciELO/Redalyc.', '::: {.retraction}
Los autores retractan...

[/retraction]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="retraction"><title>Retractación</title>
{{contenido}}
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('speech', 'speech', 'Entrevista/Discurso/Diálogo', 'bloque', 'disciplinar', 'ciencias_sociales', 10, 'borrador', 'borrador', 'envolver', '::: {.speech speaker=""}', ':::', 'Transcripción de discurso oral o diálogo con identificación del hablante.', '::: {.speech speaker="Entrevistado A"}
Yo creo que la situación cambió radicalmente a partir de 1990...

[/speech]: # ()
:::', NULL, NULL, 'speech', 'Atributos requeridos (MySQL): speaker

Plantilla JATS (MySQL, sin uso):
<speech>
  <speaker>{{speaker}}</speaker>
  <p>{{contenido}}</p>
</speech>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('field-note', 'fieldnote', 'Nota de campo', 'bloque', 'disciplinar', 'ciencias_sociales', 20, 'borrador', 'borrador', 'envolver', '::: {.fieldnote date=""}', ':::', 'Observación etnográfica o nota de trabajo de campo.', '::: {.fieldnote date="2024-03-15"}
Llegué al mercado a las 7am. Los vendedores ya estaban
organizando sus puestos...

[/fieldnote]: # ()
:::', NULL, NULL, 'disp-quote', 'Atributos requeridos (MySQL): date

Plantilla JATS (MySQL, sin uso):
<disp-quote content-type="field-note">
  <attrib>Nota de campo, {{date}}</attrib>
  <p>{{contenido}}</p>
</disp-quote>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('apparatus', 'apparatus', 'Aparato crítico', 'bloque', 'disciplinar', 'filologia', 10, 'borrador', 'borrador', 'envolver', '::: apparatus', ':::', 'Notas del aparato crítico con variantes textuales entre manuscritos.', '::: apparatus
¹ moraua] moraba B, morava C
² Toledo] Toleto A

[/apparatus]: # ()
:::', NULL, NULL, 'fn-group', 'Plantilla JATS (MySQL, sin uso):
<fn-group content-type="apparatus">{{contenido}}</fn-group>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('ling-example', 'ling-example', 'Ejemplo lingüístico', 'bloque', 'disciplinar', 'filologia', 20, 'borrador', 'borrador', 'envolver', '::: ling-example', ':::', 'Ejemplo de uso lingüístico con glosa interlineal opcional.', '::: ling-example
(1) a. *El niño parece dormir.
    b. El niño parece estar dormido.

[/ling-example]: # ()
:::', NULL, NULL, 'disp-quote', 'Plantilla JATS (MySQL, sin uso):
<disp-quote content-type="linguistic-example"><label>{{numero}}</label>{{contenido}}</disp-quote>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('etymology', 'etymology', 'Etimología', 'linea', 'disciplinar', 'filologia', 30, 'borrador', 'borrador', 'envolver', '[', ']{.etymology}', 'Explicación del origen y evolución de una palabra.', '::: etymology {voz="palabra"}
Del lat. PARABOLA, y este del gr. παραβολή ''comparación''.
:::', NULL, NULL, 'def-item', 'Atributos requeridos (MySQL): voz

Plantilla JATS (MySQL, sin uso):
<def-item><term>{{voz}}</term><def content-type="etymology">{{contenido}}</def></def-item>', 'Es un shortcode en línea y el ejemplo está escrito como bloque («:::»). La forma en línea es «[texto]{.clase}».', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('primary-source', 'primary-source', 'Fuente primaria', 'bloque', 'disciplinar', 'filologia', 40, 'borrador', 'borrador', 'envolver', '::: primary-source', ':::', 'Cita de una fuente primaria (manuscrito, inscripción, texto antiguo) con referencia.', '::: primary-source {fuente="BNE Ms. 1234, f. 23r"}
En aquel tiempo moraua en Toledo...

[/primary-source]: # ()
:::', NULL, NULL, 'disp-quote', 'Atributos requeridos (MySQL): fuente

Plantilla JATS (MySQL, sin uso):
<disp-quote content-type="primary-source"><attrib>{{fuente}}</attrib>{{contenido}}</disp-quote>', 'El ejemplo escribe la clase sin llaves y después los atributos («::: clase {...}»): Pandoc no lo lee como div y sale como párrafo. La forma válida es «::: {.clase atributo="..."}».', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('gloss', 'gloss', 'Glosa', 'linea', 'disciplinar', 'filologia', 50, 'borrador', 'borrador', 'envolver', '[', ']{.gloss}', 'Explicación o comentario sobre una palabra o pasaje del texto.', '::: gloss {lema="fazaña"}
Hecho notable, hazaña. Del lat. *facianea.
:::', NULL, NULL, 'gloss', 'Atributos requeridos (MySQL): lema

Plantilla JATS (MySQL, sin uso):
<gloss><term>{{lema}}</term><def>{{contenido}}</def></gloss>', 'Es un shortcode en línea y el ejemplo está escrito como bloque («:::»). La forma en línea es «[texto]{.clase}».', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('interlinear', 'interlinear', 'Glosa interlineal', 'bloque', 'disciplinar', 'filologia', 60, 'borrador', 'borrador', 'envolver', '::: interlinear', ':::', 'Texto con glosa morfológica interlineal (formato Leipzig).', '::: interlinear {lengua="lat"}
Puer        libr-um      leg-it
niño.NOM    libro-AC     leer-3SG.PRES
''El niño lee el libro''

[/interlinear]: # ()
:::', NULL, NULL, 'disp-quote', 'Atributos requeridos (MySQL): lengua

Plantilla JATS (MySQL, sin uso):
<disp-quote content-type="interlinear-gloss" xml:lang="{{lengua}}">{{contenido}}</disp-quote>', 'El ejemplo escribe la clase sin llaves y después los atributos («::: clase {...}»): Pandoc no lo lee como div y sale como párrafo. La forma válida es «::: {.clase atributo="..."}».', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('siglum', 'siglum', 'Sigla', 'bloque', 'disciplinar', 'filologia', 70, 'borrador', 'borrador', 'plantilla', '::: siglum', ':::', 'Definición de sigla utilizada para un manuscrito o testimonio.', '::: siglum {codigo="A", nombre="BNE Ms. 1234"}

[/siglum]: # ()
:::', NULL, NULL, 'def-item', 'Atributos requeridos (MySQL): codigo,nombre

Plantilla JATS (MySQL, sin uso):
<def-item><term>{{codigo}}</term><def>{{nombre}}</def></def-item>', 'El ejemplo escribe la clase sin llaves y después los atributos («::: clase {...}»): Pandoc no lo lee como div y sale como párrafo. La forma válida es «::: {.clase atributo="..."}».', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('stemma', 'stemma', 'Stemma codicum', 'bloque', 'disciplinar', 'filologia', 80, 'borrador', 'borrador', 'envolver', '::: stemma', ':::', 'Representación del árbol genealógico de manuscritos.', '::: stemma
[Diagrama de relaciones entre manuscritos]

[/stemma]: # ()
:::', NULL, NULL, 'fig', 'Plantilla JATS (MySQL, sin uso):
<fig fig-type="stemma"><caption><title>Stemma codicum</title></caption><graphic/></fig>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('reconstructed', 'reconstructed', 'Texto reconstruido', 'linea', 'disciplinar', 'filologia', 90, 'borrador', 'borrador', 'envolver', '[', ']{.reconstructed}', 'Texto reconstruido o hipotético, marcado con asterisco convencional.', '::: reconstructed
*FACIANEA > fazaña
:::', NULL, NULL, 'styled-content', 'Plantilla JATS (MySQL, sin uso):
<styled-content specific-use="reconstructed">*{{contenido}}</styled-content>', 'Es un shortcode en línea y el ejemplo está escrito como bloque («:::»). La forma en línea es «[texto]{.clase}».', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('paleographic', 'paleographic', 'Transcripción paleográfica', 'bloque', 'disciplinar', 'filologia', 100, 'borrador', 'borrador', 'envolver', '::: paleographic', ':::', 'Transcripción de un manuscrito con convenciones paleográficas.', '::: paleographic {tipo="diplomática"}
en aq<ue>l t<iem>po moraua en toledo | vn cauall<er>o...

[/paleographic]: # ()
:::', NULL, NULL, 'disp-quote', 'Atributos requeridos (MySQL): tipo

Plantilla JATS (MySQL, sin uso):
<disp-quote content-type="paleographic" specific-use="{{tipo}}">{{contenido}}</disp-quote>', 'El ejemplo escribe la clase sin llaves y después los atributos («::: clase {...}»): Pandoc no lo lee como div y sale como párrafo. La forma válida es «::: {.clase atributo="..."}».', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('variant', 'variant', 'Variante textual', 'linea', 'disciplinar', 'filologia', 110, 'borrador', 'borrador', 'envolver', '[', ']{.variant}', 'Indica una variante de lectura entre diferentes testimonios.', '::: variant {testigos="A B"}
moraua
::: variant {testigos="C D"}
moraba
:::', NULL, NULL, 'app', 'Atributos requeridos (MySQL): testigos

Plantilla JATS (MySQL, sin uso):
<app><rdg wit="{{testigos}}">{{contenido}}</rdg></app>', 'Es un shortcode en línea y el ejemplo está escrito como bloque («:::»). La forma en línea es «[texto]{.clase}».', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('apparatus-physics', 'apparatus-physics', 'Aparato experimental', 'bloque', 'disciplinar', 'fisica', 10, 'no_aplica', 'borrador', 'envolver', '::: apparatus-physics', ':::', 'Descripción de equipamiento experimental.', '::: apparatus-physics
Espectrómetro Raman Horiba LabRAM HR Evolution.
Láser: 532 nm, potencia 5 mW.
Detector: CCD enfriado a -70°C.

[/apparatus-physics]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="apparatus">
  <title>Aparato Experimental</title>
  <p>{{contenido}}</p>
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('measurement', 'measurement', 'Medición', 'linea', 'disciplinar', 'fisica', 20, 'borrador', 'borrador', 'envolver', '[', ']{.measurement}', 'Medición experimental con valor, incertidumbre y unidad.', '::: measurement
Magnitud: velocidad
Valor: 299792458
Incertidumbre: 1.2
Unidad: m/s
:::', NULL, NULL, 'named-content', 'Atributos requeridos (MySQL): magnitud,valor,incertidumbre,unidad

Plantilla JATS (MySQL, sin uso):
<named-content content-type="measurement">
  <named-content content-type="quantity">{{magnitud}}</named-content> = 
  ({{valor}} ± {{incertidumbre}}) {{unidad}}
</named-content>', 'Es un shortcode en línea y el ejemplo está escrito como bloque («:::»). La forma en línea es «[texto]{.clase}».', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('axiom', 'axiom', 'Axioma', 'bloque', 'disciplinar', 'matematicas', 10, 'borrador', 'borrador', 'envolver', '::: axiom', ':::', 'Verdad evidente que se acepta sin demostración.', '::: axiom
Por dos puntos distintos pasa una única recta.

[/axiom]: # ()
:::', NULL, NULL, 'statement', 'Plantilla JATS (MySQL, sin uso):
<statement content-type="axiom"><label>Axioma</label><p>{{contenido}}</p></statement>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('corollary', 'corollary', 'Corolario', 'bloque', 'disciplinar', 'matematicas', 20, 'borrador', 'borrador', 'envolver', '::: corollary', ':::', 'Consecuencia directa de un teorema ya demostrado.', '::: corollary
Todo número primo mayor que 2 es impar.

[/corollary]: # ()
:::', NULL, NULL, 'statement', 'Plantilla JATS (MySQL, sin uso):
<statement content-type="corollary"><label>Corolario</label><p>{{contenido}}</p></statement>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('definition', 'definition', 'Definición', 'bloque', 'disciplinar', 'matematicas', 30, 'borrador', 'borrador', 'envolver', '::: definition', ':::', 'Definición formal de un concepto matemático.', '::: definition {nombre="Límite"}
Sea f una función definida en un intervalo abierto...

[/definition]: # ()
:::', NULL, NULL, 'statement', 'Plantilla JATS (MySQL, sin uso):
<statement content-type="definition"><label>Definición</label><title>{{titulo}}</title><p>{{contenido}}</p></statement>', 'El ejemplo escribe la clase sin llaves y después los atributos («::: clase {...}»): Pandoc no lo lee como div y sale como párrafo. La forma válida es «::: {.clase atributo="..."}».', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('proof', 'proof', 'Demostración', 'bloque', 'disciplinar', 'matematicas', 40, 'borrador', 'borrador', 'envolver', '::: proof', ':::', 'Demostración formal de un teorema o proposición.', '::: proof
Sea a, b, c los lados del triángulo...

[/proof]: # ()
:::', NULL, NULL, 'statement', 'Plantilla JATS (MySQL, sin uso):
<statement content-type="proof"><label>Demostración</label>{{contenido}}<p>∎</p></statement>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('numbered-equation', 'numbered-equation', 'Ecuación numerada', 'bloque', 'disciplinar', 'matematicas', 50, 'borrador', 'borrador', 'envolver', '::: numbered-equation', ':::', 'Ecuación matemática con número de referencia.', '::: numbered-equation {id="eq-euler"}
e^{iπ} + 1 = 0

[/numbered-equation]: # ()
:::', NULL, NULL, 'disp-formula', 'Atributos requeridos (MySQL): id

Plantilla JATS (MySQL, sin uso):
<disp-formula id="{{id}}"><label>({{numero}})</label><alternatives><tex-math>{{contenido}}</tex-math></alternatives></disp-formula>', 'El ejemplo escribe la clase sin llaves y después los atributos («::: clase {...}»): Pandoc no lo lee como div y sale como párrafo. La forma válida es «::: {.clase atributo="..."}».', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('math-example', 'math-example', 'Ejemplo matemático', 'bloque', 'disciplinar', 'matematicas', 60, 'borrador', 'borrador', 'envolver', '::: math-example', ':::', 'Ejemplo que ilustra la aplicación de un concepto o teorema.', '::: math-example
Calcular el límite de f(x) = (x²-1)/(x-1) cuando x→1...

[/math-example]: # ()
:::', NULL, NULL, 'boxed-text', 'Plantilla JATS (MySQL, sin uso):
<boxed-text content-type="example"><label>Ejemplo</label>{{contenido}}</boxed-text>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('disp-formula', 'formula', 'Fórmula matemática', 'bloque', 'disciplinar', 'matematicas', 70, 'borrador', 'borrador', 'envolver', '::: {.formula #eq-id}', ':::', 'Ecuación o fórmula matemática destacada en línea aparte.', '::: {.formula #eq-einstein}
$$E = mc^2$$

[/formula]: # ()
:::', NULL, NULL, 'disp-formula', 'Atributos requeridos (MySQL): id

Plantilla JATS (MySQL, sin uso):
<disp-formula id="{{id}}">
  <tex-math>{{contenido}}</tex-math>
</disp-formula>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('lemma', 'lemma', 'Lema', 'bloque', 'disciplinar', 'matematicas', 80, 'borrador', 'borrador', 'envolver', '::: lemma', ':::', 'Proposición auxiliar utilizada para demostrar un teorema.', '::: lemma
Si n es par, entonces n² es par.

[/lemma]: # ()
:::', NULL, NULL, 'statement', 'Plantilla JATS (MySQL, sin uso):
<statement content-type="lemma"><label>Lema</label><title>{{titulo}}</title><p>{{contenido}}</p></statement>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('notation', 'notation', 'Notación', 'bloque', 'disciplinar', 'matematicas', 90, 'borrador', 'borrador', 'envolver', '::: notation', ':::', 'Definición de notación o símbolos utilizados.', '::: notation
- ∀: para todo
- ∃: existe
- ∈: pertenece a

[/notation]: # ()
:::', NULL, NULL, 'def-list', 'Plantilla JATS (MySQL, sin uso):
<def-list list-type="notation"><title>Notación</title>{{contenido}}</def-list>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('problem', 'problem', 'Problema', 'bloque', 'disciplinar', 'matematicas', 100, 'borrador', 'borrador', 'envolver', '::: problem', ':::', 'Enunciado de un problema matemático o físico.', '::: problem
Un proyectil se lanza con velocidad inicial v₀...

[/problem]: # ()
:::', NULL, NULL, 'boxed-text', 'Plantilla JATS (MySQL, sin uso):
<boxed-text content-type="problem"><label>Problema</label>{{contenido}}</boxed-text>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('proposition', 'proposition', 'Proposición', 'bloque', 'disciplinar', 'matematicas', 110, 'borrador', 'borrador', 'envolver', '::: proposition', ':::', 'Afirmación matemática que requiere demostración.', '::: proposition
La suma de los ángulos internos de un triángulo es 180°.

[/proposition]: # ()
:::', NULL, NULL, 'statement', 'Plantilla JATS (MySQL, sin uso):
<statement content-type="proposition"><label>Proposición</label><p>{{contenido}}</p></statement>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('solution', 'solution', 'Solución', 'bloque', 'disciplinar', 'matematicas', 120, 'borrador', 'borrador', 'envolver', '::: solution', ':::', 'Desarrollo de la solución de un problema.', '::: solution
Aplicando las ecuaciones de movimiento...

[/solution]: # ()
:::', NULL, NULL, 'boxed-text', 'Plantilla JATS (MySQL, sin uso):
<boxed-text content-type="solution"><label>Solución</label>{{contenido}}</boxed-text>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('theorem', 'theorem', 'Teorema', 'bloque', 'disciplinar', 'matematicas', 130, 'borrador', 'borrador', 'envolver', '::: theorem', ':::', 'Enunciado de un teorema matemático con nombre opcional.', '::: theorem {nombre="Pitágoras"}
En un triángulo rectángulo, el cuadrado de la hipotenusa...

[/theorem]: # ()
:::', NULL, NULL, 'statement', 'Plantilla JATS (MySQL, sin uso):
<statement content-type="theorem"><label>Teorema</label><title>{{titulo}}</title><p>{{contenido}}</p></statement>', 'El ejemplo escribe la clase sin llaves y después los atributos («::: clase {...}»): Pandoc no lo lee como div y sale como párrafo. La forma válida es «::: {.clase atributo="..."}».', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('ethics-approval', 'ethics-approval', 'Aprobación ética', 'bloque', 'disciplinar', 'medicina', 10, 'no_aplica', 'borrador', 'envolver', '::: ethics-approval', ':::', 'Información de aprobación por comité de ética.', '::: ethics-approval
Estudio aprobado por Comité de Ética del Hospital Italiano
(CEPI #2024-1234) en conformidad con Declaración de Helsinki.

[/ethics-approval]: # ()
:::', NULL, NULL, 'boxed-text', 'Plantilla JATS (MySQL, sin uso):
<boxed-text content-type="ethics">
  <p>{{contenido}}</p>
</boxed-text>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('patient-data', 'patient-data', 'Datos de paciente', 'bloque', 'disciplinar', 'medicina', 20, 'no_aplica', 'borrador', 'envolver', '::: patient-data', ':::', 'Características demográficas del paciente (edad, sexo).', '::: patient-data
Edad: 45
Sexo: masculino

[/patient-data]: # ()
:::', NULL, NULL, 'patient-data', 'Atributos requeridos (MySQL): edad,sexo

Plantilla JATS (MySQL, sin uso):
<patient-data>
  <age units="years">{{edad}}</age>
  <sex>{{sexo}}</sex>
</patient-data>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('consent-statement', 'consent-statement', 'Declaración de consentimiento', 'bloque', 'disciplinar', 'medicina', 30, 'no_aplica', 'borrador', 'envolver', '::: consent-statement', ':::', 'Declaración de consentimiento informado de pacientes.', '::: consent-statement
Todos los pacientes firmaron consentimiento informado aprobado
por el Comité de Ética institucional (protocolo #2024-045).

[/consent-statement]: # ()
:::', NULL, NULL, 'boxed-text', 'Plantilla JATS (MySQL, sin uso):
<boxed-text content-type="consent">
  <p>{{contenido}}</p>
</boxed-text>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('diagnosis', 'diagnosis', 'Diagnóstico', 'linea', 'disciplinar', 'medicina', 40, 'no_aplica', 'borrador', 'envolver', '[', ']{.diagnosis}', 'Diagnóstico médico con código ICD si está disponible.', '::: diagnosis
Hipertensión arterial esencial (ICD-10: I10)
:::', NULL, NULL, 'named-content', 'Plantilla JATS (MySQL, sin uso):
<named-content content-type="diagnosis">{{contenido}}</named-content>', 'Es un shortcode en línea y el ejemplo está escrito como bloque («:::»). La forma en línea es «[texto]{.clase}».', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('dosage', 'dosage', 'Dosis farmacológica', 'bloque', 'disciplinar', 'medicina', 50, 'no_aplica', 'borrador', 'envolver', '::: dosage', ':::', 'Indicación de dosis con fármaco, cantidad, unidad y frecuencia.', '::: dosage
Fármaco: enalapril
Cantidad: 10
Unidad: mg
Frecuencia: diaria

[/dosage]: # ()
:::', NULL, NULL, 'dosage', 'Atributos requeridos (MySQL): farmaco,cantidad,unidad,frecuencia

Plantilla JATS (MySQL, sin uso):
<dosage>
  <drug>{{farmaco}}</drug>
  <value>{{cantidad}}</value>
  <unit>{{unidad}}</unit>
  <frequency>{{frecuencia}}</frequency>
</dosage>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('clinical-trial', 'clinical-trial', 'Ensayo clínico', 'bloque', 'disciplinar', 'medicina', 60, 'no_aplica', 'borrador', 'envolver', '::: clinical-trial', ':::', 'Información de registro de ensayo clínico.', '::: clinical-trial
Registro: ClinicalTrials.gov
Número: NCT01234567

[/clinical-trial]: # ()
:::', NULL, NULL, 'clinical-trial', 'Atributos requeridos (MySQL): registro,numero

Extrae "Registro:" y "Número:" del contenido.
Compatible con ClinicalTrials.gov, ISRCTN, EudraCT.
Requiere función Lua custom para parsear texto en español.

Plantilla JATS (MySQL, sin uso):
<clinical-trial>
  <registry>{{registro}}</registry>
  <trial-id>{{numero}}</trial-id>
</clinical-trial>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('adverse-event', 'adverse-event', 'Evento adverso', 'bloque', 'disciplinar', 'medicina', 70, 'no_aplica', 'borrador', 'envolver', '::: adverse-event', ':::', 'Reporte de evento adverso durante tratamiento.', '::: adverse-event
Paciente presentó rash cutáneo leve a las 48h de iniciado tratamiento.
Se suspendió medicación y síntomas remitieron en 72h.

[/adverse-event]: # ()
:::', NULL, NULL, 'boxed-text', 'Plantilla JATS (MySQL, sin uso):
<boxed-text content-type="adverse-event">
  <title>Evento Adverso</title>
  <p>{{contenido}}</p>
</boxed-text>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('surgical-procedure', 'surgical-procedure', 'Procedimiento quirúrgico', 'bloque', 'disciplinar', 'medicina', 80, 'no_aplica', 'borrador', 'envolver', '::: surgical-procedure', ':::', 'Descripción de procedimiento quirúrgico realizado.', '::: surgical-procedure
Se realizó apendicectomía laparoscópica bajo anestesia general.
Tiempo quirúrgico: 45 minutos. Sin complicaciones.

[/surgical-procedure]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="surgical-procedure">
  <title>Procedimiento Quirúrgico</title>
  <p>{{contenido}}</p>
</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('lab-result', 'lab-result', 'Resultado de laboratorio', 'bloque', 'disciplinar', 'medicina', 90, 'no_aplica', 'borrador', 'envolver', '::: lab-result', ':::', 'Resultado de análisis de laboratorio con valor, unidad y rango normal.', '::: lab-result
Test: Glucosa
Valor: 110
Unidad: mg/dL
Rango: 70-100

[/lab-result]: # ()
:::', NULL, NULL, 'lab-result', 'Atributos requeridos (MySQL): test,valor,unidad,rango

Plantilla JATS (MySQL, sin uso):
<lab-result>
  <test-name>{{test}}</test-name>
  <test-value>{{valor}}</test-value>
  <test-unit>{{unidad}}</test-unit>
  <normal-range>{{rango}}</normal-range>
</lab-result>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('crystal-data', 'crystal-data', 'Datos cristalográficos', 'bloque', 'disciplinar', 'quimica', 10, 'no_aplica', 'borrador', 'envolver', '::: crystal-data', ':::', 'Datos de estructura cristalina obtenidos por difracción de rayos X.', '::: crystal-data
Sistema cristalino: monoclínico
Grupo espacial: P2₁/c

[/crystal-data]: # ()
:::', NULL, NULL, 'supplementary-material', 'Plantilla JATS (MySQL, sin uso):
<supplementary-material content-type="crystal-data">{{contenido}}</supplementary-material>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('spectral-data', 'spectral-data', 'Datos espectroscópicos', 'bloque', 'disciplinar', 'quimica', 20, 'no_aplica', 'borrador', 'envolver', '::: spectral-data', ':::', 'Datos de caracterización espectroscópica: RMN, IR, MS, UV-Vis.', '::: spectral-data {tipo="RMN-1H"}
¹H NMR (400 MHz, CDCl₃): δ 7.26 (s, 1H)...

[/spectral-data]: # ()
:::', NULL, NULL, 'supplementary-material', 'Atributos requeridos (MySQL): tipo

Plantilla JATS (MySQL, sin uso):
<supplementary-material content-type="spectral-data" specific-use="{{tipo}}">{{contenido}}</supplementary-material>', 'El ejemplo escribe la clase sin llaves y después los atributos («::: clase {...}»): Pandoc no lo lee como div y sale como párrafo. La forma válida es «::: {.clase atributo="..."}».', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('chem-equation', 'chem-equation', 'Ecuación química', 'bloque', 'disciplinar', 'quimica', 30, 'borrador', 'borrador', 'envolver', '::: chem-equation', ':::', 'Ecuación química balanceada con reactivos y productos. Permite notación estándar con flechas de reacción.', '::: chem-equation
2H₂ + O₂ → 2H₂O

[/chem-equation]: # ()
:::', NULL, NULL, 'disp-formula', 'Plantilla JATS (MySQL, sin uso):
<disp-formula content-type="chem-equation"><alternatives><tex-math>{{contenido}}</tex-math></alternatives></disp-formula>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('reaction-scheme', 'reaction-scheme', 'Esquema de reacción', 'bloque', 'disciplinar', 'quimica', 40, 'borrador', 'borrador', 'envolver', '::: reaction-scheme', ':::', 'Esquema de reacción química con múltiples pasos, intermediarios y condiciones.', '::: reaction-scheme
[Esquema con pasos de síntesis]

[/reaction-scheme]: # ()
:::', NULL, NULL, 'fig', 'Plantilla JATS (MySQL, sin uso):
<fig fig-type="reaction-scheme"><caption><title>{{titulo}}</title></caption><graphic/></fig>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('synthesis-scheme', 'synthesis-scheme', 'Esquema de síntesis', 'bloque', 'disciplinar', 'quimica', 50, 'borrador', 'borrador', 'envolver', '::: {.synthesis-scheme #scheme-id}', ':::', 'Representación de ruta sintética con reactivos y condiciones.', '::: {.synthesis-scheme #sch-01}
![Síntesis de compuesto 3](esquema-01.png)
Reactivos: (i) NaBH₄, MeOH, 0°C; (ii) TsCl, piridina, TA

[/synthesis-scheme]: # ()
:::', NULL, NULL, 'fig', 'Plantilla JATS (MySQL, sin uso):
<fig id="{{id}}" fig-type="scheme">
  <label>Esquema {{numero}}</label>
  <caption><p>{{contenido}}</p></caption>
  <graphic xlink:href="{{archivo}}"/>
</fig>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('chem-struct', 'chem-struct', 'Estructura química', 'linea', 'disciplinar', 'quimica', 60, 'borrador', 'borrador', 'envolver', '[', ']{.chem-struct}', 'Fórmula o estructura química representada en formato estándar.', '::: chem-struct
H₂SO₄
:::', NULL, NULL, 'chem-struct', 'Plantilla JATS (MySQL, sin uso):
<chem-struct>
  {{contenido}}
</chem-struct>', 'Es un shortcode en línea y el ejemplo está escrito como bloque («:::»). La forma en línea es «[texto]{.clase}».', datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('reaction-mechanism', 'reaction-mechanism', 'Mecanismo de reacción', 'bloque', 'disciplinar', 'quimica', 70, 'borrador', 'borrador', 'envolver', '::: reaction-mechanism', ':::', 'Descripción paso a paso del mecanismo de una reacción química.', '::: reaction-mechanism
Paso 1: Ataque nucleofílico...
Paso 2: Eliminación...

[/reaction-mechanism]: # ()
:::', NULL, NULL, 'boxed-text', 'Plantilla JATS (MySQL, sin uso):
<boxed-text content-type="reaction-mechanism"><caption><title>Mecanismo</title></caption>{{contenido}}</boxed-text>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('spectral-mention', 'spectral-mention', 'Mención espectroscópica', 'linea', 'disciplinar', 'quimica', 80, 'no_aplica', 'borrador', 'envolver', '[', ']{.spectral-mention}', 'Mención breve de dato espectroscópico dentro del flujo de un párrafo. Para datos completos usar spectral-data.', 'La señal a [δ 7.26 (s, 1H)]{.spectral-mention} confirma la presencia del aromático.', NULL, NULL, 'named-content', 'Variante inline de spectral-data. Usar cuando se cita un valor puntual dentro de un párrafo, no para listados completos de caracterización.

Plantilla JATS (MySQL, sin uso):
<named-content content-type="spectral-data">{{contenido}}</named-content>', NULL, datetime('now','localtime'), datetime('now','localtime'));
INSERT INTO shortcodes (nombre, clase, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, ejemplo, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, fecha_modificacion) VALUES ('experimental-procedure', 'experimental-procedure', 'Procedimiento experimental', 'bloque', 'disciplinar', 'quimica', 90, 'borrador', 'borrador', 'envolver', '::: experimental-procedure', ':::', 'Descripción detallada de un procedimiento de síntesis o análisis.', '::: experimental-procedure
En un matraz de 250 mL se añadieron...

[/experimental-procedure]: # ()
:::', NULL, NULL, 'sec', 'Plantilla JATS (MySQL, sin uso):
<sec sec-type="experimental-procedure"><title>Procedimiento</title>{{contenido}}</sec>', NULL, datetime('now','localtime'), datetime('now','localtime'));

-- LAS 77 FILAS, Y LA FIGURA LIBERADA EN LOS DOS
INSERT INTO _verif SELECT 'filas cargadas', COUNT(*) = 77 FROM shortcodes;
INSERT INTO _verif SELECT 'liberados', COUNT(*) = 1 FROM shortcodes
  WHERE estado_libro = 'liberado' OR estado_revista = 'liberado';
INSERT INTO _verif SELECT 'figura liberada', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'figure' AND estado_libro = 'liberado' AND estado_revista = 'liberado';

DROP TABLE _verif;

COMMIT;

SELECT grupo, COUNT(*) AS cantidad FROM shortcodes GROUP BY grupo ORDER BY grupo;
