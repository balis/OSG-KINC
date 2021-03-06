FROM fedora:25

RUN dnf -y update && dnf clean all

RUN dnf -y --setopt=install_weak_deps=False --best install \
	lapack \
	gcc-gfortran \
	libstdc++ \
	openblas \
	vim \
	wget \
	procps \
	findutils \
	curl \
	&& dnf clean all

RUN curl -sL https://rpm.nodesource.com/setup_8.x | bash - && dnf -y install nodejs
RUN npm install https://github.com/hyperflow-wms/hyperflow-job-executor/archive/master.tar.gz

WORKDIR /kinc

COPY tools/kinc-wrapper-docker /kinc/kinc-wrapper
COPY task-files/kinc /kinc/kinc
#COPY workflow.json /
#ADD http://www.mixmod.org/IMG/rpm/libmixmod_3.2.2-runtime.rpm /
#ADD http://www.mixmod.org/IMG/rpm/libmixmod_3.2.2-dev.rpm /
#RUN dnf -y install /libmixmod_3.2.2-runtime.rpm
#RUN dnf -y install /libmixmod_3.2.2-dev.rpm

# libmixmod had to be compiled
COPY tools/libmixmod-fedora25.tar.gz /tmp
RUN tar zxvf /tmp/libmixmod-fedora25.tar.gz -C /lib64

ADD http://download-ib01.fedoraproject.org/pub/fedora/linux/releases/29/Everything/x86_64/os/Packages/g/gsl-2.4-7.fc29.x86_64.rpm /
RUN dnf -y install /gsl-2.4-7.fc29.x86_64.rpm

ENV PATH $PATH:/kinc:/node_modules/.bin
#CMD ["/home/kinc-wrapper","Yeast-GEM.tar.gz","Yeast-GEM.txt","1","100000","188","7051"]
