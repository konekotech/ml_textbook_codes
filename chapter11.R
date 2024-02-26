# ファイルの読み込み
x <- read.csv("data/PCA.csv", header=TRUE, row.names=1)


# 主成分分析の実行
pca = prcomp(x, scale=TRUE)


# 固有ベクトルの確認
pca


# 累積寄与率の取得
summary(pca)


# 主成分スコアの表示
pca$x


# プロット図の表示
biplot(pca)