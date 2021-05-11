'Conjunto de datos'

'1. Particionar los datos'
'Entrenamiento= 70%
testeo=30%'
'2. Preprocesamiento de datos'
'identificar problemas: datos no balanceados, datos no discretos, etc.'
'soluciones a los problemas: balanceo de datos (over- sampling), discretizar(k - means)'
'NOTA: el balanceo sólo se aplicad a los datos de entrenamiento'
'discretización se aplica a los de entrenamiento para identificar los puntos
de corte en proceso de discretización'
'cortes: 30, 48'
'categoría 1: 18-30
categpría 2: 30-48
categoría 3: 48-71'

'3. Modelamiento'
'Regresión logística, LDA, QDA, RDA, Árboles de decisión, Random Forest,
Naive Bayes, SVM, XGBoost, Redes neuronales'

'4. Evaluación de modelos'
'Regresión logística, LDA, QDA, RDA, Árboles de decisión, Random Forest,
Naive Bayes, SVM, XGBoost, Redes neuronales'

'Métricas de evaluación de modelo'
'Accuracy, sensibilidad, especificidad, auc, f1, etc.'
'el modelo en cuanto a sus métricas presente el mejor performance'

"Aplicación de Machine Learning"
'Random Forest' #se empaquetan sus hiperparámetros y se despliega
'Aplicación de ML para nuestro negocio' #shiny - grupo R Studio
'AWS' 

'Piloteos'
'Modelo puesto en practica'
'entrene y testear con datos de enero 2011 - diciembre 2020'
'auc train(0.98) y test (0.985'
'accuracy train(0.99) y test (0.989'

'Enero 2021'
'auc (0.94) y accuracy (0.91)'
'Febrero 2021'
'auc (0.91) y accuracy (0.89)'
data = read.csv("D:/R/3. Nivel III/1/datos/data_entre.csv",na.strings = c(""," ",NA),
                sep= ",")

test = read.csv("D:/R/3. Nivel III/1/datos/data_test.csv",na.strings = c(""," ",NA),
                sep= ",")

  library(mlr)
imp_train = impute(data,
                   classes = list(factor=imputeMode(),
                                  integer= imputeMean()),
                   dummy.classes = c("integer", "factor"),
                   dummy.type = "numeric")

train = imp_train$data[,1:88]

table(train$TARGET)/dim(train)[1]*100

library(caret)
sample = createDataPartition(train$TARGET,
                             p=.10,
                             list=FALSE,
                             times=1)
train_10 = train[sample,]

library(Information)

iv = create_infotables(data= train_10,
                       y="TARGET")

data_t = as.data.frame(iv$Summary)

varibles_iv = iv$Summary[which(iv$Summary[,2]>0.02 & iv$Summary[,2]<0.8),1]


variables_selec = c(varibles_iv, "TARGET"); print(variables_selec)

train = data.frame(train[,variables_selec])

train$PROVINCIA = NULL
train$DEPARTAMENTO = NULL
train$COD_SALA = NULL
train$FEC_LLAMADA = NULL

str(train)
train$TARGET = factor(train$TARGET)

test = data.frame(test[,colnames(train)])

#modelo de +arboles
library(rpart)
mod_arb = rpart (TARGET ~.,
                 data=train,
                 method="class",
                 parms= list(split="information"))
install.packages("C50")

library(C50)
mod_c50 = C5.0(TARGET ~.,
               data=train,
               trials = 2)


predic_arb = predict(mod_arb,
                     train[,c(1:35)],
                     type = "prob")



predic_c50 = predict(mod_c50,
                     train[,c(1:35)],
                     type = "prob")

predic_arb[1:5,]
predic_c50[1:5,]

arb_cat = as.vector(ifelse(predic_arb[,2]>0.5, "1","0"))

c50_cat = as.vector(ifelse(predic_c50[,2]>0.5, "1","0"))

'Árboles de decisión'
plotROC(predic_arb[,2], train$TARGET)
areaROC(predic_arb[,2], train$TARGET)

'C5.0'
plotROC(predic_c50[,2], train$TARGET)
areaROC(predic_c50[,2], train$TARGET)

library(caret)



confusionMatrix(as.factor(arb_cat),train$TARGET, positive = "1")

confusionMatrix(as.factor(c50_cat),train$TARGET, positive = "1")


predic_c50_test = predict(mod_c50,
                     test[,c(1:35)],
                     type = "prob")
c50_cat_test = as.vector(ifelse(predic_c50_test[,2]>0.5, "1","0"))
le
plotROC(predic_c50_test[,2], test$TARGET)
areaROC(predic_c50_test[,2], test$TARGET)
test$TARGET=factor(test$TARGET)
confusionMatrix(as.factor(c50_cat_test),test$TARGET, positive = "1")

#guardar el modelo
getwd()
save(mod_c50,
     file = "modelos_c50.RData")
