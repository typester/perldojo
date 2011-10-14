? extends 'common/base';

? my $q  = $c->stash->{"q"};
? my $as = $c->stash->{answer_sheet};

? block content => sub {

<div id="examContainer">

  <!-- [[[ HEADER-AREA ]]] -->
  <div id="examHeader">
    <h1><a href="/">Perl道場</a></h1>
  <!-- / #examHeader --></div>
  <!-- / [[[ HEADER-AREA ]]] -->

  <div class="examContent group">
    <div class="blockJudge">
? if ($c->stash->{right}) {
    <p>
      <img src="/img/exam/img_correct_01.png" width="179" height="179" alt="">
    </p>
    <p class="message">正解！おめでとうございます！</p>
? } else {
    <p>
      <img src="/img/exam/img_incorrect_01.png" width="162" height="167" alt="">
    </p>
    <p class="message">残念！</p>
? }
  </div>
    <h3 class="ttlStyle2 answerResult">正解は 「<?= encoded_string $q->answer ?> 」でした</h3>
    <h4 class="ttlStyle3 answerDescription">解説</h4>
    <?= encoded_string $q->explanation ?>

    <div class="blockQuestionInformation">
      <div>
        <table>
          <tr>
            <th scope="row">正答率</th>
            <td>
? if ($c->stash->{percentage}) {
              <p class="percent"><img src="/img/exam/img_meter.png" height="13" width="<?= int($c->stash->{percentage}) * 2 ?>"></p><?= $c->stash->{percentage} ?>％
? } else {
              <p class="percent"></p> - ％
? }
            </td>
          </tr>
          <tr>
            <th scope="row">この問題の評価</th>
            <td>
              <img src="/img/exam/btn_plus_01.png" width="29" height="20" alt="" class="btnPlus">
              <span id="stars">
<? for my $i ( 1 .. $c->stash->{star} ) {?><img src="/img/exam/ico_plus_01.png"><? } ?><span id="added-stars"></span>
              </span>
            </td>
          </tr>
        </table>
        <p class="author">
          <img src="<?= $c->uri_for('/question/icon', $q->name) ?>" width="30" height="30" alt="">
          <?= $q->author_name ?>
        </p>
      </div>
    </div>
? if (!$as) {
    <div><a href="<?= $c->uri_for('/') ?>" class="btnStyle1">Top</a></div>
? } else {
    <div class="boxAnswer group">
?     if ( my $nq = $as->next_question ) {
      <a href="<?= $c->uri_for('/question/', $nq->name) ?>" class="btnStyle1 gotoNext">Next</a>
?     } else {
      <a href="<?= $c->uri_for('/question/result/', $as->serialize) ?>" class="btnStyle1 gotoResult">結果一覧へ</a>
?     }
        <p class="counter"><span><strong><?= $as->current ?></strong></span>問 / <span><?= $as->total ?></span>問</p>
    </div>
? }

  <!-- / .examContent --></div>
  <!-- [[[ FOOTER-AREA ]]] -->
  <div id="footer">
    <p class="copyright vcard">Copyright &#169; <a href="http://www.kayac.com/" title="株式会社KAYAC（カヤック）古都鎌倉から新しい価値感のサービスを次々にリリースする面白法人" class="external fn org url">KAYAC Inc. </a> All Rights Reserved.</p>
    <!-- / #footer --></div>
  <!-- / [[[ FOOTER-AREA ]]] -->

<!-- / #examContainer --></div>

<script type="text/javascript">
  (function () {
    var added = false;
    $('img.btnPlus').click( function() {
      if (added) return;
      var btn = $(this);
      added = true;
      $("#added-stars").html("<img src='/img/exam/ico_plus_01.png' id='added-star'>");
      $("#added-star").css("opacity", "0.5");
      btn.css({"opacity": "0.3", "cursor": "auto"});
      $.post('/api/star/<?= $c->stash->{q}->name ?>', function(){
        $("#added-star").css("opacity", 1);
      });
    });
  })();
</script>
? };
