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
FROM nuest/mro:4.0.2

ENV PATH=$PATH:/opt/TinyTeX/bin/x86_64-linux/

## Taken from https://github.com/rocker-org/rocker-versioned/blob/master/tidyverse/3.5.3/Dockerfile
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  libxml2-dev \
  libcairo2-dev \
  libsqlite3-dev \
  libmariadbd-dev \
  libmariadbclient-dev \
  libpq-dev \
  libssh2-1-dev \
  unixodbc-dev \
  && Rscript -e 'install.packages(c( \
    "tidyverse", \
    "dplyr", \
    "devtools", \
    "formatR", \
    "remotes", \
    "selectr", \
    "caTools", \
    "BiocManager"))'

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
	wget

## Add LaTeX, rticles and bookdown support, taken (and split up, removed rJava) from https://github.com/rocker-org/rocker-versioned/blob/master/verse/3.5.3/Dockerfile
RUN wget "https://travis-bin.yihui.name/texlive-local.deb" \
  && dpkg -i texlive-local.deb \
  && rm texlive-local.deb \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ## for rJava
    #default-jdk \
    ## Nice Google fonts
    fonts-roboto \
    ## used by some base R plots
    ghostscript \
    ## used to build rJava and other packages
    libbz2-dev \
    libicu-dev \
    liblzma-dev \
    ## system dependency of hunspell (devtools)
    libhunspell-dev \
    ## system dependency of hadley/pkgdown
    libmagick++-dev \
    ## rdf, for redland / linked data
    librdf0-dev \
    ## for V8-based javascript wrappers
    libv8-dev \
    ## R CMD Check wants qpdf to check pdf sizes, or throws a Warning
    qpdf \
    ## For building PDF manuals
    texinfo \
    ## for git via ssh key
    ssh \
 	## just because
    less \
    vim \
 	## parallelization
    libzmq3-dev \
    libopenmpi-dev \
	# for updating package mgcv
	gfortran \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

RUN \
  ## Use tinytex for LaTeX installation
  Rscript -e 'install.packages("tinytex")' \
  ## Admin-based install of TinyTeX:
  && wget -qO- \
    "https://github.com/yihui/tinytex/raw/master/tools/install-unx.sh" | \
    sh -s - --admin --no-path \
  && mv ~/.TinyTeX /opt/TinyTeX \
  && /opt/TinyTeX/bin/*/tlmgr path add \
  && tlmgr install metafont mfware inconsolata tex ae parskip listings \
  && tlmgr path add \
  && Rscript -e "tinytex::r_texmf()" \
  && chown -R root:staff /opt/TinyTeX \
  && mkdir -p /opt/microsoft/ropen/$MRO_VERSION/lib64/R/site-library \
  && chown -R root:staff /opt/microsoft/ropen/$MRO_VERSION/lib64/R/site-library \
  && chmod -R g+w /opt/TinyTeX \
  && chmod -R g+wx /opt/TinyTeX/bin \
  && echo "PATH=${PATH}" >> /opt/microsoft/ropen/$MRO_VERSION/lib64/R/etc/Renviron \
  && Rscript -e 'install.packages("PKI")'

RUN \
  ## And some nice R packages for publishing-related stuff
  Rscript -e 'install.packages(c("bookdown", "rticles", "rmdshower"))'

# Add image metadata
LABEL org.label-schema.license="https://mran.microsoft.com/faq/#licensing" \
    org.label-schema.vendor="Microsoft Corporation, Dockerfile provided by Daniel Nüst" \
	org.label-schema.name="Microsoft R Open (verse)" \
	org.label-schema.description="Docker images of Microsoft R Open (MRO) with the Intel® Math Kernel Libraries (MKL)." \ 
	org.label-schema.vcs-url=$VCS_URL \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.schema-version="rc1" \
	maintainer="Daniel Nüst <daniel.nuest@uni-muenster.de>"
