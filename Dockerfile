FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=ja_JP.UTF-8 \
    LC_ALL=${LANG} \
    LANGUAGE=${LANG} \
    TZ=Asia/Tokyo

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# Install packages
RUN apt-get update && \
    # Install the required packages for desktop    
    apt-get install -y \
      supervisor \
      xvfb \
      xfce4 \
      x11vnc \
      && \
    # Install utilities(optional).
    apt-get install -y \
      wget \
      curl \
      sudo \
      net-tools \
      vim-tiny \
      xfce4-terminal \
      iputils-ping \
      firefox \
      git \
      default-jre \
      default-jdk \
      glade \
      libgtk-3-dev \
      && \
    # Install japanese language packs(optional)
    apt-get install -y \
      language-pack-ja-base language-pack-ja \
      ibus-anthy \
      fonts-takao \
      && \
    # Clean up
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Install noVNC
RUN mkdir -p /opt/noVNC/utils/websockify && \
    wget -qO- "http://github.com/novnc/noVNC/tarball/master" | tar -zx --strip-components=1 -C /opt/noVNC && \
    wget -qO- "https://github.com/novnc/websockify/tarball/master" | tar -zx --strip-components=1 -C /opt/noVNC/utils/websockify && \
    ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# Rename user directories Japanese to English.
RUN LANG=C xdg-user-dirs-update --force

ADD startup.sh /opt/startup.sh
ADD .env /opt/.env

EXPOSE 8080
COPY supervisord/* /etc/supervisor/conf.d/
ENTRYPOINT ["/opt/startup.sh"]
