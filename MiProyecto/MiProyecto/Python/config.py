import os
from dotenv import load_dotenv

load_dotenv()


class ConnectionConfig:
    def __init__(self):
        self.nombre = os.getenv("DB_NAME")
        self.host = os.getenv("DB_HOST")
        self.puerto = os.getenv("DB_PORT")
        self.usuario = os.getenv("DB_USER")
        self.password = os.getenv("DB_PASSWORD")
        self.base_de_datos = os.getenv("DB_DATABASE")

        self.validar()

        try:
            self.puerto = int(self.puerto)
        except ValueError:
            raise ValueError(
                "La variable DB_PORT debe ser un número entero."
            )

    def validar(self):
        variables = {
            "DB_NAME": self.nombre,
            "DB_HOST": self.host,
            "DB_PORT": self.puerto,
            "DB_USER": self.usuario,
            "DB_PASSWORD": self.password,
            "DB_DATABASE": self.base_de_datos
        }

        for nombre, valor in variables.items():
            if valor is None or valor.strip() == "":
                raise ValueError(
                    f"La variable de entorno {nombre} no está configurada."
                )
