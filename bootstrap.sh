# http://web-salad.hateblo.jp/entry/2014/02/03/000000
# http://d.hatena.ne.jp/Yusk/20130428/1367132028
# http://qiita.com/mountcedar/items/e7603c2eb65661369c3b

# Setup TeX Live
brew install ghostscript
brew cask install basictex
# basictex package will create following directories:
#   /usr/texbin
#   /Library/TeX
#   /usr/local/texlive
#   /usr/local/bin/texdist
#   /etc/paths.d/TeX
#   /Library/PreferencePanes/TeXDistPrefPane-Temp.prefPane
#   /Library/PreferencePanes/TeXDistPrefPane2-Temp.prefPane
#   ~/Library/texlive/

echo "# TeX\nexport PATH=/usr/texbin:$PATH" >> ~/.zshrc

sudo tlmgr update --self --all

# Install Packages
# ptex, ptex2pdf, jfontmaps
sudo tlmgr install \
  jsclasses \
  japanese-otf

# Additional Japanese Fonts
texmflocal=`kpsewhich -var-value=TEXMFLOCAL`
sudo mkdir -p $texmflocal/fonts/opentype/local/hiragino/
cd $texmflocal/fonts/opentype/local/hiragino/
sudo ln -fs "/Library/Fonts/ヒラギノ明朝 Pro W3.otf" ./HiraMinPro-W3.otf
sudo ln -fs "/Library/Fonts/ヒラギノ明朝 Pro W6.otf" ./HiraMinPro-W6.otf
sudo ln -fs "/Library/Fonts/ヒラギノ丸ゴ Pro W4.otf" ./HiraMaruPro-W4.otf
sudo ln -fs "/Library/Fonts/ヒラギノ角ゴ Pro W3.otf" ./HiraKakuPro-W3.otf
sudo ln -fs "/Library/Fonts/ヒラギノ角ゴ Pro W6.otf" ./HiraKakuPro-W6.otf
sudo ln -fs "/Library/Fonts/ヒラギノ角ゴ Std W8.otf" ./HiraKakuStd-W8.otf
sudo mktexlsr
sudo updmap-sys --setoption kanjiEmbed hiragino
kanji-config-updmap hiragino

# jlisting
# http://mytexpert.sourceforge.jp/index.php?Listings#i1f895a0
curl -L "http://sourceforge.jp/frs/redir.php?m=jaist&f=%2Fmytexpert%2F26068%2Fjlisting.sty.bz2" -o jlisting.sty.bz2
bzip2 -d jlisting.sty.bz2
texmfdist=`kpsewhich -var-value=TEXMFDIST`
sudo mv jlisting.sty $texmfdist/tex/latex/listings/
sudo mktexlsr
texconfig rehash
