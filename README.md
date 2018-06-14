# A Docker image for Microsoft R Open

Microsoft R Open, formerly known as Revolution R Open, is an "enhanced R distribution". You can use this Docker container to give it a quick try.

Homepage: https://mran.revolutionanalytics.com/open/

For plain R Docker images see [Rocker](https://github.com/rocker-org/rocker). The Rocker images were a great help in creating the MRO images.

_MRO focusses on speed and reproducibility._
By default, packages are not installed from main CRAN, but from a CRAN repository snapshot. For more information see https://mran.revolutionanalytics.com/documents/rro/reproducibility/.
MRO promises better speed by using special multi-threaded math libraries, replacing default R's BLAS/LAPACK libraries.

**Important**: By running this container you accept the MKL and MRO licenses.

Image metadata can be explored at Microbadger: [https://microbadger.com/images/nuest/mro](https://microbadger.com/images/nuest/mro)

## Run container

```bash
docker run --user docker nuest/mro
```

This downloads the latest build of the image from [Docker Hub](https://hub.docker.com/r/nuest/mro/).
In the container, R is automatically started. When you exit R, the container is automatically stopped.

Optionally you can use [tags](https://hub.docker.com/r/nuest/mro/tags/) for specific versions of MRO and execute a demo script:

```bash
docker run -it --rm nuest/mro:v3.4.4

# in R
> source("demo.R")
```

Alternatively, you can start regular bash (you can skip the `--user docker` if root rights are needed in the container):

```bash
docker run -it --user docker mro /bin/bash
```

To work with your own data, simply mount a directory on the host computer to the container, see the [Docker documentation on volumes](https://docs.docker.com/engine/userguide/containers/dockervolumes/).

You can install packages etc. in the R session as usual, though for reproducibility it is strongly recommended to do this _only_ in the Dockerfile.

## 3.5.0

> _Microsoft R Open 3.5.0 is based on R-3.5.0._
> _The default CRAN mirror has been updated to point to the fixed CRAN repository snapshot from June 01, 2018._ [release notes](https://mran.microsoft.com/news#mro350)

The base image is Ubuntu 16.04.
See also [MRO 3.5.0 documentation](https://mran.microsoft.com/releases/3.5.0).

```bash
cd 3.5.0
docker build -t mro:3.5.0 .
```

## 3.4.4

> _The CRAN repository points to a snapshot from May 1, 2017._
> _This means that every user of Microsoft R Open has access to the same set of CRAN package versions._ [source](https://mran.microsoft.com/documents/rro/installation/#revorinst-lin)

The base image is Ubuntu 16.04.
See also [MRO 3.4.4 documentation](https://mran.microsoft.com/releases/3.4.4).

Build the image:

```bash
cd 3.4.4
docker build -t mro:3.4.4 .
```

## 3.2.5

See installation instructions: https://mran.microsoft.com/archives/install-doc/mro-3.2.5/
The base image is Ubuntu 14.04.
The interactive installation script of the MKL download package was adapted in the file `RevoMath_noninteractive-install.sh` to not require any user input.
See also [MRO 3.2.5 documentation](https://mran.microsoft.com/archives/mro-3.2.5) (archived).

Build the image:

```bash
cd 3.2.5
docker build -t mro:3.2.5 .
```

## Automatic builds

The automatic builds are configured to run on the `master` branch and each Dockerfile, e.g. `/3.4.0/Dockerfile` is tagged with the full release version, e.g. `3.4.0`. Other semantic version tags are added automatically by build hooks based on the directory names, e.g. `latest`, `3`, and `3.4` for our example.

## License

[MRO and MKL licenses](https://mran.microsoft.com/faq/#licensing)

The following license applies to the code files in this repository:

Copyright (C) 2017 Daniel Nüst

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
