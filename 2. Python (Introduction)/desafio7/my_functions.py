import pandas as pd

def fecha(df,column,desde="01/01/1900", hasta="01/01/2099"):
    df[column]=pd.to_datetime(df[column])
    desde=pd.to_datetime(desde,dayfirst=True)
    hasta=pd.to_datetime(hasta,dayfirst=True)
    return df.query("@desde<{}<@hasta".format(column))

def agrupar(df,filas, valores, medida,columnas=[]):
    pivote=pd.pivot_table(
        df,
        index=filas,
        columns=columnas,
        values=valores,
        aggfunc=medida,
        fill_value=0
    )
    return pivote

def guardar_tabla(df,nombre,engine,if_exists="fail"):
    df.to_sql(name=nombre, con=engine, if_exists=if_exists, index=False)