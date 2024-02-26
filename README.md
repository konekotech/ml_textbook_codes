# 『機械学習教本』UTF-8変換版

## 実行方法

基本的に、以下のようなコマンドで実行可能です（`chapter*.R`の部分は適宜変更してください）。
```shell
Rscript ./chapter3.R
```

## 実行にあたっての注意

### chapter4.R

事前に`R`コマンドから`Rconsole`を開き、以下を実行する必要があります（ソースコードの最前に含めてもよい）。

```
install.packages("C50")
```

### chapter5.R

ここで使われているライブラリ「apache mxnet」は開発を中止しているようです。したがって、このプログラムは動作しません。
https://mxnet.apache.org/versions/1.9.1/
https://github.com/apache/mxnet

うまくやればソースコードからビルド出来なくもなさそうですが、`cmake`を行うのにNVIDIA CUDA Toolkitが必要です。NVIDIA CUDA Toolkitを導入するためにはNVIDIA製のGPUを搭載している計算機を用いる必要があります。

### chapter6.R

事前に`R`コマンドから`Rconsole`を開き、以下を実行する必要があります（ソースコードの最前に含めてもよい）。

```
install.packages("ROCR")
```

### chapter7.R

クラス変数をfacter型に変換する必要があり、以下のコードを追記しています。

```R
# クラス変数をファクター型に変換
train$V15 <- as.factor(train$V15)
test$V15 <- as.factor(test$V15)
```

### chapter9.R
`spam`データセットの構造の関係上、ソースコードを以下のように変更しています。

```diff
# 変数削減による損失の大きさの確認
- imp <- xgb.importance(names(spam),model=mdl)
+ <- xgb.importance(names(spam[, -58]), model = mdl)
```

### chapter10.R
ソースコードに誤りがあります。

```diff
# 分析結果の表示
- plot(result_d)
+ plot(x.d)
```

### chapter11.R
ファイルの読み込みの部分に誤りがあります。

```diff
# ファイルの読み込み
- x <- read.csv("data/PCA.csv", header = TRUE, row.names = 1)
+ x <- read.csv("./PCA.csv", header = TRUE, row.names = 1)
```