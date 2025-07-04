########################################################
#        Renku install section - do not edit           #

FROM renku/renkulab-py:3.10-0.24.0 as builder

# RENKU_VERSION determines the version of the renku CLI
# that will be used in this image. To find the latest version,
# visit https://pypi.org/project/renku/#history.
ARG RENKU_VERSION=2.9.4

# Install renku from pypi or from github if a dev version
RUN if [ -n "$RENKU_VERSION" ] ; then \
        source .renku/venv/bin/activate ; \
        currentversion=$(renku --version) ; \
        if [ "$RENKU_VERSION" != "$currentversion" ] ; then \
            pip uninstall renku -y ; \
            gitversion=$(echo "$RENKU_VERSION" | sed -n "s/^[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\(rc[[:digit:]]\+\)*\(\.dev[[:digit:]]\+\)*\(+g\([a-f0-9]\+\)\)*\(+dirty\)*$/\4/p") ; \
            if [ -n "$gitversion" ] ; then \
                pip install --no-cache-dir --force "git+https://github.com/SwissDataScienceCenter/renku-python.git@$gitversion" ;\
            else \
                pip install --no-cache-dir --force renku==${RENKU_VERSION} ;\
            fi \
        fi \
    fi
#             End Renku install section                #
########################################################

FROM renku/renkulab-py:3.10-0.24.0

# Uncomment and adapt if your R or python packages require extra linux (ubuntu) software
# e.g. the following installs apt-utils and vim; each pkg on its own line, all lines
# except for the last end with backslash '\' to continue the RUN line
# Install tesseract-ocr and its German language packs
USER root
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y tesseract-ocr
RUN apt-get install -y libtesseract-dev
RUN apt-get install -y tesseract-ocr-deu
RUN wget -P /usr/share/tesseract-ocr/4.00/tessdata/ https://github.com/tesseract-ocr/tessdata/raw/refs/heads/main/deu_frak.traineddata
RUN wget -P /usr/share/tesseract-ocr/4.00/tessdata/ https://github.com/tesseract-ocr/tessdata/raw/refs/heads/main/deu_latf.traineddata

USER ${NB_USER}

# install the python dependencies
COPY requirements.txt environment.yml /tmp/
RUN mamba env update -q -f /tmp/environment.yml && \
    /opt/conda/bin/pip install -r /tmp/requirements.txt --no-cache-dir && \
    mamba clean -y --all && \
    mamba env export -n "root" && \
    rm -rf ${HOME}/.renku/venv

COPY --from=builder ${HOME}/.renku/venv ${HOME}/.renku/venv

USER root
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "tini", "--", "/entrypoint.sh" ]
CMD [ "jupyter", "server", "--ip", "0.0.0.0" ]

USER $NB_USER
RUN mkdir -p ${HOME}/lab/notebook
RUN mkdir -p ${HOME}/lab/data
COPY /notebook/*.ipynb ${HOME}/lab/notebook/
COPY /data/* ${HOME}/lab/data/
WORKDIR ${HOME}/lab