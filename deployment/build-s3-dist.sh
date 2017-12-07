#!/bin/bash

# This assumes all of the OS-level configuration has been completed and git repo has already been cloned
#sudo yum-config-manager --enable epel
#sudo yum update -y
#sudo yum install git libpng-devel libcurl-devel gcc python-devel libjpeg-devel -y
#sudo pip install --upgrade pip
#alias sudo='sudo env PATH=$PATH'
#sudo  pip install --upgrade setuptools
#sudo pip install --upgrade virtualenv

# This script should be run from the repo's deployment directory
# cd deployment
# ./build-s3-dist.sh source-bucket-base-name
# source-bucket-base-name should be the base name for the S3 bucket location where the template will source the Lambda code from.
# The template will append '-[region_name]' to this bucket name.
# For example: ./build-s3-dist.sh solutions
# The template will then expect the source code to be located in the solutions-[region_name] bucket

# Check to see if input has been provided:
if [ -z "$1" ]; then
    echo "Please provide the base source bucket name where the lambda code will eventually reside.\nFor example: ./build-s3-dist.sh solutions"
    exit 1
fi

# Build source
echo "Staring to build distribution"
echo "export deployment_dir=`pwd`"
export deployment_dir=`pwd`/deployment
echo "mkdir -p $deployment_dir/dist"
mkdir -p $deployment_dir/dist
echo "cp -f $deployment_dir/serverless-image-handler.template $deployment_dir/dist/."
cp -f $deployment_dir/serverless-image-handler.template $deployment_dir/dist/.
echo "Updating code source bucket in template with $1"
replace="s/%%BUCKET_NAME%%/$1/g"
echo "sed -i '' -e $replace $deployment_dir/dist/serverless-image-handler.template"
sed -i '' -e $replace $deployment_dir/dist/serverless-image-handler.template
echo "Creating UI ZIP file"
cd $deployment_dir/../source/ui
zip -q -r9 $deployment_dir/dist/serverless-image-handler-ui.zip *
echo "Building custom resource package ZIP file"
cd $deployment_dir/dist
pwd
echo "virtualenv env"
virtualenv env
echo "source env/bin/activate"
source env/bin/activate
echo "pip install $deployment_dir/../source/image-handler-custom-resource/. --target=$deployment_dir/dist/env/lib/python2.7/site-packages/"
pip install $deployment_dir/../source/image-handler-custom-resource/. --target=$deployment_dir/dist/env/lib/python2.7/site-packages/
cd $deployment_dir/dist/env/lib/python2.7/site-packages/
zip -r9 $deployment_dir/dist/serverless-image-handler-custom-resource.zip *
cd $deployment_dir/dist
zip -q -d serverless-image-handler-custom-resource.zip pip*
zip -q -d serverless-image-handler-custom-resource.zip easy*
rm -rf env
echo "Building Image Handler package ZIP file"
cd $deployment_dir/dist
pwd
echo "virtualenv env"
virtualenv env
echo "source env/bin/activate"
source env/bin/activate
pwd
echo "pip install $deployment_dir/../source/image-handler/. --target=$VIRTUAL_ENV/lib/python2.7/site-packages/"
pip install $deployment_dir/../source/image-handler/. --target=$VIRTUAL_ENV/lib/python2.7/site-packages/
echo "pip install -r $deployment_dir/../source/image-handler/requirements.txt --target=$VIRTUAL_ENV/lib/python2.7/site-packages/"
pip install -r $deployment_dir/../source/image-handler/requirements.txt --target=$VIRTUAL_ENV/lib/python2.7/site-packages/
cd $VIRTUAL_ENV
pwd
echo "git clone git://github.com/kohler/gifsicle.git gifsicle_s"
git clone git://github.com/kohler/gifsicle.git gifsicle_s
cd gifsicle_s
pwd
echo "autoreconf -i"
autoreconf -i
echo "./configure --prefix=$VIRTUAL_ENV"
./configure LDFLAGS="-static" --prefix=$VIRTUAL_ENV
echo "make"
make
echo "make install"
make install
echo "cp bin/gifsicle $VIRTUAL_ENV"
cp -f bin/gifsicle $VIRTUAL_ENV
cd $VIRTUAL_ENV
pwd
echo "git clone git://github.com/pornel/pngquant.git pngquant_s"
git clone git://github.com/pornel/pngquant.git pngquant_s
cd pngquant_s
pwd
echo "./configure "
./configure LDFLAGS="-static"
echo "make"
make
echo "cp pngquant $VIRTUAL_ENV"
cp -f pngquant $VIRTUAL_ENV
cd $VIRTUAL_ENV/lib/python2.7/site-packages
pwd
echo "zip -q -r9 $VIRTUAL_ENV/../serverless-image-handler.zip *"
zip -q -r9 $VIRTUAL_ENV/../serverless-image-handler.zip *
cd $VIRTUAL_ENV
pwd
echo "zip -q -g $VIRTUAL_ENV/../serverless-image-handler.zip pngquant"
zip -q -g $VIRTUAL_ENV/../serverless-image-handler.zip pngquant
echo "zip -q -g $VIRTUAL_ENV/../serverless-image-handler.zip gifsicle"
zip -q -g $VIRTUAL_ENV/../serverless-image-handler.zip gifsicle
cd ..
zip -q -d serverless-image-handler.zip pip*
zip -q -d serverless-image-handler.zip easy*
echo "List files $VIRTUAL_ENV"
ls -l $VIRTUAL_ENV
echo "Clean up build material"
#rm -rf $VIRTUAL_ENV
echo "Completed building distribution"