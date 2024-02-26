# データの中身の確認
iris


# irisデータから一つの種類のあやめのデータだけを取り出す
input.data <- subset(iris,Species=="versicolor")


# input.data からSpeciesを削除
input.data2 <- input.data[, colnames(input.data) != "Species"]


# 学習用と検証用の二つに分割
n <- (1:50)*2
train <- input.data2[n,]
test <- input.data2[-n,]
train <- na.omit(train)
test <- na.omit(test)


# 重回帰分析
result <- lm(train$Petal.Length‾., train)


# 結果の表示
print(result)

# 結果の要約
summary(result)


# ステップワイズ
result.step <- step(result,scope=list(upper=‾. , lower=‾1))


# 結果の要約
summary(result.step)


# 学習データと検証データに重回帰モデルを適用
train.result <- predict(result.step,train)
test.result <- predict(result.step,test)
train.err <- data.frame(PREDICT=train.result)
test.err <- data.frame(PREDICT=test.result)


# ヒストグラムの表示
train.dif <- train.err$PREDICT-train$Petal.Length
test.dif <- test.err$PREDICT-test$Petal.Length
hist(train.dif)
hist(test.dif)
