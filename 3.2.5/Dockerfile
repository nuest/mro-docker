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
FROM ubuntu:14.04

## User creation code (based on https://github.com/rocker-org/rocker/blob/master/r-base/Dockerfile):
## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (e.g. for linked volumes to work properly).
RUN useradd docker \
	&& mkdir /home/docker \
	&& chown docker:docker /home/docker \
	&& addgroup docker staff
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

## Install some useful tools and dependencies for MRO
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		nano \
		build-essential \
		gfortran \
		# MRO dependencies dpkg does not install on its own:
		libcairo2 \
		libgfortran3 \
		libglib2.0-0 \
		libgomp1 \
		libjpeg8 \
		libpango-1.0-0 \
		libpangocairo-1.0-0 \
		libtcl8.6 \
		libtcl8.6 \
		libtiff5 \
		libtk8.6 \
		libx11-6 \
		libxt6 \
		# needed for installation of MKL:
		build-essential \
		make \
		gcc \
  	&& rm -rf /var/lib/apt/lists/*

# Use major and minor vars to re-use them in non-interactive installation script
ENV MRO_VERSION_MAJOR 3
ENV MRO_VERSION_MINOR 2.5
ENV MRO_VERSION $MRO_VERSION_MAJOR.$MRO_VERSION_MINOR

WORKDIR /home/docker

# Download & Install MRO
RUN curl -LO -# https://mran.blob.core.windows.net/install/mro/$MRO_VERSION/MRO-$MRO_VERSION-Ubuntu-14.4.x86_64.deb \
	&& dpkg -i MRO-$MRO_VERSION-Ubuntu-14.4.x86_64.deb \
	&& rm MRO-*.deb

# Download and install MKL as user docker so that .Rprofile etc. are properly set
RUN curl -LO -# https://mran.blob.core.windows.net/install/mro/$MRO_VERSION/RevoMath-$MRO_VERSION.tar.gz \
	&& tar -xzf RevoMath-$MRO_VERSION.tar.gz
WORKDIR /home/docker/RevoMath
COPY ./RevoMath_noninteractive-install.sh RevoMath_noninteractive-install.sh
RUN ./RevoMath_noninteractive-install.sh \
	|| (echo "\n*** RevoMath Installation log ***\n" \
	&& cat mkl_log.txt \
	&& echo "\n")

# Clean up
WORKDIR /home/docker 
RUN rm RevoMath-*.tar.gz \ 
  && rm -r RevoMath 

# Print MKL license on every start 
COPY mklLicense.txt mklLicense.txt 
RUN echo '\
if (all(is.na(match(c("-q", "--silent", "--quiet", "--slave"), commandArgs())))) { \n\
	cat("\\n", readLines("/home/docker/mklLicense.txt"), "\\n", sep="\\n") \n\
}' >> /usr/lib64/MRO-$MRO_VERSION/R-$MRO_VERSION/lib/R/etc/Rprofile.site 

# Add demo script
COPY demo.R demo.R

ARG VCS_URL
ARG VCS_REF
ARG BUILD_DATE

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

CMD ["/usr/bin/R"]
