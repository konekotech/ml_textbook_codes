# mxnetのインストール
cran <- getOption("repos")
cran["dmlc"] <- "https://apache-mxnet.s3-accelerate.dualstack.amazonaws.com/R/CRAN/"
options(repos = cran)
install.packages("mxnet")


# mxnetの用意
library(mxnet)


# spamデータの利用
install.packages("kernlab")
library(kernlab)
data(spam)


# データの分割
spamx <- data.matrix(spam)
train <- spamx[1:2300*2,]
test <- spamx[-(1:2300)*2,]
train.x <- train[,-58]
train.y <- train[,58]-1
test.x <- test[,-58]
test.y <- test[,58]-1



# モデル構成
data <- mx.symbol.Variable("data")
bn0 <- mx.symbol.BatchNorm(data, eps=1e-06, fix.gamma=FALSE)
fc1 <- mx.symbol.FullyConnected(bn0, num_hidden=128)
act1 <- mx.symbol.Activation(fc1, act_type="relu")
bn1 <- mx.symbol.BatchNorm(act1, eps=1e-06, fix.gamma=FALSE)
dp1 <- mx.symbol.Dropout(bn1, p = 0.5)
fc2 <- mx.symbol.FullyConnected(dp1, num_hidden=64)
act2 <- mx.symbol.Activation(fc2, act_type="relu")
bn2 <- mx.symbol.BatchNorm(act2, eps=1e-06, fix.gamma=FALSE)
dp2 <- mx.symbol.Dropout(bn2, p = 0.5)
# skip-layer connection
lis <- list(bn0,dp2)
lis$num.args = 2
cct <- mxnet:::mx.varg.symbol.Concat(lis)
# 出力の構成
fc3 <- mx.symbol.FullyConnected(cct, num_hidden=2)
softmax <- mx.symbol.SoftmaxOutput(fc3)


# ディープラーニングによる学習
devices <- mx.cpu()
mx.set.seed(0)
set.seed(0)
logger <- mx.metric.logger$new()
model <- mx.model.FeedForward.create(
  softmax, X=train.x, y=train.y,optimizer="adagrad",
  ctx=devices, num.round=30, array.batch.size=100,
  eval.data = list(data=test.x,label=test.y),
  eval.metric=mx.metric.accuracy, learning.rate=0.07,
  initializer=mx.init.uniform(0.07),array.layout="rowmajor",
  epoch.end.callback=mx.callback.log.train.metric(1,logger))


# 正解率のグラフ化
plot(1:30,logger$train,type="l",xlim=c(1,30),ylim=c(0,1),ylab="")
par(new=TRUE)
plot(1:30,logger$eval ,type="l",xlim=c(1,30),ylim=c(0,1),lty=2)


# ディープラーニングのモデルの図示
graph.viz(model$symbol)


# モデルを利用した推定
predl <- predict(model, test.x, ctx=devices,array.layout="rowmajor")

# 行列の転置
tpredl <- t(predl)[,2]


# AUCの計算
install.packages("ROCR")
library(ROCR)
tpredlp <- prediction(tpredl,test.y)
aucp <- performance(tpredlp,"auc")
as.numeric(aucp@y.values)


# ニューラルネットとの比較
library(nnet)
train <- spam[1:2300*2,]
test <- spam[-(1:2300)*2,]
set.seed(0)
mdl <- nnet(type‾.,data=train,size=16,maxit=1000)
pre <- predict(mdl,test)
library("ROCR")
pred <- prediction(pre,test[,58])
aucp <- performance(pred,"auc")
as.numeric(aucp@y.values)


# クロス表
x <- ifelse(tpredl >0.99 ,"spam*","nonspam*")
(tb <- table(x,test.y))
# 正解率
tb[2,2]/sum(tb[2,])