# 🏦 Simple Homebanking Console

> Un simulador de homebanking por consola desarrollado en Dart, diseñado como proyecto de aprendizaje para dominar el Paradigma de Programación Orientada a Objetos (POO).

![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![POO](https://img.shields.io/badge/Paradigma-Orientado_a_Objetos-232F3E?style=for-the-badge)

## 📖 Sobre el Proyecto

**Simple Homebanking Console** es una aplicación de terminal que simula las operaciones básicas de un sistema bancario. El objetivo principal de este repositorio no es crear un sistema de producción, sino servir como un entorno de práctica para estructurar código limpio, modular y basado en objetos utilizando **Dart**.

Es ideal para estudiantes y desarrolladores que busquen analizar ejemplos prácticos de cómo interactúan las clases, objetos, encapsulamiento y otros principios fundamentales del desarrollo de software.

## ✨ Características Principales

* **Arquitectura Orientada a Objetos:** Implementación clara de clases, métodos y atributos.
* **Manejo de Archivos:** Integración con un controlador de archivos (mediante `vendor/file_controller`) para la lectura y persistencia de datos.
* **Simulación Bancaria:** * Consulta de saldos.
  * Gestión de depósitos y extracciones.
  * Autenticación y gestión simulada de usuarios.
* **Entorno Configurable:** Uso de variables de entorno (carpeta `env`) para separar la configuración de la lógica de negocio.

## 🛠️ Tecnologías y Herramientas

* **Lenguaje Principal:** [Dart](https://dart.dev/)
* **Estructura del Código:** Diseño modular dividido en librerías (`/libraries`), base de datos simulada (`/db`) y controladores (`/vendor`).

## 📁 Estructura del Proyecto

```text
simple-homebanking-console/
├── .vscode/               # Configuraciones del editor de código
├── db/                    # Archivos de la base de datos simulada
├── docs/                  # Documentación del proyecto
├── env/                   # Variables de entorno y configuraciones generales
├── libraries/             # Lógica de negocio y clases principales
├── vendor/                # Dependencias de terceros o módulos externos
│   └── file_controller/   # Controlador específico para el manejo de archivos
├── main.dart              # Punto de entrada de la aplicación
└── prueba.txt             # Archivo de pruebas de lectura/escritura
```

## 🚀 Instalación y Ejecución

Para clonar y ejecutar este proyecto en un entorno local, es necesario contar con el [SDK de Dart instalado](https://dart.dev/get-dart). 

**1. Clonar el repositorio:**
```bash
git clone [https://github.com/macs100/simple-homebanking-console.git](https://github.com/macs100/simple-homebanking-console.git)
```

**2. Acceder al directorio del proyecto:**
```bash
cd simple-homebanking-console
```

**3. Ejecutar la aplicación:**
```bash
dart run main.dart
```

## 🧠 Conceptos de POO Aplicados

Durante el desarrollo de la aplicación se han implementado los siguientes fundamentos:
- **Abstracción:** Creación de modelos de datos que representan entidades bancarias reales (cuentas, usuarios, etc.).
- **Encapsulamiento:** Protección de datos sensibles mediante el uso de modificadores de acceso.
- **Modularidad:** Separación de responsabilidades distribuidas a lo largo de las carpetas `libraries`, `db` y `vendor`.

## 🤝 Contribuciones

Al ser un proyecto con fines educativos, cualquier sugerencia, consejo o Pull Request que ayude a mejorar la estructura del código o a sumar nuevas funcionalidades orientadas a objetos es bienvenido.

1. Realizar un Fork del repositorio.
2. Crear una rama para la nueva característica (`git checkout -b feature/NuevaCaracteristica`).
3. Confirmar los cambios (`git commit -m 'Agrega nueva característica'`).
4. Subir la rama (`git push origin feature/NuevaCaracteristica`).
5. Abrir un Pull Request.

---
*Desarrollado por [macs100](https://github.com/macs100).*
