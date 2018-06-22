TARGETS = js node jpath yate teya descript descript2 typescript jsetter

.PHONY : all
all: $(TARGETS)

.PHONY: $(TARGETS)
$(TARGETS):
	./md2html $@/slides.md > $@/index.html

