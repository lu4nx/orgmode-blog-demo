all:
	LANG=zh_EN.UTF-8 emacs --script Makefile.el
clean:
	rm -rf html/*
	rm -rf ~/.org-timestamps/
