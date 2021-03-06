IMAGE=dmgnx/nginx-naxsi

NAXSI_VERSION=0.56
NAXSI_TAG=untagged-afabfc163946baa8036f
NGINX_MAINLINE_VERSION=1.15.0
NGINX_STABLE_VERSION=1.14.0

.PHONY:mainline stable

all: mainline stable

mainline: Dockerfile
	mkdir -p $@
	sed \
			-e 's/@NGINX_VERSION@/$(NGINX_MAINLINE_VERSION)/' \
			-e 's/@NAXSI_VERSION@/$(NAXSI_VERSION)/' \
			-e 's/@NAXSI_TAG@/$(NAXSI_TAG)/' \
			$< \
		> $@/$<
	cp docker-entrypoint.sh $@
	cp nginx.conf $@
	cp nginx.vh.default.conf $@

stable: Dockerfile
	mkdir -p $@
	sed \
			-e 's/@NGINX_VERSION@/$(NGINX_STABLE_VERSION)/' \
			-e 's/@NAXSI_VERSION@/$(NAXSI_VERSION)/' \
			-e 's/@NAXSI_TAG@/$(NAXSI_TAG)/' \
			$< \
		> $@/$<
	cp docker-entrypoint.sh $@
	cp nginx.conf $@
	cp nginx.vh.default.conf $@

update:
	sed -i \
		-e 's/^\(NAXSI_VERSION=\)\([0-9]\+\(\.\|$$\)\)\+/\1$(NAXSI_VERSION)/' \
		-e 's/^\(NAXSI_TAG=\)\([0-9a-zA-Z.-]\)\+/\1$(NAXSI_TAG)/' \
		-e 's/^\(NGINX_MAINLINE_VERSION=\)\([0-9]\+\(\.\|$$\)\)\+/\1$(NGINX_MAINLINE_VERSION)/' \
		-e 's/^\(NGINX_STABLE_VERSION=\)\([0-9]\+\(\.\|$$\)\)\+/\1$(NGINX_STABLE_VERSION)/' \
	   	Makefile
	sed -i \
		-e "s/\`$(shell grep '`mainline`' README.md | cut -d'`' -f2)\`/\`$(NGINX_MAINLINE_VERSION)\`/" \
		-e "s/\`$(shell grep '`stable`' README.md | cut -d'`' -f2)\`/\`$(NGINX_STABLE_VERSION)\`/" \
		README.md
