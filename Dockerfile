FROM gcr.io/spark-operator/spark-r:v2.4.5

RUN echo "deb http://cloud.r-project.org/bin/linux/debian buster-cran35/" | tee -a /etc/apt/sources.list && \
    apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git r-base r-base-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar -O /opt/spark/jars/hadoop-aws-2.7.3.jar
RUN wget -q https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar -O /opt/spark/jars/aws-java-sdk-1.7.4.jar

ENV PATH /opt/conda/bin:$PATH

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.3-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    ln -sf /opt/conda/lib/libstdc++.so.6.0.26 /usr/lib/x86_64-linux-gnu/libstdc++.so.6 && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

#RUN conda install -y r-pkgs
#Jira Task - Investigating how Spark would work with Conda environments
#1. Instrall the most cmmonly used R pacakages for Environmental Science into the Spark worker images using conda(this would install into the base environment on the spark worker images
#2. Thn the user get to install any additional images the need with system("conda install -y r-pkg-name")