? extends 'common/base';

? my $q = $c->stash->{q};

? block content => sub {

<div class="hero-unit">
  <h1><?= $c->stash->{right} ? "正解！" : "残念!" ?></h1>
  <p>正解は <?= encoded_string $q->answer ?> でした</p>
</div>

<div class="page-header">
  <h1>Explanation</h1>
</div>

<?= encoded_string $q->explanation ?>

<div class="page-header">
  <h1>TODO: 正答率のいけてるグラフとか</h1>
</div>

<p><a class="btn primary" href="/question">Next</a></p>

? };
