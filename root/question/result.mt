? extends 'common/base';

? my $q  = $c->stash->{q};
? my $as = $c->stash->{answer_sheet};
? my $rank = $as->rank;
? my $storage = $c->stash->{storage};

? block content => sub {

<div id="examContainer">

  <!-- [[[ HEADER-AREA ]]] -->
  <div id="examHeader">
    <h1 class="hidden">Perl道場</h1>
    <!-- / #examHeader --></div>
  <!-- / [[[ HEADER-AREA ]]] -->

  <div class="examContent group">
    <div class="blockResult">
      <p class="hr1"><img src="/img/exam/img_hr_01.png" width="916" height="14" alt=""></p>
      <p class="hr2"><img src="/img/exam/img_hr_02.png" width="900" height="13" alt=""></p>
      <div class="blockResultHeader">
        <p><?= $as->total ?>問中<?= $as->corrects ?>問正解</p>
        <p class="score"><?= $as->score ?><span class="unit">点</span></p>
        <p class="rank"><img src="/img/exam/img_rank_<?= sprintf('%02d', $as->rank) ?>.png" width="132" height="132" alt=""></p>
      </div>
      <div class="blockResultComment">
        <p>
? if ($rank == 1) {
          あなたはもしかしてラリーウォール自身ではないですか？でなければ、生き別れの双子のきょうだい？<br>ぜひPerl道場の問題を一緒につくってください。あなたこそPerl界、いや、プログラミング界の希望の星なのですから！
? } elsif ($rank == 2) {
          rank 2 の文言
? } elsif ($rank == 3) {
          rank 3 の文言
? } elsif ($rank == 4) {
          rank 4 の文言
? }
      </div>
      <div class="blockResultList">
        <ul class="group">
? my $n = 0;
? for my $q (@{ $as->questions }) {
?    $n++;
          <li class="group">
            <p class="number"><?= $n ?>問目</p>
            <p class="judge"><?= $as->results->[$n - 1] ? "正解" : "不正解" ?></p>
            <p class="question">【<a href="/question/<?= $q->name ?>">問題を見る</a>】</p>
            <p class="author">by
              <img src="<?= $c->uri_for('/question/icon', $q->name) ?>" width="20" height="20" alt="">
              <a target="_blank" href="<?= $q->author_uri ?>"><?= $q->author_name ?></a>
          </li>
? }
        </ul>
        <p class="tweet"><a href="/" class="btnStyle1">結果をtweetする</a></p>
      </div>
      <!-- / .blockResult --></div>
    <!-- / .examContent --></div>

  <div class="blockAction group">
    <div>
      <p class="lead">問題は毎回新しくなります。高得点めざしてトライしよう！</p>
      <p><a href="/" class="btnStyle1 type2">もう一度トライする</a></p>
    </div>
    <div>
      <p class="lead">もっといい問題を作れる！というあなたはこちら</p>
      <p><a href="https://github.com/kayac/perldojo/blob/master/README.md#files" class="btnStyle1 type3" target="_blank">問題を作成する</a></p>
    </div>
    <!-- / .blockAction --></div>

  <!-- [[[ FOOTER-AREA ]]] -->
  <div id="footer">
    <p class="copyright vcard">Copyright &#169; <a href="http://www.kayac.com/" title="株式会社KAYAC（カヤック）古都鎌倉から新しい価値感のサービスを次々にリリースする面白法人" class="external fn org url">KAYAC Inc. </a> All Rights Reserved.</p>
    <!-- / #footer --></div>
  <!-- / [[[ FOOTER-AREA ]]] -->

</div>
  <!-- / [[[ CONTENT-AREA ]]] -->

? };
