FROM centos:7.7.1908

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/msprod.repo
RUN yum install -y libaio wget bzip2 mariadb mariadb-devel postgresql postgresql-devel gcc gcc-c++ unixODBC unixODBC-devel && \
    rpm -ivh http://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/x86_64/getPackage/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm && \
    wget -q https://repo.continuum.io/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O /tmp/miniconda.sh  && \
    ACCEPT_EULA=Y yum install -y mssql-tools && \
    echo 'e1045ee415162f944b6aebfe560b8fee */tmp/miniconda.sh' | md5sum -c - && \
    bash /tmp/miniconda.sh -f -b -p /opt/conda && \
    /opt/conda/bin/conda install --yes -c conda-forge python=3.7.3 && \
    /bin/rm -f /tmp/miniconda.sh