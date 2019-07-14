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
FROM ubuntu:16.04

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

# Temp folder for R
ENV TMPDIR /home/docker/R/RTMP
RUN mkdir -p $TMPDIR && chown docker -R $TMPDIR

# Additional packages should be installed here:
ENV R_LIBS_USER /home/docker/R/packages
RUN mkdir -p $R_LIBS_USER && chown docker -R $R_LIBS_USER

## Install some useful tools and dependencies for MRO
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		# MRO dependencies that don't sort themselves out on their own:
		less \
		libgomp1 \
		libpango-1.0-0 \
		libxt6 \
		libsm6 \
		# required for installing most R packages with install.packages()
		build-essential \
		r-base-dev \
		libcurl4-gnutls-dev \
		libxml2-dev \
		libssl-dev \
		git \
	&& rm -rf /var/lib/apt/lists/* \
	&& chmod a+rwx /tmp

# Use major and minor vars to re-use them in non-interactive installation script
ENV MRO_VERSION_MAJOR 3
ENV MRO_VERSION_MINOR 5
ENV MRO_VERSION_BUGFIX 3
ENV MRO_VERSION $MRO_VERSION_MAJOR.$MRO_VERSION_MINOR.$MRO_VERSION_BUGFIX

WORKDIR /home/docker

## Donwload and install MRO & MKL, see https://mran.microsoft.com/download https://mran.blob.core.windows.net/install/mro/3.5.3/ubuntu/microsoft-r-open-3.5.3.tar.gz
RUN curl -LO -# https://mran.blob.core.windows.net/install/mro/$MRO_VERSION/ubuntu/microsoft-r-open-$MRO_VERSION.tar.gz \
	&& tar -xzf microsoft-r-open-$MRO_VERSION.tar.gz
WORKDIR /home/docker/microsoft-r-open
RUN  ./install.sh -a -u

# Clean up downloaded files
WORKDIR /home/docker
RUN rm microsoft-r-open-*.tar.gz \
	&& rm -r microsoft-r-open

# Install some popular packages by default (this might take some time!)
RUN Rscript -e "install.packages(c('data.table', 'ggplot2', 'plyr', 'dplyr', 'igraph', 'crayon', 'doParallel', 'doSNOW'), quiet = TRUE, Ncpus = 4)"

# Register user library path in R for additional packages installed by the user
RUN Rscript --vanilla -e ".libPaths(Sys.getenv('R_LIBS_USER'))"

# Print EULAs on every start of R to the user, because they were accepted at image build time
# NOTE: This causes some install.packages() commands to fail, start R with --vanilla to avoid startup messages and be able to install them!
# The reason is that cat() prints into one of the to-be-executed commands, producing an invalid compiler input. This should be replaced!
COPY MKL_EULA.txt MKL_EULA.txt
COPY MRO_EULA.txt MRO_EULA.txt
RUN echo 'local({ cat("\n", readLines("/home/docker/MKL_EULA.txt"), "\n", sep="\n") })' >> /opt/microsoft/ropen/$MRO_VERSION/lib64/R/etc/Rprofile.site && \
	echo 'local({ cat("\n", readLines("/home/docker/MRO_EULA.txt"), "\n", sep="\n") })' >> /opt/microsoft/ropen/$MRO_VERSION/lib64/R/etc/Rprofile.site

# Add demo script
COPY demo.R demo.R

# Add image metadata
LABEL org.label-schema.license="https://mran.microsoft.com/faq/#licensing" \
    org.label-schema.vendor="Microsoft Corporation, Dockerfile provided by Daniel Nüst, augmented by Imre Gera" \
	org.label-schema.name="Microsoft R Open" \
	org.label-schema.description="Docker images of Microsoft R Open (MRO) with the Intel® Math Kernel Libraries (MKL)." \ 
	org.label-schema.vcs-url=$VCS_URL \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.schema-version="rc1" \
	maintainer="Daniel Nüst <daniel.nuest@uni-muenster.de>"

CMD ["/usr/bin/R", "--no-save"]
