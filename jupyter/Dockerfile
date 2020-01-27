ARG BASE_CONTAINER=jupyter/pyspark-notebook
FROM $BASE_CONTAINER

USER root

# RSpark config
ENV R_LIBS_USER $SPARK_HOME/R/lib
RUN fix-permissions $R_LIBS_USER

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    gfortran \
    gcc && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

# R packages
RUN conda install --quiet --yes \
    'r-base=3.6.1' \
    'r-ggplot2=3.2*' \
    'r-irkernel=1.0*' \
    'r-rcurl=1.95*' \
    'r-sparklyr=1.0*' \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Apache Toree kernel
RUN pip install --no-cache-dir \
    https://dist.apache.org/repos/dist/release/incubator/toree/0.3.0-incubating/toree-pip/toree-0.3.0.tar.gz \
    && \
    jupyter toree install --sys-prefix && \
    rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Spylon-kernel
RUN conda install --quiet --yes 'spylon-kernel=0.4*' && \
    conda clean --all -f -y && \
    python -m spylon_kernel install --sys-prefix && \
    rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER



# RUN pip install sparkmonitor
RUN pip install sparkmonitor
RUN jupyter nbextension install sparkmonitor --py --user --symlink
RUN jupyter nbextension enable sparkmonitor --py --user
RUN pip uninstall -y tornado && pip uninstall -y nbconvert
RUN pip install tornado==5.1.1 && pip install nbconvert==5.6.1
RUN jupyter serverextension enable --py --user sparkmonitor
RUN ipython profile create && echo "c.InteractiveShellApp.extensions.append('sparkmonitor.kernelextension')" >>  $(ipython profile locate default)/ipython_kernel_config.py





# spark-monitor different installation:
# RUN pip install jupyter-spark
# RUN jupyter serverextension enable --py jupyter_spark
# RUN jupyter nbextension install --py jupyter_spark
# RUN jupyter nbextension enable --py jupyter_spark --user sparkmonitor
# RUN jupyter nbextension enable --py widgetsnbextension --user sparkmonitor
