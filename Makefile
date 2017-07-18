dist-clean:
	rm -rf dist
	rm -f burrow-alpine-linux-*.tar.gz
	rm -f burrow-linux-*.tar.gz

dist: dist-clean
	mkdir -p dist/alpine-linux/amd64 && GOOS=linux GOARCH=amd64 go build -ldflags "$(LDFLAGS)" -a -tags netgo -installsuffix netgo -o dist/alpine-linux/amd64/burrow
	mkdir -p dist/linux/amd64 && GOOS=linux GOARCH=amd64 go build -ldflags "$(LDFLAGS)" -o dist/linux/amd64/burrow
	mkdir -p dist/linux/armel && GOOS=linux GOARCH=arm GOARM=5 go build -ldflags "$(LDFLAGS)" -o dist/linux/armel/burrow
	mkdir -p dist/linux/armhf && GOOS=linux GOARCH=arm GOARM=6 go build -ldflags "$(LDFLAGS)" -o dist/linux/armhf/burrow

release: dist
	tar -cvzf /tmp/burrow-dist/burrow-alpine-linux-amd64-$(TAG).tar.gz -C dist/alpine-linux/amd64 burrow
	tar -cvzf /tmp/burrow-dist/burrow-linux-amd64-$(TAG).tar.gz -C dist/linux/amd64 burrow
	tar -cvzf /tmp/burrow-dist/burrow-linux-armel-$(TAG).tar.gz -C dist/linux/armel burrow
	tar -cvzf /tmp/burrow-dist/burrow-linux-armhf-$(TAG).tar.gz -C dist/linux/armhf burrow

build:
	docker build -t burrow-build-img:latest -f build.Dockerfile ./
	docker run --rm -e TAG=${TAG}  -v ${PWD}:/tmp/burrow-dist burrow-build-img:latest make release