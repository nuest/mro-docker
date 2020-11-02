# A Docker image for Microsoft R Open

[![](https://images.microbadger.com/badges/version/nuest/mro.svg)](https://microbadger.com/images/nuest/mro "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/nuest/mro.svg)](https://microbadger.com/images/nuest/mro "Get your own image badge on microbadger.com") [![Docker Automated build](https://img.shields.io/docker/automated/nuest/mro.svg)](https://hub.docker.com/r/nuest/mro/)

Microsoft R Open, formerly known as Revolution R Open, is an "enhanced R distribution".
You can use this Docker container to give MRO a quick try, i.e. without any impact on your local system, or to run MRO in an online Docker infrastructure.

Homepage: https://mran.microsoft.com/open

For plain R Docker images see [Rocker](https://github.com/rocker-org/rocker). The Rocker images were a great help in creating the MRO images.

> _MRO focusses on speed and reproducibility._

By default, packages are not installed from main CRAN, but from a CRAN repository snapshot.
For more information see https://mran.microsoft.com/documents/rro/reproducibility.
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
docker run -it --rm nuest/mro:4.0.2

# in R
> source("demo.R")
```

Alternatively, you can start regular bash (you can skip the `--user docker` if root rights are needed in the container):

```bash
docker run -it --user docker mro /bin/bash
```

To work with your own data, simply mount a directory on the host computer to the container, see the [Docker documentation on volumes](https://docs.docker.com/engine/userguide/containers/dockervolumes/).

You can install packages etc. in the R session as usual, though for reproducibility it is strongly recommended to do this _only_ in the Dockerfile.

By default, the licenses and terms of use will printed when you start a container, because you had no chance to acknowledge them before downloading the image.
If you want to disable the license printing, you can override the default R command and use one of these options, which will disable the license output (in addition to the options main effect): `-q`, `--silent`, `--quiet`, `--slave`.

```bash
$ docker run -it --rm mro:3.5.3 R --quiet
>
```

## 4.0.2

> _Microsoft R Open 4.0.2 is based on R-4.0.2._
> _The default CRAN mirror has been updated to point to the fixed CRAN repository snapshot from Jul 16, 2020._ [release notes](https://mran.microsoft.com/news#mro402)

The base image is Ubuntu 18.04.
This is also the first MRO image with `Rcpp` preinstalled.
See also [MRO 4.0.2 documentation](https://mran.microsoft.com/releases/4.0.2).

```bash
cd 4.0.2
docker build -t mro:4.0.2 .
```

## 3.5.3

> _Microsoft R Open 3.5.3 is based on R-3.5.3._
> _The default CRAN mirror has been updated to point to the fixed CRAN repository snapshot from Apr 15, 2019._ [release notes](https://mran.microsoft.com/news#mro353)

The base image is Ubuntu 18.04.
This is also the first MRO image with `Rcpp` preinstalled.
See also [MRO 3.5.3 documentation](https://mran.microsoft.com/releases/3.5.3).

```bash
cd 3.5.3
docker build -t mro:3.5.3 .
```

### 3.5.3-verse

A copycat of the `rocker/verse` image, installing `tidyverse` and other often used packages, and adding R Markdown authoring tools (LaTeX etc.).

```bash
# if using only local builds:
#docker tag mro:3.5.3 nuest/mro:3.5.3

cd 3.5.3-verse
docker build -t mro:3.5.3-verse .
```

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

## Contribute

You're welcome to contribute to this repository!
Please be aware of the [Code of Conduct](CODE_OF_CONDUCT.md).

Please open an issue before you start considerable work and do check out existing (closed) issues for possible tasks or previously answered problems.
Feel free to ping the maintainer via Email if you don't get a response within a few weeks.

### Thanks

- Imre Gera [@Hanziness](https://github.com/Hanziness) contributed improved printing of EULAs/licenses ([#12](https://github.com/nuest/mro-docker/pull/12))

## License

[MRO and MKL licenses](https://mran.microsoft.com/faq/#licensing)

The following license applies to the code files in this repository:

Copyright (C) 2020 Daniel Nüst

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
