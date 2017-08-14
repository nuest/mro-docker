#!/bin/bash
# Based on file RevoMath.sh from MKL release https://mran.revolutionanalytics.com/install/mro/3.2.3/RevoMath-3.2.3.tar.gz

PWDD=`pwd`
RRO_VERSION_MAJOR=$MRO_VERSION_MAJOR
RRO_VERSION_MINOR=$MRO_VERSION_MINOR
R_PATH="noop"
LIB_PATH=
ETC_PATH=

getOption() {
        while [ 1 ]
        do
                printOptions
#                read ans
#                if [ "1" = $ans ] ; then
#					if [ ! "--nolicense" = "$1" ] ; then
#						confirmLicense
#					fi
                printLicense
                installMklLibraries
#                    break
#                elif [ "2" = $ans ] ; then
#                    uninstallMklLibraries
#                    break
#
#                elif [ "3" = $ans ] ; then
#                    echo "Exiting now..."
#                    echo "Good bye"
                    exit 0
#                else
#                    echo "Error: The number entered was not recognized."
#                echo "Please enter a number from 1 - 3."
#                echo ""
#                    continue
#                fi
        done
}

printLicense() {
        echo "#"
        echo "########## Continuing automatically with 1! ##########"
        echo "#"
        cat mklLicense.txt
        echo "#"
        echo "########## License agreement implicitly accepted! ##########"
        echo "#"
}


printOptions() {
        echo "**********************************************************************"
        echo "*"
        echo "*     Which action do you want to perform?"
        echo "*"
        echo "*     1. Install MKL"
        echo "*     2. Uninstall MKL"
        echo "*     3. Exit utility"
        echo "*"
        echo "*     (Ex: enter 1 to install MKL to RRO ${RRO_VERSION_MAJOR}.${RRO_VERSION_MINOR})"
        echo "*"
        echo "*     Enter the corresponding number now: "
        echo "*"
        echo "**********************************************************************"
}

checkPreviousMklInstall() {
if [ -e $LIB_PATH/libmkl_core.so ]; then
echo "A previous installation of MKL was detected. To reinstall, you must first uninstall the current MKL installation. Exiting now..."
exit 0
fi
}

copyLinkMklLibraries() {
## ensure libRlapack.so and libRblas.so exist
if [ -e $LIB_PATH/libRlapack.so ]; then
   if [ -e $LIB_PATH/libRblas.so ]; then
       mv $LIB_PATH/libRlapack.so $LIB_PATH/libRlapack.so.keep
       mv $LIB_PATH/libRblas.so $LIB_PATH/libRblas.so.keep
       ## copy mkl libraries
       cp $PWDD/mkl/libs/* $LIB_PATH
       ## set env variables in Rprofile.site
       sed -i -e '1 a\
Sys.setenv("MKL_INTERFACE_LAYER"="GNU,LP64")\
Sys.setenv("MKL_THREADING_LAYER"="GNU")\
' $ETC_PATH/Rprofile.site
       ## install RevoUtilsMath
       $R_PATH CMD INSTALL $PWDD/RevoUtilsMath.tar.gz  > mkl_log.txt 2>&1
       echo "MKL was successfully installed for Microsoft R Open ${RRO_VERSION_MAJOR}.${RRO_VERSION_MINOR}."
       echo "Exiting now..."
       exit 0
   fi
fi
echo "Error: This does not look like a valid Microsoft R Open installation."
echo "libRlapack.so and/or libRblas.so do not exist in ${LIB_PATH}"
exit 0
}

checkForValidRROInstallation() {
## check RRO installation
if [ ! -e /usr/bin/R ]; then
     ## check default path
    if [ ! -e /usr/lib64/MRO-$MRO_VERSION/R-$MRO_VERSION/lib64/R/bin/R ]; then
        ## prompt user for valid RRO installation
        echo "Could not find a valid installation of Microsoft R Open ${RRO_VERSION_MAJOR}.${RRO_VERSION_MINOR}."
        echo "Exiting now..."
        exit 1
    else
        R_PATH=/usr/lib64/MRO-$MRO_VERSION/R-$MRO_VERSION/lib64/R/bin/R
    fi
fi
if [ ! -e $R_PATH ]; then
    ## get full path
    TEMP_PATH=`ls -l /usr/bin/R`
    R_PATH=`echo $TEMP_PATH | awk -F "[ >]" '{print $NF}'`
fi

## get version
RRO=`echo "print(Revo.version)" | $R_PATH -q --no-save`
MAJOR=`echo $RRO  | awk -F" " '{
for(i=1;i<=NF;i++){
if($i~/major/) {
{print $(i+1)}
exit
}
}}'`

MINOR=`echo $RRO  | awk -F"[ -]" '{
for(i=1;i<=NF;i++){
if($i~/minor/) {
{print $(i+1)}
exit
}
}}'`

    if [ "$MAJOR" = $RRO_VERSION_MAJOR ] && [ "$MINOR" = $RRO_VERSION_MINOR ]; then
        ## get lib path
        PATH_LEN=${#R_PATH}
        LIB_PATH_LEN=`expr $PATH_LEN - 6`
        LIB_PATH=${R_PATH:0:$LIB_PATH_LEN}
        ETC_PATH=$LIB_PATH/etc
        LIB_PATH=$LIB_PATH/lib
        if [ -e $LIB_PATH ]; then
            return 0
        fi
    else
        echo "Error: Microsoft R Open was detected; however, it is not the correct version."
        echo "This utility is for version ${RRO_VERSION_MAJOR}.${RRO_VERSION_MINOR} only.  Exiting now........."
        echo ""
        exit 1
    fi
}

installMklLibraries() {
checkForValidRROInstallation
if [ -e $LIB_PATH ]; then
    checkPreviousMklInstall
    copyLinkMklLibraries
fi
}

uninstallMklLibraries() {
checkForValidRROInstallation
if [ -e $LIB_PATH ]; then
    if [ -e $LIB_PATH/libmkl_core.so ]; then
        rm $LIB_PATH/libmkl*
        rm $LIB_PATH/libiomp5.so
        rm $LIB_PATH/libRblas.so
        rm $LIB_PATH/libRlapack.so
        mv $LIB_PATH/libRblas.so.keep $LIB_PATH/libRblas.so
        mv $LIB_PATH/libRlapack.so.keep $LIB_PATH/libRlapack.so
        ## remove env variables from Rprofile.site
        sed -i -e '/MKL_INTERFACE_LAYER/d' $ETC_PATH/Rprofile.site
        sed -i -e '/MKL_THREADING_LAYER/d' $ETC_PATH/Rprofile.site
        echo "remove.packages('RevoUtilsMath')" | $R_PATH -q --vanilla --no-save > mkl_log.txt 2>&1
        echo "MKL was successfully uninstalled from $LIB_PATH"
        echo "Exiting now..."
        exit 0
    else
        echo "MKL was not installed in $LIB_PATH"
        exit 0
    fi
fi
echo "MKL could not be found."
exit 1
}
confirmLicense() {
more mklLicense.txt

echo ""
read -p "Do you accept the terms in the license agreement (y or n)? "
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "The license agreement was NOT accepted."
    echo "Exiting now..."
    exit 0
fi

}

#if [ ! "--nolicense" = "$1" ] ; then
#confirmLicense
#fi
echo "mkl_log" > mkl_log.txt 2>&1
getOption
