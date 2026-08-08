# Petete TV

Petete TV es un proyecto independiente de **Petete & Geppetto Labs** orientado inicialmente a descubrir, organizar y reproducir documentales y contenidos audiovisuales de interés desde fuentes compatibles.

## Objetivo inicial

La primera versión se centrará en una experiencia sencilla de televisión y descubrimiento de contenido:

- Pantalla de bienvenida basada en SuperPetete, adaptada a Petete TV.
- Lista de canales encontrados en una columna lateral izquierda.
- Área principal de visualización en formato 16:9.
- Controles de reproducción bajo la pantalla.
- Base preparada para EPG, búsqueda, favoritos, fuentes y clasificación de contenidos.

## Ruta local oficial

La copia local principal del proyecto en Windows será:

`T:\AT WORK\SCRIPTS\PeteteTV`

El repositorio GitHub `NandyAstur/PeteteTV` y esta carpeta local deben mantenerse sincronizados mediante herramientas propias del proyecto.

## Estrategia de plataformas

El desarrollo se realizará en dos etapas claramente separadas:

1. **PC / Windows primero**: diseño, arquitectura, reproductor, fuentes, catálogo, interfaz, estabilidad, instalador, actualización y herramientas de diagnóstico.
2. **Android después**: cuando la versión PC esté suficientemente pulida y estable, se creará la versión Android reutilizando todo lo que sea razonablemente compartible.

La arquitectura de PC debe prepararse desde el principio para no bloquear la futura versión Android. Se separarán especialmente:

- modelos de datos;
- catálogo de canales y contenidos;
- definición y validación de fuentes;
- EPG y metadatos;
- preferencias y favoritos;
- lógica de búsqueda y clasificación;
- contratos del reproductor;
- servicios de red y diagnóstico;
- interfaz específica de cada plataforma.

No se debe acoplar lógica de negocio a controles exclusivos de Windows cuando pueda mantenerse en componentes reutilizables.

## Flujo de desarrollo

Petete TV seguirá el mismo principio operativo que Petete Radio: repositorio como fuente de trabajo, copia local sincronizable y herramientas de un clic para las tareas frecuentes.

Cuando exista código suficiente se incorporarán utilidades equivalentes a:

- `ACTUALIZAR_LOCAL.bat`: actualizar la copia local desde `main` con comprobaciones y mensajes claros.
- `PETETE_TV_ACTUALIZAR_GITHUB_A_LOCAL.bat`: herramienta explícita de sincronización GitHub → carpeta local.
- `PROBAR_APP.bat`: restaurar/compilar/ejecutar una candidata de prueba y conservar logs.
- `CREAR_EXE_E_INSTALADOR_Y_PUBLICAR_SI_CORRECTO.bat`: compilación Release, creación del EXE, instalador y flujo de publicación controlada.
- `PETETE_TV_INSTALADOR.iss`: instalador Windows con Inno Setup cuando la aplicación llegue a esa fase.

Estas herramientas no deben crearse como simples envoltorios frágiles: deberán comprobar dependencias, rutas, estado Git, errores de compilación y generar logs persistentes.

## Estado

Proyecto recién iniciado. La primera fase consiste en definir identidad visual, arquitectura y pantalla principal antes de implementar motores de búsqueda, fuentes y reproducción real.

## Documentación

- `docs/INTERFAZ_INICIAL.md`: definición de la pantalla de bienvenida y primera interfaz principal.
- `docs/FLUJO_DESARROLLO_Y_MULTIPLATAFORMA.md`: reglas de desarrollo PC, sincronización local y preparación de Android.

## Repositorio

Este repositorio es privado durante la fase inicial de desarrollo.
