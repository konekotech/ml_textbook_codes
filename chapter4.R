# ライブラリの用意
install.packages("nnet")
library(nnet)


# データの分割
n <- 1:30*5
test <- iris[n,]
train <- iris[-n,]


# ニューラルネットによる学習
nn <- nnet(Species~., data=train, size=8)


# 実行回数の変更
nn <- nnet(Species~., data=train, size=8, maxit=1000)


# 推定結果の取得
result <- predict(nn,test)


# もっとも確率の高い種別の取り出し
result <- predict(nn,test,type="class")


# 正解数の確認
table(result,test$Species)


# 決定木との比較
library("C50")
tr <- C5.0(x=train[,-5], y=train$Species)
result <- predict(tr,test)
table(result,test$Species)