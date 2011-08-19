(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)


(create-fontset-from-ascii-font "Inconsolata-15:weight=normal:slant=normal" nil "inconsolata")
(set-fontset-font "fontset-inconsolata"
                  'unicode
                  (font-spec :family "Hiragino Kaku Gothic ProN" :size 15)
                  nil
                  'append)
(add-to-list 'default-frame-alist '(font . "fontset-inconsolata"))
