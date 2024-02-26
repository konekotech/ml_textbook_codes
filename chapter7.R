# klaRの用意
install.packages("klaR")
library(klaR)


# データの取得
download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data", destfile = "./adult.data")
download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.test", destfile = "./adult.test")
train <- read.table("adult.data", sep = ",", header = FALSE)
test <- read.table("adult.test", sep = ",", header = FALSE, skip = 1)


# クラス変数をファクター型に変換
train$V15 <- as.factor(train$V15)
test$V15 <- as.factor(test$V15)


# モデルの構築とデータへの適用
nb <- NaiveBayes(V15 ~ ., data = train)
pre <- predict(nb, newdata = test)


# クロス表
table(pre$class, test$V15)
# 正解率
tabb <- table(pre$class, test$V15)
sum(diag(tabb)) / sum(tabb)


# ラプラススムージング
nb <- NaiveBayes(V15 ~ ., data = train, fL = 1)


# 年齢(V1)の確認
plot(nb, "V1")


# カーネル密度推定
nb <- NaiveBayes(V15 ~ ., data = train, usekernel = TRUE, fL = 1)


# 勤務時間(V13)の確認
plot(nb, "V13")
