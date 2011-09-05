? extends 'common/base';

? my $q = $c->stash->{q};

? block content => sub {

<div class="page-header">
  <h1>Question</h1>
</div>

<?= encoded_string $q->question ?>

<div class="page-header">
  <h1>Choices</h1>
</div>

? if (my $err = $c->stash->{err}) {
<div class="alert-message error">
  <p><?= $err ?></p>
</div>
? }

<form method="post">
<ul class="inputs-list">
? my $i = 0;
? for my $choice (@{ $q->choices }) {
<li>
<label>
  <input type="radio" name="choice" value="<?= ++$i ?>">
  <span>
    <?= encoded_string $choice ?>
  </span>
</label>
</li>
? }
</ul>

<p><button type="submit" class="btn primary">Answer</button></p>

</form>

? };
