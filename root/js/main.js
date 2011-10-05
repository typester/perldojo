// use all page
dispatcher('.', function () {
  $(function () {
    // ロールオーバー
    $('.btn').meca('hover');
    // 外部リンク
    $('a.external').meca('external');
    // pngfix
    $('.pngfix').meca('pngfix');
    // pngfix（背景画像）
    $('.bgpng').meca('bgpngfix');
    // 高さ揃え
    $('.heightAlign').meca('heightAlign');
    // IE6でposition fixed
    $('.fixed').meca('positionFixed');
    // スムーズスクロール
    $('a[href^="#"]').meca('smoothScroll');
    // OSのクラス追加
    $('body').meca('addOsClass');
    // IEで画像のlabel押せるようにする
    $('label img').meca('labelClickable');
    // active
    $('.hasActive').meca('active');
    //placeholder
    $('input[placeholder], textarea[placeholder]').meca('placeholder');
  });
});

function dispatcher (path, func) {
  dispatcher.path_func = dispatcher.path_func || []
  if (func) return dispatcher.path_func.push([path, func]);
  for(var i = 0, l = dispatcher.path_func.length; i < l; ++i) {
    var func = dispatcher.path_func[i];
    var match = path.match(func[0]);
    match && func[1](match);
  };
};
dispatcher(location.pathname);
