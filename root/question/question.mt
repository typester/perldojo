? extends 'common/base';

? my $q = $c->stash->{q};
? my $as = $c->stash->{answer_sheet};

? block content => sub {

<div id="examContainer">

  <!-- [[[ HEADER-AREA ]]] -->
  <div id="examHeader">
    <h1><a href="/">Perl道場</a></h1>
    <!-- / #examHeader --></div>
  <!-- / [[[ HEADER-AREA ]]] -->

  <div class="examContent group">
    <h2 class="ttlStyle1">Question</h2>
    <div>
      <p><?= encoded_string $q->question ?></p>
    </div>
    <p class="author" style="text-align:right;font-size:11px;">
      by <?= $q->author_name ?>
      <img src="<?= $c->uri_for('/question/icon', $q->name) ?>" width="20" height="20" alt="">
    </p>
    <!-- / .examContent --></div>

  <div class="examContent group">
    <h3 class="ttlStyle2">Choice</h2>
? if (my $err = $c->stash->{err}) {
    <div class="alert-message error">
      <p><?= $err ?></p>
    </div>
? }
    <form method="post">
      <ol class="listAnswers">
? my $i = 0;
? for my $choice (@{ $q->choices }) {
? ++$i;
        <li class="group"><label class="choices-label" id="choice-<?= $i ?>-label"><input id="choice-<?= $i ?>" type="radio" name="choice" value="<?= $i ?>" class="hidden choices"><span><?= $i ?></span><div><?= encoded_string $choice ?></div></label></li>
? }
      </ol>
      <div class="boxAnswer group">
        <p class="btnAnswer"><button type="submit" class="btnStyle1">Answer</button></p>
? if ($as) {
        <p class="counter"><span><strong><?= $as->current ?></strong></span>問 / <span><?= $as->total ?></span>問</p>
? }
      </div>
    </form>
    <!-- / .examContent --></div>

  <!-- [[[ FOOTER-AREA ]]] -->
  <div id="footer">
    <p class="copyright vcard">Copyright &#169; <a href="http://www.kayac.com/" title="株式会社KAYAC（カヤック）古都鎌倉から新しい価値感のサービスを次々にリリースする面白法人" class="external fn org url">KAYAC Inc. </a> All Rights Reserved.</p>
    <!-- / #footer --></div>
  <!-- / [[[ FOOTER-AREA ]]] -->

<!-- / #examContainer --></div>

<script type="text/javascript">
  $('input.choices').change( function() {
    var id = $(this).attr("id") + "-label";
    $("label.choices-label").removeClass("selected");
    $("label#" + id).addClass("selected");
  });
</script>
? };
