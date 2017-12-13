FROM amazonlinux

RUN echo 'alias ll="ls -ltha"' >> ~/.bashrc

WORKDIR /tmp

RUN yum-config-manager --enable epel && \
    yum update -y && \
    curl http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm --output epel-release-7-11.noarch.rpm && \
    rpm -Uvh epel-release*rpm && \
    yum groupinstall "Development Tools" -y && \
    yum install gifsicle autoconf automake bzip2 cmake freetype-devel gcc-c++ libtool make mercurial pkgconfig zlib-devel git s3cmd ffmpeg libtiff-dev libjasper-dev libgtk2.0-dev webp libpng-devel libcurl-devel gcc python27 python27-devel python27-setuptools python27-pip python27-wheel libjpeg-devel zip libjpeg-turbo-devel.x86_64 libjpeg-turbo-utils.x86_64 libtiff-devel.x86_64 libpng-devel.x86_64 jasper-devel.x86_64 -y && \
    pip install --upgrade pip && \
    env PATH=$PATH && \
    alias sudo='sudo env PATH=$PATH' && \
    pip install --upgrade setuptools && \
    pip install --upgrade virtualenv

#sudo yum-config-manager --enable epel
#sudo yum update -y
#sudo yum install git libpng-devel libcurl-devel gcc python-devel libjpeg-devel -y
#sudo pip install --upgrade pip
#alias sudo='sudo env PATH=$PATH'
#sudo  pip install --upgrade setuptools
#sudo pip install --upgrade virtualenv
WORKDIR /build
