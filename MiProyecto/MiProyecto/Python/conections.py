class Connection:
    def __init__(self, config):
        self.config = config

    def conectar(self):
        print("Intentando conectar a la base de datos...")
        print(f"Host: {self.config.host}")
        print(f"Puerto: {self.config.puerto}")
        print(f"Usuario: {self.config.usuario}")
        print(f"Base de datos: {self.config.base_de_datos}")
