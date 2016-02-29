# A Docker image for Microsoft R Open

Microsoft R Open, formerly known as Revolution R Open, is an "enhanced R distribution". You can use this Docker container to give it a quick try.

Homepage: https://mran.revolutionanalytics.com/open/

For plain R Docker images see [Rocker](), which were a great help in creating these images.

MRO focusses on speed and reproducibility. By default, packages are not installed from main CRAN, but from a CRAN repository snapshot. For more information see https://mran.revolutionanalytics.com/documents/rro/reproducibility/. MRO promises better speed by using special multitreaded math libraries, replacing default R's BLAS/LAPACK libraries.

**Important**: By running this container you accept the MKL license, see file `mklLicense.txt`. The interactive installation script of the [MKL download package](https://mran.revolutionanalytics.com/download/) was adapted in `RevoMath_noninteractive-install.sh` to not require any user input.


## Run container

`docker run --user docker nuest/docker-mro`

This downloads the latest build of the image from [Docker Hub](https://hub.docker.com/r/nuest/docker-mro/).


## Build image and run it

Build the iamge:

`docker build -t mro .`

Run the image:

`docker run -it --user docker mro`

(You can skip the --user docker if root rights are needed in the container.)

In the container, R is automatically started, and execute a demo script:

`source("demo.R")`

Alternatively, you can start regular bash:

`docker run -it --user docker mro /bin/bash`

When you exit R, the container is automatically stopped.

To work with your own data, simply mount a directory on the host computer to the container, see the [Docker documentation on volumes](https://docs.docker.com/engine/userguide/containers/dockervolumes/).

You can install packages etc. in the R session as usual, though for reproducibility it is strongly recommended to do this _only_ in the Dockerfile.


## Tasks / Ideas / Next steps

* include something similar than the `install2.R` script so that packages can properly be installed
* Try out the benchmarks: https://mran.revolutionanalytics.com/documents/rro/multithread/
* Create an image extending rocker/base-r for direct comparison
* Pre-configure as recommended here: https://mran.revolutionanalytics.com/documents/rro/reproducibility/doc-research/


## License

Copyright (C) 2016 Daniel Nüst

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
