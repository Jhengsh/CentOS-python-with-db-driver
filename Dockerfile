FROM centos:7.9.2009
ENV CONDA_DIR=/opt/conda
ENV PATH="/opt/conda/bin:${PATH}"

RUN yum install -y libaio wget bzip2 mariadb mariadb-devel postgresql postgresql-devel gcc gcc-c++ unixODBC unixODBC-devel
RUN miniforge_arch=$(uname -m) && \
    miniforge_installer="Mambaforge-Linux-${miniforge_arch}.sh" && \
    wget --quiet "https://github.com/conda-forge/miniforge/releases/latest/download/${miniforge_installer}" && \
    /bin/bash "${miniforge_installer}" -f -b -p "${CONDA_DIR}" && \
    /bin/rm -f "${miniforge_installer}" && \
    ${CONDA_DIR}/bin/conda config --system --set auto_update_conda false && \
    ${CONDA_DIR}/bin/conda config --system --set show_channel_urls true && \
    ${CONDA_DIR}/bin/mamba install --quiet --yes python=3.9 && \
    ${CONDA_DIR}/bin/mamba list python | grep '^python ' | tr -s ' ' | cut -d ' ' -f 1,2 >> "${CONDA_DIR}/conda-meta/pinned" && \
    ${CONDA_DIR}/bin/conda update --all --quiet --yes && \
    ${CONDA_DIR}/bin/conda clean --all -f -y

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/msprod.repo
RUN rpm -ivh http://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/x86_64/getPackage/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm && \
    ACCEPT_EULA=Y yum install -y mssql-tools
CMD ["/opt/conda/bin/python"]
