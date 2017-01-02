(require 'package)

;;; 后面需要加载三方库，所以先初始化包管理器
;; (package-initialize)
;; (setq package-enable-at-startup nil)

;; 如果需要高亮代码
;; (require 'htmlize)

(require 'org)
(require 'ox-html)
(require 'ox-publish)

;; HTML模板目录
(defvar *site-template-directory* "templates")

(defun read-html-template (template-file)
  (with-temp-buffer
    (insert-file-contents (concat *site-template-directory* "/" template-file))
    (buffer-string)))

(let ((org-publish-project-alist
       '(("images"
          :base-directory "src"
          :base-extension "jpg\\|png\\|c\\|gif"
          :publishing-directory "html"
          :recursive t
          :publishing-function org-publish-attachment)
         ("static"
          :base-directory "static"
          :base-extension "jpg\\|png\\|c\\|gif\\|css\\|js"
          :publishing-directory "html/static"
          :recursive t
          :publishing-function org-publish-attachment)
         ("wiki-src"
          :base-directory "src"
          :base-extension "org"
          :publishing-directory "html"
          :recursive t
          :publishing-function org-html-publish-to-html
          :headline-levels 4)
         ("rss.xml"
          :base-directory "src"
          :base-extension "xml"
          :publishing-directory "html"
          :publishing-function org-publish-attachment)
         ("wiki-project" :components ("wiki-src" "static" "rss.xml" "images"))))
      ;;; 设置CSS样式
      (org-html-head-extra "<link rel=\"stylesheet\" type=\"text/css\" href=\"/static/css/default.css\" />")
      ;;; 取消默认的CSS
      (org-html-head-include-default-style nil)
      ;;; 取消默认的Javascript代码
      (org-html-head-include-scripts nil)
      ;;; XXX 用org-html-head可以设置<head>部分
      (org-html-preamble (read-html-template "preamble.html"))
      (org-html-postamble (read-html-template "postamble.html")))
  ;;; 设置Mathjax库的路径
  (add-to-list 'org-html-mathjax-options '(path "https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_HTML"))
  (org-publish-project "wiki-project"))
