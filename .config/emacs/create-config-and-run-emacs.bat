cd %USERPROFILE%\Documents\git\dotfiles\.emacs.d
emacs --batch -l org .\Emacs.org -f org-babel-tangle
runemacs -q -l %USERPROFILE%\Documents\git\dotfiles\.emacs.d\init-new.el
