.PHONY: deploy

init:
	git worktree add -f /tmp/book home-page
	git worktree remove -f /tmp/book
	git worktree add -f /tmp/book home-page

deploy: init
	@echo "====> deploying to github"
	mdbook build
	rm -rf /tmp/book/*
	cp -rp book/* /tmp/book/
	cd /tmp/book && \
		git add -A && \
		git commit -m "deployed on $(shell date) by ${USER}" && \
		git push -f origin home-page