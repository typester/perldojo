? extends 'common/base';

? my $q = $c->stash->{q};

? block content => sub {

<div id="examContainer">

  <!-- [[[ HEADER-AREA ]]] -->
  <div id="examHeader">
    <h1 class="hidden">Perl道場</h1>
  <!-- / #examHeader --></div>
  <!-- / [[[ HEADER-AREA ]]] -->

  <div class="examContent group">
    <div class="blockJudge">
? if ($c->stash->{right}) {
    <p>
      <img src="/img/exam/img_correct_01.png" width="179" height="179" alt="" />
    </p>
    <p class="message">正解！おめでとうございます！</p>
? } else {
    <p>
      <img src="/img/exam/img_incorrect_01.png" width="162" height="167" alt="" />
    </p>
    <p class="message">残念！</p>
? }
  </div>
    <h3 class="ttlStyle2">正解は <?= encoded_string $q->answer ?> でした</h3>
    <h4 class="ttlStyle3">解説</h4>
    <?= encoded_string $q->explanation ?>

    <div class="blockQuestionInformation">
      <div>
        <table>
          <tr>
            <th scope="row">正答率</th>
            <td><p class="percent"><img src="/img/exam/img_meter.png" height="13" /></p>30%</td>
          </tr>
          <tr>
            <th scope="row">この問題の評価</th>
            <td><img src="/img/exam/btn_plus_01.png" width="29" height="20" alt="" class="btnPlus" /><img src="/img/exam/ico_plus_01.png" width="15" height="20" alt="" /></td>
          </tr>
        </table>
        <p class="author"><img src="https://secure.gravatar.com/avatar/fbc6511bcc0649366086c0445fb456d3?s=140&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png" width="30" height="30" alt="" /><?= $q->author ?></p>
      </div>
    </div>
    <div><a href="/question" class="btnStyle1">Next</a></div>
    <!-- / .examContent --></div>

  <!-- [[[ FOOTER-AREA ]]] -->
  <div id="footer">
    <p class="copyright vcard">Copyright &#169; <a href="http://www.kayac.com/" title="株式会社KAYAC（カヤック）古都鎌倉から新しい価値感のサービスを次々にリリースする面白法人" class="external fn org url">KAYAC Inc. </a> All Rights Reserved.</p>
    <!-- / #footer --></div>
  <!-- / [[[ FOOTER-AREA ]]] -->

<!-- / #examContainer --></div>
? };
