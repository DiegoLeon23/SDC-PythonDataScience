library(gplots)
library(ROCR)

plotROC <- function(prediccion, real, adicionar=FALSE, color = "red")
  ## Se definen dos variables "prediccion", "real" 
{
  pred <- prediction(prediccion, real) ## crear un objeto llamado "pred", donde se evaluara la función "prediction", con las variables prediccion y real
  perf <- performance(pred, "tpr", "fpr") ## crear un objeto llamado "perf", donde se evaluara la función "perfomance", con el objeto "pred", anteriormente creado
  plot(perf,col = color, add = adicionar, main = "curva ROC")
  segments(0, 0, 1, 1, col = "black") ## se hace un plot con el objeto perf
  grid()
}


areaROC <- function(prediccion, real)
  ## Se definen dos variables "prediccion", "real" 
{
  pred <- prediction(prediccion, real) ## crear un objeto llamado "pred", donde se evaluara la función "prediction", con las variables prediccion y real
  auc <- performance(pred,"auc")@y.values ## crear un objeto llamado "auc", donde se evaluara la función perfomance, con el objeto pred
  return(auc) ## e retorna el valor del "auc"
}
