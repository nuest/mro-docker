FROM ubuntu:trusty
MAINTAINER Daniel Nüst <daniel.nuest@uni-muenster.de>
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
	&& rm -rf /var/lib/apt/lists/*

# Use major and minor vars to re-use them in non-interactive installtion script
ENV MRO_VERSION_MAJOR 3
ENV MRO_VERSION_MINOR 3
ENV MRO_VERSION_BUGFIX 1
ENV MRO_VERSION $MRO_VERSION_MAJOR.$MRO_VERSION_MINOR.$MRO_VERSION_BUGFIX

WORKDIR /home/docker

# Download, valiate, and unpack
RUN curl -LO -# https://mran.microsoft.com/install/mro/$MRO_VERSION/microsoft-r-open-$MRO_VERSION.tar.gz
RUN echo "b2568eb06f29964765136a4eb096659378d629a4cca9963b016bf731004eb71d microsoft-r-open-$MRO_VERSION.tar.gz" > checksum.txt \
	&& sha256sum -c --strict checksum.txt \
	&& tar -xvf microsoft-r-open-$MRO_VERSION.tar.gz

# Install MRO, which inkludes MKL, see https://mran.microsoft.com/documents/rro/installation/
WORKDIR /home/docker/microsoft-r-open
RUN ./install.sh -a -u \
	&& ls logs && cat logs/*

# Print MKL and MRO EULAs on every start
RUN cp MKL_EULA.txt /home/docker/MKL_EULA.txt \
	&& cp MKL_EULA.txt /home/docker/MRO_EULA.txt \
	&& echo 'cat("\n", readLines("/home/docker/MKL_EULA.txt"), "\n", sep="\n")' >> /usr/lib64/microsoft-r/$MRO_VERSION_MAJOR.$MRO_VERSION_MINOR/lib64/R/etc/Rprofile.site \
	&& echo 'cat("\n", readLines("/home/docker/MRO_EULA.txt"), "\n", sep="\n")' >> /usr/lib64/microsoft-r/$MRO_VERSION_MAJOR.$MRO_VERSION_MINOR/lib64/R/etc/Rprofile.site

# Clean up
WORKDIR /home/docker
RUN rm microsoft-r-open-$MRO_VERSION.tar.gz \
	&& rm -r microsoft-r-open

# Add demo script
COPY demo.R demo.R

CMD ["/usr/bin/R"]
