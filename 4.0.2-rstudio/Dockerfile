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
FROM nuest/mro:4.0.2-verse

# based on https://github.com/rocker-org/rocker-versioned2/blob/master/dockerfiles/Dockerfile_rstudio_4.0.2
ENV S6_VERSION=v1.21.7.0
ENV RSTUDIO_VERSION=1.3.1093
ENV PATH=/usr/lib/rstudio-server/bin:$PATH

WORKDIR /rocker_scripts
ADD https://raw.githubusercontent.com/rocker-org/rocker-versioned2/master/scripts/install_rstudio.sh install_rstudio.sh
ADD https://raw.githubusercontent.com/rocker-org/rocker-versioned2/master/scripts/install_pandoc.sh install_pandoc.sh
ADD https://raw.githubusercontent.com/rocker-org/rocker-versioned2/master/scripts/install_s6init.sh install_s6init.sh
ADD https://raw.githubusercontent.com/rocker-org/rocker-versioned2/master/scripts/default_user.sh default_user.sh
ADD https://raw.githubusercontent.com/rocker-org/rocker-versioned2/master/scripts/userconf.sh userconf.sh
ADD https://raw.githubusercontent.com/rocker-org/rocker-versioned2/master/scripts/pam-helper.sh pam-helper.sh

RUN chmod +x *.sh && \
  ./install_rstudio.sh && \
  ./install_pandoc.sh

EXPOSE 8787

WORKDIR /

CMD ["/init"]
