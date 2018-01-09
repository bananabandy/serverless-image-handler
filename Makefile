.PHONY: all image package dist clean

all: package

image:
	docker build --tag amazonlinux:python .

package: image
	docker run --rm --volume $(shell pwd):/build amazonlinux:python sh ./deployment/build-s3-dist.sh indiefolio-images

dist: package
	s3cmd put deployment/dist/serverless-image-handler.template s3://indiefolio/solutions/serverless-image-handler.template && s3cmd put deployment/dist/serverless-image-handler.zip s3://indiefolio/solutions/serverless-image-handler.zip && s3cmd put deployment/dist/serverless-image-handler-custom-resource.zip s3://indiefolio/solutions/serverless-image-handler-custom-resource.zip

clean:
	docker rmi --force amazonlinux:python
