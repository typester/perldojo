? extends 'common/base';
? my $storage = $c->stash->{storage};

? block content => sub {
<div id="container">

<!-- [[[ HEADER-AREA ]]] -->
<div id="header">
  <div class="headerBg">
    <div id="socialBtn">
      <ul>
        <li class="facebook">
          <div id="fb-root"></div>
          <script>(function(d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) {return;}
            js = d.createElement(s); js.id = id;
            js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
            fjs.parentNode.insertBefore(js, fjs);
            }(document, 'script', 'facebook-jssdk'));</script>
          <div class="fb-like" data-send="false" data-layout="button_count" data-width="90" data-show-faces="true"></div>
        </li>
        <li class="hatebu"><a href="http://b.hatena.ne.jp/entry/" class="hatena-bookmark-button" data-hatena-bookmark-layout="standard" title="このエントリーをはてなブックマークに追加"><img src="http://b.st-hatena.com/images/entry-button/button-only.gif" alt="このエントリーをはてなブックマークに追加" width="20" height="20" style="border: none;"></a><script type="text/javascript" src="http://b.st-hatena.com/js/bookmark_button.js" charset="utf-8" async="async"></script></li>
        <li class="stumbleupon"><script src="http://www.stumbleupon.com/hostedbadge.php?s=4"></script></li>
        <li class="twitter"><a href="https://twitter.com/share" class="twitter-share-button" data-text="門下生募集中！PerlエンジニアがつくるPerlエンジニアのためのPerlの検定試験「Perl道場」入門条件はPerlが好きなこと
#perldojo" data-count="horizontal">Tweet</a><script type="text/javascript" src="//platform.twitter.com/widgets.js"></script></li>
        <li class="plusone"><g:plusone size="medium"></g:plusone></li>
      </ul>
      <!-- / #socialBtn --></div>
    <div class="title">
      <h1 class="hidden">Perl道場</h1>
      <p>PerlエンジニアがPerlエンジニアのためにつくる<br>Perl検定試験「Perl道場」へようこそ。<br>入門条件はただひとつ。「Perlが好きであること」。<br>あのPerlエンジニアが出題した問題に挑んでみよう！</p>
      <a href="/question"><img src="/img/btn_entry_01.png" width="385" height="153" alt="テストを受ける" class="btn"></a>
    </div>
    <!-- / #headerBg --></div>
  <!-- / #header --></div>
<!-- / [[[ HEADER-AREA ]]] -->

<!-- [[[ CONTENT-AREA ]]] -->
<div id="content" class="group">

  <!-- [ MAIN-CONTENT-AREA ] -->
  <div class="ranking">
    <h2 class="rankingHeader">良問出題ランキング</h2>
? my $n = 0;
? for my $author (@{ $c->stash->{by_s} }) {
?   $n++;
    <p class="rank<?= $n ?>"><img src="<?= $c->uri_for('/icon', $author->{name}) ?>" width="42" height="42"><span class="username"><a href="<?= $storage->get_author_uri($author->{name}) ?>"><?= $author->{name} ?></a></span><span class="point"><?= $author->{value} ?><span class="pt">pt</span></span></p>
? }
    <!-- / #main --></div>
  <!-- [ MAIN-CONTENT-AREA ] -->

  <!-- [ SUB-CONTENT-AREA ] -->
  <div class="ranking right">
    <h2 class="rankingHeader">難問出題ランキング</h2>
? $n = 0;
? for my $author (@{ $c->stash->{by_p} }) {
?   $n++;
    <p class="rank<?= $n ?>"><img src="<?= $c->uri_for('/icon', $author->{name}) ?>" width="42" height="42"><span class="username"><a href="<?= $storage->get_author_uri($author->{name}) ?>"><?= $author->{name} ?></a></span><span class="point"><?= 100 - $author->{value} ?><span class="pt">pt</span></span></p>
? }
    <!-- / #sub --></div>
  <!-- / [ SUB-CONTENT-AREA ] -->

  <p class="entrybtn"><a href="https://github.com/kayac/perldojo/blob/master/README.md#files"><img src="img/btn_entry_02.png"></a></p>

  <div class="socialTool">
    <div class="blockStream">
      <script src="http://widgets.twimg.com/j/2/widget.js"></script>
      <script>
        new TWTR.Widget({
          version: 2,
          type: 'search',
          search: 'perl',
          interval: 30000,
          title: 'perl_dojo',
          subject: 'Perl道場',
          width: 960,
          height: 210,
          theme: {
            shell: {
              background: '#577482',
              color: '#ffffff'
            },
            tweets: {
              background: '#edecde',
              color: '#444444',
              links: '#000000'
            }
          },
          features: {
            scrollbar: false,
            loop: true,
            live: true,
            hashtags: true,
            timestamp: true,
            avatars: true,
            toptweets: true,
            behavior: 'default'
          }
        }).render().start();
      </script>
    </div>
  </div>


  <div class="socialTool">
    <div id="fb-root"></div>
    <script>(function(d, s, id) {
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) {return;}
      js = d.createElement(s); js.id = id;
      js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
      fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));
    </script>

    <div class="fb-like" data-href="perldojo.org" data-send="true" data-width="450" data-show-faces="true"></div>
  </div>

  <!-- / #content --></div>
<!-- / [[[ CONTENT-AREA ]]] -->

<!-- [[[ FOOTER-AREA ]]] -->
<div id="footer">

  <p class="copyright vcard">Copyright &#169; <a href="http://www.kayac.com/" title="株式会社KAYAC（カヤック）古都鎌倉から新しい価値感のサービスを次々にリリースする面白法人" class="external fn org url">KAYAC Inc. </a> All Rights Reserved.</p>
  <!-- / #footer --></div>
<!-- / [[[ FOOTER-AREA ]]] -->

<!-- / #container --></div>
? }

