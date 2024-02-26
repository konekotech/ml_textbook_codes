# xgboostの用意
install.packages("xgboost")
library(xgboost)


# spamデータの読み込みおよび目的変数の成型
library(kernlab)
data(spam)
tar <- 1:2300 * 2
train <- xgb.DMatrix(
    data = as.matrix(spam[tar, -58]),
    label = as.integer(spam[tar, 58]) - 1
)
test <- xgb.DMatrix(
    data = as.matrix(spam[-tar, -58]),
    label = as.integer(spam[-tar, 58]) - 1
)


# 補正モデルの個数の指定
best <- xgb.cv(
    data = train, nfold = 10, nrounds = 100,
    objective = "binary:logistic", early_stopping_rounds = 10
)


# AUCの設定
best <- xgb.cv(
    data = train, nfold = 10, nrounds = 100,
    objective = "binary:logistic",
    seed = 1, early_stopping_rounds = 10, eval_metric = "auc"
)


# xgboostによるモデル構築
mdl <- xgboost(data = train, nrounds = 43, objective = "binary:logistic")
pred <- predict(mdl, test)


# AUCによる性能確認
library(ROCR)
tlabel <- as.integer(spam[-tar, 58]) - 1
tpredlp <- prediction(pred, tlabel)
aucp <- performance(tpredlp, "auc")
as.numeric(aucp@y.values)


# 変数削減による損失の大きさの確認
# imp <- xgb.importance(names(spam),model=mdl)
imp <- xgb.importance(names(spam[, -58]), model = mdl)
xgb.plot.importance(imp)
