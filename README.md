Perl道場
====================

問題作成方法
--------------------

https://github.com/kayac/perldojo

を fork し問題定義ファイルを追加後、 pull request を送信してください。


問題定義ファイル
--------------------

問題定義ファイルは `data` ディレクトリ以下に `.pod` 形式で記述します。

また、 `=head1` として決まった要素を定義する必要があります。以下の要素はすべて必須項目です。

 * =head1 QUESTION
 * =head1 CHOICES
 * =head1 ANSWER
 * =head1 EXPLANATION
 * =head1 AUTHOR

その他の要素（たとえば LICENSE や SEE ALSO 等）は自由に記述していただいてかまいません。

問題はすべて選択肢形式で、回答を一つ選ばせるタイプにする必要があります。

なお、`tools/new-question.pl` コマンドを使って新しい問題を作成することができます。

    # data/foo.podを作成する
    $ tools/new-question.pl foo

このとき作者名とgithubのアドレスが自動で埋めこまれますが、これは `git config user.name` と `git config github.user` から自動で取得されるほか、`--author` と `--github` オプションで設定することも出来ます。

    $ tools/new-question.pl --author 'My Name' --github 'myaccount'

### QUESTION

問題文を記述します。

内容に制約はありませんので、`.pod` の形式に沿っていればどのような記述でもかまいません


### CHOICES

回答の選択肢を記述します。これは、

    =head1 CHOICES
    
    =over
    
    =item 1.
    
    回答1
    
    =item 2.
    
    回答2
    
    =item 3.
    
    回答3
    
    =item 4.
    
    回答4
    
    =back

というリスト形式である必要があります。回答の個数には制限はありません。

また、各回答の文章は単語である必要はなく、複数行にまたがっていたり、コードブロックが含まれていても許容します。


### ANSWER

CHOICES で指定した選択肢のうち、正解である選択肢の数値を記述します。

    =head1 ANSWER
    
    3


### EXPLANATION

問題の解説文です。問題に答えたあとに表示されます。

QUESTION 同様、フォーマットは自由です。


### AUTHOR

問題の作者を記述します。
将来的にここは自由に記述できるようにしたいですが、いまのところ下記のような、

    =head1 AUTHOR
    
    Daisuke Murase
    http://github.com/typester

一行目に名前、二行目にgithubのURLというような感じで記述します。


問題のライセンスについて
--------------------

問題定義ファイル自体にライセンスの記述がない場合は、[CC-by](http://creativecommons.org/licenses/by/2.1/jp/) ライセンスであると見なし、
また、問題の著作権は問題作成者に帰属するとします。

