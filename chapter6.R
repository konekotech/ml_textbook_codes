# kernlabの用意
install.packages("kernlab")
library(kernlab)


# データ分割：学習データと検証データとに分ける
testd <- 1:30 * 5
test <- iris[testd, ]
train <- iris[-testd, ]
# 学習：カーネルとしてRBF カーネル(rbfdot) を使用
kmdl <- ksvm(Species ~ ., data = train, kernel = "rbfdot")
# 推定
pred <- predict(kmdl, test)
# 判定結果の比較
table(pred, test$Species)


# データの分離状況の図示
irisn <- iris[51:150, c(2, 3, 5)]
irisn$Species <- droplevels(irisn$Species)
kmdl <- ksvm(Species ~ ., data = irisn, kernel = "rbfdot")
plot(kmdl, data = irisn)


# e1071の用意
install.packages("e1071")
library(e1071)


# データの読み込み
data(spam)
# データ分割
tar <- 1:2300 * 2
test <- spam[-tar, ]
train <- spam[tar, ]
# 学習： RBF カーネルを使用
set.seed(10)
mdl <- svm(type ~ ., data = train, kernel = "radial")
# 推定
pred <- predict(mdl, test)
# 判定結果の比較
table(pred, test$type)


# スパムである確率を求める
set.seed(10)
mdl <- svm(type ~ ., data = train, kernel = "radial", probability = TRUE)
pred <- predict(mdl, test, probability = TRUE)


# AUCの計算
library(ROCR)
tlabel <- as.integer(test$type) - 1
tpredlp <- prediction(attr(pred, "probabilities")[1:2301], tlabel)
aucp <- performance(tpredlp, "auc")
as.numeric(aucp@y.values)
