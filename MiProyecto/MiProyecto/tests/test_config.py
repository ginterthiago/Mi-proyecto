from Python.config import ConnectionConfig


def test_cargar_variables():
    config = ConnectionConfig()

    assert config.nombre == "Mi Base de datos"
    assert config.host == "localhost"
    assert config.puerto == 5432
    assert config.usuario == "admin"
    assert config.password == "123"
    assert config.base_de_datos == "Mi Base"
