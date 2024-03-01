# ファイルの読み込み
x <- read.csv("./cluster.csv", header = TRUE, row.names = 1)


# 非階層型の作成
result_k <- kmeans(x, 3, iter.max = 10)


# 分析結果の表示
result_k$cluster


# クラスターのサイズを調べる
result_k$size


# 各クラスターの中心値
result_k$centers


# 階層型の作成
x.d <- dist(x)
result_d <- hclust(x.d, method = "centroid")

# 分析結果の表示
plot(result_d)
