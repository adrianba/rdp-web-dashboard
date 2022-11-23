FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y sudo wget curl apt-utils software-properties-common xorg xrdp xorgxrdp icewm

COPY ./mozilla-firefox /etc/apt/preferences.d/
RUN add-apt-repository ppa:mozillateam/ppa && \
    apt-get -y install firefox

COPY ./policies.json /usr/lib/firefox/distribution/
COPY ./run.sh /usr/bin/

RUN mkdir /var/run/dbus && \
    cp /etc/X11/xrdp/xorg.conf /etc/X11 && \
    sed -i "s/console/anybody/g" /etc/X11/Xwrapper.config && \
    sed -i "s/xrdp\/xorg/xorg/g" /etc/xrdp/sesman.ini && \
    sed -i "s/# ShowTaskBar=1/ShowTaskBar=0/g" /usr/share/icewm/preferences && \
    sed -i "s/^# ShowWorkspaceStatus=1/ShowWorkspaceStatus=0/g" /usr/share/icewm/preferences && \
    sed -i "s/^#DesktopBackgroundColor=/DesktopBackgroundColor=/" /usr/share/icewm/themes/default/default.theme && \
    sed -i "s/^DesktopBackgroundImage=/#DesktopBackgroundImage=/" /usr/share/icewm/themes/default/default.theme && \
    echo "icewm-session &" >> /etc/skel/.Xsession && \
    echo "firefox --kiosk __HOMEPAGE__" >> /etc/skel/.Xsession && \
    chmod +x /usr/bin/run.sh

EXPOSE 3389
ENTRYPOINT ["/usr/bin/run.sh"]