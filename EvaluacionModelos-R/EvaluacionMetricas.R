'Conjunto de Datos'

'1. Particionar los datos'
  'Entrenamiento = 70%'
  'Testeo = 30%'

'2. Preprocesamiento de datos'
  'identificar problemas: datos no balanceados, datos no discretos, datos nulls'
  'Soluciones a los problemas: balanceo de datos(over-sampling),discretizar(k-means)'
  'NOTA: El balanceo solo se aplica a los datos de entrenamiento'
  'discretizacion se aplica a los de entrenamiento para identificar los puntos de corte en proceso de discretización'
  'cortes: 30, 48'
  'categoria1: 18-30'
  'categoria2: 30-48'
  'categoria3: 48-71'

'3.Evaluacion de Modelos'
  'Regresion Logistica, LDA, Arboles de Decisión, Random Forest,
  Naive Bayes, SVM, XGBoost, Redes Neuronales'


'Metricas para evaluacion de modelo'
'Accurac, sensibilidad, especificidad, auc, f1, etc.'
'el modelo en cuanto a sus métricas presente el mejor performance'

'Aplicación de Machine Learning'
'Random Forest' #se empaquetan sus hiperparametros y se despliega
'Aplicacion de ML para nuestro negocio' #shiny - grupo R Studio
'AWS'

'Piloteos'
'Modelo puesto en practica'
'entrene y testear con datos de enero 2011 -diciembre 2020'

'Enero 2021'
'Febrero 2021'


data=read.csv('D:/Social Data Consulting/data_selec_entre.csv',na.strings=c(""," ",NA),sep=',')


test=read.csv('D:/Social Data Consulting/data_selec_test.csv',na.strings=c(""," ",NA),sep=',')

library(mlr)
imp_train=impute(data,classes= list(factor=imputeMode(),
                                    integer=imputeMean()),
                 dummy.classes=c("integer","factor"),
                 dummy.type="numeric")

train = imp_train$data[1,88]

table(train$TARGET)/dim(train)[1]*100

library(caret)
sample = createDataPartition(train$TARGET,
                             p=.10,
                             list=FALSE,
                             times=1)

train_10=train[sample,]

library(Information)

iv=create_infotables(data=train_10,y='TARGET')

data_t= as.data.frame(iv$Summary)

variables_iv= iv$Summary[which(iv$Summary[,2]>0.02 & iv$Summary[,2]<0.8),1]

variables_selec=c(variables_iv,"TARGET"); print(variables_selec)

train_data.frame(train[,variables_selec])

train$PROVINCIA=NULL
train$DEPARTAMENTO=NULL
train$COD_SALA=NULL
train$FEC_LLAMADA=NULL

str(train)
train$TARGET = factor(train$TARGET)
test = data.frame(test[,colnames(train)])






