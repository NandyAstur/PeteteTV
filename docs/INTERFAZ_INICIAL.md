# Petete TV — Interfaz inicial

## 1. Pantalla de bienvenida

Se reutilizará el concepto visual habitual de SuperPetete como elemento de continuidad de marca, pero con identidad específica para Petete TV.

Requisitos:

- SuperPetete como protagonista visual.
- Nombre `PETETE TV` claramente visible.
- Logo específico de Petete TV, diferente al de Petete Radio.
- Fondo limpio y coherente con la familia visual Petete.
- Transición breve hacia la interfaz principal.
- No bloquear el inicio más tiempo del necesario.

El activo gráfico definitivo se incorporará cuando se apruebe el logo oficial de Petete TV.

## 2. Pantalla principal — estructura base

La primera pantalla de trabajo se divide en dos columnas principales.

```text
┌──────────────────────────────────────────────────────────────────────────────┐
│ PETETE TV                                                     [⚙] [—] [□] [X] │
├───────────────────────┬──────────────────────────────────────────────────────┤
│ CANALES ENCONTRADOS   │                                                      │
│                       │                 PANTALLA 16:9                         │
│ [logo] Canal 1        │                                                      │
│ [logo] Canal 2        │                                                      │
│ [logo] Canal 3        │                                                      │
│ [logo] Canal 4        │                                                      │
│ [logo] Canal 5        │                                                      │
│                       ├──────────────────────────────────────────────────────┤
│                       │  ▶   ⏸   ■      ─────────●──────    🔊   ⛶          │
│                       │  Canal / programa actual · estado · calidad         │
└───────────────────────┴──────────────────────────────────────────────────────┘
```

### Columna izquierda — canales

Debe mostrar los canales detectados/configurados con una presentación compacta y clara.

Cada elemento debe estar preparado para incluir:

- logotipo;
- nombre del canal;
- estado: disponible, cargando, caído o desconocido;
- indicador de emisión/documental cuando exista información EPG;
- favorito;
- selección activa;
- menú contextual futuro.

La lista debe admitir desplazamiento vertical y búsqueda/filtrado posteriormente.

### Zona derecha — pantalla de vídeo

- Relación fija 16:9.
- Escalado manteniendo proporción.
- Fondo negro cuando no hay señal.
- Estado de carga visible pero discreto.
- Mensajes diferenciados para `Sin canal seleccionado`, `Cargando`, `Reconectando`, `No disponible` y errores reproducibles.
- Doble clic futuro para pantalla completa.

### Reproductor inferior

Debajo de la pantalla 16:9 habrá una franja compacta para el reproductor.

Primera propuesta de controles:

- reproducir/pausar;
- detener;
- reconectar/recargar señal;
- volumen y silencio;
- pantalla completa;
- nombre del canal seleccionado;
- programa/contenido actual cuando pueda determinarse;
- estado de la conexión;
- resolución/calidad cuando sea detectable.

Para emisiones en directo no debe mostrarse una barra temporal falsa. La barra de progreso solo aparecerá cuando el medio permita desplazamiento temporal, replay o vídeo bajo demanda.

## 3. Principios de diseño

- Apariencia reconocible como miembro de la familia Petete, sin copiar literalmente Petete Radio.
- Prioridad al contenido y a la visualización.
- Controles grandes y claros, evitando sobrecargar la pantalla.
- Preparación para distintos tamaños de ventana.
- La lista de canales y el reproductor deben poder evolucionar sin rehacer la estructura general.
- Separar interfaz, catálogo de canales, fuentes y motor de reproducción desde el inicio.

## 4. Próximos activos necesarios

1. Logo oficial Petete TV con transparencia real.
2. Variante de SuperPetete para la bienvenida de Petete TV.
3. Iconos definitivos del reproductor.
4. Paleta y acabado visual definitivo.

## 5. Próxima fase técnica

Una vez aprobado el diseño visual:

1. elegir stack de escritorio;
2. crear shell de ventana;
3. implementar layout responsive;
4. cargar datos ficticios de canales;
5. integrar reproductor real;
6. añadir modelo de fuentes y catálogo;
7. incorporar EPG y descubrimiento de documentales.
