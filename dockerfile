ARG BASE_TAG="develop"
ARG BASE_IMAGE="core-ubuntu-noble"
FROM flowcaseweb/$BASE_IMAGE:$BASE_TAG
USER root

ENV HOME /home/flowcase-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

RUN wget https://github.com/vanilla-wiiu/vanilla/releases/download/continuous/vanilla-linux-x86_64.tar.gz \
	&& tar -xzf vanilla-linux-x86_64.tar.gz \
	&& rm vanilla-linux-x86_64.tar.gz \
	&& chmod +x bin/vanilla

RUN echo "/usr/bin/desktop_ready && bin/vanilla &" > $STARTUPDIR/custom_startup.sh
RUN chmod 755 $STARTUPDIR/custom_startup.sh

# Update the desktop environment to be optimized for a single application
RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
RUN apt-get remove -y xfce4-panel

######### End Customizations ###########

RUN chown 1000:0 $HOME

ENV HOME /home/flowcase-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
