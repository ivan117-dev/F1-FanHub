# 🏎️ F1 FanHub

**F1 FanHub** es una aplicación móvil moderna para el seguimiento de la temporada de Fórmula 1, desarrollada con **Flutter** y enfocada en las mejores prácticas de ingeniería de software para ofrecer una experiencia de usuario fluida y profesional.

La aplicación ofrece datos actualizados de carreras, clasificaciones y estadísticas detalladas, todo bajo una arquitectura robusta, escalable y con soporte offline.

## ✨ Características Principales

* **📅 Calendario de Temporada:** Visualización de próximas carreras y resultados históricos de las anteriores.
* **📊 Tablas de Posiciones:** Standings de Pilotos y Constructores actualizados en tiempo real.
* **📈 Análisis de Rendimiento:** Gráficos interactivos (`fl_chart`) que muestran la progresión de posición de cada piloto durante la temporada.
* **⏱️ Resultados Detallados:** Tiempos de Carrera, Sprint, Clasificación (Q1, Q2, Q3) y análisis de Pit Stops.
* **💾 Soporte Offline:** Sistema de caché local inteligente para consultar resultados sin conexión a internet.
* **🌙 Dark Mode:** Soporte nativo para temas Claro y Oscuro con cambio dinámico.
* **🇪🇸 Localización:** Traducción automática de nombres de circuitos, nacionalidades y estados de carrera al español.

## 🛠️ Stack Tecnológico y Arquitectura

Este proyecto sigue estrictamente los principios de **Clean Architecture**, separando el código en capas para facilitar el mantenimiento y testeo:

* **Presentación (MVVM):** Gestión de estado reactiva.
* **Dominio:** Entidades y Casos de Uso (Reglas de negocio puras).
* **Data:** Repositorios, Modelos y Data Sources (Remotos y Locales).

### Librerías Principales:

| Paquete | Versión | Propósito |
| :--- | :--- | :--- |
| **provider** | `^6.1.5+1` | Gestión de estado (MVVM). |
| **get_it** | `^9.1.1` | Inyección de dependencias (Service Locator). |
| **dio** | `^5.9.0` | Cliente HTTP avanzado para consumo de API. |
| **fl_chart** | `^1.1.1` | Gráficos estadísticos interactivos y animados. |
| **shared_preferences** | `^2.5.3` | Persistencia de datos local (Caché). |
| **intl** | `^0.20.2` | Formateo de fechas y localización. |
| **url_launcher** | `^6.3.2` | Navegación a enlaces externos. |

## 🔌 API

Los datos son obtenidos gracias a la API open-source de [Jolpica-F1](https://github.com/jolpica/jolpica-f1), sucesora y compatible con la Ergast Developer API.
