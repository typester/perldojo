? extends 'common/base';
? use List::Util qw/ max /;
? my $q  = $c->stash->{q};
? my $as = $c->stash->{answer_sheet};
? my $rank = $as->rank;
? my $storage = $c->stash->{storage};

? block content => sub {

<div id="examContainer">

  <!-- [[[ HEADER-AREA ]]] -->
  <div id="examHeader">
    <h1><a href="/">Perl道場</a></h1>
    <!-- / #examHeader --></div>
  <!-- / [[[ HEADER-AREA ]]] -->

  <div class="examContent group">
    <div class="blockResult">
      <p class="hr1"><img src="/img/exam/img_hr_01.png" width="916" height="14" alt=""></p>
      <p class="hr2"><img src="/img/exam/img_hr_02.png" width="900" height="13" alt=""></p>
      <div class="blockResultHeader">
        <p><?= $as->total ?>問中<?= $as->corrects ?>問正解</p>
        <p class="score"><?= $as->score ?><span class="unit">点</span></p>
        <p class="rank"><img src="/img/exam/img_rank_<?= sprintf('%02d', $rank) ?>.png" width="132" height="132" alt=""></p>
      </div>
      <div class="blockResultComment">
        <p>
? if ($rank == 1) {
           もしかしてラリー・ウォール・・・さんですか？難問を全て解いてしまったあなたは、すでにPerl界を代表するハッカーに違いない！<br>ぜひ出題をお願いします！
? } elsif ($rank == 2) {
           もう少しで全問正解！今回間違えたところを振り返ってみて、次はパーフェクトを目指してください！<br>あなたのレベルなら問題の出題もぜひ挑戦してください！
? } elsif ($rank == 3) {
           なかなかやりますね！しかしまだPerlには身につける知識がたくさんあるようです。<br>解けなかった問題を復習して、偉大なるperlハッカーを目指してください！
? } elsif ($rank == 4) {
           すこし難しかったでしょうか？しかしこれがPerlを引っ張るトップエンジニアが作った問題です。<br>ぜひ繰り返し挑戦して知識を深めていってください！
? } elsif ($rank == 5) {
           あなたのPerl知識はまだまだこれからのようです。しかし！それだけ伸びしシロがあるということ。<br>何度もチャレンジして確実な知識を習得してくださいね！
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
