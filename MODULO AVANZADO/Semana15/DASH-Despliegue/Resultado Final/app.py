# -*- coding: utf-8 -*-
"""
Created on Thu Mar 12 20:28:19 2020

@author: SOCIAL DATA
"""
#Definimos la libreria
import os
import pandas as pd
import dash
import dash_core_components as dcc
import dash_html_components as html
import dash_bootstrap_components as dbc
from dash.dependencies import Output, Input, State
from joblib import load

#external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']
#app = dash.Dash(external_stylesheets=[dbc.themes.CYBORG])

app = dash.Dash(__name__, external_stylesheets=[dbc.themes.BOOTSTRAP])

server = app.server



#Definimos el formulario
controls = dbc.Card(
    [
        dbc.FormGroup(
            [
                dbc.Label("Pregnancies"),
                dbc.Input(id="input-preg", type="number",placeholder="Entrar Pregnancies"),
            ]
        ),
         dbc.FormGroup(
            [
                dbc.Label("Glucose"),
                dbc.Input(id="input-glu", type="number",placeholder="Entrar Glucose"),
            ]
        ),
          dbc.FormGroup(
            [
                dbc.Label("BloodPressure"),
                dbc.Input(id="input-blood", type="number",placeholder="Entrar BloodPressure"),
            ]
        ),
          dbc.FormGroup(
            [
                dbc.Label("SkinThickness"),
                dbc.Input(id="input-skin", type="number",placeholder="Entrar SkinThickness"),
            ]
        ),
          dbc.FormGroup(
            [
                dbc.Label("Insulin"),
                dbc.Input(id="input-insul", type="number",placeholder="Entrar Insulin"),
            ]
        ),
          dbc.FormGroup(
            [
                dbc.Label("BMI"),
                dbc.Input(id="input-bmi", type="number",placeholder="Entrar BMI"),
            ]
        ),
          dbc.FormGroup(
            [
                dbc.Label("DiabetesPedigreeFunction"),
                dbc.Input(id="input-diabetes", type="number",placeholder="Entrar DiabetesPedigreeFunction"),
            ]
        ),
          dbc.FormGroup(
            [
                dbc.Label("Age"),
                dbc.Input(id="input-age", type="number",placeholder="Entrar Age"),
            ]
        ),
          dbc.FormGroup(
            [
                dbc.Button("Predecir", color="primary",id='submit-button', n_clicks=0),
                
            ]
        ),
         
          dbc.FormGroup(
            [
                 #dbc.Alert("Rellene todos los datos", color="primary",id='display-value3'),
                 html.Div(id='display-value3'),
            ]
        ),
    ],
    body=True,
)


#Enmaquetamos el html
app.layout = dbc.Container(
    [
        html.H1("Modelo Predictivo"),
        html.Hr(),
        dbc.Row(
            [
                dbc.Col(controls, md=4),#En html en escritorio del 1 al 12 eligimos 4.
                #dbc.Col(dcc.Graph(id="cluster-graph"), md=8),
            ],
            align="center",
        ),
    ],
    fluid=True,
)

#El "Output" representa el texto de salida
#El "Input" es el boton que cuando le des click activara este evento
#Los "State" representa a los input
@app.callback(Output('display-value3', 'children'),#el "display-value3" es el id 
              [Input('submit-button', 'n_clicks')],#el "display-value3" es el id
              [State('input-preg', 'value'),#el "input-preg" es el id 
               State('input-glu', 'value'),#el "input-glu" es el id 
               State('input-blood', 'value'),#el "input-blood" es el id 
               State('input-skin', 'value'),#el "input-skin" es el id 
               State('input-insul', 'value'),#el "input-insul" es el id 
               State('input-bmi', 'value'),#el "input-bmi" es el id 
               State('input-diabetes', 'value'),#el "input-diabetes" es el id 
               State('input-age', 'value'),#el "input-age" es el id 
               ])
def display_value(n_clicks,value_pre,value_glu,value_blood,value_skin,value_insul,value_bmi,value_db,
                  value_age):
    
    #el n_clicks es el numero de veces que presiono el boton
    #,ya que en caso contrario al momento de ejecutar obtendremos un error
    if n_clicks!=0:
            clf = load('Modelo.joblib')#Cargamos el modelo
            
            d = {'Pregnancies': [value_pre], 
                 'Glucose': [value_glu],
                 'BloodPressure': [value_blood], 
                 'SkinThickness': [value_skin],
                 'Insulin': [value_insul], 
                 'BMI': [value_bmi],
                 'DiabetesPedigreeFunction': [value_db],
                 'Age': [value_age]}
            df = pd.DataFrame(data=d)
            
            prediccion=clf.predict(df)[0]
            return 'La prediccion es '+str(prediccion)
    else:
            return 'Rellene todos los datos por favor'

#Siempre al final del archivo
if __name__ == '__main__':
    app.run_server(debug=True)
    
    
    