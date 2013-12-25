all :
	./md2html teya/slides.md > teya/index.html
	./md2html yate/slides.md > yate/index.html
	./md2html descript/slides.md > descript/index.html
	./md2html node/slides.md > node/index.html

.PHONY : all

