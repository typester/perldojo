? extends 'common/base';

? my $q = $c->stash->{q};

? block content => sub {

<div class="hero-unit">
  <h1><?= $c->stash->{right} ? "正解！" : "残念!" ?></h1>
  <p>正解は <?= encoded_string $q->answer ?> でした</p>
</div>

<div class="page-header">
  <h1>解説</h1>
</div>

<?= encoded_string $q->explanation ?>

<div class="page-header">
  <h1>TODO</h1>
</div>

<ul>
  <li>作成者の表示</li>
  <li>結果画面に正答率、選択肢ごとの回答された割合、などを表示</li>
</ul>

<p><a class="btn primary" href="/question">Next</a></p>

? };
