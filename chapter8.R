# データの中身の確認
data.frame(Titanic)


# 集計情報を人単位に分ける
install.packages("epitools")
library(epitools)
data <- expand.table(Titanic)
data


# C50の用意
install.packages("C50")
library(C50)


# 決定木の作成
tree <- C5.0(x=data[,-4], y=data$Survived)
summary(tree)


# 画像出力
plot(tree)