
# MiProyecto

Proyecto realizado para trabajar con un gestor de paquetes, dependencias, pruebas automatizadas y GitHub Actions.

## Tecnologías utilizadas

* **Lenguaje:** Python
* **Gestor de paquetes:** PIP
* **Control de versiones:** Git
* **Repositorio:** GitHub
* **Integración continua:** GitHub Actions

## Dependencias

El proyecto utiliza las siguientes librerías:

* **python-dotenv:** permite cargar variables de entorno desde un archivo `.env`.
* **pytest:** permite crear y ejecutar pruebas automatizadas.

Las dependencias se encuentran en el archivo:

```text
MiProyecto/requirements.txt
```

Contenido:

```text
python-dotenv
pytest
```

## Instalación

Para instalar las dependencias del proyecto se utiliza PIP:

```bash
pip install -r requirements.txt
```

Si se está ubicado en la carpeta raíz del repositorio:

```bash
pip install -r MiProyecto/requirements.txt
```

## Configuración

El proyecto utiliza variables de entorno para almacenar los datos necesarios para la conexión a la base de datos.

El archivo `.env` contiene variables como:

```text
DB_NAME
DB_HOST
DB_PORT
DB_USER
DB_PASSWORD
DB_DATABASE
```

El archivo `.env` no se sube al repositorio porque contiene información sensible.

Para indicar qué variables necesita el proyecto se puede utilizar un archivo `.env.example` sin credenciales reales.

## Ejecución

Para ejecutar el proyecto:

```bash
python MiProyecto/Python/main.py
```

También se puede ingresar a la carpeta del proyecto:

```bash
cd MiProyecto
python Python/main.py
```

## Pruebas automatizadas

Las pruebas fueron realizadas utilizando **pytest**.

Para ejecutar las pruebas desde la carpeta `MiProyecto`:

```bash
python -m pytest
```

También se pueden ejecutar desde la raíz del repositorio:

```bash
python -m pytest MiProyecto/tests
```

Actualmente el proyecto cuenta con una prueba que verifica que las variables de configuración sean cargadas correctamente desde el archivo `.env`.

## GitHub Actions

El proyecto utiliza GitHub Actions para ejecutar automáticamente las pruebas cada vez que se realiza un `push`.

El workflow se encuentra en:

```text
.github/workflows/tests.yml
```

El proceso realizado por GitHub Actions es:

1. Descargar el código del repositorio.
2. Configurar Python.
3. Instalar las dependencias utilizando `requirements.txt`.
4. Crear un archivo `.env` temporal para el entorno de pruebas.
5. Ejecutar las pruebas utilizando pytest.
6. Informar si las pruebas fueron exitosas o si ocurrió algún error.

Si todas las pruebas pasan, GitHub Actions finaliza correctamente.

Si alguna prueba falla, la ejecución se marca como fallida.

## Estructura del proyecto

```text
Practicas/
│
├── .github/
│   └── workflows/
│       └── tests.yml
│
├── MiProyecto/
    ├── Python/
    │   ├── __init__.py
    │   ├── config.py
    │   ├── conections.py
    │   └── main.py
    │
    ├── tests/
    │   └── test_config.py
    │
    ├── requirements.txt
    └── .env
```

> El archivo `.env` se encuentra excluido del repositorio mediante `.gitignore` y no contiene información que deba publicarse.

## Resultado

El proyecto cuenta con pruebas automatizadas ejecutadas localmente y mediante GitHub Actions.

La ejecución final de GitHub Actions finaliza correctamente cuando las pruebas pasan.
