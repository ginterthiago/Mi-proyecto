from config import ConnectionConfig
from conections import Connection


def main():
    config = ConnectionConfig()

    conexion = Connection(config)

    conexion.conectar()


if __name__ == "__main__":
    main()
