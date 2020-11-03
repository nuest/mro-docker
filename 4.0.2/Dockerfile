# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

## (Based on https://github.com/rocker-org/rocker/blob/master/r-base/Dockerfile)
## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (e.g. for linked volumes to work properly).
RUN useradd docker \
	&& mkdir /home/docker \
	&& chown docker:docker /home/docker \
	&& addgroup docker staff
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& apt-get update && apt-get install -y locales \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

## Install some useful tools and dependencies for MRO
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		build-essential \
		gfortran \
		# needed on Ubuntu 20.04
		libtinfo5 \
		# MRO dependencies that don't sort themselves out on their own:
		less \
		libgomp1 \
		libpango-1.0-0 \
		libxt6 \
		libsm6 \
		# Needed for Rcpp:
		make \
		g++ \
	&& rm -rf /var/lib/apt/lists/*

# Use major and minor vars to re-use them in non-interactive installation script
ENV MRO_VERSION_MAJOR 4
ENV MRO_VERSION_MINOR 0
ENV MRO_VERSION_BUGFIX 2
ENV MRO_VERSION $MRO_VERSION_MAJOR.$MRO_VERSION_MINOR.$MRO_VERSION_BUGFIX
ENV R_HOME=/opt/microsoft/ropen/$MRO_VERSION/lib64/R

WORKDIR /home/docker

## Donwload and install MRO & MKL, see https://mran.microsoft.com/download https://mran.blob.core.windows.net/install/mro/4.0.2/microsoft-r-open-4.0.2.tar.gz
RUN curl -LO -# https://mran.blob.core.windows.net/install/mro/$MRO_VERSION/Ubuntu/microsoft-r-open-$MRO_VERSION.tar.gz \
	&& tar -xzf microsoft-r-open-$MRO_VERSION.tar.gz
RUN tar -xzf microsoft-r-open-$MRO_VERSION.tar.gz
WORKDIR /home/docker/microsoft-r-open
RUN  ./install.sh -a -u

# Clean up downloaded files
WORKDIR /home/docker
RUN rm microsoft-r-open-*.tar.gz \
	&& rm -r microsoft-r-open

# Print EULAs on every start of R to the user, because they were accepted at image build time
COPY MKL_EULA.txt MKL_EULA.txt
COPY MRO_EULA.txt MRO_EULA.txt
RUN echo '\
if (all(is.na(match(c("-q", "--silent", "--quiet", "--slave"), commandArgs())))) { \n\
	cat("\\n", readLines("/home/docker/MKL_EULA.txt"), "\\n", sep="\\n") \n\
	cat("\\n", readLines("/home/docker/MRO_EULA.txt"), "\\n", sep="\\n") \n\
}' >> /opt/microsoft/ropen/$MRO_VERSION/lib64/R/etc/Rprofile.site

# Add Rcpp because it is widely used
RUN Rscript -e 'install.packages("Rcpp")'

# Use libcurl for download, otherwise problems with tar files
RUN echo 'options("download.file.method" = "libcurl")' >> /opt/microsoft/ropen/$MRO_VERSION/lib64/R/etc/Rprofile.site

# Add demo script
COPY demo.R demo.R

# Add image metadata
LABEL org.label-schema.license="https://mran.microsoft.com/faq/#licensing" \
    org.label-schema.vendor="Microsoft Corporation, Dockerfile provided by Daniel Nüst" \
	org.label-schema.name="Microsoft R Open" \
	org.label-schema.description="Docker images of Microsoft R Open (MRO) with the Intel® Math Kernel Libraries (MKL)." \ 
	org.label-schema.vcs-url=$VCS_URL \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.schema-version="rc1" \
	maintainer="Daniel Nüst <daniel.nuest@uni-muenster.de>"

CMD ["/usr/bin/R", "--no-save"]
