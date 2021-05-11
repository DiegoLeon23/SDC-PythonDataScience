bank=read.csv(file.choose(),T,sep=';')

prop.table(table(bank$y))*100
#data no balanceada
#problema que genera: modelo va predecir bien la clase mayoritaria pero no la minoritaria
#modelo de ML va ser deficiente

# solo se balancea a los datos de entrenamiento

#PARTICIONAR

set.seed(2021) #semilla
library(caTools)
generar=sample.split(data_balanced$y,SplitRatio=0.7)

d_entrenamiento=subset(data_balanced, generar==TRUE)
d_testeo=subset(data_balanced,generar==FALSE)

#BALANCEO DE DATOS
library(ROSE)

data_balanced= ovun.sample(y~.,
                           data=bank,
                           method = "over",
                           p=0.4)$data


prop.table(table(data_balanced$y))*100

#MODELO DE MACHINE LEARNING
##entrenar el modelo con d_entrenamiento 
##testear el modelo con d_testeo

library(rpart)
modelo=rpart(y~.,data=d_entrenamiento,method="class")


y_predict_proba=predict(modelo,d_testeo[,-17],type="prob")

y_predict_proba


y_predict=as.factor(as.vector(ifelse(y_predict_proba[,2]>0.5,"yes","no")))
y_predict


y_real=as.factor(d_testeo$y)

row.names(y_predict_proba)=NULL
row.names(y_predict_proba)

proba=y_predict_proba[,2]

data_ml_metrics=as.data.frame(cbind(proba,y_predict,y_real))

tabla=table(y_real,y_predict)

accuracy= (tabla[1,1] + tabla[2,2])/dim(d_testeo)[1]; print(accuracy)

library(caret)

confusionMatrix(y_predict,y_real,positive="yes")

plotROC(proba,y_real)
areaROC(proba,y_real)



