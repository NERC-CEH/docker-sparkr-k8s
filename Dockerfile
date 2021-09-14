FROM nerc/spark-r:3.1.2

USER root
RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install s3 Libraries
RUN wget -q https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar -O /opt/spark/jars/hadoop-aws-3.2.0.jar
RUN wget -q https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.563/aws-java-sdk-bundle-1.11.563.jar -O /opt/spark/jars/aws-java-sdk-bundle-1.11.563.jar

# Install conda to spark image
ENV PATH /opt/conda/bin:$PATH

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.3-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    ln -sf /opt/conda/lib/libstdc++.so.6.0.26 /usr/lib/x86_64-linux-gnu/libstdc++.so.6 && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc