なにこれ？
-------
mikutterのプラグインです．以前つくったfav_bayes.rbのようなもので，いろいろな機械学習を試すことが可能になっています．

どうつかうの？
-------
まず， [jubatus](http://jubat.us/) を準備します．インストールは簡単で，Ubuntu，Debian，CentOSなら [公式ページ](http://jubat.us/ja/quickstart.html) をよく読んでパッケージを落として各OSにあわせた方法でインストールできます．Macの場合は，jubatusのリポジトリからhomebrewのformulaをダウンロードしてインストールするのが楽だと思う．インストールが終わったら，jubaclassifierを起動しておいてください．準備がとりあえずこのリポジトリからおとしてmikutterのプラグインディレクトリへいれる．

    git clone git://github.com/katsyoshi/mikutter-jubatus.git ~/.mikutter/plugin/jubatus
    cd ~/.mikutter/plugin/jubatus
    bundle install --path .bundler

でmikutterを起動すればはじまります．が設定されていないです．まだ設定画面がないので，手動で設定します．mikutter上でAlt-xをおしてコンソールを開き，UserConfig[:jubatus_train] = trueと入力すると学習をはじめます．

todo
-------
* 設定画面
* 学習結果保存
* 推薦

bugs
-------
* タイムアウトがclassifyのときよくおきる


license
-------
LGPL 2.1

