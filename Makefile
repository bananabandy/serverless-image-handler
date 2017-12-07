.PHONY: all image package dist clean

all: package

image:
	docker build --tag amazonlinux:python .

package: image
	docker run --rm --volume ${PWD}:/build amazonlinux:python sh ./deployment/build-s3-dist.sh testimgresize

dist: package
	cp .s3cfg ~/. && s3cmd put deployment/dist/serverless-image-handler.zip s3://testimgresize/serverless-image-handler.zip && s3cmd put deployment/dist/serverless-image-handler-custom-resource.zip s3://testimgresize/serverless-image-handler-custom-resource.zip

clean:
	docker rmi --force amazonlinux:python
