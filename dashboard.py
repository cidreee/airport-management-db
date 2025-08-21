import streamlit as st
import pandas as pd
import mysql.connector
import plotly.express as px
import plotly.graph_objects as go


# Configura tu conexión a MySQL
conn = mysql.connector.connect(
    host="127.0.0.1",
    port=3306,
    user="root",
    password="150904vmam",  # ponla entre comillas
    database="aeropuerto"
)
# Configuración de la página
st.set_page_config(page_title="Dashboard Aeropuerto", layout="wide")
st.markdown("<h1 style='text-align: center;'>✈️ Dashboard del Aeropuerto</h1>", unsafe_allow_html=True)
st.markdown("<p style='text-align: center;'>Resumen visual de vuelos, ingresos, tripulación y pasajeros.</p>", unsafe_allow_html=True)
st.divider()

# === FILTROS GLOBALES ===
with st.expander("Filtros del Dashboard", expanded=True):
    colf1, colf2 = st.columns(2)

    meses = {
        1: "Enero", 2: "Febrero", 3: "Marzo", 4: "Abril",
        5: "Mayo", 6: "Junio", 7: "Julio", 8: "Agosto",
        9: "Septiembre", 10: "Octubre", 11: "Noviembre", 12: "Diciembre"
    }

    with colf1:
        mes_sel = st.selectbox("🗓 Selecciona un mes (para ingresos)", list(meses.keys()), format_func=lambda x: meses[x])

    df_aerolineas = pd.read_sql("SELECT aerolinea_id, nombre FROM aerolineas;", conn)
    aerolinea_dict = dict(zip(df_aerolineas['nombre'], df_aerolineas['aerolinea_id']))

    with colf2:
        aerolinea_sel = st.selectbox("Selecciona una aerolínea (para estado de vuelos)", ["Todas"] + list(aerolinea_dict.keys()))

st.divider()

# === SECCIÓN 1: VUELOS POR MES E INGRESOS ===
st.subheader("Resumen Mensual")

col1, col2 = st.columns(2)
with col1:
    df1 = pd.read_sql("SELECT MONTH(fecha_salida) AS mes, COUNT(*) AS total_vuelos FROM vuelos GROUP BY mes;", conn)
    fig1 = px.bar(df1, x='mes', y='total_vuelos', title="Vuelos por Mes", labels={'mes': 'Mes', 'total_vuelos': 'Cantidad'})
    st.plotly_chart(fig1, use_container_width=True)

with col2:
    df5 = pd.read_sql(f"""
        SELECT MONTH(fecha_pago) AS mes, SUM(monto) AS total_ingresos
        FROM pagos WHERE MONTH(fecha_pago) = {mes_sel}
        GROUP BY mes;
    """, conn)
    st.markdown(f"### Ingresos en {meses[mes_sel]}")
    st.markdown("*Este dato responde al filtro de mes seleccionado arriba.*")
    if not df5.empty:
        st.metric("Total ingresos", f"${df5['total_ingresos'].iloc[0]:,.2f}")
    else:
        st.warning("Sin ingresos registrados en este mes.")

st.divider()

# === SECCIÓN 2: DURACIÓN PROMEDIO Y ESTADO DE VUELOS ===
st.subheader(" Rutas y Estado de Vuelos")

col3, col4 = st.columns(2)
with col3:
    df2 = pd.read_sql("""
        SELECT r.aeropuerto_origen, r.aeropuerto_destino,
        ROUND(AVG(TIMESTAMPDIFF(MINUTE, v.fecha_salida, v.fecha_llegada_estimada))) AS duracion
        FROM vuelos v JOIN rutas r ON v.ruta_id = r.ruta_id
        GROUP BY r.aeropuerto_origen, r.aeropuerto_destino;
    """, conn)
    df2['ruta'] = df2['aeropuerto_origen'] + " - " + df2['aeropuerto_destino']
    fig2 = px.bar(df2, x='duracion', y='ruta', orientation='h', title="Duración Promedio por Ruta", labels={'duracion': 'Minutos'})
    st.plotly_chart(fig2, use_container_width=True)

with col4:
    st.markdown("### Estado de los Vuelos")
    st.markdown("*Este gráfico responde al filtro de aerolínea seleccionado arriba.*")

    query_estado = f"""
        SELECT estado, COUNT(*) AS total
        FROM vuelos
        {"WHERE aerolinea_id = " + str(aerolinea_dict[aerolinea_sel]) if aerolinea_sel != "Todas" else ""}
        GROUP BY estado;
    """
    df_estado = pd.read_sql(query_estado, conn)
    fig_estado = px.pie(df_estado, names='estado', values='total', title=None)
    st.plotly_chart(fig_estado, use_container_width=True)

st.divider()

# === SECCIÓN 3: PILOTOS Y PASAJEROS ===
st.subheader("Tripulación y Pasajeros")

col5, col6 = st.columns(2)
with col5:
    df3 = pd.read_sql("""
        SELECT CONCAT(nombre, ' ', apellido) AS piloto, horas_de_vuelo
        FROM tripulacion WHERE puesto = 'piloto'
        ORDER BY horas_de_vuelo DESC LIMIT 5;
    """, conn)
    fig3 = px.bar(df3, x='horas_de_vuelo', y='piloto', orientation='h', title="Top 5 Pilotos con Más Horas de Vuelo", labels={'horas_de_vuelo': 'Horas'})
    st.plotly_chart(fig3, use_container_width=True)

with col6:
    df4 = pd.read_sql("""
        SELECT nacionalidad, COUNT(*) AS total
        FROM pasajeros GROUP BY nacionalidad
        ORDER BY total DESC LIMIT 10;
    """, conn)
    fig4 = px.bar(df4, x='total', y='nacionalidad', orientation='h', title="Top 10 Nacionalidades de Pasajeros")
    st.plotly_chart(fig4, use_container_width=True)

st.divider()

# === SECCIÓN 4: RUTAS MÁS TRANSITADAS ===
st.subheader("Rutas Más Transitadas")

df7 = pd.read_sql("""
    SELECT r.aeropuerto_origen, r.aeropuerto_destino, COUNT(*) AS total_vuelos
    FROM vuelos v JOIN rutas r ON v.ruta_id = r.ruta_id
    GROUP BY r.aeropuerto_origen, r.aeropuerto_destino
    ORDER BY total_vuelos DESC LIMIT 10;
""", conn)
df7['ruta'] = df7['aeropuerto_origen'] + " - " + df7['aeropuerto_destino']
fig7 = px.bar(df7, x='total_vuelos', y='ruta', orientation='h', title="Top 10 Rutas Más Transitadas")
st.plotly_chart(fig7, use_container_width=True)

# Cerrar conexión
conn.close()