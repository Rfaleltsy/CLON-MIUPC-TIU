# CLON MIUPC - TIU Virtual

Aplicación desarrollada en Flutter que replica fielmente la interfaz de la TIU (Tarjeta de Identificación Universitaria) Virtual de la UPC (Universidad Peruana de Ciencias Aplicadas). 

## 🚀 Funcionalidades Principales

*   **Configuración Dinámica:** Pantalla inicial para ingresar datos personalizados como nombres, apellidos, código de alumno, ID Banner, carrera y campus.
*   **Encuadre de Foto Nativo:** Un sistema de selección de fotos con un visor interactivo (`InteractiveViewer`) 100% nativo que permite hacer zoom y arrastrar la foto para un encuadre circular perfecto (sin usar librerías externas complejas). Incluye opción para remover la foto.
*   **Privacidad Automática:** El sistema detecta los apellidos y, para replicar la seguridad real, oculta el resto de los caracteres con asteriscos (ej. `T***`). Los nombres se convierten automáticamente a mayúsculas.
*   **Reloj en Tiempo Real:** Reloj digital en vivo con contador de segundos, estilizado con la fuente exacta y el espaciado idéntico al original.
*   **Fecha Dinámica:** Fecha actualizada automáticamente en español, con la primera letra del día y mes en mayúsculas, justo debajo del reloj.
*   **Diseño Pixel-Perfect:** 
    *   Fondo de nubes personalizado.
    *   Fuentes exactas incrustadas (`SolanoGothicMVB`, `Godfrey`, `Nimbus Sans`).
    *   Distribución compacta de datos secundarios (Código, Banner, Carrera) idéntica a la aplicación oficial.
    *   Sombreados y superposiciones precisas.

## 💻 Tecnologías Usadas
*   Flutter & Dart
*   Manipulación de capas e imágenes nativas (`RepaintBoundary`, `dart:ui`).

---

<div align="center">
  <p style="color: grey; font-size: 14px; opacity: 0.6;">
    © Desarrollado por <b>Rafael Tasayco</b>
  </p>
</div>
