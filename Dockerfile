FROM amazonlinux

RUN echo 'alias ll="ls -ltha"' >> ~/.bashrc

ARG NUM_CORES=2

WORKDIR /tmp

RUN yum clean all && \
    yum makecache && \
    yum update -y && \
    yum groups mark convert -y && \
    yum upgrade -y && \
    yum groupupdate "Development Tools" -y && \
    yum install epel-release -y && \
    yum install --upgrade autoconf git s3cmd ffmpeg libtiff-dev libjasper-dev libgtk2.0-dev webp libpng-devel libcurl-devel gcc python27 python27-devel python27-setuptools python27-pip python27-wheel libjpeg-devel zip libjpeg-turbo-devel.x86_64 libjpeg-turbo-utils.x86_64 libtiff-devel.x86_64 libpng-devel.x86_64 jasper-devel.x86_64 wget optipng pngcrush gifsicle libjpeg* pngquant ImageMagick-devel -y && \
    pip install --upgrade pip && \
    env PATH=$PATH && \
    alias sudo='sudo env PATH=$PATH' && \
    pip install --upgrade setuptools && \
    pip install --upgrade virtualenv

RUN which pngquant

WORKDIR /build
